%% Vibrating string example
%

% Number of beads in a string
npts = 20;

% Mass of bead
m = 1;

% Spring constant
k = 1;

% Damping
c = 0.01;

% Timestep in seconds
dt = 0.01;

% Number of timesteps to simulate
ntimesteps = 10000;

% Initialize the array y
y = zeros(1,npts);

% Initialize the string in a plucked shape
for i = 1:(npts/2)
    y(i) =  2*i / npts;
    y(end-(i-1)) = y(i);
end

% y = sin ([1:npts]*4*pi/(npts+1));

%%
% Initialize velocities of beads
vy = zeros(1,npts);

% Add zeros to the start and end of y and vy to simulate stationary beads
y  = [0 y 0];
vy = [0 vy 0];

%%
% Plot the bead array

figure;
h = plot (y, 'b.-');
axis ([1 npts+2 -1 1]);

%%
for i = 1:ntimesteps

    % Compute the force acting on each bead in the string
    % Note the fancy indexing
    F = k*(y(3:end)-y(2:end-1)) + k*(y(1:end-2) - y(2:end-1));

    F = [0 F 0] - c*vy;

    % Update the bead positions
    y = y + vy*dt;

    % Update the beads velocities
    vy = vy + (F/m)*dt;


    % Plot the beads
    set (h, 'YData', y);

    % Small pause so we can see the results of the simulation
    pause (0.00001);

end
