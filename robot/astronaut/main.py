import time
import numpy as np
from math import *
from coppeliasim_zmqremoteapi_client import RemoteAPIClient


print("Program started")


# 机器人仿真器：用于控制机器人在CoppeliaSim中的运动


class RobotSimulator:
    def __init__(self):
        """
        初始化与CoppeliaSim的连接，并设置仿真环境及机器人初始状态
        """
        self.client = RemoteAPIClient()
        self.sim = self.client.getObject("sim")

        # 设置仿真空闲帧率为0
        self.default_idle_fps = self.sim.getInt32Param(self.sim.intparam_idle_fps)
        self.sim.setInt32Param(self.sim.intparam_idle_fps, 0)

        # 启动逐步仿真
        self.client.setStepping(True)
        self.sim.startSimulation()

        # 初始化机器人关节对象
        self.joints = np.zeros(7)
        self._initialize_robot_parts()

        self.base = "A"
        self.matrix_left = []
        self.matrix_right = []
        self._initialize_object_matrices()

        # 设置初始关节位置为0
        self._set_joint_positions(np.zeros(7))

    def _initialize_robot_parts(self):
        """
        初始化机器人各个部件（关节、链条、基座等）的句柄
        """
        parts = [
            ("./L_Base", 16),
            ("./L_Joint1", 17),
            ("./L_Link1", 18),
            ("./L_Joint2", 19),
            ("./L_Link2", 20),
            ("./L_Joint3", 21),
            ("./L_Link3", 22),
            ("./Joint4", 23),
            ("./R_Link3", 24),
            ("./R_Joint3", 25),
            ("./R_Link2", 26),
            ("./R_Joint2", 27),
            ("./R_Link1", 28),
            ("./R_Joint1", 29),
            ("./R_Base", 30),
        ]

        joint_index = 0  # 关节索引

        for part_name, index in parts:
            setattr(self, f"part_{index}", self.sim.getObject(part_name))

            # 只将关节对象赋值给 self.joints
            if "Joint" in part_name:
                if joint_index < len(self.joints):
                    self.joints[joint_index] = getattr(self, f"part_{index}")
                    joint_index += 1

    def _initialize_object_matrices(self):
        """
        初始化左右基座的物体矩阵
        """
        for i in range(16, 30):
            self.matrix_left.append(self.sim.getObjectMatrix(i, i + 1))
            self.matrix_right.append(self.sim.getObjectMatrix(i + 1, i))

    def _set_joint_positions(self, positions):
        """
        设置所有关节的位置
        """
        for i, position in enumerate(positions):
            self.sim.setJointPosition(self.joints[i], position)

    def switch_base(self, base):
        """
        切换机器人使用的基座（"A" 或 "B"）
        """
        if self.base == base:
            return

        # 保存当前关节位置
        current_positions = np.array(
            [self.sim.getJointPosition(joint) for joint in self.joints]
        )

        if base == "A":
            self._switch_to_base("left", current_positions)
        elif base == "B":
            self._switch_to_base("right", current_positions)

        self.base = base

    def _switch_to_base(self, base_side, current_positions):
        """
        切换到指定的基座（左基座或右基座）
        """
        if base_side == "left":
            self.sim.setObjectParent(self.part_16, -1)
            for i in range(16, 30):
                self.sim.setObjectParent(i + 1, i)
                self.sim.setObjectMatrix(i + 1, i, self.matrix_right[i - 16])
                if i % 2 == 1:  # 如果是关节
                    self.sim.setJointPosition(i, -current_positions[(i - 17) // 2])
        elif base_side == "right":
            self.sim.setObjectParent(self.part_30, -1)
            for i in range(29, 15, -1):
                self.sim.setObjectParent(i, i + 1)
                self.sim.setObjectMatrix(i, i + 1, self.matrix_left[i - 16])
                if i % 2 == 1:  # 如果是关节
                    self.sim.setJointPosition(i, -current_positions[(i - 17) // 2])

    def move(self, joint_positions):
        """
        移动机器人到给定的关节位置
        """
        if self.base == "A":
            self._set_joint_positions(joint_positions)
        elif self.base == "B":
            self._set_joint_positions(joint_positions[::-1])

    def print_joint_positions(self):
        """
        打印当前所有关节的位置
        """
        print("当前关节位置:")
        for i in range(7):
            print(f"关节 {i + 1}: {self.sim.getJointPosition(self.joints[i]):.4f}")


# 五次多项式轨迹规划
def compute_quintic_curve_coefficients(
    start_pos, end_pos, start_vel, end_vel, duration
):
    # 计算五次多项式的轨迹系数
    time_matrix = np.array(
        [
            [0, 0, 0, 0, 0, 1],
            [duration**5, duration**4, duration**3, duration**2, duration, 1],
            [0, 0, 0, 0, 1, 0],
            [5 * duration**4, 4 * duration**3, 3 * duration**2, 2 * duration, 1, 0],
            [0, 0, 0, 2, 0, 0],
            [20 * duration**3, 12 * duration**2, 6 * duration, 2, 0, 0],
        ]
    )
    inv_time_matrix = np.linalg.inv(time_matrix)
    coeffs = np.dot(
        inv_time_matrix,
        np.array(
            [
                [start, end, start_vel, end_vel, 0, 0]
                for start, end, start_vel, end_vel in zip(
                    start_pos, end_pos, start_vel, end_vel
                )
            ]
        ).T,
    ).T
    return coeffs


def execute_quintic_curve(coeffs, time):
    # 根据时间计算五次多项式轨迹的关节位置
    time_vector = np.array([time**5, time**4, time**3, time**2, time, 1])
    joint_positions = np.dot(coeffs, time_vector)
    return joint_positions


# 带中间速度的三点五次多项式轨迹规划
def compute_quintic_curve_with_mid_vel(
    start_pos, mid_pos, end_pos, mid_vel, time_start_mid, time_mid_end
):
    # 计算带中间速度的三点五次多项式轨迹系数
    time_matrix = np.array(
        [
            [0, 0, 0, 0, 0, 1],
            [
                time_start_mid**5,
                time_start_mid**4,
                time_start_mid**3,
                time_start_mid**2,
                time_start_mid,
                1,
            ],
            [
                time_mid_end**5,
                time_mid_end**4,
                time_mid_end**3,
                time_mid_end**2,
                time_mid_end,
                1,
            ],
            [0, 0, 0, 0, 1, 0],
            [
                5 * time_start_mid**4,
                4 * time_start_mid**3,
                3 * time_start_mid**2,
                2 * time_start_mid,
                1,
                0,
            ],
            [
                5 * time_mid_end**4,
                4 * time_mid_end**3,
                3 * time_mid_end**2,
                2 * time_mid_end,
                1,
                0,
            ],
        ]
    )
    inv_time_matrix = np.linalg.inv(time_matrix)
    coeffs = np.dot(
        inv_time_matrix,
        np.array(
            [
                [start, mid, end, 0, mid_vel, 0]
                for start, mid, end in zip(start_pos, mid_pos, end_pos)
            ]
        ).T,
    ).T
    return coeffs


def execute_quintic_curve_with_mid_vel(coeffs, time):
    # 根据时间计算三点五次多项式轨迹的关节位置
    time_vector = np.array([time**5, time**4, time**3, time**2, time, 1])
    joint_positions = np.dot(coeffs, time_vector)
    return joint_positions


# 主程序执行

# 创建机器人仿真器
robot_simulator = RobotSimulator()

# 定义关节配置（q0, q1, q1_ 和 q2）
q0 = [0, 0, 0, 0, 0, 0, 0]
q1 = [2.0944, 0, -0.7070, -1.4139, 0.7070, 0, -2.0944]
print("q1:   ", q1)
q1_ = [2.0944, 0, -0.7070, 1.4139, 0.7070, 0, -2.0944]
print("q1_:  ", q1_)
q2 = [4.9266, 0, -0.8038, 0.6938, -1.6808, 1.3566, 0]
print("q2:   ", q2)

# 定义运动时间
t01 = t12 = t23 = 10
total_time = t01 + t12 + t23

# 计算五次多项式系数
coeffs_01 = compute_quintic_curve_coefficients(q0, q1, np.zeros(7), np.zeros(7), t01)
coeffs_12 = compute_quintic_curve_coefficients(q1_, q2, np.zeros(7), np.zeros(7), t12)

# 仿真循环
time_list = []
joint_positions = [[], [], [], [], [], [], []]

while (current_time := robot_simulator.sim.getSimulationTime()) < total_time:
    if current_time < t01:
        robot_simulator.switch_base("B")
        joint_q = execute_quintic_curve(coeffs_01, current_time)
    elif current_time < t01 + t12:
        robot_simulator.switch_base("A")
        joint_q = execute_quintic_curve(coeffs_12, current_time - t01)

    robot_simulator.move(joint_q)
    time_list.append(current_time)
    for i in range(7):
        joint_positions[i].append(joint_q[i])

    robot_simulator.sim.addLog(
        robot_simulator.sim.verbosity_scriptinfos, f"仿真时间: {current_time:.2f} s"
    )
    robot_simulator.client.step()  # 触发下一步仿真
    time.sleep(0.01)

time.sleep(1)
robot_simulator.sim.stopSimulation()  # 停止仿真

# 恢复原始空闲帧率
robot_simulator.sim.setInt32Param(
    robot_simulator.sim.intparam_idle_fps, robot_simulator.default_idle_fps
)

print("Program ended")
