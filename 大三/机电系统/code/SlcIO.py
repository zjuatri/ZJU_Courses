import math
import struct

from Layer import Layer
from Polyline import Polyline


HEADER_END = b"\r\n\x1a"
END_MARKER = 0xFFFFFFFF


def writeSlcFile(layers, path):
    layers = list(layers)
    previous = -math.inf
    for layer in layers:
        if not math.isfinite(layer.z) or layer.z <= previous:
            raise ValueError("SLC 层高必须有限且严格递增")
        savedZ = struct.unpack("<f", struct.pack("<f", layer.z))[0]
        if savedZ <= previous:
            raise ValueError("相邻层高在 SLC 单精度格式中无法区分")
        previous = savedZ
        if getattr(layer, "openContours", []):
            raise ValueError("当前切片存在开放线段链，不能保存为无 gap 的 SLC")
        for contour in layer.contours:
            if not contour.isClosed() or contour.count() < 4:
                raise ValueError("SLC 仅支持至少三个顶点的封闭轮廓")
            for point in contour.points:
                if not all(math.isfinite(v) for v in (point.x, point.y, point.z)):
                    raise ValueError("SLC 轮廓包含非有限坐标")
                if abs(point.z - layer.z) > 1e-7:
                    raise ValueError("轮廓顶点必须位于当前层平面上")
                struct.pack("<2f", point.x, point.y)
    start = layers[0].z if layers else 0.0
    thickness = layers[1].z - start if len(layers) > 1 else 0.0

    samples = [(start, thickness, 0.0, 0.0)]
    for i in range(1, len(layers) - 1):
        step = layers[i + 1].z - layers[i].z
        if not math.isclose(step, samples[-1][1], rel_tol=1e-7, abs_tol=1e-7):
            samples.append((layers[i].z, step, 0.0, 0.0))
    if len(samples) > 255:
        raise ValueError("SLC 采样表不能超过 255 个通道")
    with open(path, "wb") as stream:
        stream.write(b"-SLCVER 2.0 -UNIT MM" + HEADER_END)
        stream.write(bytes(256))
        stream.write(struct.pack("<B", len(samples)))
        for sample in samples:
            stream.write(struct.pack("<4f", *sample))
        for layer in layers:
            stream.write(struct.pack("<fI", layer.z, len(layer.contours)))
            for contour in layer.contours:
                stream.write(struct.pack("<2I", contour.count(), 0))
                for point in contour.points:
                    stream.write(struct.pack("<2f", point.x, point.y))
        stream.write(struct.pack("<fI", layers[-1].z if layers else 0.0, END_MARKER))


def _readExact(stream, size):
    data = stream.read(size)
    if len(data) != size:
        raise ValueError("SLC 文件已截断")
    return data


def readSlcFile(path):
    layers = []
    with open(path, "rb") as stream:
        header = bytearray()
        for _ in range(2048):
            header.extend(_readExact(stream, 1))
            if header.endswith(HEADER_END):
                break
        else:
            raise ValueError("SLC 头部缺少结束标记或超过 2048 字节")
        if b"-SLCVER 2.0" not in header or b"-UNIT MM" not in header:
            raise ValueError("仅支持以毫米为单位的 SLC 2.0 文件")
        _readExact(stream, 256)
        count = struct.unpack("<B", _readExact(stream, 1))[0]
        _readExact(stream, count * 16)
        while True:
            z, contourCount = struct.unpack("<fI", _readExact(stream, 8))
            if not math.isfinite(z):
                raise ValueError("SLC 层高不是有限实数")
            if contourCount == END_MARKER:
                if stream.read(1):
                    raise ValueError("SLC 结束标记后仍有数据")
                return layers
            if layers and z <= layers[-1].z:
                raise ValueError("SLC 层高必须严格递增")
            layer = Layer(z)
            for _ in range(contourCount):
                vertices, gaps = struct.unpack("<2I", _readExact(stream, 8))
                if gaps:
                    raise ValueError("当前实现仅支持无 gap 的 SLC 封闭轮廓")
                if vertices < 3:
                    raise ValueError("SLC 轮廓至少需要三个顶点")
                contour = Polyline()
                for _ in range(vertices):
                    x, y = struct.unpack("<2f", _readExact(stream, 8))
                    if not math.isfinite(x) or not math.isfinite(y):
                        raise ValueError("SLC 顶点不是有限实数")
                    contour.addTuple((x, y, z))
                if not contour.isClosed():
                    contour.addPoint(contour.startPoint())
                layer.contours.append(contour)
            layers.append(layer)
