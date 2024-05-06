function y = TaylorExp(x)
% TaylorExp computes exp(x) using a Taylor series.
% Example 11-4
% It stops after 30 terms or if the last term added is <0.0001.
% Input argument
%   x    The exponent
% Output argument
%   y    Approximation of exp(x)

% Initialize variables
n = 1; an = 1; y = an;
% Repeated add terms until precision is reached or 30 terms are found
while (abs(an) >= 0.0001) & (n <= 30)
    an = x^n/factorial(n);
    y = y+an;
    n = n+1;
end
if n > 30
    disp('More than 30 terms are needed.');
else
    fprintf('Used %i terms.\n', n);
end
    