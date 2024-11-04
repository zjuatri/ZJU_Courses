model model1
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=1000) 
    annotation (Placement(transformation(origin = {-273.348, 59.9914}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground 
    annotation (Placement(transformation(origin={-317.945,-4.29019}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C(displayUnit="uF")=0.001,v(start=5)) 
    annotation (Placement(transformation(origin={-203.68,31.9309}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
equation
  connect(resistor.n, capacitor.p) 
  annotation(Line(origin={-239,46}, 
points={{-24.348,13.9914},{35.3197,13.9914},{35.3197,-4.06911}}, 
color={0,0,255}));
  connect(capacitor.n, ground.p) 
  annotation(Line(origin={-256,13}, 
points={{52.32,8.9309},{52.32,-7.29019},{-61.9454,-7.29019}}, 
color={0,0,255}));
  connect(resistor.p, ground.p) 
  annotation(Line(origin={-296,32}, 
points={{12.652,27.9914},{-21.9454,27.9914},{-21.9454,-26.2902}}, 
color={0,0,255}));

end model1;