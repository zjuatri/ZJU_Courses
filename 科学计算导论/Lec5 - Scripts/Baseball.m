%
% Baseball.m
%

%% Run simulation
states = BaseballSimulator ([0 0 50 50], 0.1, 100);
plot (states(1,:), states(2,:));

%% Run simulation with different starting velocities
states = BaseballSimulator ([0 0 40 30], 0.1, 100);

hold on;
plot (states(1,:), states(2,:), 'r');


%% Run simulation with viscous drag included
states = BaseballSimulatorWithDrag ([0 0 50 50], 0.04, 0.1, 200);

hold on;
plot (states(1,:), states(2,:), 'r');

%% Run Simulator modeling bounces on the ground
states = BaseballSimulatorWithCollisions ([0 0 70 30], 0.04, 0.6, 0.1, 400);

figure;
plot (states(1,:), states(2,:), 'b');
