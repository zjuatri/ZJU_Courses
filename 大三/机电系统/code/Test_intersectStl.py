import argparse
from collections import Counter
from pathlib import Path
from time import perf_counter

import SliceAlgo
from StlModel import StlModel


ALGORITHMS = {
    "brutal": SliceAlgo.intersectStl_brutal,
    "sweep": SliceAlgo.intersectStl_sweep,
    "match": SliceAlgo.intersectStl_match,
}


def layerSignature(layer):
    return Counter(tuple(sorted(tuple(round(v, 7) for v in (p.x, p.y, p.z))
                                for p in (segment.A, segment.B)))
                   for segment in layer.segments)


def assertSameLayers(expected, actual):
    if len(expected) != len(actual):
        raise AssertionError("三种算法层数不一致")
    for a, b in zip(expected, actual):
        if a.z != b.z or layerSignature(a) != layerSignature(b):
            raise AssertionError("高度 %g 处截交线段不一致" % a.z)


def benchmark(model, thickness):
    baseline, results = None, {}
    for name, algorithm in ALGORITHMS.items():
        start = perf_counter()
        layers = algorithm(model, thickness)
        elapsed = perf_counter() - start
        if baseline is None:
            baseline = layers
        else:
            assertSameLayers(baseline, layers)
        results[name] = elapsed
        print("  %s：%.4f 秒，%d 层，%d 条线段" % (
            name, elapsed, len(layers), sum(len(layer.segments) for layer in layers)), flush=True)
    print("  结果一致；暴力/扫描：%.2f 倍，暴力/匹配：%.2f 倍" % (
        results["brutal"] / max(results["sweep"], 1e-12),
        results["brutal"] / max(results["match"], 1e-12)), flush=True)
    return results


def main():
    parser = argparse.ArgumentParser(description="第五章三种 STL 截交算法比较")
    parser.add_argument("stl", nargs="?", type=Path,
                        default=Path(__file__).resolve().parent.parent / "3DP-asc.STL")
    parser.add_argument("--layer-thickness", nargs="+", type=float, default=[2.0, 1.0, 0.5])
    args = parser.parse_args()
    model = StlModel().readStlFile(args.stl)
    print("模型：%s，面片：%d" % (args.stl.name, model.getFacetNumber()), flush=True)
    for thickness in args.layer_thickness:
        print("切片厚度：%g" % thickness, flush=True)
        benchmark(model, thickness)


if __name__ == "__main__":
    main()
