function newBallState = updateBallState (ballState, dt, walls, coefficient_of_restitution)

newBallState = UpdateState(ballState,dt);

    function wall = NearestWall (current_state,walls)
        wall = walls(1);
        [tmin, collisionState] = findCollision(current_state,walls(1),coefficient_of_restitution);
        for i = 2:size(walls)
            [t, collisionState] = findCollision(current_state,walls(i),coefficient_of_restitution);
            if t < tmin
                wall = walls(i);
                tmin = t;
            end
        end
    end

    function next_state = UpdateStateNoCollisions (current_state, dt)
        x = current_state(1);
        y = current_state(2);
        vx = current_state(3);
        vy = current_state(4);

        next_state(1) = x + vx * dt;
        next_state(2) = y + vy * dt;
        next_state(3) = vx;
        next_state(4) = vy;
    end

    function next_state = UpdateState (current_state, dt)
        nearest = NearestWall(current_state,walls);
        [t, collisionState] = findCollision (current_state, nearest, coefficient_of_restitution);
        if dt > t
            next_state = UpdateStateNoCollisions(collisionState,dt - t);
        else
            next_state = UpdateStateNoCollisions(current_state,dt);
        end
    end

end

function [t, collisionState] = findCollision (ballState, wall, coefficient_of_restitution)
x = ballState(1);
y = ballState(2);
vx = ballState(3);
vy = ballState(4);
if wall(1) == wall(3)
    ystart = min([wall(2),wall(4)]);
    yend = max([wall(2),wall(4)]);
    t = (wall(1) - x) /  vx;
    yc = y + vy * t;
    if t > 0 && ystart <= yc && yc <= yend
        collisionState(1) = wall(1);
        collisionState(2) = yc;
        collisionState(3) = coefficient_of_restitution * collision_state(3);
        collisionState(4) = - coefficient_of_restitution * collision_state(4);
    else
        t = Inf;
        collisionState = [];
    end
end

if wall(2) == wall(4)
    xstart = min([wall(1),wall(3)]);
    xend = max([wall(1),wall(3)]);
    t = (wall(2) - y) /  vy;
    xc = x + vx * t;
    if t > 0 && xstart <= xc && xc <= xend
        collisionState(1) = xc;
        collisionState(2) = wall(2);
        collisionState(3) = - coefficient_of_restitution * collision_state(3);
        collisionState(4) = coefficient_of_restitution * collision_state(4);
    else
        t = Inf;
        collisionState = [];
    end
end
end