from bisect import bisect_left, bisect_right

from GeomAlgo import intersectTriangleZPlane
from GeomBase import epsilon
from Layer import Layer
from SliceUtils import genLayerHeights


class IntersectStl_match:
    def __init__(self, stlModel, layerThk):
        self.stlModel = stlModel
        self.layerThk = layerThk
        self.layers = []
        self.intersect()

    def genLayerHeights(self):
        zs = genLayerHeights(self.stlModel, self.layerThk)
        return zs, {z: Layer(z) for z in zs}

    @staticmethod
    def _checkHeights(zs):
        if any(a >= b for a, b in zip(zs, zs[1:])):
            raise ValueError("匹配层高必须严格递增")

    def matchFacetZs_brutal(self, zs):
        self._checkHeights(zs)
        for triangle in self.stlModel.triangles:
            low, high = triangle.zMinPnt().z - epsilon, triangle.zMaxPnt().z + epsilon
            triangle.zs = []
            for z in zs:
                if z > high:
                    break
                if z >= low:
                    triangle.zs.append(z)

    def matchFacetZs_bisection(self, zs):
        self._checkHeights(zs)
        for triangle in self.stlModel.triangles:
            start = bisect_left(zs, triangle.zMinPnt().z - epsilon)
            stop = bisect_right(zs, triangle.zMaxPnt().z + epsilon)

            triangle.zs = zs[start:stop]

    def intersect(self):
        zs, layerDic = self.genLayerHeights()
        self.matchFacetZs_bisection(zs)
        for triangle in self.stlModel.triangles:
            for z in triangle.zs:
                segment = intersectTriangleZPlane(triangle, z)
                if segment is not None:
                    layerDic[z].segments.append(segment)
        self.layers = list(layerDic.values())
        return self.layers
