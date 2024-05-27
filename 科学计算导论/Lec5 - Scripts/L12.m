%
% Lecture 12 Calculus Script
%

%% 12-1 Approximating the derivative of a function

dx = 0.1;
xmin = 0;
xmax = 10;

x = xmin:dx:xmax;

% A simple polynomial
%%
y = x.^2 - 12*x + 35;

%%
y = exp (-x./5) .* sin(2*x);

%%
figure;
plot(x,y);

%% 12-2 Approximating the derivative

dy_dx = (y(2:end) - y(1:end-1)) ./ dx;

% dealing with the edge effects
dy_dx(end+1) = 0;

hold on;
plot(x, dy_dx, 'r');


%% 12-3 An alternative approximation 
% - centered approximation
dy_dx = (y(3:end) - y(1:end-2)) ./ (2*dx);

% dealing with the edge effects
dy_dx = [0 dy_dx 0];

plot (x, dy_dx, 'g');


%% 12-4 Choosing dx

dx = 1e-3;
x = [-dx 0 dx];
y = exp(x);

dy_dx = (y(3) - y(2)) / dx

%%
dy_dx = (y(3) - y(1)) / (2*dx)


%% 12-5 Passing a function as an argument (fn1)

xmin = 0;
xmax = 10;
dx = 0.1;
x = xmin:dx:xmax;

dy_dx = differentiate (@fn1,xmin,xmax,dx)


%% 12-6 Anonymous functions (with diff)

dy_dx = differentiate (@(x)(exp(-x./5).*sin(2*x)),xmin,xmax,dx)

%%
dy_dx1 = diff((exp(-x./5).*sin(2*x)))


%% 12-7 Approximating the integral

dx = 0.1;
xmin = 0;
xmax = 10;

x = xmin:dx:xmax;

% A simple polynomial
y = 3*x.^2 - 4*x + 10;
figure;
area(x,y);


%% A more interesting function
y = exp (-x./5) .* sin(2*x);
area(x,y);


%% 12-8  Simple approximation of the integral 
% - a bar for every interval in the range

A1 = dx*sum(y(1:end-1))


%% 12-9 The Trapezium approximation

A2 = (dx/2)*(y(1) + y(end) + 2*sum(y(2:end-1)))


%% 12-10 Passing a function as an argument

xmin = 0;
xmax = 10;
n = 100;

A = integrate (@fn1,xmin,xmax,n)

%% 12-11 Anonymous functions

A = integrate (@(x)(exp(-x./5).*sin(2*x)),xmin,xmax,100)

%%

A2 = simpson (@(x)(exp(-x./5).*sin(2*x)),xmin,xmax,100)

%%

A2 = simpson (@(x)(3*x.^2 - 4*x + 10),0,10,100)


%% 12-12 Another example
xmin = 1;
xmax = 10;

fplot(@(x)(log(x.^2 + sin(2*x))), [xmin xmax])

%%
quad(@(x)(log(x.^2 + sin(2*x))),xmin,xmax)

%%
A = integrate (@(x)(log(x.^2 + sin(2*x))), xmin, xmax, 100)

