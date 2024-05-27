% Lecture 20
%
%% ODE solver ode45
dydt = @ (t,y) (t^3-2*y)/t
[t y] = ode45(dydt, [1:0.5:3], 4.2)
plot(t, y)


%% Solve again with smaller spacing for the plot
[t y] = ode45(dydt, [1:0.01:3], 4.2);
hold on
plot(t, y,'r')
xlabel('t'); ylabel('y')


%% Example 20-1: Car crash and safety bumper

K = 30; m = 1500; v0 = 25;
dvdx = @ (x,v) -(K*v^2*(x + 1)^3)/m
% Vector to define the interval of solution
xspan = [0:0.2:3];

% Solve the ODE
[x v] = ode45(dvdx, xspan, v0)
plot(x, v)
xlabel('x (m)'); ylabel('Velocity (m/s)')


%%  Random numbers
a = rand(1,4)
b = rand(3)
c = rand(2,4)


%%

randperm(8)

%%

d = randn(3,4)


%% 10 elements between -5 and 10
v = (10-(-5))*rand(1,10)-5

%% 2x15 matrix of random integers between 1 and 100
A = round(99*rand(2,15)+1)

%% 15 integers with mean 50 and std dev of 5
v = round(5*randn(1,15)+50)


%% rand0 and seed
seed(0.5)
rand0(2,3)

%%
rand0(2,3)

%% rand0 and seed
seed(0.5)
rand0(2,3)