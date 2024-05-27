function states = BaseballSimulatorWithCollisions (initial_state, drag_coefficient, coefficient_of_restitution, dt, ntimesteps)
% This function simulates the flight of a baseball given an initial
% position and velocity. The result is a 4 * ntimesteps array giving the
% state of the ball at each instant in time. Each column has 4 numbers
% corresponding to x, y, vx and vy respectively.
% the parameter c corresponds to the coefficient of viscous drag
%
% UNITS: x and y are in meters and vx and vy are in meters per second
%

% Initialize the states array
states = zeros(4,ntimesteps);

% Set up the initial state of the system
states(:,1) = initial_state;

for t = 2:ntimesteps
    states(:,t) = UpdateBaseballState(states(:,t-1), dt);
end

% This nested function is used to compute the state of the baseball after
% dt seconds assuming that it doesn't collide with anything
    function next_state = UpdateBaseballStateNoCollisions (current_state, dt)
        
        x = current_state(1);
        y = current_state(2);
        vx = current_state(3);
        vy = current_state(4);

        % Do a normal state update computing the next state of the ball
        next_state(1) = (x + vx*dt);
        next_state(2) = (y + vy*dt);
        next_state(3) = (vx - drag_coefficient*vx*dt);
        next_state(4) = (vy - 9.8*dt - drag_coefficient*vy*dt);

    end
        

% This nested function is used to update the state of the baseball
% It computes where the ball will be after dt seconds based on its current
% state taking into account collisions
    function next_state = UpdateBaseballState (current_state, dt)

        % Do a normal state update computing the next state of the ball
        next_state = UpdateBaseballStateNoCollisions (current_state, dt);
        
        % Check if there was a collision by checking the y coordinate of
        % the position
        if (next_state(2) < 0)

            % If so figure out approximately when the collision occured.
            y = current_state(2);
            vy = current_state(4);
            
            collision_time = -y / vy;
            
            % Simulate forward to the collision point
            collision_state = UpdateBaseballStateNoCollisions (current_state, collision_time);
            
            % Model the collision by modifying the ball velocities
            
            % vx(after) = coefficient_of_restitution * vx(before)
            collision_state(3) = coefficient_of_restitution * collision_state(3);
            
            % vy(after) = - coefficient_of_restitution * vy(before)
            collision_state(4) = - coefficient_of_restitution * collision_state(4);
            
            % Call UpdateBaseballState recursively to continue simulating
            % the remainder of the time interval
            next_state = UpdateBaseballState(collision_state, dt-collision_time);
        end
    end

end
