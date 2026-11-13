from GeomBase import Point3D, Vector3D


class Triangle:
    def __init__(self, A, B, C, N=None):
        if not all(isinstance(p, Point3D) for p in (A, B, C)):
            raise TypeError("三角形顶点必须是 Point3D")
        if N is not None and not isinstance(N, Vector3D):
            raise TypeError("三角形法向量必须是 Vector3D")
        self.A, self.B, self.C = A.clone(), B.clone(), C.clone()
        self.N = N.clone() if N is not None else Vector3D()
        self.zs = []

    def __str__(self):
        return "Triangle(A=%s, B=%s, C=%s, N=%s)" % (
            self.A, self.B, self.C, self.N)

    def zMinPnt(self):
        return min((self.A, self.B, self.C), key=lambda p: p.z)

    def zMaxPnt(self):
        return max((self.A, self.B, self.C), key=lambda p: p.z)

    def calcNormal(self):
        normal = self.A.pointTo(self.B).crossProduct(self.A.pointTo(self.C))
        self.N = Vector3D() if normal.isZeroVector() else normal.normalized()
        return self.N
