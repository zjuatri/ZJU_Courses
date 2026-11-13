from GeomAlgo import adjustPolygonDirs, intersectTriangleZPlane
from GeomBase import epsilon
from IntersectStl_match import IntersectStl_match
from IntersectStl_sweep import IntersectStl_sweep
from Layer import Layer
from Polyline import Polyline
from SlcIO import readSlcFile, writeSlcFile
from SliceUtils import genLayerHeights


def intersectStl_brutal(stlModel, layerThk):
    layers = []
    for z in genLayerHeights(stlModel, layerThk):
        layer = Layer(z)
        for triangle in stlModel.triangles:
            segment = intersectTriangleZPlane(triangle, z)
            if segment is not None:
                layer.segments.append(segment)
        layers.append(layer)
    return layers


def intersectStl_sweep(stlModel, layerThk):
    return IntersectStl_sweep(stlModel, layerThk).layers


def intersectStl_match(stlModel, layerThk):
    return IntersectStl_match(stlModel, layerThk).layers


def linkSegs_brutal(segs):
    remaining, seen = [], set()
    for seg in segs:
        if seg.length() <= epsilon:
            continue
        ends = sorted(((seg.A.x, seg.A.y, seg.A.z), (seg.B.x, seg.B.y, seg.B.z)))
        key = tuple(ends)

        if key not in seen:
            remaining.append(seg)
            seen.add(key)
    contours = []
    while remaining:
        contour = Polyline()
        contour.appendSegment(remaining.pop(0))
        while remaining and not contour.isClosed():
            for index, seg in enumerate(remaining):
                if contour.appendSegment(seg):
                    remaining.pop(index)
                    break
            else:
                break
        contours.append(contour)
    return contours


def linkSegs_dorder(segs):
    from LinkSegs_dorder import LinkSegs_dorder
    linker = LinkSegs_dorder(segs)
    return linker.contours + linker.polys


def linkSegs_dlook(segs):
    from LinkSegs_dlook import LinkSegs_dlook
    linker = LinkSegs_dlook(segs)
    return linker.contours + linker.polys


def buildLayerContours(layer, linkAlgo="dlook", clearSegments=False):
    from GeomBase import epsilonSquare
    algorithms = {"brutal": linkSegs_brutal, "dorder": linkSegs_dorder,
                  "dlook": linkSegs_dlook}
    if linkAlgo not in algorithms:
        raise ValueError("拼接算法必须是 brutal、dorder 或 dlook")
    layer.contours, layer.openContours = [], []
    for contour in algorithms[linkAlgo](layer.segments):
        if contour.isClosed() and contour.count() >= 4 and abs(contour.getArea()) > epsilonSquare:
            layer.contours.append(contour)
        else:
            layer.openContours.append(contour)
    adjustPolygonDirs(layer.contours)
    if clearSegments:
        layer.segments.clear()
    return layer


def slice_combine(stlModel, layerThk):
    layers = intersectStl_sweep(stlModel, layerThk)
    for layer in layers:
        buildLayerContours(layer, "dlook", clearSegments=True)
    return layers


def slice_topo(stlModel, layerThk):
    from TopoSlicer import TopoSlicer
    return TopoSlicer(stlModel, layerThk).layers
