% Script for lecture 16 3D plots
%
%% 16-1: Simple 3D plot

% Vector of independent variables for plotting the function
t = 0:0.1:6*pi;
% Evaluate the functions for x, y, and z
x = sqrt(t).*sin(2*t);
y = sqrt(t).*cos(2*t);
z = 0.5*t;
% Plot it
plot3(x, y, z, 'k', 'linewidth', 1)
%%
grid on
%%
xlabel('x'); ylabel('y'); zlabel('z');



%% 16-2: Example of mesh and surface plots
% Step 1: Make the grid
x = -1:0.1:3;
y = 1:0.1:4;
[X, Y] = meshgrid(x, y);

%% Step 2: Find the z values
Z = X.*Y.^2./(X.^2 + Y.^2);

%% Step 3: Draw the plots
mesh(X, Y, Z)

%%
figure
surf(X, Y, Z)
%%
xlabel('x'); ylabel('y'); zlabel('z');



%% 16-3: Variations of mesh and surface plots

% Reset colormap from previous script
colormap('default');

% Define the domain, the grid, and calculate z values
x = -3:0.25:3;
y = -3:0.25:3;
[X, Y] = meshgrid(x, y);  
Z = 1.8.^(-1.5*sqrt(X.^2+Y.^2)).*cos(0.5*Y).*sin(X);

%% Basic mesh plot
mesh(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% Basic surface plot
surf(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% Mesh curtain plot
meshz(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% Mesh and contour plot
meshc(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% Surface and contour plot
surfc(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% Surface plot with lighting
surfl(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');

%% 3D contour plot
contour3(X, Y, Z, 15);
xlabel('x'); ylabel('y'); zlabel('z');

%% 2D contour plot
contour(X, Y, Z, 15);
xlabel('x'); ylabel('y'); zlabel('z');



%% 16-4: More 3D plots

% Unit sphere
[X, Y, Z] = sphere(20);
surf(X, Y, Z);

%% Cylinder
% Calculate the profile r of the cylinder
t = linspace(0, pi, 20);
r = 1+sin(t);
[X, Y, Z] = cylinder(r);
surf(X, Y, Z);
axis square

%% 3D bar plot
% Each column is one curve; rows hold the data
Y = [1  6.5  7;  2  6  7;  3  5.5  7;...
     4  5  7;  3  4  7;  2  3  7;  1  2  7];
Y
bar3(Y)

%% 3D stem plot
t = 0:0.2:10;
x = t;
y = sin(t);
z = t.^1.5;
stem3(x, y, z, 'fill');
grid on
xlabel('x'); ylabel('y'); zlabel('z');

%% 3D scatter plot
t = 0:0.4:10;
x = t;
y = sin(t);
z = t.^1.5;
scatter3(x, y, z, 'filled');
grid on
xlabel('x'); ylabel('y'); zlabel('z');
 
%% 3D pie chart
X = [5 9 14 20];
% explode is used to offset a slice
explode = [0 0 1 0];
pie3(X, explode)



%% 16-5: Controlling the view
% Set up initial plot
x = -3:0.25:3;
y = -3:0.25:3;
[X, Y] = meshgrid(x, y);
Z = 1.8.^(-1.5*sqrt(X.^2+Y.^2)).*cos(0.5*Y).*sin(X);

%% Surface plot
surf(X, Y, Z)
xlabel('x'); ylabel('y'); zlabel('z');

%% Change the view
view(20, 35)

%% Projection on x-y plane: top view
title('Top view')
view(0, 90)

%% Projection on x-z plane: side view
title('Side view')
view (0, 0)

%% Projection on y-z plane: side view
title('Side view')
view (90, 0)

%% Rotate the view until CTRL C typed
az = -37.5;
delta_az = 7.2;
l=0;
while 1<50
    l=l+1;
    az
    view (az, 30);
    az = az + delta_az;
    pause(0.5);
end

%% Now try the Plot Editor...