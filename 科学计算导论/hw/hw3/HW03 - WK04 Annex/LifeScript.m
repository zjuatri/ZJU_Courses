%%
% Game of Life
%
% given a list of shapes
block = [1 1; 1 1];
boat = [1 1 0; 1 0 1; 0 1 0];
blinker = [1 1 1];
toad = [0 1 1 1; 1 1 1 0];
glider = [1 1 1; 1 0 0; 0 1 0];
LWSS = [0 1 0 0 1; 1 0 0 0 0; 1 0 0 0 1; 1 1 1 1 0];

% initialize the cells
% please insert your shapes here!!!
in = zeros(50);

in (10, 10:12) = blinker;

in (20:22, 20:22) = glider;

in (25:28, 30:34) = LWSS;

% run the simulation
iterations = 1000;

for i = 1:iterations
    image(logical(in));
    colormap ([1 1 1; 0 0 0]);

    in = updateCells(in);
    pause(0.001);
end