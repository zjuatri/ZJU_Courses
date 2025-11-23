import numpy as np
cimport numpy as np
from libc.math cimport sin, cos, sqrt, atan2, acos, asin, M_PI, fabs, isnan

cdef class IKSolver:
    cdef double d1, d2, a1, a2, a3, d4, d5, d6
    cdef double[6][2] limits
    
    def __init__(self):
        # DH Parameters (Meters) - 与MATLAB保持一致
        self.d1 = 0.230
        self.d2 = -0.054
        self.a1 = 0.000  # MATLAB中a_num[0] = 0
        self.a2 = 0.185  # MATLAB中a_num[2] = 185/1000
        self.a3 = 0.170  # MATLAB中a_num[3] = 170/1000
        self.d4 = 0.077
        self.d5 = 0.077
        self.d6 = 0.0855
        
        # Joint Limits (Radians)
        deg2rad = M_PI / 180.0
        self.limits[0][0] = -200 * deg2rad; self.limits[0][1] = 200 * deg2rad
        self.limits[1][0] = -90 * deg2rad;  self.limits[1][1] = 90 * deg2rad
        self.limits[2][0] = -120 * deg2rad; self.limits[2][1] = 120 * deg2rad
        self.limits[3][0] = -150 * deg2rad; self.limits[3][1] = 150 * deg2rad
        self.limits[4][0] = -150 * deg2rad; self.limits[4][1] = 150 * deg2rad
        self.limits[5][0] = -180 * deg2rad; self.limits[5][1] = 180 * deg2rad

    def solve(self, target_pose):
        """
        Solves IK for ZJU-1 robot using the analytical algorithm ported from MATLAB (matlab.mat).
        target_pose: np.array([x, y, z, alpha, beta, gamma])
        Returns: np.ndarray (6, N) containing valid solutions.
        """
        cdef double px, py, pz, rx, ry, rz
        cdef double nx, ny, nz
        cdef double ox, oy, oz
        cdef double ax, ay, az
        cdef double cx, sx, cy, sy, cz, sz
        cdef double R[3][3]
        
        # MDH Parameters
        cdef double d1 = self.d1
        cdef double d2 = self.d2
        cdef double d4 = self.d4
        cdef double d5 = self.d5
        cdef double d6 = self.d6
        cdef double a2 = self.a2
        cdef double a3 = self.a3
        
        # Offsets (rad)
        cdef double off1 = 0.0
        cdef double off2 = -M_PI / 2.0
        cdef double off3 = 0.0
        cdef double off4 = M_PI / 2.0
        cdef double off5 = M_PI / 2.0
        cdef double off6 = 0.0
        
        # Internal variables
        cdef double A1, B1, C1, rho2, C12, sq1
        cdef double th1, q1, c1, s1v
        cdef double c5, th5, q5, s5v
        cdef double A6, B6, th6, q6, c6, s6
        cdef double m, n, num_c3, den_c3, c3, th3, q3, s3v, c3v
        cdef double K1, K2, den_q2, s2v, c2v, th2, q2
        cdef double y4_val, x4_val, th4, q4
        
        cdef double s1_loop, s5_loop, s3_loop
        cdef double epsilon = 1e-6
        
        solutions = []
        
        # Extract pose
        px = target_pose[0]
        py = target_pose[1]
        pz = target_pose[2]
        rx = target_pose[3]
        ry = target_pose[4]
        rz = target_pose[5]
        
        # Calculate Rotation Matrix R = Rx*Ry*Rz
        cx = cos(rx); sx = sin(rx)
        cy = cos(ry); sy = sin(ry)
        cz = cos(rz); sz = sin(rz)
        
        # R = Rx * Ry * Rz
        # Row 0
        R[0][0] = cy * cz
        R[0][1] = -cy * sz
        R[0][2] = sy
        # Row 1
        R[1][0] = sx * sy * cz + cx * sz
        R[1][1] = -sx * sy * sz + cx * cz
        R[1][2] = -sx * cy
        # Row 2
        R[2][0] = -cx * sy * cz + sx * sz
        R[2][1] = cx * sy * sz + sx * cz
        R[2][2] = cx * cy
        
        nx = R[0][0]; ny = R[1][0]; nz = R[2][0]
        ox = R[0][1]; oy = R[1][1]; oz = R[2][1]
        ax = R[0][2]; ay = R[1][2]; az = R[2][2]
        
        # ================= q1 =================
        A1 = py - ay * d6
        B1 = px - ax * d6
        C1 = d2 + d4
        
        rho2 = A1*A1 + B1*B1
        C12 = C1*C1
        
        if rho2 < C12:
            return np.array([]).reshape(6, 0)
            
        sq1 = sqrt(rho2 - C12)
        
        for s1_loop in [1.0, -1.0]:
            th1 = atan2(A1, B1) - atan2(C1, s1_loop * sq1)
            q1 = th1 - off1
            # Check Limit q1
            if q1 < self.limits[0][0] or q1 > self.limits[0][1]:
                continue
                
            c1 = cos(th1)
            s1v = sin(th1)
            
            # ================= q5 =================
            c5 = ax * s1v - ay * c1
            if fabs(c5) > 1.0 + epsilon:
                continue
            if c5 > 1.0: c5 = 1.0
            if c5 < -1.0: c5 = -1.0
            
            for s5_loop in [1.0, -1.0]:
                th5 = s5_loop * acos(c5)
                q5 = th5 - off5
                
                # Normalize q5 to [-pi, pi]
                q5 = atan2(sin(q5), cos(q5))
                
                # Check Limit q5
                if q5 < self.limits[4][0] or q5 > self.limits[4][1]:
                    continue
                    
                s5v = sin(th5)
                
                # ================= q6 =================
                A6 = ny * c1 - nx * s1v
                B6 = oy * c1 - ox * s1v
                
                if (A6*A6 + B6*B6 < epsilon):
                    continue
                
                if fabs(s5v) < epsilon:
                    th6 = 0.0
                else:
                    th6 = atan2(-B6*s5v, A6*s5v)
                
                q6 = th6 - off6
                # Normalize q6
                q6 = atan2(sin(q6), cos(q6))
                
                # Check Limit q6
                if q6 < self.limits[5][0] or q6 > self.limits[5][1]:
                    continue
                    
                c6 = cos(th6)
                s6 = sin(th6)
                
                # ================= q3 =================
                # m = -d5*( s6*(ny*s1v + nx*c1) + c6*(ox*c1 + oy*s1v) ) 
                #     - d6*(ay*s1v + ax*c1) + px*c1 + py*s1v;
                m = -d5 * ( s6*(ny*s1v + nx*c1) + c6*(ox*c1 + oy*s1v) ) \
                    -d6 * (ay*s1v + ax*c1) + px*c1 + py*s1v
                
                # n = pz - d1 - az*d6 - d5*oz*c6 - d5*nz*s6;
                n = pz - d1 - az*d6 - d5*oz*c6 - d5*nz*s6
                
                num_c3 = m*m + n*n - a3*a3 - a2*a2
                den_c3 = 2.0 * a2 * a3
                
                if fabs(den_c3) < epsilon:
                    continue
                    
                c3 = num_c3 / den_c3
                
                if fabs(c3) > 1.0 + epsilon:
                    continue
                if c3 > 1.0: c3 = 1.0
                if c3 < -1.0: c3 = -1.0
                
                for s3_loop in [1.0, -1.0]:
                    th3 = s3_loop * acos(c3)
                    q3 = th3 - off3
                    # Normalize q3
                    q3 = atan2(sin(q3), cos(q3))
                    
                    # Check Limit q3
                    if q3 < self.limits[2][0] or q3 > self.limits[2][1]:
                        continue
                        
                    s3v = sin(th3)
                    c3v = cos(th3)
                    
                    # ================= q2 =================
                    K1 = a2 + a3*c3v
                    K2 = a3*s3v
                    den_q2 = m*m + n*n
                    
                    if den_q2 < epsilon:
                        continue
                    
                    s2v = -(m*K2 + n*K1) / den_q2
                    c2v =  (m*K1 - n*K2) / den_q2
                    th2 = atan2(s2v, c2v)
                    q2 = th2 - off2
                    
                    # Normalize q2
                    q2 = atan2(sin(q2), cos(q2))
                    
                    # Check Limit q2
                    if q2 < self.limits[1][0] or q2 > self.limits[1][1]:
                        continue
                    
                    # ================= q4 =================
                    # y4 = ox*c1*c6 + nx*c1*s6 + oy*c6*s1v + ny*s1v*s6;
                    y4_val = ox*c1*c6 + nx*c1*s6 + oy*c6*s1v + ny*s1v*s6
                    # x4 = oz*c6 + nz*s6;
                    x4_val = oz*c6 + nz*s6
                    
                    th4 = atan2(y4_val, x4_val) - th2 - th3
                    q4 = th4 - off4
                    
                    # Normalize q4
                    q4 = atan2(sin(q4), cos(q4))
                    
                    # Check Limit q4
                    if q4 < self.limits[3][0] or q4 > self.limits[3][1]:
                        continue
                    
                    sol_row = np.array([q1, q2, q3, q4, q5, q6])
                    solutions.append(sol_row)
        
        if len(solutions) == 0:
             return np.array([]).reshape(6, 0)
             
        return np.array(solutions).T
