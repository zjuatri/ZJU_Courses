import math


epsilon = 1.0e-7
epsilonSquare = epsilon * epsilon


class Point3D:
    def __init__(self, x=0.0, y=0.0, z=0.0, w=1.0):
        self.x, self.y, self.z, self.w = x, y, z, w

    def __str__(self):
        return "Point3D: %g, %g, %g" % (self.x, self.y, self.z)

    def clone(self):
        return Point3D(self.x, self.y, self.z, self.w)

    def pointTo(self, other):
        return Vector3D(other.x - self.x, other.y - self.y, other.z - self.z,
                        other.w - self.w)

    def translate(self, vec):
        self.x += vec.dx
        self.y += vec.dy
        self.z += vec.dz
        self.w += vec.dw
        return self

    def translated(self, vec):
        return self.clone().translate(vec)

    def multiplied(self, m):
        if not isinstance(m, Matrix3D):
            raise TypeError("点只能右乘 Matrix3D")
        values = (self.x, self.y, self.z, self.w)
        result = [sum(values[i] * m.a[i][j] for i in range(4))
                  for j in range(4)]
        return Point3D(*result)

    def distanceSquare(self, other):
        dx, dy, dz = self.x - other.x, self.y - other.y, self.z - other.z
        return dx * dx + dy * dy + dz * dz

    def distance(self, other):
        return math.sqrt(self.distanceSquare(other))

    def middle(self, other):
        return Point3D((self.x + other.x) / 2.0,
                       (self.y + other.y) / 2.0,
                       (self.z + other.z) / 2.0,
                       (self.w + other.w) / 2.0)

    def isCoincide(self, other):
        return self.distanceSquare(other) <= epsilonSquare

    def isIdentical(self, other):
        return (self.x == other.x and self.y == other.y and
                self.z == other.z and self.w == other.w)

    def __add__(self, vec):
        if not isinstance(vec, Vector3D):
            return NotImplemented
        return self.translated(vec)

    def __sub__(self, other):
        if isinstance(other, Point3D):
            return other.pointTo(self)
        if isinstance(other, Vector3D):
            return self.translated(other.reversed())
        return NotImplemented

    def __mul__(self, m):
        return self.multiplied(m)


class Vector3D:
    def __init__(self, dx=0.0, dy=0.0, dz=0.0, dw=0.0):
        self.dx, self.dy, self.dz, self.dw = dx, dy, dz, dw

    def __str__(self):
        return "Vector3D: %g, %g, %g" % (self.dx, self.dy, self.dz)

    def clone(self):
        return Vector3D(self.dx, self.dy, self.dz, self.dw)

    def reverse(self):
        self.dx, self.dy, self.dz, self.dw = (-self.dx, -self.dy,
                                               -self.dz, -self.dw)
        return self

    def reversed(self):
        return self.clone().reverse()

    def dotProduct(self, other):
        return self.dx * other.dx + self.dy * other.dy + self.dz * other.dz

    def crossProduct(self, other):
        return Vector3D(self.dy * other.dz - self.dz * other.dy,
                        self.dz * other.dx - self.dx * other.dz,
                        self.dx * other.dy - self.dy * other.dx)

    def amplify(self, f):
        self.dx *= f
        self.dy *= f
        self.dz *= f
        self.dw *= f
        return self

    def amplified(self, f):
        return self.clone().amplify(f)

    def lengthSquare(self):
        return self.dx * self.dx + self.dy * self.dy + self.dz * self.dz

    def length(self):
        return math.sqrt(self.lengthSquare())

    def normalize(self):
        length = self.length()
        if length <= epsilon:
            raise ValueError("零向量不能单位化")
        self.dx /= length
        self.dy /= length
        self.dz /= length

        self.dw /= length
        return self

    def normalized(self):
        return self.clone().normalize()

    def isZeroVector(self):
        return self.lengthSquare() <= epsilonSquare

    def multiplied(self, m):
        if not isinstance(m, Matrix3D):
            raise TypeError("向量只能右乘 Matrix3D")
        values = (self.dx, self.dy, self.dz, self.dw)
        result = [sum(values[i] * m.a[i][j] for i in range(4))
                  for j in range(4)]
        return Vector3D(*result)

    def isParallel(self, other):
        return self.crossProduct(other).isZeroVector()

    def getAngle(self, vec):
        denominator = self.length() * vec.length()
        if denominator <= epsilon:
            raise ValueError("零向量没有定义夹角")
        value = max(-1.0, min(1.0, self.dotProduct(vec) / denominator))
        return math.acos(value)

    def getAngle2D(self):
        if self.lengthSquare() <= epsilonSquare:
            raise ValueError("零向量没有定义方向角")
        angle = math.atan2(self.dy, self.dx)
        if angle < 0.0:
            return angle + 2.0 * math.pi
        return angle

    def getOrthoVector2D(self):

        return Vector3D(-self.dy, self.dx, 0.0)

    def __add__(self, other):
        if not isinstance(other, Vector3D):
            return NotImplemented
        return Vector3D(self.dx + other.dx, self.dy + other.dy,
                        self.dz + other.dz, self.dw + other.dw)

    def __sub__(self, other):
        if not isinstance(other, Vector3D):
            return NotImplemented
        return Vector3D(self.dx - other.dx, self.dy - other.dy,
                        self.dz - other.dz, self.dw - other.dw)

    def __mul__(self, m):
        if isinstance(m, (int, float)):
            return self.amplified(m)
        return self.multiplied(m)

class Matrix3D:
    def __init__(self, values=None):
        if values is None:
            self.a = [[1.0, 0.0, 0.0, 0.0],
                      [0.0, 1.0, 0.0, 0.0],
                      [0.0, 0.0, 1.0, 0.0],
                      [0.0, 0.0, 0.0, 1.0]]
        else:
            if len(values) != 4 or any(len(row) != 4 for row in values):
                raise ValueError("Matrix3D 必须是 4x4 矩阵")
            self.a = [list(row) for row in values]

    def __str__(self):
        return "Matrix3D\n" + "\n".join(" ".join("%g" % v for v in row)
                                             for row in self.a)

    def makeIdentical(self):
        self.a = Matrix3D().a
        return self

    def multiplied(self, other):
        if not isinstance(other, Matrix3D):
            raise TypeError("矩阵只能与 Matrix3D 相乘")
        return Matrix3D([[sum(self.a[i][k] * other.a[k][j]
                              for k in range(4)) for j in range(4)]
                         for i in range(4)])


    def getDeterminant(self):
        matrix = [row[:] for row in self.a]
        determinant = 1.0
        for col in range(4):
            pivot = max(range(col, 4), key=lambda r: abs(matrix[r][col]))
            if abs(matrix[pivot][col]) <= epsilon:
                return 0.0
            if pivot != col:
                matrix[col], matrix[pivot] = matrix[pivot], matrix[col]
                determinant = -determinant
            pivot_value = matrix[col][col]
            determinant *= pivot_value
            for row in range(col + 1, 4):
                factor = matrix[row][col] / pivot_value
                for j in range(col + 1, 4):
                    matrix[row][j] -= factor * matrix[col][j]
        return determinant

    def getReverseMatrix(self):
        augmented = [self.a[i][:] + Matrix3D().a[i][:] for i in range(4)]
        for col in range(4):
            pivot = max(range(col, 4), key=lambda r: abs(augmented[r][col]))
            if abs(augmented[pivot][col]) <= epsilon:
                raise ValueError("奇异矩阵不存在逆矩阵")
            augmented[col], augmented[pivot] = augmented[pivot], augmented[col]
            value = augmented[col][col]
            augmented[col] = [x / value for x in augmented[col]]
            for row in range(4):
                if row == col:
                    continue
                factor = augmented[row][col]
                augmented[row] = [augmented[row][j] - factor * augmented[col][j]
                                  for j in range(8)]
        return Matrix3D([row[4:] for row in augmented])

    @staticmethod
    def createTranslateMatrix(dx=0.0, dy=0.0, dz=0.0):
        m = Matrix3D()
        m.a[3][0], m.a[3][1], m.a[3][2] = dx, dy, dz
        return m

    @staticmethod
    def createScaleMatrix(sx=1.0, sy=1.0, sz=1.0):
        m = Matrix3D()
        m.a[0][0], m.a[1][1], m.a[2][2] = sx, sy, sz
        return m

    @staticmethod
    def createRotateMatrix(axis, angle):
        n = axis.normalized()
        x, y, z = n.dx, n.dy, n.dz
        c, s, t = math.cos(angle), math.sin(angle), 1.0 - math.cos(angle)

        return Matrix3D([
            [t*x*x + c,   t*x*y + s*z, t*x*z - s*y, 0.0],
            [t*x*y - s*z, t*y*y + c,   t*y*z + s*x, 0.0],
            [t*x*z + s*y, t*y*z - s*x, t*z*z + c,   0.0],
            [0.0, 0.0, 0.0, 1.0],
        ])

    @staticmethod
    def createMirrorMatrix(point, normal):
        n = normal.normalized()
        x, y, z = n.dx, n.dy, n.dz
        r = [[1 - 2*x*x, -2*x*y, -2*x*z],
             [-2*y*x, 1 - 2*y*y, -2*y*z],
             [-2*z*x, -2*z*y, 1 - 2*z*z]]

        d = 2.0 * (point.x*x + point.y*y + point.z*z)
        return Matrix3D([r[0] + [0.0], r[1] + [0.0], r[2] + [0.0],
                         [d*x, d*y, d*z, 1.0]])

    def __mul__(self, other):
        return self.multiplied(other)

    def __add__(self, other):
        if not isinstance(other, Matrix3D):
            return NotImplemented
        return Matrix3D([[self.a[i][j] + other.a[i][j] for j in range(4)]
                         for i in range(4)])

    def __sub__(self, other):
        if not isinstance(other, Matrix3D):
            return NotImplemented
        return Matrix3D([[self.a[i][j] - other.a[i][j] for j in range(4)]
                         for i in range(4)])
