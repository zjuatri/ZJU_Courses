%%
% Planetary simulation
%

% Gravitational constant N*m^2/kg^2
G = 6.67e-11;

% Mass of Sun in kg
Ms = 1.99e30;

% Mass of Earth in kg
Me = 5.98e24;

% Timestep duration in seconds (1 hour)
dt = 60*60;

% Number of timesteps (3 years)
ntimesteps = 3*365*24;

state = zeros(4,ntimesteps);

% Orbital radius of earth in meters
Re= 149.6e9;

% Orbital velocity of earth in meters/sec
Ve = 29.8e3;

% Initial Position and velocity of earth [x, y, vx, vy]
state(:,1) = [Re , 0, 0, Ve ];
% state(:,1) = [Re , 0, 0.4*Ve, 0.6*Ve ];
% state(:,1) = [Re , 0, 0, 0.8*Ve ];
for i = 2:ntimesteps
    current_pos = state(1:2,i-1);
    current_vel = state(3:4,i-1);
    
    % Compute Gravitational force acting on planet
    
    % Compute distance between sun and planet
    R = norm(current_pos);
    
    F = G*Ms*Me/(R^2);
    
    % Compute acceleration of the planet which is always directed towards
    % the sun
    a = -(F/Me)*((1/R)*current_pos);
    
    % Compute the next state;
    state(:,i) = [(current_pos + dt*current_vel); (current_vel + dt*a)];
end


figure;
plot (state(1,:), state(2,:));

