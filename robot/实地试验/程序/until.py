import math
import numpy as np


# 两点间五次多项式轨迹规划，返回值kArray为多项式系数
def quinticCurvePlanning(startPosition, endPosition, time):
    timeMatrix = np.matrix([
        [         0,           0,             0,          0,        0,   1],
        [   time**5,     time**4,       time**3,    time**2,     time,   1],
        [         0,           0,             0,          0,        1,   0],
        [ 5*time**4,   4*time**3,     3*time**2,     2*time,        1,   0],
        [         0,           0,             0,          2,        0,   0],
        [20*time**3,  12*time**2,        6*time,          2,        0,   0]

    ])
    invTimeMatrix = np.linalg.inv(timeMatrix)
    kArray = []
    for i in range(len(startPosition)):
        X = np.matrix([startPosition[i], endPosition[i],0,0,0,0]).T
        k = np.dot(invTimeMatrix,X)
        kArray.append(k)
    return kArray

# 两点间规划，带入当前时间time，求得当前时刻下的关节位置值
def quinticCurveExcute(kArray, time):
    timeVector = np.matrix([time**5,     time**4,       time**3,    time**2,     time,   1]).T
    jointPositions = []
    for i in range(6):
        jointPosition = np.dot(kArray[i].T,timeVector)
        jointPositions.append(jointPosition[0,0])
    return np.array(jointPositions)

# 三点间五次多项式轨迹规划，返回值kArray为多项式系数，其中起点终点速度均为零，中间点速度可以规划，为入参midVel
# 其中time为起点到中间点的运动时间，time1为起始点到终点的运动时间（即整段规划的运动时间）
def quinticCurvePlanning2(startPosition, middlePosition, endPosition, midVel, time, time1):
    timeMatrix = np.matrix([
        [          0,            0,              0,           0,        0,   1],
        [    time**5,      time**4,        time**3,     time**2,     time,   1],
        [   time1**5,     time1**4,       time1**3,    time1**2,    time1,   1],
        [          0,            0,              0,           0,        1,   0],
        [  5*time**4,    4*time**3,      3*time**2,      2*time,        1,   0],
        [ 5*time1**4,   4*time1**3,     3*time1**2,     2*time1,        1,   0],
    ])
    invTimeMatrix = np.linalg.inv(timeMatrix)
    kArray = []
    for i in range(len(startPosition)):
        X = np.matrix([startPosition[i], middlePosition[i], endPosition[i],0,midVel,0]).T
        k = np.dot(invTimeMatrix,X)
        kArray.append(k)
    return kArray

# 三点间规划，带入当前时间time，求得当前时刻下的关节位置值
def quinticCurveExcute2(kArray, time):
    timeVector = np.matrix([time**5,     time**4,       time**3,    time**2,     time,   1]).T
    jointPositions = []
    for i in range(6):
        jointPosition = np.dot(kArray[i].T,timeVector)
        jointPositions.append(jointPosition[0,0])
    return np.array(jointPositions)