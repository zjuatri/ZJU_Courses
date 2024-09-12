model Model1 "lab1"
  Modelica.Electrical.Analog.Sources.ConstantVoltage U(V=12) 
    annotation (Placement(transformation(origin={-296,48.4795}, 
extent={{-10,-10},{10,10}}, 
rotation=-90)));
  Modelica.Electrical.Analog.Basic.Ground ground 
    annotation (Placement(transformation(origin={-296,20}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor U1(R=330) 
    annotation (Placement(transformation(origin={-194.298,63.6239}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Basic.Resistor U2(R=620) 
    annotation (Placement(transformation(origin={-161.54,63.3745}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor 
    annotation (Placement(transformation(origin={-249.644,63.3331}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor 
    annotation (Placement(transformation(origin={-194.554,44.2175}, 
extent={{-10,-10},{10,10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor1 
    annotation (Placement(transformation(origin={-161.275,86.768}, 
extent={{-10,-10},{10,10}})));
  equation
  connect(U1.n, U2.p) 
  annotation(Line(origin={-177.046,62.8757}, 
points={{-7.25181,0.748193},{5.50602,0.748193},{5.50602,0.498795}}, 
color={0,0,255}));
  connect(U2.n, ground.p) 
  annotation(Line(origin={-255,47}, 
points={{103.46,16.3745},{103.46,-17},{-41,-17}}, 
color={0,0,255}));
  connect(U.p, currentSensor.p) 
  annotation(Line(origin={-277,57}, 
points={{-19,1.47952},{-19,6.3331},{17.3562,6.3331}}, 
color={0,0,255}));
  connect(U1.p, currentSensor.n) 
  annotation(Line(origin={-221,63}, 
points={{16.7022,0.623893},{-18.6438,0.623893},{-18.6438,0.3331}}, 
color={0,0,255}));
  connect(ground.p, U.n) 
  annotation(Line(origin={-296,33}, 
points={{0,-3},{0,5.47952}}, 
color={0,0,255}));
  connect(U1.p, voltageSensor.p) 
  annotation(Line(origin={-204,54}, 
  points={{-0.298,9.6239},{-0.298,-9.78246},{-0.554494,-9.78246}}, 
  color={0,0,255}));
  connect(U1.n, voltageSensor.n) 
  annotation(Line(origin={-184,54}, 
  points={{-0.298,9.6239},{-0.298,-9.78246},{-0.554494,-9.78246}}, 
  color={0,0,255}));
  connect(voltageSensor1.p, U2.p) 
  annotation(Line(origin={-171,75}, 
  points={{-0.275388,11.768},{-0.275388,-11.6255},{-0.54,-11.6255}}, 
  color={0,0,255}));
  connect(voltageSensor1.n, U2.n) 
  annotation(Line(origin={-151,75}, 
  points={{-0.275388,11.768},{-0.275388,-11.6255},{-0.54,-11.6255}}, 
  color={0,0,255}));
  end Model1;