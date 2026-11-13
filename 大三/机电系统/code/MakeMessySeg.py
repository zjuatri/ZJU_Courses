import math
import random

from GeomBase import Point3D
from Segment import Segment


def makeMessySegs(circleNum=10, segNumPerCircle=100000, radius=100.0, seed=None):
    if not isinstance(circleNum, int) or circleNum < 0:
        raise ValueError("圆数量必须是非负整数")
    if not isinstance(segNumPerCircle, int) or segNumPerCircle < 3:
        raise ValueError("每个圆的线段数必须至少为 3")
    if not math.isfinite(radius) or radius <= 0:
        raise ValueError("半径必须是有限正数")
    rng = random.Random(seed)
    segs = []
    for circle in range(circleNum):
        points = [Point3D(circle * 3 * radius + radius * math.cos(2 * math.pi * i / segNumPerCircle),
                          radius * math.sin(2 * math.pi * i / segNumPerCircle), 0)
                  for i in range(segNumPerCircle)]
        for i, point in enumerate(points):
            segment = Segment(point, points[(i + 1) % segNumPerCircle])
            if rng.random() < 0.5:
                segment.swap()
            segs.append(segment)
    rng.shuffle(segs)
    return segs
