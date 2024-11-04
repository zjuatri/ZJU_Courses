model Model3
  Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage 
    annotation (Placement(transformation(origin={-268.026,-20.8035}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R=5100) 
    annotation (Placement(transformation(origin={-231.741,55.6371}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=1e-5) 
    annotation (Placement(transformation(origin = {-148.527, 56.121}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=15000) 
    annotation (Placement(transformation(origin={-81.7622,-10.6436}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Ground ground 
    annotation (Placement(transformation(origin={23.7063,-66.7646}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor2(R=15000) 
    annotation (Placement(transformation(origin={-81.3414,99.9387}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor3(R=17200) 
    annotation (Placement(transformation(origin={-81.985,158.899}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor4(R=3300) 
    annotation (Placement(transformation(origin={5.71349,118.342}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Semiconductors.NPN npn 
    annotation (Placement(transformation(origin={-10.6436,58.0077}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor5(R=1800) 
    annotation (Placement(transformation(origin={37.335,12.6609}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor1(C=0.0001) 
    annotation (Placement(transformation(origin={80.3594,9.04708}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=12) 
    annotation (Placement(transformation(origin={104.201,168.596}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor2(C=1e-5) 
    annotation (Placement(transformation(origin={54.0695,65.5356}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor6(R=2000) 
    annotation (Placement(transformation(origin={170.008,-5.9122}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  annotation(Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, 
grid={2,2})));
equation
  connect(capacitor.p, resistor1.n) 
  annotation(Line(origin={-187,56}, 
points={{28.473,0.121},{-34.7412,0.121},{-34.7412,-0.362903}}, 
color={0,0,255}));
  connect(capacitor.n, resistor.p) 
  annotation(Line(origin={-110,28}, 
  points={{-28.527,28.121},{28.2378,28.121},{28.2378,-28.6436}}, 
  color={0,0,255}));
  connect(sineVoltage.n, ground.p) 
  annotation(Line(origin={-135,-44}, 
points={{-133.026,13.1965},{-133.026,-12.7646},{158.706,-12.7646}}, 
color={0,0,255}));
  connect(resistor.n, ground.p) 
  annotation(Line(origin={-42,-39}, 
points={{-39.7622,18.3564},{-39.7622,-17.7646},{65.7063,-17.7646}}, 
color={0,0,255}));
  connect(resistor2.n, resistor.p) 
  annotation(Line(origin={-83,45}, 
points={{1.65857,44.9387},{1.65857,-45.6436},{1.2378,-45.6436}}, 
color={0,0,255}));
  connect(resistor3.n, resistor2.p) 
  annotation(Line(origin={-82,129}, 
  points={{0.0149715,19.8994},{0.0149715,-19.0613},{0.65857,-19.0613}}, 
  color={0,0,255}));
  connect(resistor3.p, resistor4.p) 
  annotation(Line(origin={-38,150}, 
  points={{-43.985,18.899},{-43.985,21.3624},{43.7135,21.3624},{43.7135,-21.6582}}, 
  color={0,0,255}));
  connect(resistor4.n, npn.C) 
  annotation(Line(origin={3,86}, 
  points={{2.71349,22.3418},{2.71349,-21.9923},{-3.64364,-21.9923}}, 
  color={0,0,255}));
  connect(npn.B, resistor.p) 
  annotation(Line(origin={-51,29}, 
  points={{30.3564,29.0077},{-30.7622,29.0077},{-30.7622,-29.6436}}, 
  color={0,0,255}));
  connect(npn.E, resistor5.p) 
  annotation(Line(origin={18,37}, 
  points={{-18.6436,15.0077},{19.335,15.0077},{19.335,-14.3391}}, 
  color={0,0,255}));
  connect(resistor5.n, ground.p) 
  annotation(Line(origin={31,-27}, 
  points={{6.335,29.6609},{6.335,-29.7646},{-7.2937,-29.7646}}, 
  color={0,0,255}));
  connect(capacitor1.p, resistor5.p) 
  annotation(Line(origin={57,13}, 
points={{23.3594,6.04708},{23.3594,9.6609},{-19.665,9.6609}}, 
color={0,0,255}));
  connect(capacitor1.n, resistor5.n) 
  annotation(Line(origin={57,-9}, 
points={{23.3594,8.04708},{23.3594,0.25745},{12.0203,0.25745},{12.0203,11.6609},{-19.665,11.6609}}, 
color={0,0,255}));
  connect(resistor3.p, constantVoltage.p) 
  annotation(Line(origin={-14,171}, 
points={{-67.985,-2.101},{108.201,-2.101},{108.201,-2.4042}}, 
color={0,0,255}));
  connect(constantVoltage.n, ground.p) 
  annotation(Line(origin={70,56}, 
points={{44.2012,112.596},{218.307,112.596},{218.307,-112.765},{-46.2937,-112.765}}, 
color={0,0,255}));
  connect(npn.C, capacitor2.p) 
  annotation(Line(origin={22,65}, 
  points={{-22.6436,-0.9923},{13.7094,-0.9923},{13.7094,0.5356},{22.0695,0.5356}}, 
  color={0,0,255}));
  connect(ground.p, resistor6.n) 
  annotation(Line(origin={97,-36}, 
points={{-73.2937,-20.7646},{75.3978,-20.7646},{75.3978,20.0878},{73.008,20.0878}}, 
color={0,0,255}));
  end Model3;