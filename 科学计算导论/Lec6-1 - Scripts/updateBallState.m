function newBallState = updateBallState (ballState, dt, walls, coefficient_of_restitution)
% Computes where the ball will be after dt seconds taking into account
% collisions with the walls

time_to_collision = dt;
newBallState = [(ballState(1)+ballState(3)*dt)  (ballState(2)+ballState(4)*dt) ballState(3) ballState(4)]; 

% For each wall compute when the ball will contact that surface
for wall = walls'
    % Determine when the ball will hit the wall
    [t collision_state] = findCollision (ballState, wall, coefficient_of_restitution);
    
    if (t <= time_to_collision)
        % Update time to collision and ball state to reflect earliest
        % collision
        time_to_collision  = t;
        newBallState = collision_state;
    end
end
time_to_collision
newBallState


if (time_to_collision < dt)
    newBallState = updateBallState (newBallState, dt-time_to_collision, walls, coefficient_of_restitution);
end



function [t, collisionState] = findCollision (ballState, wall, coefficient_of_restitution)
% This function determines when the ball will hit the given wall and its
% state after the collision

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
    
    % Check if ball is heading towards wall
    if ((x1 - x)*vx > 0)
        t1 = (x1 - x) / vx;
        newY = y + vy*t1;
        
        if ((newY >= min(y1,y2)) && (newY <= max(y1,y2)))
            t = t1;
            collisionState(1) = x1;
            collisionState(2) = newY;
            collisionState(3) = coefficient_of_restitution*(-vx);
            collisionState(4) = coefficient_of_restitution*( vy);
        end
    end
    
end

if (y1 == y2)
    % horizontal wall
    
    % Check if ball is heading towards wall
    if ((y1 - y)*vy > 0)
        t1 = (y1 - y) / vy;
        newX = x + vx*t1;
        
        if ((newX >= min(x1,x2)) && (newX <= max(x1,x2)))
            t = t1;
            collisionState(1) = newX;
            collisionState(2) = y1;
            collisionState(3) = coefficient_of_restitution*( vx);
            collisionState(4) = coefficient_of_restitution*(-vy);
        end
    end
    
end