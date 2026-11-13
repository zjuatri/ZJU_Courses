from bisect import bisect_right
from collections import deque

from GeomAlgo import adjustPolygonDirs
from GeomBase import Point3D, epsilon, epsilonSquare
from Segment import Segment
from Layer import Layer
from Polyline import Polyline
from SliceUtils import genLayerHeights


class TVertex:
    def __init__(self, pnt3d, digits=7):
        self.x, self.y, self.z = (round(v, digits) for v in (pnt3d.x, pnt3d.y, pnt3d.z))
        self.faces = []
        self._point = pnt3d.clone()

    def toTuple(self):
        return self.x, self.y, self.z

    def toPoint3D(self):
        return Point3D(*self.toTuple())

    def isSmaller(self, other):
        return self.toTuple() < other.toTuple()


class TEdge:
    def __init__(self, tA, tB):
        self.A, self.B = tA, tB
        self.F = None
        self.OE = None
        self.incident = []

    def toTuple(self):
        a, b = sorted((self.A.toTuple(), self.B.toTuple()))
        return a + b

    def intersect(self, z):
        da, db = self.A._point.z - z, self.B._point.z - z
        if abs(da) <= epsilon and abs(db) <= epsilon:
            return None
        if abs(da) <= epsilon:
            return Point3D(self.A._point.x, self.A._point.y, z)
        if abs(db) <= epsilon:
            return Point3D(self.B._point.x, self.B._point.y, z)
        if da * db >= 0:
            return None
        t = da / (da - db)
        return Point3D(self.A._point.x + t * (self.B._point.x - self.A._point.x),
                       self.A._point.y + t * (self.B._point.y - self.A._point.y), z)


class TFace:
    def __init__(self, tA, tB, tC, te1, te2, te3):
        self.A, self.B, self.C = tA, tB, tC
        self.E1, self.E2, self.E3 = te1, te2, te3
        self.used = False

    def zMin(self):
        return min(self.A._point.z, self.B._point.z, self.C._point.z)

    def zMax(self):
        return max(self.A._point.z, self.B._point.z, self.C._point.z)

    def intersect(self, z):
        vertices = (self.A, self.B, self.C)
        nodes = [v for v in vertices if abs(v._point.z - z) <= epsilon]
        if len(nodes) == 3:
            return None, None, None
        if len(nodes) == 2:
            a, b = (Point3D(v._point.x, v._point.y, z) for v in nodes)
            if a.isCoincide(b):
                return None, None, None
            return Segment(a, b), [], tuple(nodes)
        edges, points = [], []
        for edge in (self.E1, self.E2, self.E3):
            if (edge.A._point.z - z) * (edge.B._point.z - z) < 0 and all(
                    abs(v._point.z - z) > epsilon for v in (edge.A, edge.B)):
                point = edge.intersect(z)
                if point is not None:
                    edges.append(edge)
                    points.append(point)
        if len(nodes) == 1 and len(points) == 1:
            points.append(Point3D(nodes[0]._point.x, nodes[0]._point.y, z))
        if len(points) != 2 or points[0].isCoincide(points[1]):
            return None, None, None
        return Segment(*points), edges, nodes[0] if nodes else None


class TModel:
    def __init__(self, stlModel):
        self.stlModel = stlModel
        self.vxDic, self.egDic = {}, {}
        self.faces = []
        self.createTModel()

    def createTModel(self):
        self.vxDic, self.egDic, self.faces = {}, {}, []
        for triangle in self.stlModel.triangles:
            vertices = []
            for point in (triangle.A, triangle.B, triangle.C):
                vertex = TVertex(point)
                key = vertex.toTuple()
                if key not in self.vxDic:
                    self.vxDic[key] = vertex
                vertices.append(self.vxDic[key])
            if len(set(vertices)) < 3:
                continue
            a, b, c = vertices
            edges = (TEdge(a, b), TEdge(b, c), TEdge(c, a))
            face = TFace(a, b, c, *edges)
            self.faces.append(face)
            for vertex in vertices:
                vertex.faces.append(face)
            for edge in edges:
                edge.F = face
                self.egDic.setdefault(edge.toTuple(), []).append(edge)
        for edges in self.egDic.values():
            for edge in edges:
                edge.incident = edges
            if len(edges) == 2:
                edges[0].OE, edges[1].OE = edges[1], edges[0]
        return self


class TopoSlicer:
    def __init__(self, stlModel, layerThk):
        self.stlModel = stlModel
        self.layerThk = layerThk
        genLayerHeights(stlModel, layerThk)
        self.topModel = TModel(stlModel)
        self.layers = []
        self._sections = {}
        self.slice()

    def findSeedFace(self, faces):
        return next((face for face in faces if not face.used), None)

    def _neighbors(self, edges, node):
        for edge in reversed(edges or []):
            if edge.OE is not None:
                yield edge.OE.F
            for other in edge.incident:
                if other is not edge:
                    yield other.F
        nodes = node if isinstance(node, tuple) else (() if node is None else (node,))
        for vertex in nodes:
            yield from vertex.faces

    def findNextFace(self, edges, node):
        for face in self._neighbors(edges, node):
            if face.used:
                continue
            if face in self._sections:
                return face
            if node is not None:
                vertex = node[0] if isinstance(node, tuple) else node
                if face.intersect(vertex._point.z)[0] is not None:
                    return face
        return None

    def createLayerContours(self, z, faces):
        faces = list(faces)
        self._sections = {}
        seen = set()
        for face in faces:
            face.used = False
            section = face.intersect(z)
            seg = section[0]
            if seg is None:
                face.used = True
                continue
            key = tuple(sorted((tuple(round(v, 7) for v in (p.x, p.y, p.z))
                                for p in (seg.A, seg.B))))
            if key in seen:
                face.used = True
                continue
            seen.add(key)
            self._sections[face] = section
        layer = Layer(z)
        for seed in faces:
            if seed.used:
                continue
            segment = self._sections[seed][0]
            seed.used = True
            chain = deque((segment.A, segment.B))
            for forward in (True, False):
                current = seed
                while not chain[0].isCoincide(chain[-1]):
                    _, edges, node = self._sections[current]
                    endpoint = chain[-1] if forward else chain[0]
                    target, newPoint = None, None
                    for candidate in self._neighbors(edges, node):
                        if candidate.used or candidate not in self._sections:
                            continue
                        seg = self._sections[candidate][0]
                        if endpoint.isCoincide(seg.A):
                            target, newPoint = candidate, seg.B
                            break
                        if endpoint.isCoincide(seg.B):
                            target, newPoint = candidate, seg.A
                            break
                    if target is None:
                        break
                    target.used = True
                    current = target
                    if forward:
                        chain.append(newPoint)
                    else:
                        chain.appendleft(newPoint)
            contour = Polyline()
            contour.points = [point.clone() for point in chain]
            if contour.isClosed() and contour.count() >= 4 and abs(contour.getArea()) > epsilonSquare:
                contour.points[-1] = contour.points[0].clone()
                layer.contours.append(contour)
            else:
                layer.openContours.append(contour)
        adjustPolygonDirs(layer.contours)
        self._sections = {}
        return layer

    def slice(self):
        zs = genLayerHeights(self.stlModel, self.layerThk)
        ordered = sorted(self.topModel.faces, key=lambda face: face.zMin())
        minima = [face.zMin() for face in ordered]
        active, position, self.layers = [], 0, []
        for z in zs:
            stop = bisect_right(minima, z + epsilon, lo=position)
            active = [face for face in active if face.zMax() >= z - epsilon]
            active.extend(face for face in ordered[position:stop] if face.zMax() >= z - epsilon)
            position = stop
            self.layers.append(self.createLayerContours(z, active))
        return self.layers
