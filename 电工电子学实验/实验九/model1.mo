model model1
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
  Modelica.Electrical.Analog.Basic.Resistor resistor3(R=10000) 
    annotation (Placement(transformation(origin={-36.1728,58.3279}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor2(R=100000) 
    annotation (Placement(transformation(origin={10.1971,115.296}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R=10000) 
    annotation (Placement(transformation(origin={-35.8072,40.8698}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage(f=300,V=2) 
    annotation (Placement(transformation(origin={-76.8344,40.9462}, 
extent={{10,-10},{-10,10}})));
  annotation(Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, 
grid={2,2})));
equation
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
points={{11.069,-2.8621},{-10.1728,-2.8621},{-10.1728,-2.6721}}, 
color={0,0,255}));
  connect(constantVoltage.n, ground.p) 
  annotation(Line(origin={21,40}, 
points={{11.2069,42.3103},{50.9329,42.3103},{50.9329,-41.7007},{-14.4828,-41.7007}}, 
color={0,0,255}));
  connect(constantVoltage1.p, ground.p) 
  annotation(Line(origin={21,13}, 
points={{11.6897,15.2414},{51.1984,15.2414},{51.1984,-14.7007},{-14.4828,-14.7007}}, 
color={0,0,255}));
  connect(resistor3.p, ground.p) 
  annotation(Line(origin={-20,28}, 
points={{-26.1728,30.3279},{-109.029,30.3279},{-109.029,-29.7007},{26.5172,-29.7007}}, 
color={0,0,255}));
  connect(resistor2.p, opAmp.in_n) 
  annotation(Line(origin={-2,87}, 
  points={{2.19709,28.2956},{-2.93103,28.2956},{-2.93103,-28.8621}}, 
  color={0,0,255}));
  connect(opAmp.out, resistor2.n) 
  annotation(Line(origin={18,84}, 
  points={{-2.93103,-31.8621},{2.19709,-31.8621},{2.19709,31.2956}}, 
  color={0,0,255}));
  connect(opAmp.in_p, resistor1.n) 
  annotation(Line(origin={-15,44}, 
  points={{10.069,2.1379},{-10.8072,2.1379},{-10.8072,-3.13016}}, 
  color={0,0,255}));
  connect(resistor1.p, sineVoltage.p) 
  annotation(Line(origin={-56,41}, 
  points={{10.1928,-0.130165},{-10.8344,-0.130165},{-10.8344,-0.0538}}, 
  color={0,0,255}));
  connect(sineVoltage.n, ground.p) 
  annotation(Line(origin={-61,20}, 
points={{-25.8344,20.9462},{-68.1011,20.9462},{-68.1011,-21.7007},{67.5172,-21.7007}}, 
color={0,0,255}));
  end model1;