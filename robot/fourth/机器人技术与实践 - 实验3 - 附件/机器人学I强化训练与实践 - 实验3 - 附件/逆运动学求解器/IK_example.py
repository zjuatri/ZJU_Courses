import IK.IK as IK
import numpy as np

if __name__ == '__main__':
    iks = IK.IKSolver()
    # [x, y, z, rx, ry, rz] (Cartesian, meter; X-Y'-Z'Euler, rad)
    q_result = iks.solve(np.array([0, 0.15, 0.6, -1.57, -0.82, -1.57]))
    print(q_result)
    