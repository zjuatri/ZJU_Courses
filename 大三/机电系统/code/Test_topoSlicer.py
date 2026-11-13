from pathlib import Path
from time import perf_counter

from SliceAlgo import slice_combine, slice_topo
from StlModel import StlModel


def main():
    path = Path(__file__).resolve().parent.parent / "3DP-asc.STL"
    layerThks = [10, 5, 2]
    model = StlModel().readStlFile(path)
    print("面片数：", model.getFacetNumber())

    for layerThk in layerThks:
        print("层厚：", layerThk)
        for algorithm in (slice_topo, slice_combine):
            start = perf_counter()
            layers = algorithm(model, layerThk)
            elapsed = perf_counter() - start
            count = sum(len(layer.contours) for layer in layers)
            print("%s：%.6f 秒，层数：%d，轮廓数：%d" % (
                algorithm.__name__, elapsed, len(layers), count))
        print()


if __name__ == "__main__":
    main()
