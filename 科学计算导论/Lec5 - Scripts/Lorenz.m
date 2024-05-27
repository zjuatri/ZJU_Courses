%% Lorenz Attractor simulation
%
SIGMA = 10.;
RHO = 28.;
BETA = 8./3.;
 
dt = 1e-3;
ntimesteps = 50000;

% Here we are demonstrating sensitive dependence on initial conditions
% where a small change in the initial conditions can have a drastic change
% on the final result of the simulation

initial_state = [20+1e-5;5;-5];

state = LorenzAttractor([20;5;-5], dt, ntimesteps, SIGMA, RHO, BETA);

figure;
plot3(state(1,:), state(2,:), state(3,:));

%%
new_state = LorenzAttractor([20;5+1e-5;-5], dt, ntimesteps, SIGMA, RHO, BETA);

hold on;
plot3(new_state(1,:), new_state(2,:), new_state(3,:), 'r');

%% Plot the two trajectories against each other
figure;
subplot(2,1,1); plot (state(2,:));
subplot(2,1,2); plot (new_state(2,:), 'r');
