from collections import deque

from LinkPoint import createLinkPoints
from Polyline import Polyline


def cmp_pntSmaller(lp1, lp2):
    a, b = lp1.toTuple(), lp2.toTuple()
    return (a > b) - (a < b)


class LinkSegs_dorder:
    def __init__(self, segs):
        self.segs = list(segs)
        self.contours = []
        self.polys = []
        self.link()

    def createLpList(self):
        points = sorted(createLinkPoints(self.segs), key=lambda p: p.toTuple())
        for index, point in enumerate(points):
            point.index = index
        return points

    def findUnusedPnt(self, lpnts):
        return next((p for p in lpnts if not p.used), None)

    def link(self):
        points = self.createLpList()
        starts, stops = [0] * len(points), [0] * len(points)
        start = 0
        while start < len(points):
            stop = start + 1
            while stop < len(points) and points[stop].toTuple() == points[start].toTuple():
                stop += 1
            for index in range(start, stop):
                starts[index], stops[index] = start, stop
            start = stop

        self.contours, self.polys = [], []
        for seed in points:
            if seed.used:
                continue
            seed.used = seed.other.used = True
            chain = deque((seed, seed.other))
            for forward in (True, False):
                while chain[0].toTuple() != chain[-1].toTuple():
                    point = chain[-1] if forward else chain[0]
                    nextPoint = None
                    for i in range(starts[point.index], stops[point.index]):
                        if not points[i].used:
                            nextPoint = points[i]
                            break
                    if nextPoint is None:
                        break
                    nextPoint.used = nextPoint.other.used = True
                    if forward:
                        chain.append(nextPoint.other)
                    else:
                        chain.appendleft(nextPoint.other)
            poly = Polyline()
            for point in chain:
                poly.addPoint(point.toPoint3D())
            if poly.isClosed():
                self.contours.append(poly)
            else:
                self.polys.append(poly)
        return self.contours
