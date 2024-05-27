function dy_dx = differentiate (f, xmin, xmax, dx)
% differentiate : computes the numerical derivative of the function f over
% the interval xmin xmax with spacing dx

x = [xmin:dx:xmax];

% Evaluate the function over the interval
y = f(x);

% Here we employ the centered approximation of the derivative

dy_dx = (y(3:end) - y(1:end-2)) ./ (2*dx);

% Note that the first and last elements of dy_dx are computed differently to account
% for the fact that there is no y(0) or y(end+1)

first_derivative = (y(2) - y(1)) / dx;
last_derivative  = (y(end) - y(end-1)) / dx;

dy_dx = [ first_derivative  , dy_dx , last_derivative ];