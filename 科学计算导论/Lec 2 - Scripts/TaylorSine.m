function y = TaylorSine(x, n)
% TaylorSine calculates n terms of the Taylor Series for sin(x)
% Example 11-3
% Input arguments
%   x   Angle in degrees
%   n   Number of terms
% Output argument
%   y   Approximation to sin(x)

% Convert degrees to radians
xr = x*pi/180;
% Sum the first n terms of the series, 0 to n-1
y = 0;
for k = 0:n-1
    y = y + (-1)^k*xr^(2*k+1)/factorial(2*k+1);
end