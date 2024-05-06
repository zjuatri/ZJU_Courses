function [me SD] = stat(v)
% Calculate mean and standard deviation of vector v
n = length(v);
me = AVG(v, n);
SD = StandDiv(v, me, n);

% Subfunction to calculate mean
function av = AVG(x, num)
av = sum(x)/num;

% Subfunction to calculate standard deviation
function Sdiv = StandDiv(x, xAve, num)
xdif = x-xAve;
xdif2 = xdif.^2;
Sdiv = sqrt(sum(xdif2)/(num-1));
