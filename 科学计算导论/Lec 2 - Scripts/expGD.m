function At = expGD(A0, At1, t1, t)
% expGD calculates exponential growth and decay
% Example 11-1
% Input arguments are
%   A0   Quantity at time 0
%   At1  Quantity at time t1
%   t1   Time t1
%   t    Time t to find A
% Output argument is
%   At   Quantity at time t
% Written by Alan Usas, 2/12/08

% Find the constant k for the function
k = log(At1/A0)/t1;
% Evaluate A at time t
At = A0*exp(k*t);