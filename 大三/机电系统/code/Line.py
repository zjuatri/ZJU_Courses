from GeomBase import *


class Line:
    def __init__(self, P, V):
        if not isinstance(P, Point3D) or not isinstance(V, Vector3D):
            raise TypeError("Line 需要 Point3D 和 Vector3D")
        self.P = P.clone()
        self.V = V.clone().normalized()

    def __str__(self):
        return "Line(P=%s, V=%s)" % (self.P, self.V)
