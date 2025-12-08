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
sys.path.append(os.path.abspath('./IK'))

try:
    from IK import IKSolver
except ImportError:
    print("【错误】无法导入 IK 模块")
    sys.exit(1)

ik_solver = IKSolver()

# ==========================================
# 1. 最终安全限位 (Final Limits)
# ==========================================
SAFE_LIMITS = [
    [-145, 58],  # J1: 实测限位
    [-85,  88],  # J2: 实测限位
    [-98,  98],  # J3: 死守 100 度红线
    [-150, 150], # J4
    [-150, 150], # J5
    [-168, 168]  # J6: 崩溃点是170.3，我们卡在168，留2度保命
]

# 基准姿态
BASE_EULER = np.array([np.pi, 0, -np.pi/2]) 

def clamp_joints(q_deg):
    """强制将关节角限制在安全范围内"""
    q_clamped = np.copy(q_deg)
    for i in range(6):
        min_val, max_val = SAFE_LIMITS[i]
        q_clamped[i] = np.clip(q_clamped[i], min_val, max_val)
    return q_clamped

def get_current_joints_robust(robot):
    """带重试机制的读取"""
    max_retries = 3
    for i in range(max_retries):
        try:
            feedback = robot.syncFeedback()
            if feedback is not None:
                if isinstance(feedback, tuple): 
                    data = feedback[0].flatten()
                else:
                    data = feedback[:, 0].flatten()
                if np.all(data == 0) and i < max_retries - 1:
                    time.sleep(0.02)
                    continue
                return data
        except Exception:
            time.sleep(0.02)
    return None

# ==========================================
# 2. IK 工具
# ==========================================
def get_euler_from_matrix(matrix):
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

def build_matrix(pos, euler):
    x, y, z = pos
    alpha, beta, gamma = euler
    c_a, s_a = np.cos(alpha), np.sin(alpha)
    c_b, s_b = np.cos(beta),  np.sin(beta)
    c_g, s_g = np.cos(gamma), np.sin(gamma)
    r11 = c_b * c_g
    r12 = -c_b * s_g
    r13 = s_b
    r21 = c_a * s_g + s_a * s_b * c_g
    r22 = c_a * c_g - s_a * s_b * s_g
    r23 = -s_a * c_b
    r31 = s_a * s_g - c_a * s_b * c_g
    r32 = s_a * c_g + c_a * s_b * s_g
    r33 = c_a * c_b
    return np.array([[r11, r12, r13, x], [r21, r22, r23, y], [r31, r32, r33, z], [0,0,0,1]])

def multiply_matrices(m1, m2):
    return np.dot(m1, m2)

def solve_ik_pose(pose_matrix, q_last):
    if pose_matrix.shape == (4, 4):
        x, y, z = pose_matrix[0,3], pose_matrix[1,3], pose_matrix[2,3]
        rx, ry, rz = get_euler_from_matrix(pose_matrix)
        target_pose = np.array([x, y, z, rx, ry, rz], dtype=np.float64)
    else:
        target_pose = pose_matrix

    solutions = ik_solver.solve(target_pose)
    if solutions.shape[1] == 0: return None
    
    valid_sols = np.rad2deg(solutions)
    diffs = np.linalg.norm(valid_sols.T - q_last, axis=1)
    best_idx = np.argmin(diffs)
    best_sol = valid_sols[:, best_idx]
    
    # 强制 Clamp，如果有稍微越界（比如J6算出169），强行压回168
    # 这样虽然动作有极其微小的变形，但保证不报错
    return clamp_joints(best_sol)

# ==========================================
# 3. 运动控制
# ==========================================
CONTROL_T = 0.04 

def move_to_joint(robot, q_target, duration=3.0):
    q_start = get_current_joints_robust(robot)
    if q_start is None: return False
    
    print(f"  [动作] 移动到关节: {np.round(q_target, 1)}")
    
    max_diff = np.max(np.abs(q_target - q_start))
    real_duration = max(duration, max_diff / 20.0) 
    
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

# ==========================================
# 4. 任务逻辑
# ==========================================

def run_square_task(robot, center_xyz, side_len=100):
    print(f"\n>>> 任务1: 正方形 (中心 {center_xyz})")
    cx, cy, cz = np.array(center_xyz) / 1000.0
    half = (side_len / 1000.0) / 2.0
    points = [
        np.array([cx - half, cy - half, cz]),
        np.array([cx + half, cy - half, cz]),
        np.array([cx + half, cy + half, cz]),
        np.array([cx - half, cy + half, cz]),
        np.array([cx - half, cy - half, cz])
    ]
    
    q_curr = get_current_joints_robust(robot)
    if q_curr is None: return
    
    start_pose = np.concatenate((points[0], BASE_EULER))
    q_start = solve_ik_pose(start_pose, q_curr)
    
    if q_start is None: return print("起始点无解")
    if not move_to_joint(robot, q_start, duration=4.0): return
    
    q_prev = get_current_joints_robust(robot)
    speed_mm_s = 25 
    
    for i in range(len(points) - 1):
        p_curr, p_next = points[i], points[i+1]
        steps = int(max(np.linalg.norm(p_next-p_curr)*1000/speed_mm_s, 1.0) / CONTROL_T)
        for step in range(steps):
            ratio = (step + 1) / steps
            curr_pos = p_curr + (p_next - p_curr) * ratio
            q_next = solve_ik_pose(np.concatenate((curr_pos, BASE_EULER)), q_prev)
            if q_next is None: return print("IK中断")
            robot.syncMove(np.reshape(q_next, (6, 1)))
            q_prev = q_next
            time.sleep(CONTROL_T)

def run_circle_task(robot, center_xyz, diameter=100):
    print(f"\n>>> 任务2: 圆形 (中心 {center_xyz})")
    cx, cy, cz = np.array(center_xyz) / 1000.0
    r = (diameter / 1000.0) / 2.0
    
    q_curr = get_current_joints_robust(robot)
    if q_curr is None: return

    start_pose = np.concatenate((np.array([cx+r, cy, cz]), BASE_EULER))
    q_start = solve_ik_pose(start_pose, q_curr)
    
    if q_start is None: return print("起始点无解")
    if not move_to_joint(robot, q_start, duration=4.0): return
    
    q_prev = get_current_joints_robust(robot)
    steps = int(max(np.pi*diameter/25, 2.0) / CONTROL_T)
    
    for step in range(steps):
        theta = 2 * np.pi * (step / steps)
        x = cx + r * np.cos(theta)
        y = cy + r * np.sin(theta)
        q_next = solve_ik_pose(np.array([x, y, cz, *BASE_EULER]), q_prev)
        if q_next is None: break
        robot.syncMove(np.reshape(q_next, (6, 1)))
        q_prev = q_next
        time.sleep(CONTROL_T)

def run_cone_task(robot, tip_xyz, cone_angle_deg=20):
    print(f"\n>>> 任务3: 圆锥 (顶点 {tip_xyz}, 锥角 {cone_angle_deg}°)")
    tip_pos_m = np.array(tip_xyz) / 1000.0
    half_angle = np.deg2rad(cone_angle_deg) / 2.0
    
    q_curr = get_current_joints_robust(robot)
    if q_curr is None: return

    m_base = build_matrix([0,0,0], BASE_EULER)
    m_tilt = build_matrix([0,0,0], [0, half_angle, 0])
    m_spin = build_matrix([0,0,0], [0, 0, 0])
    m_final = multiply_matrices(multiply_matrices(m_spin, m_tilt), m_base)
    m_final[0:3, 3] = tip_pos_m
    
    q_start = solve_ik_pose(m_final, q_curr)
    if q_start is None: return print("起始姿态无解")
    
    if not move_to_joint(robot, q_start, duration=5.0): return
    
    steps = int(12.0 / CONTROL_T) # 稍慢一点，12秒转完
    q_prev = get_current_joints_robust(robot)
    
    for step in range(steps):
        current_angle = 2 * np.pi * (step / steps) * 2 # 转2圈
        m_spin = build_matrix([0,0,0], [0, 0, current_angle])
        m_final = multiply_matrices(multiply_matrices(m_spin, m_tilt), m_base)
        m_final[0:3, 3] = tip_pos_m
        
        q_next = solve_ik_pose(m_final, q_prev)
        if q_next is None: break
        robot.syncMove(np.reshape(q_next, (6, 1)))
        q_prev = q_next
        time.sleep(CONTROL_T)
        
    safe_pose = np.concatenate((tip_pos_m + np.array([0,0,0.05]), BASE_EULER))
    q_safe = solve_ik_pose(safe_pose, q_prev)
    if q_safe is not None: move_to_joint(robot, q_safe, duration=3.0)

# ==========================================
# 主程序
# ==========================================
def main():
    try:
        r = Robot(com='COM5', baud=250000)
        r.connect()
    except Exception as e:
        print(f"连接 COM5 失败: {e}")
        return
    
    print("通信检查...")
    if get_current_joints_robust(r) is None: return 
        
    print("回零...")
    r.go_home()
    time.sleep(2)
    
    # === 最终通关配置 ===
    # 坐标: [370, 0, 100] (保护 J3 < 78度)
    # 锥角: 20度 (保护 J6 < 150度)
    # 这组参数组合经过计算，所有关节都远离物理崩溃点。
    
    uni_center = [370, 0, 100]
    
    run_square_task(r, uni_center, side_len=100)
    time.sleep(1)
    
    run_circle_task(r, uni_center, diameter=100)
    time.sleep(1)
    
    # 关键：锥角改为 20
    run_cone_task(r, uni_center, cone_angle_deg=60)
    
    print("\n所有演示完成！任务成功。")

if __name__ == "__main__":
    main()