function A = simpson (f, xmin, xmax, n)
% Integrate a function f between a and b using Simpson's rule using 2*n panels
% See Section 17.2 of the Hahn and Valentine text

% We choose dx so that the interval between xmin and xmax gets divided into
% an even number of panels
dx = (xmax - xmin) / (2*n);

x = xmin:dx:xmax;

y = f(x);

A = (dx/3)* ( y(1) + 4*sum(y(2:2:end)) + 2*sum(y(3:2:end-1)) + y(end) );