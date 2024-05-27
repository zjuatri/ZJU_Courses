function states = BaseballSimulator (initial_state, dt, ntimesteps)
% This function simulates the flight of a baseball given an initial
% position and velocity. The result is a 4 * ntimesteps array giving the
% state of the ball at each instant in time. Each column has 4 numbers
% corresponding to x, y, vx and vy respectively.
%
% UNITS: x and y are in meters and vx and vy are in meters per second
%

% Initialize the states array
states = zeros(4,ntimesteps);

% Set up the initial state of the system
states(:,1) = initial_state;

for t = 2:ntimesteps
    states(:,t) = UpdateBaseballState(states(:,t-1));
end


% This subfunction is used to compute the next state of the baseball as a
% function of the current state.
    function next_state = UpdateBaseballState (current_state)

        x = current_state(1);
        y = current_state(2);
        vx = current_state(3);
        vy = current_state(4);

        next_state(1) = (x + vx*dt);
        next_state(2) = (y + vy*dt);
        next_state(3) = vx;
        next_state(4) = (vy - 9.8*dt);

    end

end
