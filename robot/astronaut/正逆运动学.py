# -*- coding: utf-8 -*-
import numpy as np

P = np.pi
c = np.cos
s = np.sin
def Tran(alpha, a, d, theta):
    return np.array([
        [c(theta), -s(theta)*c(alpha), s(theta)*s(alpha), a*c(theta)],
        [s(theta), c(theta)*c(alpha), -c(theta)*s(alpha), a*s(theta)],
        [0,            s(alpha),             c(alpha),        d],
        [0,              0,                     0,            1]
    ])

def getT(X, Y, Z, a, b, y):
    return np.array([
        [c(y)*c(b),                         -s(y)*c(b),              s(b) ,  X],
        [c(a)*s(y) + s(a)*s(b)*c(y), c(a)*c(y) - s(a)*s(b)*s(y), -s(a)*c(b), Y],
        [s(a)*s(y) - c(a)*s(b)*c(y), s(a)*c(y) + c(a)*s(b)*s(y), c(a)*c(b),  Z],
        [0,                                     0,                    0,     1]
    ])

def getcoords(T):
    return T[0:3,3]

def getdegree(T):
    R = T[0:3, 0:3]
    phi = np.arctan2(-R[2, 1], R[2, 2])  # Roll
    theta = np.arcsin(R[2, 0])         # Pitch
    psi = np.arctan2(-R[1, 0], R[0, 0])  # Yaw
    # ת��Ϊ��
    phi_deg = np.degrees(phi)
    theta_deg = np.degrees(theta)
    psi_deg = np.degrees(psi)

    return phi_deg, theta_deg, psi_deg


def forward(q,base):
    if(base=="R"):
        t1 = q[0]
        t2 = q[1]
        t3 = q[2]
        t4 = -q[3]
        t5 = -q[4]
        t6 = -q[5]
        t7 = -q[6]
        T_01 = Tran(P/2, 0, 0.12, t1+P)
        T_12 = Tran(P/2, 0, 0.1, t2 - P / 2)
        T_23 = Tran(0, 0.4, 0.15, t3+P )
        T_34 = Tran(0, 0.4, 0.15, t4+P )
        T_45 = Tran(P/2, 0, 0, t5)
        T_56 = Tran(P/2, 0, 0.1, t6 + P / 2)
        T_67 = Tran(0, 0, 0.12, t7)
    elif(base=="L"):
        t1 = q[6]
        t2 = q[5]
        t3 = q[4]
        t4 = -q[3]
        t5 = -q[2]
        t6 = -q[1]
        t7 = -q[0]
        T_01 = Tran(P / 2, 0, 0.12, t1 + P)
        T_12 = Tran(P / 2, 0, 0.1, t2 - P / 2)
        T_23 = Tran(0, 0.4, 0.15, t3 + P)
        T_34 = Tran(0, 0.4, 0.15, t4 + P)
        T_45 = Tran(P / 2, 0, 0, t5)
        T_56 = Tran(P / 2, 0, 0.1, t6 + P / 2)
        T_67 = Tran(0, 0, 0.12, t7)
    return  T_01 @ T_12 @ T_23 @ T_34 @ T_45 @ T_56 @ T_67 


def getCD(T):
    CD = np.zeros(6)
    R = T[0:3, 0:3]
    phi = np.arctan2(-R[2, 1], R[2, 2])  # Roll
    theta = np.arcsin(R[2, 0])         # Pitch
    psi = np.arctan2(-R[1, 0], R[0, 0])  # Yaw
    
    CD[0:3] = T[0:3,3]
    CD[3:6] = np.array([phi, theta, psi])
    return CD.T

def printT(T):
    print(T)
    print(getcoords(T))
    print(getdegree(T))

def solve(CD, base):
    X, Y, Z, a, b, y = CD
    c = np.cos
    s = np.sin
    P = np.pi
    T_end = np.array(
        [
            [c(y) * c(b), -s(y) * c(b), s(b), X],
            [
                c(a) * s(y) + s(a) * s(b) * c(y),
                c(a) * c(y) - s(a) * s(b) * s(y),
                -s(a) * c(b),
                Y,
            ],
            [
                s(a) * s(y) - c(a) * s(b) * c(y),
                s(a) * c(y) + c(a) * s(b) * s(y),
                c(a) * c(b),
                Z,
            ],
            [0, 0, 0, 1],
        ]
    )
    nx, ny, nz = T_end[0:3, 0]
    ox, oy, oz = T_end[0:3, 1]
    ax, ay, az = T_end[0:3, 2]
    px, py, pz = T_end[0:3, 3]
    t2 = 0  
    # R_base
    d1, d2, d3, d4, d5, d6, d7 = 0.12, 0.1, 0.15, 0.15, 0, 0.1, 0.12
    a3, a4 = 0.4, 0.4

    # theta1
    m1 = d7 * ax - px
    n1 = py - d7 * ay
    const1 = -d3 - d4
    t1 = np.arctan2(m1, n1) - np.arctan2(const1, np.sqrt(m1**2 + n1**2 - const1**2))
    s1, c1 = s(t1), c(t1)

    # theta7
    m7 = ox * c1 + oy * s1
    n7 = nx * c1 + ny * s1
    t7 = -np.arctan2(m7, n7)
    s7, c7 = s(t7), c(t7)

    # theta6
    m6 = ax * c1 + ay * s1
    n6 = nx * c1 * c7 + ny * s1 * c7 - ox * s7 * c1 - oy * s7 * s1
    t6 = np.arctan2(m6, n6)
    s6, c6 = s(t6), c(t6)

    # theta4
    m4 = -az * d7 - d1 - d6 * (nz * s7 + oz * c7) + pz
    n4 = (
        d6 * ((nx * s1 - ny * c1) * s7 + (ox * s1 - oy * c1) * c7)
        + d7 * (ax * s1 - ay * c1)
        - px * s1
        + py * c1
        - d2
    )
    COS4 = (a3**2 + a4**2 - m4**2 - n4**2) / (2 * a3 * a4)
    t4 = np.arccos(COS4)
    s4, c4 = s(t4), c(t4)

    # theta3
    m3 = a3 - a4 * c4
    n3 = a4 * s4
    t3 = np.arctan2(n3 * m4 - m3 * n4, m3 * m4 + n3 * n4)
    s3, c3 = s(t3), c(t3)

    # theta5
    s345 = -nz * s7 - oz * c7
    c345 = (nx * s1 - ny * c1) * s7 + (ox * s1 - oy * c1) * c7
    t345 = np.arctan2(s345, c345)
    t5 = t345 - t3 - t4
    s5, c5 = s(t5), c(t5)
    # R_base
    ans = np.array([t1, t2, t3, -t4, -t5, -t6, -t7])
    # L_base
    if base == "L":
        ans = np.array([-t7, -t6, -t5, -t4, t3, t2, t1])
    ans = np.array([(t + P) % (2 * P) - P for t in ans])

    return ans

def printT(T):
    print("XYZ:")
    print(getcoords(T))
    print("aby:")
    print(getdegree(T))


P = np.pi
CD1 = np.array([0.3, 0, 0, -P, 0, 0])  # R_base
q1 = solve(CD1,"R")
print("q1: ")
print(q1)
T1 = forward(q1, "R")
printT(T1)
print("\n")
CD2 = np.array([0.3, 0, 0, -P, 0, 0])  # L_base
q2 = solve(CD2,"L")
print("q2: ")
print(q2)
T2 = forward(q2, "L")
printT(T2)
print("\n")

q=np.zeros(7)
print(forward(q, "R"))
printT(forward(q, "R"))
