%%
% Simulating a planetary system in 2D.
%

% Matrix storing positions of bodies
Pos = [0 1 0; 0 0 1];

% Velocities of planets
% Vel = rand(2,3)-0.5;

Vel = [0 0 -0.5; 0 -0.3 0];

% Mass of particles
m = 1;

G = 0.1;

% Timestep
dt = 0.1;

ntimesteps = 5000;

figure;
h = plot (Pos(1,:), Pos(2,:), 'bo');
axis ([-1 1 -1 1]*10);

for k = 1:ntimesteps;
    % For each planet figure out the forces acting on it.

    F = zeros(2,3);

    for i = 1:3
        for j = 1:3
            if (i ~= j)
                d = Pos(:,j) - Pos(:,i);
                F(:,i) = F(:,i) + (G*m*m*d) / norm(d,3);
            end
        end
    end
    
    % Update positions
    Pos = Pos + Vel*dt;
    
    % Update Velocities
    Vel = Vel + (F/m)*dt;

    set (h, 'XData', Pos(1,:));
    set (h, 'YData', Pos(2,:));
    
    pause(0.001);

end
