function brownianMotion (nparticles, iterations)
%% Simulate brownian motion

% Initialize positions of particles randomly
scale = 20;

x = scale*rand(nparticles, 1);
y = scale*rand(nparticles, 1);

% display particles
h = plot (x, y, 'bo', 'MarkerSize', 10);
axis ([0 scale 0 scale]);

for k = 1:iterations
    
    % Generate random motions
    dx = rand(nparticles, 1) -0.5 + 0.1;
    dy = rand(nparticles, 1) -0.5;
    
    % Update particle positions
    x = x + dx;
    y = y + dy;
    
    % Update the display
    set (h, 'XData', x);
    set (h, 'YData', y);
    
    pause (0.1);
    
end