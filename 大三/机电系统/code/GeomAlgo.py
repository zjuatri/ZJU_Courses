import math

from GeomBase import Matrix3D, Point3D, Vector3D, epsilon, epsilonSquare
from Line import Line
from Ray import Ray
from Segment import Segment
from Plane import Plane


def nearZero(x):
    return abs(x) < epsilon


def pointLineDistance(point, line):
    if not isinstance(point, Point3D) or not isinstance(line, Line):
        raise TypeError("需要 Point3D 和 Line")
    t = line.P.pointTo(point).dotProduct(line.V)
    projection = line.P + line.V * t
    return point.distance(projection)


def pointRayDistance(point, ray):
    if not isinstance(point, Point3D) or not isinstance(ray, Ray):
        raise TypeError("需要 Point3D 和 Ray")
    t = ray.P.pointTo(point).dotProduct(ray.V)
    if t < 0.0:
        return point.distance(ray.P)
    return point.distance(ray.P + ray.V * t)


def pointOnRay(point, ray):
    return pointRayDistance(point, ray) <= epsilon


def pointSegmentDistance(point, segment):
    if not isinstance(point, Point3D) or not isinstance(segment, Segment):
        raise TypeError("需要 Point3D 和 Segment")
    length = segment.length()
    if length <= epsilon:
        return point.distance(segment.A)
    direction = segment.direction().amplified(1.0 / length)
    t = segment.A.pointTo(point).dotProduct(direction)
    if t <= 0.0:
        return point.distance(segment.A)
    if t >= length:
        return point.distance(segment.B)
    return point.distance(segment.A + direction * t)


def pointPlaneDistance(point, plane):
    if not isinstance(point, Point3D) or not isinstance(plane, Plane):
        raise TypeError("需要 Point3D 和 Plane")
    return abs(plane.N.dotProduct(plane.P.pointTo(point)))


def linePlaneDistance(line, plane):
    if not isinstance(line, Line) or not isinstance(plane, Plane):
        raise TypeError("需要 Line 和 Plane")
    if abs(line.V.dotProduct(plane.N)) > epsilon:
        return 0.0
    return pointPlaneDistance(line.P, plane)


def rayPlaneDistance(ray, plane):
    if not isinstance(ray, Ray) or not isinstance(plane, Plane):
        raise TypeError("需要 Ray 和 Plane")
    signed = plane.N.dotProduct(ray.V)
    if abs(signed) <= epsilon:
        return pointPlaneDistance(ray.P, plane)

    side = plane.N.dotProduct(plane.P.pointTo(ray.P))
    if side * signed < 0.0 or abs(side) <= epsilon:
        return 0.0
    return abs(side)


def segmentPlaneDistance(segment, plane):
    if not isinstance(segment, Segment) or not isinstance(plane, Plane):
        raise TypeError("需要 Segment 和 Plane")
    side_a = plane.N.dotProduct(plane.P.pointTo(segment.A))
    side_b = plane.N.dotProduct(plane.P.pointTo(segment.B))
    if abs(side_a) <= epsilon or abs(side_b) <= epsilon or side_a * side_b < 0.0:
        return 0.0
    return min(abs(side_a), abs(side_b))


def lineLineDistance(line1, line2):
    if not isinstance(line1, Line) or not isinstance(line2, Line):
        raise TypeError("需要两个 Line")
    normal = line1.V.crossProduct(line2.V)
    if normal.lengthSquare() <= epsilonSquare:
        return pointLineDistance(line1.P, line2)
    return abs(line1.P.pointTo(line2.P).dotProduct(normal.normalized()))


def distance(obj1, obj2):
    if isinstance(obj1, Point3D):
        if isinstance(obj2, Line):
            return pointLineDistance(obj1, obj2)
        if isinstance(obj2, Ray):
            return pointRayDistance(obj1, obj2)
        if isinstance(obj2, Segment):
            return pointSegmentDistance(obj1, obj2)
        if isinstance(obj2, Plane):
            return pointPlaneDistance(obj1, obj2)
    if isinstance(obj2, Point3D) and isinstance(obj1, (Line, Ray, Segment, Plane)):
        return distance(obj2, obj1)
    if isinstance(obj1, Line) and isinstance(obj2, Line):
        return lineLineDistance(obj1, obj2)
    if isinstance(obj1, (Line, Ray, Segment)) and isinstance(obj2, Plane):
        if isinstance(obj1, Line):
            return linePlaneDistance(obj1, obj2)
        if isinstance(obj1, Ray):
            return rayPlaneDistance(obj1, obj2)
        return segmentPlaneDistance(obj1, obj2)
    if isinstance(obj1, Plane) and isinstance(obj2, (Line, Ray, Segment)):
        return distance(obj2, obj1)
    raise TypeError("不支持这两个实体的距离计算")


def intersectLineLine(line1, line2):
    if not isinstance(line1, Line) or not isinstance(line2, Line):
        raise TypeError("需要两个 Line")
    w = line1.P.pointTo(line2.P)
    cross = line1.V.crossProduct(line2.V)
    denom = cross.lengthSquare()
    if denom <= epsilonSquare:
        return None
    if abs(w.dotProduct(cross)) > epsilon * max(1.0, w.length()):
        return None
    t = w.crossProduct(line2.V).dotProduct(cross) / denom
    return line1.P + line1.V * t


def _entity_line(entity):
    if isinstance(entity, Line):
        return entity, None, None
    if isinstance(entity, Ray):
        return Line(entity.P, entity.V), 0.0, math.inf
    if isinstance(entity, Segment):
        length = entity.length()
        if length <= epsilon:
            return None, 0.0, 0.0
        direction = entity.direction().amplified(1.0 / length)
        return Line(entity.A, direction), 0.0, length
    raise TypeError("实体必须是 Line、Ray 或 Segment")


def entityIntersection(entity1, entity2):
    line1, low1, high1 = _entity_line(entity1)
    line2, low2, high2 = _entity_line(entity2)
    if line1 is None or line2 is None:

        point = entity1.A if line1 is None else entity2.A
        other = entity2 if line1 is None else entity1
        if isinstance(other, Line):
            separation = pointLineDistance(point, other)
        elif isinstance(other, Ray):
            separation = pointRayDistance(point, other)
        else:
            separation = pointSegmentDistance(point, other)
        if separation <= epsilon:
            return point
        return None
    point = intersectLineLine(line1, line2)
    if point is None:
        return None
    t1 = line1.P.pointTo(point).dotProduct(line1.V)
    t2 = line2.P.pointTo(point).dotProduct(line2.V)
    if low1 is not None and (t1 < low1 - epsilon or t1 > high1 + epsilon):
        return None
    if low2 is not None and (t2 < low2 - epsilon or t2 > high2 + epsilon):
        return None
    return point


def linePlaneIntersection(line, plane):
    if not isinstance(line, Line) or not isinstance(plane, Plane):
        raise TypeError("需要 Line 和 Plane")
    denominator = line.V.dotProduct(plane.N)
    if abs(denominator) <= epsilon:
        return None
    t = plane.N.dotProduct(line.P.pointTo(plane.P)) / denominator
    return line.P + line.V * t


def rayPlaneIntersection(ray, plane):
    if not isinstance(ray, Ray) or not isinstance(plane, Plane):
        raise TypeError("需要 Ray 和 Plane")
    point = linePlaneIntersection(Line(ray.P, ray.V), plane)
    if point is None or ray.P.pointTo(point).dotProduct(ray.V) < -epsilon:
        return None
    return point


def intersectSegmentPlane(segment, plane):
    if not isinstance(segment, Segment) or not isinstance(plane, Plane):
        raise TypeError("需要 Segment 和 Plane")
    length = segment.length()
    if length <= epsilon:
        if pointPlaneDistance(segment.A, plane) <= epsilon:
            return segment.A
        return None
    point = linePlaneIntersection(Line(segment.A, segment.direction()), plane)
    if point is None:
        return None
    t = segment.A.pointTo(point).dotProduct(segment.direction().normalized())
    if -epsilon <= t <= length + epsilon:
        return point
    return None


def intersect(obj1, obj2):
    if isinstance(obj1, (Line, Ray, Segment)) and isinstance(obj2, (Line, Ray, Segment)):
        return entityIntersection(obj1, obj2)
    if isinstance(obj1, Plane) and isinstance(obj2, (Line, Ray, Segment)):
        return intersect(obj2, obj1)
    if isinstance(obj2, Plane):
        if isinstance(obj1, Line):
            return linePlaneIntersection(obj1, obj2)
        if isinstance(obj1, Ray):
            return rayPlaneIntersection(obj1, obj2)
        if isinstance(obj1, Segment):
            return intersectSegmentPlane(obj1, obj2)
    raise TypeError("不支持这两个实体的求交计算")


def pointInPolygon(p, polygon):
    points = polygon.points
    count = len(points) - 1 if polygon.isClosed() else len(points)
    if count == 0:
        return 0
    inside = False
    for i in range(count):
        a, b = points[i], points[(i + 1) % count]
        dx, dy = b.x - a.x, b.y - a.y
        length2 = dx * dx + dy * dy
        t = 0.0 if length2 == 0 else ((p.x - a.x) * dx + (p.y - a.y) * dy) / length2
        t = max(0.0, min(1.0, t))
        if (p.x - a.x - t * dx) ** 2 + (p.y - a.y - t * dy) ** 2 <= epsilonSquare:
            return -1

        if (a.y > p.y) != (b.y > p.y):
            x = a.x + (p.y - a.y) * dx / dy
            if x > p.x:
                inside = not inside
    return int(inside) if count >= 3 else 0


def _trianglePlaneSection(points, distances):
    sides = [0 if abs(d) <= epsilon else (1 if d > 0 else -1)
             for d in distances]
    if all(s == 0 for s in sides) or all(s > 0 for s in sides) or all(s < 0 for s in sides):
        return None
    intersections = [p for p, s in zip(points, sides) if s == 0]
    for i, j in ((0, 1), (1, 2), (2, 0)):
        if sides[i] * sides[j] < 0:
            a, b = points[i], points[j]
            t = distances[i] / (distances[i] - distances[j])
            intersections.append(Point3D(a.x + t * (b.x - a.x),
                                         a.y + t * (b.y - a.y),
                                         a.z + t * (b.z - a.z)))
    unique = []
    for p in intersections:
        if not any(p.isCoincide(q) for q in unique):
            unique.append(p)
    return Segment(*unique) if len(unique) == 2 else None


def intersectTrianglePlane(triangle, plane):
    points = (triangle.A, triangle.B, triangle.C)
    distances = [plane.N.dotProduct(plane.P.pointTo(p)) for p in points]
    return _trianglePlaneSection(points, distances)


def intersectTriangleZPlane(triangle, z):
    points = (triangle.A, triangle.B, triangle.C)
    if min(p.z for p in points) > z + epsilon or max(p.z for p in points) < z - epsilon:
        return None
    segment = _trianglePlaneSection(points, [p.z - z for p in points])
    if segment is not None:
        segment.A.z = segment.B.z = z
    return segment


def adjustPolygonDirs(polygons):
    polygons = list(polygons)
    for i, polygon in enumerate(polygons):
        if not polygon.isClosed() or polygon.count() < 4:
            continue
        parents = sum(pointInPolygon(polygon.startPoint(), other) == 1
                      for j, other in enumerate(polygons)
                      if i != j and other.isClosed() and other.count() >= 4)
        polygon.makeCW() if parents % 2 else polygon.makeCCW()
    return polygons


def rotatePolygons(polygons, angle, center=None):
    center = Point3D() if center is None else center
    matrix = (Matrix3D.createTranslateMatrix(-center.x, -center.y, -center.z)
              * Matrix3D.createRotateMatrix(Vector3D(0, 0, 1), angle)
              * Matrix3D.createTranslateMatrix(center.x, center.y, center.z))
    return [polygon.multiplied(matrix) for polygon in polygons]


