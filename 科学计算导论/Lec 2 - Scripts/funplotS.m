function xyout = funplotS(Fun, a, b)
% funplotS graphs function Fun in the range [a, b]
% Input arguments:
%   Fun     Function name of the function to be graphed as a string
%   a       First point in the range
%   b       Last point in the range
% Output argument:
%   xyout   3x2 matrix of x and y=f(x) values for
%           x=a, x=(a+b)/2, x=b
% Produces a plot as a side effect of the function.

x = linspace(a, b, 100);
y = feval(Fun,x);
xyout(1,1) = a; xyout(2,1) = (a+b)/2; xyout(3,1) = b;
xyout(1,2) = y(1);
xyout(2,2) = feval(Fun,(a+b)/2);
xyout(3,2) = y(100);
plot(x,y)
xlabel('x')
ylabel('y')