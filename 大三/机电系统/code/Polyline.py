from GeomBase import *
from Segment import Segment


class Polyline:
    def __init__(self):
        self.points = []

    def __str__(self):
        return "Polyline(%d points)" % len(self.points)

    def clone(self):
        result = Polyline()
        result.points = [point.clone() for point in self.points]
        return result

    def count(self):
        return len(self.points)

    def addPoint(self, pt):
        if not isinstance(pt, Point3D):
            raise TypeError("多边形顶点必须是 Point3D")
        self.points.append(pt.clone())
        return self

    def addTuple(self, tuple_value):
        if len(tuple_value) != 3:
            raise ValueError("点 tuple 必须包含 x、y、z 三个值")
        return self.addPoint(Point3D(*tuple_value))

    def raddPoint(self, pt):
        if not isinstance(pt, Point3D):
            raise TypeError("多边形顶点必须是 Point3D")
        self.points.insert(0, pt.clone())
        return self

    def removePoint(self, index):
        return self.points.pop(index)

    def point(self, index):
        return self.points[index]

    def startPoint(self):
        if not self.points:
            return None
        return self.points[0]

    def endPoint(self):
        if not self.points:
            return None
        return self.points[-1]

    def isClosed(self):
        return len(self.points) >= 2 and self.points[0].isCoincide(self.points[-1])

    def reverse(self):
        self.points.reverse()
        return self

    def getArea(self):
        if len(self.points) < 3:
            return 0.0
        n = len(self.points) - 1 if self.isClosed() else len(self.points)
        area2 = sum(self.points[i].x * self.points[(i + 1) % n].y -
                    self.points[(i + 1) % n].x * self.points[i].y
                    for i in range(n))
        return area2 * 0.5

    def makeCCW(self):
        if self.getArea() < -epsilon:
            self.reverse()
        return self

    def makeCW(self):
        if self.getArea() > epsilon:
            self.reverse()
        return self

    def isCCW(self):
        return self.getArea() > epsilon

    def translate(self, vec):
        if not isinstance(vec, Vector3D):
            raise TypeError("平移量必须是 Vector3D")
        for point in self.points:
            point.translate(vec)
        return self

    def translated(self, vec):
        return self.clone().translate(vec)

    def appendSegment(self, seg):
        if not isinstance(seg, Segment):
            raise TypeError("只能拼接 Segment")
        if self.count() == 0:
            self.addPoint(seg.A)
            self.addPoint(seg.B)
            return True
        start, end = self.startPoint(), self.endPoint()
        if end.isCoincide(seg.A):
            self.addPoint(seg.B)
        elif end.isCoincide(seg.B):
            self.addPoint(seg.A)
        elif start.isCoincide(seg.B):
            self.raddPoint(seg.A)
        elif start.isCoincide(seg.A):
            self.raddPoint(seg.B)
        else:
            return False
        return True

    def multiply(self, m):
        if not isinstance(m, Matrix3D):
            raise TypeError("多边形只能右乘 Matrix3D")
        self.points = [point * m for point in self.points]
        return self

    def multiplied(self, m):
        return self.clone().multiply(m)


def writePolyline(path, polyline):
    file = None
    try:
        if not isinstance(polyline, Polyline):
            raise TypeError("polyline 必须是 Polyline")
        file = open(path, "w", encoding="utf-8")
        file.write("%s\n" % polyline.count())
        for point in polyline.points:
            file.write("%s, %s, %s\n" % (point.x, point.y, point.z))
        return True
    except Exception as ex:
        print(ex)
        return None
    finally:
        if file is not None:
            file.close()


def readPolyline(path):
    file = None
    try:
        file = open(path, "r", encoding="utf-8")
        line = file.readline()
        if not line:
            return Polyline()
        number = int(line.strip())
        if number < 0:
            raise ValueError("顶点个数不能为负数")
        polyline = Polyline()
        for _ in range(number):
            values = [value.strip() for value in file.readline().split(",")]
            if len(values) != 3:
                raise ValueError("多边形点格式应为 x, y, z")
            polyline.addTuple(tuple(float(value) for value in values))
        return polyline
    except Exception as ex:
        print(ex)
        return None
    finally:
        if file is not None:
            file.close()
