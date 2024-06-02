function newBallState = updateBallState (ballState, dt, walls, coefficient_of_restitution)
% Computes where the ball will be after dt seconds taking into account
% collisions with the walls

time_to_collision = dt;
newBallState = [(ballState(1)+ballState(3)*dt)  (ballState(2)+ballState(4)*dt) ballState(3) ballState(4)]; 

% For each wall compute when the ball will contact that surface
for wall = walls'
    % Determine when the ball will hit the wall
    [t collision_state] = findCollision (newBallState, dt, wall, coefficient_of_restitution);

    if (t < time_to_collision)
        % Update time to collision and ball state to reflect earliest collision
        time_to_collision  = t;
        newBallState = collision_state;
    end
end

if (time_to_collision < dt)
    newBallState = updateBallState (newBallState, dt-time_to_collision, walls, coefficient_of_restitution);
end
end


function [t, collisionState] = findCollision (ballState, dt, wall, coefficient_of_restitution)
% This function determines when the ball will hit the given wall and its
% state after the collision, where t = time-to-collisoon

x = ballState(1);
y = ballState(2);
vx = ballState(3);
vy = ballState(4);

x1 = wall(1);
y1 = wall(2);
x2 = wall(3);
y2 = wall(4);

% Initialize outputs
t = Inf;
collisionState = [];

if (x1 == x2)
    % vertical wall
    
    % Check if ball has hit the wall
    if ((x - x1)*vx > 0)
        t2 = (x - x1) / vx;
        newY = y - vy*t2;
        
        if ((t2<dt) && (newY >= min(y1,y2)) && (newY <= max(y1,y2)))
            t = dt - t2;
            collisionState(1) = x1;
            collisionState(2) = newY;
            collisionState(3) = coefficient_of_restitution*(-vx);
            collisionState(4) = coefficient_of_restitution*( vy);
        end
    end
    
end

if (y1 == y2)
    % horizontal wall
    
    % Check if ball has hit the wall
    if ((y - y1)*vy > 0)
        t2 = (y - y1) / vy;
        newX = x - vx*t2;
        
        if ((t2<dt) && (newX >= min(x1,x2)) && (newX <= max(x1,x2)))
            t = dt - t2;
            collisionState(1) = newX;
            collisionState(2) = y1;
            collisionState(3) = coefficient_of_restitution*( vx);
            collisionState(4) = coefficient_of_restitution*(-vy);
        end
    end
    
end

if (abs(t)<1e-10) 
    t = Inf;
end

end