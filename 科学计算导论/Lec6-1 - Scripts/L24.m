% Lecture 24 notes
%
%% Setting up the polynomial and Plot the function

c = poly([-1 2 3 7 8])
df_dx = polyder(c)

fplot (@(x)(polyval(c,x)), [-1.5 9])
grid on


%% Testing the bisection method
bisectionMethod(@(x)(polyval(c,x)), [4 7.5], 1e-6)

%%
bisectionMethod(@(x)(polyval(c,x)), [0 2.5], 1e-6)

%%
bisectionMethod(@(x)(polyval(c,x)), [-3 0], 1e-6)



%% Testing Newton's method
c = poly([-1 2 3 7 8])
NewtonsMethod (@(x)(polyval(c,x)), @(x)(polyval(df_dx,x)), 6, 1e-6)

%%
NewtonsMethod (@(x)(polyval(c,x)), @(x)(polyval(df_dx,x)), 2.5, 1e-6)


%%
NewtonsMethod (@(x)(polyval(c,x)), @(x)(polyval(df_dx,x)), 1, 1e-6)


%% Using fzero function

% Initial plot for estimate
fplot('x*exp(-x)-0.2', [0 8])
grid on

%% Find the solution between 0 and 1, guess 0.3
x1 = fzero('x*exp(-x)-0.2', 0.3)


%% Find the second solution between 2 and 3
% Define an anonymous function F
F = @(x) x*exp(-x)-0.2
fzero(F, 2.5)


%% What if there is no solution?
fzero('x^2+1', 1)



%% Solving for the launch angle that will hit the target 200 meters away

h = plot (0, 0, 'bo', 'MarkerSize', 5);
axis ([0 250 0 70]);

bracket = bisectionMethod (@(x)(ArtillerySimulation(x,50,0.01,0.01, h) - 200), [20 40], 1e-1);

%% Testing the Golden Section Method
c = poly([-1 2 3 7 8])
fplot (@(x)(polyval(c,x)), [-1.5 9])

x = GoldenSectionSearch (@(x)(polyval(c,x)), [1 4], 1e-5);
fprintf('x1=%f10  x3=%f10\n',x(1),x(2))


%% Applying the Golden Section Method to find the lowest point on the trajectory

fplot (@(t)(sqrt( (-3 + 10*cos(t))^2 + (2 + 5*sin(t))^2) ), [0 2*pi]);

GoldenSectionSearch (@(t)(sqrt( (-3 + 10*cos(t))^2 + (2 + 5*sin(t))^2) ), [3 6], 1e-5)


%% Find the choice of firing angle that makes the shell go the furthest
%% 1st try (not working!)

fplot (@(x)(ArtillerySimulation(x,50,0.1,0.01, 0)), [10 80]);

GoldenSectionSearch (@(x)(ArtillerySimulation(x,50,0.1,0.01, 0)), [10 80], 1e-3)

%% better one!

fplot (@(x)(-ArtillerySimulation(x,50,0.1,0.01, 0)), [10 80]);

GoldenSectionSearch (@(x)(-ArtillerySimulation(x,50,0.1,0.01, 0)), [10 80], 1e-3)


%% Minima and maxima with fminbnd

% Plot the function
F = @ (x) x^3 - 12*x^2 + 40.25*x - 36.5
fplot(F, [0 8])
grid on

%%
% Find the minimum between 5 and 6
[x fval] = fminbnd(F, 5, 6)

%%
% Change interval to 0 to 8
[x fval] = fminbnd(F, 0, 8)

%%
% Change interval to 0 to 1
[x fval] = fminbnd(F, 0, 1)

%%
% Find maxima by multiplying function by -1
% and finding minima
F2 = @ (x) -F(x)
[x fval] = fminbnd(F2, 0, 8)


%% Example: Maximum viewing angle

% Do an initial plot
fplot('((x^2+5^2)+(x^2+41^2)-36^2)/(2*sqrt(x^2+5^2)*sqrt(x^2+41^2))', [0 25])
xlabel('x'); ylabel('cos(\theta)');

%%
% Find the minimum
[x anglecos] = fminbnd('((x^2+5^2)+(x^2+41^2)-36^2)/(2*sqrt(x^2+5^2)*sqrt(x^2+41^2))', 10, 20)
angle = acosd(anglecos)

