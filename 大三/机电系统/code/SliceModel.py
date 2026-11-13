import SliceAlgo


class SliceModel:
    def __init__(self, stlModel, layerThk, sliceAlgo="brutal", linkAlgo="dlook"):
        self.stlModel = stlModel
        self.layerThk = layerThk
        self.layers = []
        self.sliceAlgo = sliceAlgo
        self.linkAlgo = linkAlgo
        if linkAlgo not in ("brutal", "dorder", "dlook"):
            raise ValueError("拼接算法必须是 brutal、dorder 或 dlook")
        if sliceAlgo == "brutal":
            self.slice_brutal()
        elif sliceAlgo in ("optimal", "sweep"):
            self.slice_optimal()
        elif sliceAlgo == "match":
            self._slice(SliceAlgo.intersectStl_match)
        elif sliceAlgo == "topo":
            self.slice_topo()
        elif sliceAlgo == "combine":
            self.slice_combine()
        else:
            raise ValueError("切片算法必须是 brutal、sweep、match、optimal、combine 或 topo")

    def _slice(self, algorithm):
        self.layers = algorithm(self.stlModel, self.layerThk)
        for layer in self.layers:
            SliceAlgo.buildLayerContours(layer, self.linkAlgo)
        return self.layers

    def slice_brutal(self):
        return self._slice(SliceAlgo.intersectStl_brutal)

    def slice_optimal(self):
        return self._slice(SliceAlgo.intersectStl_sweep)

    def slice_topo(self):
        self.layers = SliceAlgo.slice_topo(self.stlModel, self.layerThk)
        return self.layers

    def slice_combine(self):
        self.layers = SliceAlgo.slice_combine(self.stlModel, self.layerThk)
        return self.layers

    def writeSlcFile(self, path):
        SliceAlgo.writeSlcFile(self.layers, path)

    def readSlcFile(self, path):
        self.layers = SliceAlgo.readSlcFile(path)
        return self.layers

    def drawLayerContours(self, va, start=0, stop=0xFFFF, step=1,
                          clr=(0, 0, 0), lineWidth=1):
        if step <= 0:
            raise ValueError("绘图层间隔必须大于零")
        actors = []
        for layer in self.layers[start:stop:step]:
            for contour in layer.contours:
                actor = va.drawPolyline(contour)
                actor.GetProperty().SetColor(*clr)
                actor.GetProperty().SetLineWidth(lineWidth)
                actors.append(actor)
        return actors
