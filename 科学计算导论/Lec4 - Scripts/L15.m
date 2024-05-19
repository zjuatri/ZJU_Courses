% script for lecture 15
%
%% 15-1: Plot command
x = [1 2 3 5 7 7.5 8 10]
y = [2 6.5 7 7 5.5 4 6 8]
plot (x,y)

%%
% Line specifiers
% Red line
plot(x,y,'r')

%% Cyan dashed line
plot(x,y,'--c')
%% 

%% Point marker '*' and no line
plot(x,y,'*')

%% Green dotted line with diamonds
plot(x,y,'g:d')


%% Properties
% Magenta line, circle markers, 2pt line width,
% 12 point circle with green edges and yellow filling
% Note case of property names
plot(x,y,'-mo','LineWidth',2,'markersize',12,...
    'MarkerEdgeColor','g','markerfacecolor','y')


%% 15-2: Plotting functions
%
x = [-2:0.01:4];
y = 3.5.^(-0.5*x).*cos(6*x);
plot(x,y)

%% Try again with coarser spacing
x = [-2:0.3:4];
y = 3.5.^(-0.5*x).*cos(6*x); 
plot(x,y)

%% Using fplot command
fplot('x^2+4*sin(2*x)-1',[-3 3])


%% 15-3: Multiple plots
%
x = [-2:0.01:4];
y = 3*x.^3-26*x+6;
yd = 9*x.^2-26;
ydd = 18*x;
% Plot with default colors
plot(x,y,x,yd,x,ydd)


%% Choose colors and line styles
plot(x,y,'-b',x,yd,'--r',x,ydd,':k')
 

%% 15-4: Multiple plots with hold command
%
x = [-2:0.01:4];
y = 3*x.^3-26*x+6;
yd = 9*x.^2-26;
ydd = 18*x;
% Plot first graph: y
plot(x,y,'-b')

% Prepare for multiple plots
%%
hold on

%%
plot(x,yd,'--r')
plot(x,ydd,':k')
% Finish
%%
hold off

%% 15-5: Multiple plots with line command
%
x = [-2:0.01:4];
y = 3*x.^3-26*x+6;
yd = 9*x.^2-26;
ydd = 18*x;
% Plot first graph: y
plot(x,y,'LineStyle','-', 'color', 'b')

%% Add other plots
line(x,yd,'LineStyle','--', 'color', 'r')
%%
line(x,ydd,'LineStyle',':', 'color', 'k')


%% 15-6: Formatting plots with commands
% Light intensity experiment
x = [10:0.1:22];
y = 95000./x.^2;
xd = [10:2:22];
yd = [950 640 460 340 250 180 140];
% Plot the theoretical results
plot(x,y,'-','LineWidth',1.0)

%%
xlabel('DISTANCE (cm)')

%%
ylabel('INTENSITY (lux)')

%%
title('\fontname{Arial}Light Intensity as a Function of Distance', 'FontSize', 14)

%%
axis([8 24 0 1200])
text(14,700,'Comparison between theory and experiment', 'EdgeColor','r','LineWidth',2)

%%
hold on

%%
plot(xd,yd, 'ro--','linewidth',1.0,'markersize',10)
legend('Theory', 'Experiment', 0)
%%
grid on
%%
hold off

%% 15-7: Logarithmic plots
%
x = linspace(0.1,60,1000);
y = 2.^(-0.2*x+10);
% Linear scale plot
plot(x, y)


%% y axis logarithmic, x axis linear
semilogy(x, y)


%% x axis logarithmic, y axis linear
semilogx(x, y)

%% Both axes logarithmic
loglog(x, y)


%% 15-8: Plots with error bars
%
xd = [10:2:22];
yd = [950 640 460 340 250 180 140];
ydErr = [30 20 18 35 20 30 10];
errorbar(xd, yd, ydErr)
xlabel('DISTANCE (cm)')
ylabel('INTENSITY (lux)')


%% 15-9: Special plots
%
% Vertical bar plot
yr = [1988:1994];
sales = [8 12 20 22 18 24 27];
bar(yr, sales, 'r')
xlabel('Year')
ylabel('Sales (millions)')

%%
% Horizontal bar plot
barh(yr, sales)
xlabel('Sales (millions)')
ylabel('Year')

%%
% Stairs plot
stairs(yr, sales)


%%
% Pie charts
grades = [11 18 26 9 5];
pie(grades)
legend('A', 'B', 'C', 'D', 'F', 0)
title('Class grades')

%% Polar plot
t = linspace(0,2*pi,200);
r = 3*cos(0.5*t).^2+t;
polar(t, r)


%% 15-10: Histograms
%
% Daily max temperatures in Washington, DC for April, 2002
y = [58 73 73 53 50 48 56 73 73 66 69 63 74 82 84 91 93 89 91 80 59 69 56 64 63 66 64 74 63 69];
hist(y)

%%
% Notes:
% Smallest value is 48 and largest is 93
% Range is 45, so each bin width is 4.5
% First bin is 48-52.5 (two data points)
% Second bin is 52.5-57 (three data points)
% Two bins contain no data points

% Specify number of bins
hist(y, 3)


%%
% Specify bin centers
x = [45:10:95]
hist(y, x)

%% 15-11: Multiple figure windows
%
close all
fplot('x*cos(x)', [0,10])

%%
figure
fplot('exp(-0.2*x)*cos(x)', [0,10])

%%
close all

%% 15-12: subplot
subplot(2,2,1)
fplot('x*cos(x)', [0,10])

%%
subplot(2,2,2)
yr = [1988:1994];
sales = [8 12 20 22 18 24 27];
bar(yr, sales, 'r')
xlabel('Year')
ylabel('Sales (millions)')

%%
subplot(2,2,3)
grades = [11 18 26 9 5]
pie(grades)
legend('A', 'B', 'C', 'D', 'F', 0)

%%
subplot(2,2,4)
t = linspace(0,2*pi,200);
r = 3*cos(0.5*t).^2+t;
polar(t, r)