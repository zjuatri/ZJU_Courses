import math
import struct
from pathlib import Path

from GeomBase import Point3D, Vector3D
from Triangle import Triangle


class StlModel:
    def __init__(self):
        self.triangles = []
        self.xMin = self.xMax = self.yMin = self.yMax = 0.0
        self.zMin = self.zMax = 0.0

    def getFacetNumber(self):
        return len(self.triangles)

    def getCoords(self, line):
        values = tuple(float(value) for value in line.split()[-3:])
        if len(values) != 3 or not all(math.isfinite(v) for v in values):
            raise ValueError("STL 坐标必须包含三个有限实数")
        return values

    def readStlFile(self, filepath):
        data = Path(filepath).read_bytes()

        count = struct.unpack_from("<I", data, 80)[0] if len(data) >= 84 else 0
        if len(data) >= 84 and len(data) == 84 + count * 50:
            triangles = self._readBinary(data)
        else:
            try:
                triangles = self._readAscii(data.decode("utf-8-sig"))
            except UnicodeDecodeError as exc:
                raise ValueError("STL 不是有效的 ASCII 文件，或二进制文件已截断") from exc
        self.triangles = triangles
        self.getBounds()
        return self

    def _readBinary(self, data):
        triangles = []
        for values in struct.iter_unpack("<12fH", memoryview(data)[84:]):
            if not all(math.isfinite(v) for v in values[:12]):
                raise ValueError("二进制 STL 包含非有限坐标")
            triangles.append(Triangle(
                Point3D(*values[3:6]), Point3D(*values[6:9]),
                Point3D(*values[9:12]), Vector3D(*values[:3])))
        return triangles

    def _readAscii(self, text):
        triangles, vertices, normal = [], None, None
        sawSolid = False
        inLoop = False
        for number, raw in enumerate(text.splitlines(), 1):
            line = raw.strip()
            if not line:
                continue
            words = line.split()
            keyword = words[0].lower()
            if keyword in ("solid", "endsolid"):
                if vertices is not None:
                    raise ValueError("STL 面片未结束，第 %d 行" % number)
                sawSolid = True
            elif keyword == "facet" and len(words) == 5 and words[1].lower() == "normal":
                if vertices is not None:
                    raise ValueError("STL 面片嵌套，第 %d 行" % number)
                normal, vertices = Vector3D(*self.getCoords(line)), []
            elif keyword == "outer" and words[1:] == ["loop"]:
                if vertices is None or inLoop:
                    raise ValueError("STL outer loop 位置错误，第 %d 行" % number)
                inLoop = True
            elif keyword == "vertex" and len(words) == 4:
                if vertices is None or not inLoop:
                    raise ValueError("STL vertex 不在面片内部，第 %d 行" % number)
                vertices.append(Point3D(*self.getCoords(line)))
            elif keyword == "endloop":
                if not inLoop:
                    raise ValueError("STL endloop 位置错误，第 %d 行" % number)
                inLoop = False
            elif keyword == "endfacet":
                if vertices is None or len(vertices) != 3 or inLoop:
                    raise ValueError("STL 面片必须有三个顶点，第 %d 行" % number)
                triangles.append(Triangle(*vertices, normal))
                vertices = None
            else:
                raise ValueError("无法识别 STL 第 %d 行：%s" % (number, line))
        if not sawSolid or vertices is not None or inLoop:
            raise ValueError("ASCII STL 文件无效或不完整")
        return triangles

    def extractFromVtkStlReader(self, vtkStlReader):
        vtkStlReader.Update()
        if vtkStlReader.GetErrorCode():
            raise ValueError("VTK 无法读取 STL 文件")
        data = vtkStlReader.GetOutput()
        normals = data.GetCellData().GetNormals()
        triangles = []
        for index in range(data.GetNumberOfCells()):
            cell = data.GetCell(index)
            if cell.GetNumberOfPoints() != 3:
                raise ValueError("VTK 数据包含非三角形面片")
            points = [Point3D(*data.GetPoint(cell.GetPointId(i))) for i in range(3)]
            normal = Vector3D(*normals.GetTuple3(index)) if normals else None
            triangle = Triangle(*points, normal)
            if normal is None:
                triangle.calcNormal()
            triangles.append(triangle)
        self.triangles = triangles
        self.getBounds()
        return self

    def getBounds(self):
        if not self.triangles:
            self.xMin = self.xMax = self.yMin = self.yMax = 0.0
            self.zMin = self.zMax = 0.0
        else:
            points = (p for t in self.triangles for p in (t.A, t.B, t.C))
            first = next(points)
            self.xMin = self.xMax = first.x
            self.yMin = self.yMax = first.y
            self.zMin = self.zMax = first.z
            for p in points:
                self.xMin, self.xMax = min(self.xMin, p.x), max(self.xMax, p.x)
                self.yMin, self.yMax = min(self.yMin, p.y), max(self.yMax, p.y)
                self.zMin, self.zMax = min(self.zMin, p.z), max(self.zMax, p.z)
        return self.xMin, self.xMax, self.yMin, self.yMax, self.zMin, self.zMax
