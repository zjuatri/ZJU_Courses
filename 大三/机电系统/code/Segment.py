from GeomBase import Matrix3D, Point3D


class Segment:
    def __init__(self, A, B):
        if not isinstance(A, Point3D) or not isinstance(B, Point3D):
            raise TypeError("Segment 需要两个 Point3D")
        self.A = A.clone()
        self.B = B.clone()

    def multiply(self, m):
        if not isinstance(m, Matrix3D):
            raise TypeError("线段只能右乘 Matrix3D")
        self.A = self.A * m
        self.B = self.B * m
        return self

    def multiplied(self, m):
        return Segment(self.A, self.B).multiply(m)

    def __str__(self):
        return "Segment(A=%s, B=%s)" % (self.A, self.B)

    def length(self):
        return self.A.distance(self.B)

    def direction(self):
        return self.A.pointTo(self.B)

    def swap(self):
        self.A, self.B = self.B, self.A
        return self

