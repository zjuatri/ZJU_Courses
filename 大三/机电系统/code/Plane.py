from GeomBase import *
from Line import Line


class Plane:
    def __init__(self, P, N):
        if not isinstance(P, Point3D) or not isinstance(N, Vector3D):
            raise TypeError("Plane 需要 Point3D 和 Vector3D")
        self.P = P.clone()
        self.N = N.clone().normalized()

    def __str__(self):
        a, b, c, d = self.toFormula()
        return "Plane: %gx + %gy + %gz + %g = 0" % (a, b, c, d)

    def toFormula(self):
        n = self.N
        return n.dx, n.dy, n.dz, -(n.dx * self.P.x + n.dy * self.P.y + n.dz * self.P.z)

    @staticmethod
    def zPlane(z):
        return Plane(Point3D(0.0, 0.0, z), Vector3D(0.0, 0.0, 1.0))

    def intersect(self, other):
        if not isinstance(other, Plane):
            raise TypeError("other 必须是 Plane")
        direction = self.N.crossProduct(other.N)
        if direction.lengthSquare() <= epsilonSquare:
            return None


        d1 = self.N.dotProduct(Vector3D(self.P.x, self.P.y, self.P.z))
        d2 = other.N.dotProduct(Vector3D(other.P.x, other.P.y, other.P.z))
        dot = self.N.dotProduct(other.N)
        denominator = 1.0 - dot * dot
        if abs(denominator) <= epsilonSquare:
            return None
        alpha = (d1 - dot * d2) / denominator
        beta = (d2 - dot * d1) / denominator
        point = Point3D(alpha * self.N.dx + beta * other.N.dx,
                        alpha * self.N.dy + beta * other.N.dy,
                        alpha * self.N.dz + beta * other.N.dz)
        return Line(point, direction)
