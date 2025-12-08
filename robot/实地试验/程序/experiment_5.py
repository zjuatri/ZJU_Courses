import sys
import os
import numpy as np
import time
import math
from Robot.Robot import Robot
import until

# ==========================================
# 0. 环境设置
# ==========================================
# 添加 IK 模块路径
sys.path.append(os.path.abspath('./IK'))

try:
    from IK import IKSolver
except ImportError:
    print("【错误】无法导入 IK 模块")
    sys.exit(1)

ik_solver = IKSolver()

# ==========================================
# 1. 全局配置与安全限位
# ==========================================
# 关节安全限位 (根据 circle_and_square.py)
SAFE_LIMITS = [
    [-145, 58],  # J1
    [-85,  88],  # J2
    [-98,  98],  # J3
    [-150, 150], # J4
    [-150, 150], # J5
    [-168, 168]  # J6
]

# 基准末端姿态 (垂直向下)
BASE_EULER = np.array([np.pi, 0, -np.pi/2]) 

# 关键点坐标 (单位: mm)
POINT_A = np.array([370, -90, 115])
POINT_B = np.array([288, -288, 115])

# 起始区域抓取点 (假设)
PICK_POS_1 = np.array([370, 0, 100]) # 假设在 A 点附近或 X 轴上
PICK_POS_2 = np.array([370, 200, 100]) # 假设第二个木块的位置

# 目标区域配置
# 题目要求：目标区域为 J1 = 90 度所在位置
# 根据用户反馈及限位，此处修正为 -90 度方向 (Y轴负方向)
TARGET_POS_BASE = np.array([0, -300, 115]) 

# 木块高度 (用于堆叠)
BLOCK_HEIGHT = 30 

# 控制周期
CONTROL_T = 0.04 

# ==========================================
# 2. 辅助函数 (IK/FK/Math)
# ==========================================
def clamp_joints(q_deg):
    """限制关节角度在安全范围内"""
    q_clamped = np.copy(q_deg)
    for i in range(6):
        min_val, max_val = SAFE_LIMITS[i]
        q_clamped[i] = np.clip(q_clamped[i], min_val, max_val)
    return q_clamped

def get_euler_from_matrix(matrix):
    """从旋转矩阵提取欧拉角"""
    r11, r12, r13 = matrix[0,0], matrix[0,1], matrix[0,2]
    r23, r33 = matrix[1,2], matrix[2,2]
    val = max(min(r13, 1.0), -1.0)
    beta = math.asin(val)
    if abs(r13) < 0.99999:
        alpha = math.atan2(-r23, r33)
        gamma = math.atan2(-r12, r11)
    else:
        alpha = math.atan2(matrix[1,0], matrix[1,1])
        gamma = 0
    return np.array([alpha, beta, gamma])

def solve_ik_pose(target_pos, q_last, euler=BASE_EULER):
    """
    逆运动学求解
    :param target_pos: [x, y, z] 目标位置
    :param q_last: 上一次的关节角 (用于选择最优解)
    :param euler: 末端姿态欧拉角
    :return: 6关节角度 (度) 或 None
    """
    x, y, z = target_pos
    # 构造目标向量: [x, y, z, alpha, beta, gamma]
    # 注意：这里直接传入欧拉角给 ik_solver，假设 solver 内部处理矩阵转换
    # 参考 circle_and_square.py 的用法，它似乎可以直接传 [x,y,z,rx,ry,rz]
    
    target_pose_vec = np.array([x, y, z, euler[0], euler[1], euler[2]], dtype=np.float64)
    
    # 调用 C 扩展模块求解
    solutions = ik_solver.solve(target_pose_vec)
    
    if solutions.shape[1] == 0:
        return None
    
    valid_sols = np.rad2deg(solutions)
    
    # 选择离当前姿态最近的解
    diffs = np.linalg.norm(valid_sols.T - q_last, axis=1)
    best_idx = np.argmin(diffs)
    best_sol = valid_sols[:, best_idx]
    
    return clamp_joints(best_sol)

def get_current_joints_robust(robot):
    """读取当前关节角 (带重试)"""
    max_retries = 3
    for i in range(max_retries):
        try:
            feedback = robot.syncFeedback()
            if feedback is not None:
                if isinstance(feedback, tuple): 
                    data = feedback[0].flatten()
                else:
                    data = feedback[:, 0].flatten()
                # 过滤全0数据 (除非真的是0)
                if np.all(data == 0) and i < max_retries - 1:
                    time.sleep(0.02)
                    continue
                return data
        except Exception:
            time.sleep(0.02)
    return None

# ==========================================
# 3. 运动控制函数
# ==========================================
def control_gripper(robot, enable):
    """
    控制吸爪/夹爪
    :param enable: True 为吸取/闭合, False 为释放/张开
    """
    # TODO: 请根据实际 Robot 类的接口修改此处
    # 假设接口为 set_suction 或类似
    print(f"  [吸爪] {'启动' if enable else '释放'}")
    time.sleep(0.5) # 模拟动作时间
    # if hasattr(robot, 'set_suction'):
    #     robot.set_suction(enable)

def move_to_joint(robot, q_target, duration=3.0):
    """关节空间点到点运动 (PTP)"""
    q_start = get_current_joints_robust(robot)
    if q_start is None: return False
    
    # print(f"  [PTP] 移动到: {np.round(q_target, 1)}")
    
    max_diff = np.max(np.abs(q_target - q_start))
    real_duration = max(duration, max_diff / 20.0) # 限制最大速度
    
    k_array = until.quinticCurvePlanning(q_start, q_target, real_duration)
    t = 0
    while t < real_duration:
        start = time.time()
        q_now = until.quinticCurveExcute(k_array, t)
        robot.syncMove(np.reshape(clamp_joints(q_now), (6, 1)))
        t += CONTROL_T
        cost = time.time() - start
        if cost < CONTROL_T: time.sleep(CONTROL_T - cost)
    return True

def move_linear(robot, start_pos, end_pos, speed_mm_s=30):
    """
    笛卡尔空间直线运动
    :param start_pos: [x, y, z]
    :param end_pos: [x, y, z]
    :param speed_mm_s: 速度 mm/s
    """
    print(f"  [Linear] 直线运动: {start_pos} -> {end_pos}")
    q_prev = get_current_joints_robust(robot)
    if q_prev is None: return False
    
    dist = np.linalg.norm(end_pos - start_pos)
    duration = dist / speed_mm_s
    steps = int(max(duration / CONTROL_T, 1))
    
    for step in range(steps):
        t_start = time.time()
        ratio = (step + 1) / steps
        curr_pos = start_pos + (end_pos - start_pos) * ratio
        
        # 求解 IK
        q_next = solve_ik_pose(curr_pos / 1000.0, q_prev) # 注意单位转换: mm -> m ? 
        # 等等，circle_and_square.py 中 solve_ik_pose 的输入单位似乎是 m (因为有点除以1000的操作)
        # 但 POINT_A 是 370，如果是 m 那太大了。
        # 检查 circle_and_square.py:
        # cx, cy, cz = np.array(center_xyz) / 1000.0
        # 所以 solve_ik_pose 期望的是 米 (m)。
        
        if q_next is None:
            print("  [错误] 路径点 IK 无解")
            return False
            
        robot.syncMove(np.reshape(q_next, (6, 1)))
        q_prev = q_next
        
        cost = time.time() - t_start
        if cost < CONTROL_T: time.sleep(CONTROL_T - cost)
        
    return True

# ==========================================
# 4. 任务流程
# ==========================================
def run_experiment_5(robot):
    print(">>> 开始实验5: 抓取与搬运")
    
    # 0. 初始状态
    q_curr = get_current_joints_robust(robot)
    if q_curr is None: return
    
    # a) 机械臂从零位置启动，运行至起始区域
    print("\n[步骤 a] 移动至起始区域上方")
    # 假设起始区域在 PICK_POS_1 上方
    start_area_hover = PICK_POS_1 + np.array([0, 0, 50])
    q_start = solve_ik_pose(start_area_hover / 1000.0, q_curr)
    if q_start is not None:
        move_to_joint(robot, q_start, duration=4.0)
    else:
        print("起始区域不可达")
        return

    # b) 启动真空吸爪，抓取起始区域内的木块，移动至A点
    print("\n[步骤 b] 抓取木块1并移动至 A 点")
    # 下降
    q_pick = solve_ik_pose(PICK_POS_1 / 1000.0, get_current_joints_robust(robot))
    if q_pick is not None:
        move_to_joint(robot, q_pick, duration=2.0)
        control_gripper(robot, True) # 吸取
        time.sleep(5.0)
        
    # c) 移动过程中控制木块从A点沿直线路径运动至B点
    print("\n[步骤 c] 直线运动 A -> B (抬高 10cm)")
    # 抬高 10cm 以避免碰撞
    safe_height_vec = np.array([0, 0, 100])
    point_a_high = POINT_A + safe_height_vec
    point_b_high = POINT_B + safe_height_vec
    
    # 延伸 B 点，使直线运动更长 (延伸 20%)
    vec_ab = point_b_high - point_a_high
    point_b_extended = point_a_high + vec_ab * 1.2
    
    # 抓取后直接抬升到直线运动的高度 (A点上方)
    print("  抬升至直线运动高度...")
    q_a_high = solve_ik_pose(point_a_high / 1000.0, get_current_joints_robust(robot))
    if q_a_high is not None:
        move_to_joint(robot, q_a_high, duration=3.0)

    # 执行直线运动 (使用延伸后的 B 点)
    move_linear(robot, point_a_high, point_b_extended, speed_mm_s=40)
    
    # d) 控制从B点到达目标区域 (J1=90度位置)
    print("\n[步骤 d] 移动至目标区域并放置")
    # 先移动到目标位置上方 (TARGET_POS_BASE)
    target_pos_1 = TARGET_POS_BASE
    q_target_1 = solve_ik_pose(target_pos_1 / 1000.0, get_current_joints_robust(robot))
    
    if q_target_1 is not None:
        move_to_joint(robot, q_target_1, duration=4.0)
        
        # 再向下微调 20mm 进行放置
        print("  向下微调 20mm...")
        target_pos_drop = target_pos_1 - np.array([0, 0, 20])
        q_target_drop = solve_ik_pose(target_pos_drop / 1000.0, get_current_joints_robust(robot))
        if q_target_drop is not None:
            move_to_joint(robot, q_target_drop, duration=1.0)
            
        control_gripper(robot, False) # 放置
        time.sleep(5.0)
        
        # 抬起一点避免碰撞
        target_hover = target_pos_1 + np.array([0, 0, 50])
        q_hover = solve_ik_pose(target_hover / 1000.0, get_current_joints_robust(robot))
        move_to_joint(robot, q_hover, duration=2.0)
    
    # e) 抓取第二个木块放置到目标区域，并堆叠
    print("\n[步骤 e] 抓取第二个木块并堆叠")
    
    # 回到起始区域抓第二个 (假设在 PICK_POS_2)
    q_pick_2_hover = solve_ik_pose((PICK_POS_2 + np.array([0,0,50])) / 1000.0, get_current_joints_robust(robot))
    move_to_joint(robot, q_pick_2_hover, duration=4.0)
    
    # 下降抓取
    q_pick_2 = solve_ik_pose(PICK_POS_2 / 1000.0, get_current_joints_robust(robot))
    move_to_joint(robot, q_pick_2, duration=2.0)
    control_gripper(robot, True)
    time.sleep(5.0)
    move_to_joint(robot, q_pick_2_hover, duration=2.0)
    
    # 移动到目标区域堆叠 (Z + BLOCK_HEIGHT)
    target_pos_2 = TARGET_POS_BASE + np.array([0, 0, BLOCK_HEIGHT])
    q_target_2 = solve_ik_pose(target_pos_2 / 1000.0, get_current_joints_robust(robot))
    
    if q_target_2 is not None:
        move_to_joint(robot, q_target_2, duration=4.0)
        control_gripper(robot, False) # 放置
        time.sleep(5.0)
        # 抬起结束
        target_hover_2 = target_pos_2 + np.array([0, 0, 50])
        q_hover_2 = solve_ik_pose(target_hover_2 / 1000.0, q_target_2)
        move_to_joint(robot, q_hover_2, duration=2.0)
        
    print("\n任务完成！")

# ==========================================
# 主程序入口
# ==========================================
def main():
    try:
        # 端口号可能需要根据实际情况修改
        r = Robot(com='COM6', baud=250000)
        r.connect()
    except Exception as e:
        print(f"连接失败: {e}")
        return
    
    print("通信检查...")
    if get_current_joints_robust(r) is None: 
        print("无法读取关节信息")
        return 
        
    print("回零...")
    r.go_home()
    time.sleep(2)
    
    run_experiment_5(r)

if __name__ == "__main__":
    main()
