% Lecture 28 script

%% regular system

A = [20 15 10; -3 -2.249 7; 5 1 3]
b = [45 1.751 9]'
x = A\b
%% check on the equation

norm (b - A*x)
%% overconstrianed system

A=[1 -1; 0 1; 1 0]
b = [0 2 1]'

x=A\b
%% check on the equation
norm (b - A*x)

%% Least squares solutions

A = [1 0; 0 1; 0 0]
b = [3; 2; 1]

x = A \ b
norm (b - A*x)

%% Another 3x2 system
A = [1 2; 3 5; 2 -4];
b = [3; 2; 1];

x = A \ b

norm (b - A*x)

%% Fitting a straight line 

fat      = [9 13 21 30 31 31 34 25 28 20 5];
calories = [260 320 420 530 560 550 590 500 560 440 300];

figure;

plot (fat, calories, 'b.');

%% least squares fit
A = [fat' ones(length(fat),1)]
x = A \ calories'

hold on;
fplot (@(t) x(1)*t+x(2), [5 30],'r');

%%
mean (abs(A * x - calories'))

%% Fitting a quadratic

Height = [1.47 1.5 1.52 1.55 1.57 1.60 1.63 1.65 1.68 1.7 1.73 1.75 1.78 1.8 1.83]';
Weight = [52.21 53.12 54.48 55.84 57.2 58.57 59.93 61.29 63.11 64.47 66.28 68.1 69.92 72.19 74.46]';

figure; 

plot (Height, Weight, 'b.');

%% Quadratic model

A = [Height.^2 Height ones(length(Height),1)];
x = A \ Weight;

hold on;
fplot (@(t) x(1)*t^2+x(2)*t+x(3), [1.45 1.85],'r');

mean (abs(A * x - Height))

%% Fitting, you name it

theta = [0:0.1:2*pi]';

y = 3*sin(theta) + 5*cos(theta);

y = y + 1.0*(rand(size(y)) - 0.5);

figure;

plot (theta, y, 'b.');

A = [sin(theta) cos(theta)];

x = A \ y
% compare with the exact value x(1)=3, x(2)=5

hold on;
fplot (@(t)(x(1)*sin(t) + x(2)*cos(t)), [0 2*pi]);

mean (abs(A * x - y))

%% one more example

t = [0 .3 .8 1.1 1.6 2.3]';
y = [.82 .72 .63 .60 .55 .50]';

plot (t, y, 'b.');

A = [ones(size(t)) exp(-t)]
x = A\y

T = (0:0.1:2.5)';
Y = [ones(size(T)) exp(-T)]*x;
plot(T,Y,'-',t,y,'o')