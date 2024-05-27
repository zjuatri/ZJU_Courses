function A = integrate (f, xmin, xmax, n)
% integrate : computes the numerical integral of the function f over
% the interval xmin xmax with spacing dx
% using Trapezoidal rule
dx = (xmax - xmin)/n;
x = [xmin:dx:xmax];

% Evaluate the function over the interval
y = f(x);

% Here we employ the Trapezium approximation
A = (dx/2)*(y(1) + y(end) + 2*sum(y(2:end-1)));
