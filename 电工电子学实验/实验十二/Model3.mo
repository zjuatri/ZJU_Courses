model Model3
  Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage(f=50,V=15*sqrt(2)) 
    annotation (Placement(transformation(origin={-262.905,9.43158}, 
extent={{-10,10},{10,-10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Ground ground 
    annotation (Placement(transformation(origin={-262.905,-47.9439}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Ideal.IdealDiode diode 
    annotation (Placement(transformation(origin={-187.846,44.407}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Ideal.IdealDiode diode1 
    annotation (Placement(transformation(origin={-220.463,18.0772}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Ideal.IdealDiode diode2 
    annotation (Placement(transformation(origin={-195.137,-14.3649}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Ideal.IdealDiode diode3 
    annotation (Placement(transformation(origin={-158.414,7.81756}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=240) 
    annotation (Placement(transformation(origin={-67.2,-21.2211}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C(displayUnit="uF")=0.00047) 
    annotation (Placement(transformation(origin={-103.354,-23.5789}, 
extent={{-10,10},{10,-10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R=10) 
    annotation (Placement(transformation(origin={-116.519,7.66319}, 
extent={{-10.9825,-10.9825},{10.9825,10.9825}})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor1(C(displayUnit="uF")=0.0001) 
    annotation (Placement(transformation(origin={-136.365,-14.9333}, 
extent={{-10,10},{10,-10}}, 
rotation=270)));

  annotation(Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, 
grid={2,2})));
equation




  connect(sineVoltage.n, ground.p) 
  annotation(Line(origin={-261,-19}, 
points={{-1.905,18.4316},{-1.905,-18.9439},{-1.90484,-18.9439}}, 
color={0,0,255}));
  connect(sineVoltage.p, diode.p) 
  annotation(Line(origin={-230,33}, 
  points={{-32.905,-13.5684},{-32.905,12.586},{32.1542,12.586},{32.1542,11.407}}, 
  color={0,0,255}));
  connect(diode.p, diode1.n) 
  annotation(Line(origin={-204,30}, 
  points={{6.15423,14.407},{4.75789,14.407},{4.75789,-15.0667},{-6.46339,-15.0667},{-6.46339,-11.9228}}, 
  color={0,0,255}));
  connect(diode1.p, diode2.p) 
  annotation(Line(origin={-223,2}, 
  points={{-7.46339,16.0772},{-17.1123,16.0772},{-17.1123,-16.3649},{17.8633,-16.3649}}, 
  color={0,0,255}));
  connect(diode2.n, diode3.p) 
  annotation(Line(origin={-177,-3}, 
  points={{-8.13668,-11.3649},{-8.13668,10.8176},{8.58581,10.8176}}, 
  color={0,0,255}));
  connect(diode.n, diode3.n) 
  annotation(Line(origin={-163,26}, 
  points={{-14.8458,18.407},{14.5858,18.407},{14.5858,-18.1824}}, 
  color={0,0,255}));
  connect(diode2.n, sineVoltage.n) 
  annotation(Line(origin={-224,-7}, 
points={{38.8633,-7.36491},{38.8633,-23.8281},{-38.905,-23.8281},{-38.905,6.43158}}, 
color={0,0,255}));
  connect(resistor.n, diode2.p) 
  annotation(Line(origin={-142,-23}, 
points={{74.8,-8.22106},{74.8,-25.3684},{-63.137,-25.3684},{-63.137,8.6351}}, 
color={0,0,255}));
  connect(capacitor.n, resistor.n) 
  annotation(Line(origin={-95,-32}, 
points={{-8.35437,-1.57895},{-8.35437,-16.3684},{27.8,-16.3684},{27.8,0.77894}}, 
color={0,0,255}));
  connect(diode3.n, resistor1.p) 
  annotation(Line(origin={-141,14}, 
points={{-7.414,-6.18244},{13.4987,-6.18244},{13.4987,-5.35436}}, 
color={0,0,255}));
  connect(resistor1.n, capacitor.p) 
  annotation(Line(origin={-108,4}, 
points={{2.46365,3.66319},{6.00049,3.66319},{6.00049,-17.5789},{4.64563,-17.5789}}, 
color={0,0,255}));
  connect(resistor1.n, resistor.p) 
  annotation(Line(origin={-87,-1}, 
  points={{-20.5013,9.64564},{19.8,9.64564},{19.8,-10.2211}}, 
  color={0,0,255}));
  connect(resistor1.p, capacitor1.p) 
  annotation(Line(origin={-132,1}, 
  points={{4.4985,6.66319},{-4.36491,6.66319},{-4.36491,-5.93333}}, 
  color={0,0,255}));
  connect(capacitor1.n, resistor.n) 
  annotation(Line(origin={-101,-37}, 
points={{-35.3649,12.0667},{-35.3649,-11.7298},{34.9789,-11.7298},{34.9789,4.38246},{33.8,4.38246},{33.8,5.7789}}, 
color={0,0,255}));
  end Model3;