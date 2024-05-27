function dx = thirdOrderODE(t,x,p,q,r)

% p = 2;
% q = 1.5;
% r = 0.1;

dx = zeros(3,1);
dx(1) = x(2);
dx(2) = x(3);
dx(3) = -p*x(3)-q*x(2)-r*x(1);



% dx(1) = x(2);
% dx(2) = x(3);
% dx(3) = -p*x(3)-q*x(2)-r*x(1);
% 
% xout = [dx(1);dx(2);dx(3)];

% dx1 = x(2);
% dx2 = x(3);
% dx3 = -p*x(3)-q*x(2)-r*x(1);
% 
% xout = [dx1; dx2; dx3];