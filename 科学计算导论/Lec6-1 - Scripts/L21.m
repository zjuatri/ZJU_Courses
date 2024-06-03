% lecture 21 notes
%
%% Polynomial evaluation
p = [1 -12.1 40.59 -17.015 -71.95 35.88];
% Find f(9)
polyval(p,9)

%% Plot f(x) for -1.5<=x<=6.7
x = -1.5:0.1:6.7;
y = polyval(p,x);
plot(x, y)

%% Roots of a polynomial
p = [1 -12.1 40.59 -17.015 -71.95 35.88];
r = roots(p)

%% Find polynomial from its roots
p2 = poly(r)

%% multiplication
p1 = [1 -2 1]
p2 = [1 0 3]
p3 = conv(p1,p2)

%% division (q=common factor
p1 = [1 -2 1]
p2 = [1 -1]
[q, r] = deconv(p1,p2)

%% derivative of a polynomial 
pd = polyder(p)

%% Curve fitting with polynomials

% Data points to fit
x = [0.9 1.5 3 4 6 8 9.5];
y = [0.9 1.5 2.5 5.1 4.5 4.9 6.3];
% Try polynomials of degree 1-6
for n = [1 2 3 4 5 6]
    p = polyfit(x, y, n);
    % x values for plotting polynomial
    xp = 0.9:0.1:9.5;
    % Evaluate and plot the trial polynomial
    yp = polyval(p, xp);
    plot(x, y, 'o', xp, yp);
    axis([0, 10, 0, 9]);
    xlabel('x'); ylabel('y');
    s = sprintf('Polynomial fit degree %i', n);
    text(2,8,s,'FontSize',14);
    fprintf('Degree %i fit\n', n)
    disp(p)

    pause
end

%% Example 21-1: Fitting an equation to data points

t = 0:0.5:5;
w = [6.00 4.83 3.70 3.15 2.41 1.83 1.49 1.21 0.96 0.73 0.64];
% Try linear plot first
plot(t,w,'o')

%%
% Test exponential with log w axis
semilogy(t,w,'o')

%%
% Test reciprocal with 1/w plot
wrecip = 1./w;
plot(t, wrecip, 'o');
ylabel('1/w')

%%
% Try exponential fit using rewritten form
p = polyfit(t, log(w), 1)
% calculate m and b
m = p(1);
b = exp(p(2));
tm = 0:0.1:5;
wm = b*exp(m*tm);
plot(t, w, 'o', tm, wm); 

 
%% Example 21-2: Interpolation with three methods
x = 0:1.0:5;
y = [1.0 -0.6242 -1.4707 3.2406 -0.7366 -6.3717];
xi = 0:0.1:5;
yilin = interp1(x, y, xi, 'linear');
yispl = interp1(x, y, xi, 'spline');
yipch = interp1(x, y, xi, 'pchip');
yfun = 1.5.^xi.*cos(2*xi);
subplot(1,3,1)
plot(x, y, 'o', xi, yfun, xi, yilin, '--');
title('Linear')
subplot(1,3,2)
plot(x, y, 'o', xi, yfun, xi, yispl, '--');
title('Cubic spline')
subplot(1,3,3)
plot(x, y, 'o', xi, yfun, xi, yipch, '--');
title('Pchip')


%% Example 21-3: Thickness of a box

W = 15; gamma = 0.101;
V = W/gamma;
% First polynomial: 24-2x
a = [-2  24];
% Second polynomial: 12-2x
b = [-2  12];
% Third polynomial: 4-x
c = [-1   4];
% Mulitply the three polynomials
Vin = conv(c, conv(a, b));
% Form 3rd degree polynomial
p = [0 0 0 (V-24*12*4)] + Vin;
% Find the root
x = roots(p)
 
%% Example 21-4: Size of a capacitor

R=2000;
t = 1:10;
v = [9.4 7.31 5.15 3.55 2.81 2.04 1.26 0.97 0.74 0.58];  
p = polyfit(t, log(v), 1);
C = -1/(R*p(1))
V0 = exp(p(2))
tplot = 0:0.1:10;
vplot = V0*exp(-tplot./(R*C));
plot(t, v, 'o', tplot, vplot)
