function newBallState = updateBallState (ballState, dt, walls, coefficient_of_restitution)

    % Do a normal state update computing the next state of the ball
    newBallState = [(ballState(1) + ballState(3)*dt) (ballState(2) + ballState(4)*dt) ballState(3)  ballState(4)];

    time_to_collision = dt;
    for wall = walls'
        
        % collision check
        [t collision_state] = findCollision (newBallState, dt, wall, coefficient_of_restitution);
        
      
        if (t < time_to_collision)
            time_to_collision = t;
            newBallState = collision_state;
        end
    end
    
    if (time_to_collision < dt )
        time_to_collision
        newBallState
        newBallState = updateBallState (newBallState, dt-time_to_collision, walls, coefficient_of_restitution);
    end



function [t collision_state] = findCollision (ballState, dt, wall, coefficient_of_restitution)

x1 = wall(1);
y1 = wall(2);
x2 = wall(3);
y2 = wall(4);

x = ballState(1);
y = ballState(2);
vx = ballState(3);
vy = ballState(4);

t = Inf;
collision_state = [];

if ( x1 == x2 )   % vertical wall
    if ( (x-x1)*vx > 0 )
        t2 = (x - x1 ) / vx;
        Yw = y - vy*t2;
        if ( (t2< dt ) && Yw > min(y1,y2) && Yw < max(y1,y2) )
            t = dt - t2;
            collision_state(1) = x1;
            collision_state(2) = Yw;
            collision_state(3) = coefficient_of_restitution*(-vx);
            collision_state(4) = coefficient_of_restitution*(vy);
        end
    end
end

if ( y1 == y2 )   % horizontal wall
    if ( (y-y1)*vy > 0 )
        t2 = (y - y1 ) / vy;
        Xw = x - vx*t2;
        if ( (t2< dt ) && Xw > min(x1,x2) && Xw < max(x1,x2) )
            t = dt - t2;
            collision_state(1) = Xw;
            collision_state(2) = y1;
            collision_state(3) = coefficient_of_restitution*(vx);
            collision_state(4) = coefficient_of_restitution*(-vy);
        end
    end
end