%
% Simulate a spring, mass, dashpot system
%

% Mass of weight in kg
m = 1;

% Hooke's constant of spring in N/m
k = 5;

% Dashpot damping in N/(m/s)
c = 1;

% Force acting on the mass, F_t = -k*x_t - c*v_t

% The state of the system at any point in time is characterized by the
% displacement x_t and the mass velocity v_t ie state at time t = [x_t, v_t]

% Timestep duration in seconds
dt = 0.1;

% Number of timesteps
ntimesteps = 400;

% First create an array to store the system state
state = zeros(2,ntimesteps);

% Set the systems initial state.
% x_0 = 0.2, v_0 = 0;

state(1,1) = 0.2;
state(2,1) = 0;


% Simulation loop - For each timestep compute the next state of the system
% as a function of the current state of the system based on the equations
% governing the dynamical system

for i = 1:(ntimesteps-1)
    % x_t+1 = x_t + v_t*dt
    state(1,i+1) = state(1,i) + state(2,i)*dt;
   
    % Compute instantaneous acceleration
    at = - (k*state(1,i) + c*state(2,i)) / m;
    
    % v_t+1 = v_t + a_t*dt
    state(2,i+1) = state(2,i) + at*dt;
end


% Plot the results

figure;

% Plot position, x_t
plot(state(1,:));
hold on;

% Plot velocity, v_t
plot(state(2,:), 'r');
