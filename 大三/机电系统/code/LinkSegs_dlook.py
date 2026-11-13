from collections import deque

from LinkPoint import createLinkPoints
from Polyline import Polyline


class LinkSegs_dlook:
    def __init__(self, segs):
        self.segs = list(segs)
        self.contours = []
        self.polys = []
        self.link()

    def createLpDic(self):
        dic = {}
        for point in createLinkPoints(self.segs):
            dic.setdefault(point.toTuple(), []).append(point)
        return dic

    def findUnusedPnt(self, dic):
        for points in dic.values():
            for point in points:
                if not point.used:
                    return point
        return None

    def findNextPnt(self, p, dic):
        points = dic.get(p.toTuple(), [])
        while points:
            point = points.pop()
            if not point.used:
                return point
        return None

    def link(self):
        dic = self.createLpDic()
        points = [point for group in dic.values() for point in group]
        self.contours, self.polys = [], []
        for seed in points:
            if seed.used:
                continue
            seed.used = seed.other.used = True
            chain = deque((seed, seed.other))
            for forward in (True, False):
                while chain[0].toTuple() != chain[-1].toTuple():
                    point = chain[-1] if forward else chain[0]
                    nextPoint = self.findNextPnt(point, dic)
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
