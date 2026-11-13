from time import perf_counter

from MakeMessySeg import makeMessySegs
from SliceAlgo import linkSegs_brutal, linkSegs_dorder, linkSegs_dlook


def main():
    circleNum = 3
    segNums = [100, 500, 1000]
    algorithms = [linkSegs_brutal, linkSegs_dorder, linkSegs_dlook]

    for segNum in segNums:
        segs = makeMessySegs(circleNum, segNum, seed=7)
        print("线段数：", len(segs))
        for algorithm in algorithms:
            start = perf_counter()
            contours = algorithm(segs)
            elapsed = perf_counter() - start
            print("%s：%.6f 秒，轮廓数：%d" % (
                algorithm.__name__, elapsed, len(contours)))
        print()


if __name__ == "__main__":
    main()
