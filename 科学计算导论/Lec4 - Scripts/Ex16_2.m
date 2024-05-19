% Example 16-2: Heat conduction on a plate

% Initialize the variables
a = 5; b = 4; na = 20; nb = 16; T0 = 80;
clear T

% k will determine number of terms
k = 100;

% Create the mesh
x = linspace(0, a, na);
y = linspace(0, b, nb);
[X, Y] = meshgrid(x, y);

% Calculate the temperature at each point
for i = 1:nb
    for j = 1:na
        % Initialize the temperature to 0
        T(i,j) = 0;
        % Sum for k terms using the heat equation
        for n = 1:k
            ns = 2*n-1;
            T(i, j) = T(i, j) + (sin(ns*pi*X(i,j)/a)/ns) .*...
                sinh(ns*pi*Y(i,j)/a)/sinh(ns*pi*b/a);
        end
        T(i, j) = T(i, j)*4*T0/pi;
    end
end

% Plot it
mesh(X, Y, T)
figure
surf(X, Y, T)
xlabel('x (m)'); ylabel('y (m)'); zlabel('T (^oC)');
        