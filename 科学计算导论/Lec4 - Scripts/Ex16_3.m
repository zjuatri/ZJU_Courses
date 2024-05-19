% Example 16-3: Electric field of two point charges

% Initialize the variables
eps0 = 8.85e-12; q1 = 2e-10; q2 = 3e-10;
k = 1/(4*pi*eps0);

% Create the grid -0.2<=x<=0.2 and -0.2<=y<=0.2
x = -0.2:0.01:0.2;
y = -0.2:0.01:0.2;
[X, Y] = meshgrid(x, y);

% Calculate distance from each grid point to each particle
r1 = sqrt((X+0.25).^2 + Y.^2);
r2 = sqrt((X-0.25).^2 + Y.^2);

% Calculate the electric potential at each grid point
V = k*(q1./r1 + q2./r2);

% Plot the field
mesh(X, Y, V)
figure
surf(X, Y, V)
xlabel('x (m)'); ylabel('y (m)'); zlabel('V (V)');