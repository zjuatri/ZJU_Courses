model model1
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=10000) 
    annotation (Placement(transformation(origin={-64.1703,38.4026}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.OpAmp opAmp 
    annotation (Placement(transformation(origin={5.06897,52.1379}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=12) 
    annotation (Placement(transformation(origin={22.2069,82.3103}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage1(V=12) 
    annotation (Placement(transformation(origin={22.6897,28.2414}, 
extent={{10,-10},{-10,10}})));
  Modelica.Electrical.Analog.Basic.Ground ground 
    annotation (Placement(transformation(origin={6.51724,-11.7007}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor2(R=100000) 
    annotation (Placement(transformation(origin={5.89144,117.706}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor3(R=10000) 
    annotation (Placement(transformation(origin={-36.1728,61.9408}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R=100000) 
    annotation (Placement(transformation(origin={-5.27471,18.4133}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage(V=3,f=1000) 
    annotation (Placement(transformation(origin={-90.8367,61.2824}, 
extent={{10,-10},{-10,10}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage1(V=2,f=1000) 
    annotation (Placement(transformation(origin={-91.4851,38.6854}, 
extent={{10,-10},{-10,10}})));
  annotation(Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, 
grid={2,2})));
equation
  connect(resistor.n, opAmp.in_p) 
  annotation(Line(origin={-13,44}, 
points={{-41.1703,-5.59739},{8.06897,-5.59739},{8.06897,2.1379}}, 
color={0,0,255}));
  connect(opAmp.VMin, constantVoltage1.n) 
  annotation(Line(origin={8,36}, 
points={{-2.93103,6.13786},{-2.93103,-7.7586},{4.6897,-7.7586}}, 
color={0,0,255}));
  connect(opAmp.VMax, constantVoltage.p) 
  annotation(Line(origin={8,77}, 
points={{-2.93103,-14.8621},{-2.93103,5.31034},{4.20694,5.31034}}, 
color={0,0,255}));
  connect(opAmp.in_n, resistor3.n) 
  annotation(Line(origin={-16,61}, 
points={{11.069,-2.8621},{-10.1728,-2.8621},{-10.1728,0.940804}}, 
color={0,0,255}));
  connect(opAmp.in_n, resistor2.p) 
  annotation(Line(origin={3,84}, 
points={{-7.93103,-25.8621},{-7.93103,33.7059},{-7.10856,33.7059}}, 
color={0,0,255}));
  connect(opAmp.in_p, resistor1.p) 
  annotation(Line(origin={-7,38}, 
points={{2.06897,8.1379},{2.06897,-9.58666},{1.72529,-9.58666}}, 
color={0,0,255}));
  connect(resistor1.n, ground.p) 
  annotation(Line(origin={1,4}, 
points={{-6.27471,4.41334},{-6.27471,-5.7007},{5.51724,-5.7007}}, 
color={0,0,255}));
  connect(constantVoltage.n, ground.p) 
  annotation(Line(origin={21,40}, 
points={{11.2069,42.3103},{50.9329,42.3103},{50.9329,-41.7007},{-14.4828,-41.7007}}, 
color={0,0,255}));
  connect(constantVoltage1.p, ground.p) 
  annotation(Line(origin={21,13}, 
points={{11.6897,15.2414},{51.1984,15.2414},{51.1984,-14.7007},{-14.4828,-14.7007}}, 
color={0,0,255}));
  connect(resistor2.n, opAmp.out) 
  annotation(Line(origin={46,81}, 
points={{-30.1086,36.7059},{-30.1086,-28.8621},{-30.931,-28.8621}}, 
color={0,0,255}));
  connect(sineVoltage.p, resistor3.p) 
  annotation(Line(origin={-64,62}, 
  points={{-16.8367,-0.717582},{17.8272,-0.717582},{17.8272,-0.0592}}, 
  color={0,0,255}));
  connect(sineVoltage.n, ground.p) 
  annotation(Line(origin={-49,30}, 
points={{-51.8367,31.2824},{-89.8242,31.2824},{-89.8242,-31.7007},{55.5172,-31.7007}}, 
color={0,0,255}));
  connect(resistor.p, sineVoltage1.p) 
  annotation(Line(origin={-78,46}, 
points={{3.8297,-7.59739},{-3.48507,-7.59739},{-3.48507,-7.31461}}, 
color={0,0,255}));
  connect(sineVoltage1.n, ground.p) 
  annotation(Line(origin={-66,23}, 
points={{-35.4851,15.6854},{-73.0807,15.6854},{-73.0807,-24.7007},{72.5172,-24.7007}}, 
color={0,0,255}));
  end model1;