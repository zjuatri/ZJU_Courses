% Lecture 23 notes
%
%% syntax error
x = (y + 3)/2

%% Run-time errors
b = 0; 
c = 25/b;

x= 0;
log(x);

%% Logical errors


%% Programming example
% billiardScript : Sets up and runs a billiard simulation


% Initial State of ball
%                 x    y   vx vy
initialState = [1.2 0.88 10.1 10];

%         x1  y1  x2  y2
walls = [  0   0  10   0; ...
           0  10  10  10; ...
           0   0   0  10; ...
          10   0  10  10; ...
           0   5   5   5; ...
           4   0   4   3; ...
           7   6   7   9 ];

coefficient_of_restitution = 1.0;
timestep = 0.04;
iterations = 1000;


% Run the simulation
billiards (initialState, walls, timestep, iterations, coefficient_of_restitution);