from GeomAlgo import intersectTriangleZPlane
from GeomBase import epsilon
from Layer import Layer
from SliceUtils import genLayerHeights


class SweepPlane:
    def __init__(self):
        self.triangles = []


class IntersectStl_sweep:
    def __init__(self, stlModel, layerThk):
        self.stlModel = stlModel
        self.layerThk = layerThk
        self.layers = []
        self.intersect()

    def genLayerHeights(self):
        return genLayerHeights(self.stlModel, self.layerThk)

    def intersect(self):
        zs = self.genLayerHeights()

        facets = sorted(((t.zMinPnt().z, t.zMaxPnt().z, t)
                         for t in self.stlModel.triangles), key=lambda item: item[0])
        sweep, active, k = SweepPlane(), [], 0
        self.layers = []
        for z in zs:
            active = [item for item in active if item[1] >= z - epsilon]
            while k < len(facets) and facets[k][0] <= z + epsilon:
                item = facets[k]
                if item[1] >= z - epsilon:
                    active.append(item)

                k += 1
            sweep.triangles = [item[2] for item in active]
            layer = Layer(z)
            for triangle in sweep.triangles:
                segment = intersectTriangleZPlane(triangle, z)
                if segment is not None:
                    layer.segments.append(segment)
            self.layers.append(layer)
        return self.layers
