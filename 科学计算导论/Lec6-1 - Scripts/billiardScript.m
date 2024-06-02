%%
% billiardScript : Sets up and runs a billiard simulation
% 
% initialState: 
%      the initial state of the ball (position and velocity) expressed as a row vector [x y vx vy] 
%      (x and y in meters, vx and vy in meters/second) 
% walls : 
%      The walls in the simulation this is provided as an array with
%      one row for every wall - each row encodes the endpoints of the wall in the following format [x1 y1 x2 y2]
%      so the array [1 3 1 5; 7 5 10 5] would represent two walls one with end
%      points (1,3) and (1,5) and the other with endpoints (7,5) and (10,5).
%      Note that the walls will either be purely horizontal or purely vertical
%      and you can tell which by checking whether the x or y coordinates of
%      the endpoints are constant
% timestep : 
%      the simulation timestep in seconds
% iterations : 
%      number of timesteps to run the simulation
% coefficient_of_restitution : 
%      after the ball collides with a wall it's speed after the collision is related to its speed 
%      before the collision the coefficient of restitution. This is a
%      unitless quantity between 0 and 1.


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
%

ballState = initialState;

% Initialize the display

% Draw the ball
h = plot (ballState(1), ballState(2), 'bo', 'MarkerSize', 10);

% Set the axis to correspond to a 10 meter by 10 meter field
axis ([0 10 0 10]);

% Draw the walls using the line function
line (walls(:,[1 3])',walls(:,[2 4])')

% For each timestep
for i = 1:iterations
    % Update the ball state
    ballState = updateBallState (ballState, timestep, walls, coefficient_of_restitution);
    % Redraw the ball
    set (h, 'XData', ballState(1));
    set (h, 'YData', ballState(2));
   
    % pause so that we can see the drawing
    pause (0.2);
end
