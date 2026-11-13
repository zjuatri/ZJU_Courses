import vtk

from GeomBase import Point3D
from Polyline import Polyline
from Segment import Segment


class VtkAdaptor:
    def __init__(self, bgClr=(0.95, 0.95, 0.95), offScreen=False):
        self.renderer = vtk.vtkRenderer()
        self.renderer.SetBackground(bgClr)

        self.window = vtk.vtkRenderWindow()
        self.window.AddRenderer(self.renderer)
        self.window.SetSize(900, 600)
        self.window.SetOffScreenRendering(offScreen)

        self.interactor = vtk.vtkRenderWindowInteractor()
        self.interactor.SetRenderWindow(self.window)
        self.interactor.SetInteractorStyle(
            vtk.vtkInteractorStyleTrackballCamera()
        )
        if not offScreen:
            self.interactor.Initialize()

    def display(self):
        self.renderer.ResetCamera()
        self.window.Render()
        self.interactor.Start()

    def saveImage(self, path):

        self.renderer.ResetCamera()
        self.window.Render()
        capture = vtk.vtkWindowToImageFilter()
        capture.SetInput(self.window)
        capture.ReadFrontBufferOff()
        capture.Update()
        writer = vtk.vtkPNGWriter()
        writer.SetFileName(str(path))
        writer.SetInputConnection(capture.GetOutputPort())
        writer.Write()
        if writer.GetErrorCode():
            raise OSError("VTK 无法保存场景截图")

    def setBackgroundColor(self, r, g, b):
        return self.renderer.SetBackground(r, g, b)

    def drawAxes(
        self,
        length=100.0,
        shaftType=0,
        cylinderRadius=0.01,
        coneRadius=0.2,
    ):
        axes = vtk.vtkAxesActor()
        axes.SetTotalLength(length, length, length)
        axes.SetShaftType(shaftType)
        axes.SetCylinderRadius(cylinderRadius)
        axes.SetConeRadius(coneRadius)
        axes.SetAxisLabels(0)
        self.renderer.AddActor(axes)
        return axes

    def drawActor(self, actor):
        self.renderer.AddActor(actor)
        return actor

    def drawPdSrc(self, pdSrc):
        mapper = vtk.vtkPolyDataMapper()
        mapper.SetInputConnection(pdSrc.GetOutputPort())
        actor = vtk.vtkActor()
        actor.SetMapper(mapper)
        return self.drawActor(actor)

    def drawSphere(self, r):
        source = vtk.vtkSphereSource()
        source.SetRadius(r)
        source.SetThetaResolution(50)
        source.SetPhiResolution(50)
        return self.drawPdSrc(source)

    def drawStlModel(self, stlFilePath):
        reader = vtk.vtkSTLReader()
        reader.SetFileName(stlFilePath)
        return self.drawPdSrc(reader)

    def removeActor(self, actor):
        self.renderer.RemoveActor(actor)

    def drawPoint(self, point, radius=2.0):
        source = vtk.vtkSphereSource()
        source.SetCenter(point.x, point.y, point.z)
        source.SetRadius(radius)
        return self.drawPdSrc(source)

    def drawSegment(self, seg):
        source = vtk.vtkLineSource()
        source.SetPoint1(seg.A.x, seg.A.y, seg.A.z)
        source.SetPoint2(seg.B.x, seg.B.y, seg.B.z)
        return self.drawPdSrc(source)

    def drawPolyline(self, polyline):
        points = vtk.vtkPoints()
        for point in polyline.points:
            points.InsertNextPoint(point.x, point.y, point.z)
        data = vtk.vtkPolyData()
        data.SetPoints(points)
        if polyline.count() >= 2:
            line = vtk.vtkPolyLine()
            line.GetPointIds().SetNumberOfIds(polyline.count())
            for index in range(polyline.count()):
                line.GetPointIds().SetId(index, index)
            cells = vtk.vtkCellArray()
            cells.InsertNextCell(line)
            data.SetLines(cells)
        mapper = vtk.vtkPolyDataMapper()
        mapper.SetInputData(data)
        actor = vtk.vtkActor()
        actor.SetMapper(mapper)
        return self.drawActor(actor)

    def drawTriangles(self, triangles):
        cells = vtk.vtkCellArray()
        points = vtk.vtkPoints()
        for triangle in triangles:
            point_ids = [points.InsertNextPoint(point.x, point.y, point.z)
                         for point in (triangle.A, triangle.B, triangle.C)]
            vtk_triangle = vtk.vtkTriangle()
            for index, point_id in enumerate(point_ids):
                vtk_triangle.GetPointIds().SetId(index, point_id)
            cells.InsertNextCell(vtk_triangle)
        data = vtk.vtkPolyData()
        data.SetPoints(points)
        data.SetPolys(cells)
        mapper = vtk.vtkPolyDataMapper()
        mapper.SetInputData(data)
        actor = vtk.vtkActor()
        actor.SetMapper(mapper)
        return self.drawActor(actor)
