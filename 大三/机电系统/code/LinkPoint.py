from GeomBase import Point3D, epsilon


class LinkPoint:
    def __init__(self, pnt3d, digits=7):
        self.x = round(pnt3d.x, digits)
        self.y = round(pnt3d.y, digits)
        self.z = round(pnt3d.z, digits)
        self.other = None
        self.used = False
        self.index = 0

    def __str__(self):
        other = None if self.other is None else self.other.toTuple()
        return f"LinkPoint({self.toTuple()}, used={self.used}, other={other})"

    def toTuple(self):
        return self.x, self.y, self.z

    def toPoint3D(self):
        return Point3D(self.x, self.y, self.z)


def createLinkPoints(segs):
    points, seen = [], set()
    for seg in segs:
        if seg.length() <= epsilon:
            continue
        a, b = LinkPoint(seg.A), LinkPoint(seg.B)
        key = tuple(sorted((a.toTuple(), b.toTuple())))
        if key[0] == key[1] or key in seen:
            continue
        seen.add(key)
        a.other, b.other = b, a
        points.extend((a, b))
    return points

