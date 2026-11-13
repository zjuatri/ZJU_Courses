import argparse
from pathlib import Path
from time import perf_counter

from SliceModel import SliceModel
from StlModel import StlModel


def main():
    parser = argparse.ArgumentParser(description="STL 切片、SLC 导出与 VTK 可视化")
    parser.add_argument("stl", nargs="?", type=Path,
                        default=Path(__file__).resolve().parent.parent / "vase.STL",
                        help="STL 文件路径（默认仓库中的 vase.STL）")
    parser.add_argument("--layer-thickness", type=float, default=10.0, help="切片厚度")
    parser.add_argument("--algorithm", choices=("brutal", "sweep", "match", "combine", "topo"), default="sweep")
    parser.add_argument("--link-algorithm", choices=("brutal", "dorder", "dlook"), default="dlook")
    parser.add_argument("--output", type=Path, help="输出 SLC 文件路径")
    parser.add_argument("--show", action="store_true", help="打开 VTK 交互窗口")
    parser.add_argument("--image", type=Path, help="保存 VTK 场景 PNG 图片")
    args = parser.parse_args()
    model = StlModel().readStlFile(args.stl)
    print("模型：%s，面片：%d，包络：%s" % (args.stl.name, model.getFacetNumber(), model.getBounds()))
    start = perf_counter()
    sliced = SliceModel(model, args.layer_thickness, args.algorithm, args.link_algorithm)
    openCount = sum(len(layer.openContours) for layer in sliced.layers)
    print("算法：%s，厚度：%g，层数：%d，轮廓：%d，开放链：%d，耗时：%.3f 秒" % (
        args.algorithm, args.layer_thickness, len(sliced.layers),
        sum(len(layer.contours) for layer in sliced.layers), openCount, perf_counter() - start))
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        sliced.writeSlcFile(args.output)
        print("已保存 SLC：%s" % args.output)
    if args.show or args.image:
        from VtkAdaptor import VtkAdaptor
        va = VtkAdaptor(offScreen=not args.show)
        actor = va.drawTriangles(model.triangles)
        actor.GetProperty().SetOpacity(0.15)
        sliced.drawLayerContours(va, clr=(0.05, 0.25, 0.7), lineWidth=2)
        for layer in sliced.layers:
            for contour in layer.openContours:
                va.drawPolyline(contour).GetProperty().SetColor(0.9, 0.1, 0.1)
        camera = va.renderer.GetActiveCamera()
        camera.SetPosition(1, -1, 0.8)
        camera.SetFocalPoint(0, 0, 0)
        camera.SetViewUp(0, 0, 1)
        if args.image:
            args.image.parent.mkdir(parents=True, exist_ok=True)
            va.saveImage(args.image)
            print("已保存场景：%s" % args.image)
        if args.show:
            va.display()
        va.window.Finalize()


if __name__ == "__main__":
    main()
