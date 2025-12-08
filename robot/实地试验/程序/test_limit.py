import sys
import os
import numpy as np
import time
from Robot.Robot import Robot

# ==========================================
# 0. 环境设置
# ==========================================
sys.path.append(os.path.abspath('./IK'))

# ==========================================
# 1. 辅助函数
# ==========================================
def get_feedback(robot):
    """读取当前真实角度"""
    try:
        fb = robot.syncFeedback()
        if fb is not None:
            if isinstance(fb, tuple): return fb[0].flatten()
            return fb[:, 0].flatten()
    except:
        pass
    return None

def move_smooth(robot, q_target, duration=2.0):
    """平滑移动到目标点 (简单插值)"""
    q_start = get_feedback(robot)
    if q_start is None: return False
    
    steps = int(duration / 0.04)
    for i in range(steps):
        ratio = (i + 1) / steps
        q_now = q_start + (q_target - q_start) * ratio
        robot.syncMove(np.reshape(q_now, (6, 1)))
        time.sleep(0.04)
    return True

# ==========================================
# 2. 极限探测核心
# ==========================================
def probe_single_joint(robot, joint_idx, direction):
    """
    探测单个关节的极限
    joint_idx: 0-5 (对应 J1-J6)
    direction: +1 (正向) 或 -1 (负向)
    """
    # 1. 获取当前状态作为起点
    q_current = get_feedback(robot)
    if q_current is None: return None
    
    print(f"    正在探测 J{joint_idx+1} ({'正向' if direction>0 else '负向'})...")
    
    # 2. 设定步长 (0.5度/次，比较慢且安全)
    step = 0.5 * direction
    
    # 3. 开始蠕动
    limit_found = False
    last_valid_angle = q_current[joint_idx]
    
    # 最多试探 150 度 (防止死循环)
    for _ in range(300): 
        # 计算下一个目标
        q_target = np.copy(q_current)
        q_target[joint_idx] += step
        
        # 发送指令
        robot.syncMove(np.reshape(q_target, (6, 1)))
        time.sleep(0.05) # 给一点反应时间
        
        # 读取反馈验证
        q_real = get_feedback(robot)
        if q_real is None: break
        
        # === 核心判据 ===
        # 如果 发送的目标 与 实际反馈 差距超过 2度
        # 说明指令被拒绝 (Out of range) 或者 机械臂动不了了
        diff = abs(q_target[joint_idx] - q_real[joint_idx])
        
        if diff > 2.0:
            print(f"    [停止] 检测到卡顿/拒绝！指令: {q_target[joint_idx]:.2f}, 实际: {q_real[joint_idx]:.2f}")
            limit_found = True
            break
        
        # 更新状态
        q_current = q_target
        last_valid_angle = q_real[joint_idx]
        
        # 实时打印
        print(f"\r    J{joint_idx+1}: {last_valid_angle:.2f}°", end="")
    
    print("") # 换行
    return last_valid_angle

# ==========================================
# 3. 主程序
# ==========================================
def main():
    try:
        r = Robot(com='COM4', baud=250000)
        r.connect()
    except Exception as e:
        print(f"连接失败: {e}")
        return

    print("正在回零...")
    r.go_home()
    time.sleep(2)
    
    # 记录测得的限位
    measured_limits = []
    
    # === 开始测试 J1 到 J6 ===
    # 为了安全，我们只测前 5 个关节，J6 通常是无限或很大的
    # 也可以根据需要修改 range(6)
    for i in range(3,5): 
        print(f"\n[{i+1}/6] 测试关节 J{i+1} =================")
        
        # 1. 确保回中 (除了正在测的关节，其他归零，防止干涉)
        # J2 和 J3 比较特殊，互相关联，我们尽量让它们处于舒适区
        # 基础姿态：全部归零 (垂直向上/向前)
        base_pose = np.zeros(6) 
        # 如果是测 J3，先把 J2 放到 0 度 (竖直) 比较好
        # 如果是测 J2，先把 J3 放到 0 度
        move_smooth(r, base_pose, duration=2.0)
        time.sleep(0.5)
        
        # 2. 测正向极限
        max_val = probe_single_joint(r, i, 1)
        
        # 3. 回中
        move_smooth(r, base_pose, duration=2.0)
        
        # 4. 测负向极限
        min_val = probe_single_joint(r, i, -1)
        
        # 5. 回中
        move_smooth(r, base_pose, duration=2.0)
        
        print(f"--> J{i+1} 测得范围: [{min_val:.1f}, {max_val:.1f}]")
        measured_limits.append([min_val, max_val])
        
    print("\n" + "="*40)
    print("【最终测得的真实限位】")
    print("请将下方数据更新到你的 SAFE_LIMITS 中：")
    print("="*40)
    print("SAFE_LIMITS = [")
    for i, limit in enumerate(measured_limits):
        # 建议收缩 2 度作为缓冲区
        safe_min = limit[0] + 2.0
        safe_max = limit[1] - 2.0
        print(f"    [{safe_min:.1f}, {safe_max:.1f}], # J{i+1} (实测: {limit[0]:.1f}~{limit[1]:.1f})")
    print("    [-179, 179]  # J6 (未测/默认)")
    print("]")

if __name__ == "__main__":
    main()