import math


def genLayerHeights(stlModel, layerThk):
    if not math.isfinite(layerThk) or layerThk <= 0:
        raise ValueError("切片厚度必须是正的有限实数")
    *_, zMin, zMax = stlModel.getBounds()
    if not math.isfinite(zMin) or not math.isfinite(zMax):
        raise ValueError("模型高度必须是有限实数")
    if zMin >= zMax:
        return []
    if zMin + layerThk <= zMin:
        raise ValueError("切片厚度太小，无法在当前模型坐标精度下递增")
    heights, index, previous = [], 1, zMin

    tolerance = 4 * max(math.ulp(zMin), math.ulp(zMax), math.ulp(layerThk))
    while True:
        z = zMin + index * layerThk
        if z >= zMax or math.isclose(z, zMax, rel_tol=0, abs_tol=tolerance):
            return heights
        if z <= previous:
            raise ValueError("切片厚度太小，相邻层高无法区分")
        heights.append(z)
        previous, index = z, index + 1
