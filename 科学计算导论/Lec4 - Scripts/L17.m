% Lecture 17 script

%% 17-1: Properties with get and set

% Plot the sample data and retrieve the handle
x = 0:0.1:2;
y = x.^2;
handl = plot(x, y);

%%
% Display the properties of the plotted line
% result is a structure array
result = get(handl)

%%
% Change the width and style
set(handl, 'Linewidth', 4, 'LineStyle', '--')

%% Get all possible property values
set(handl, 'LineStyle')

%% Get all possible properties 
prop = set(handl)

%% and property values
prop.LineStyle



%% Ex17-1: Customizing a plot

clear; clf('reset')

%%
% Calculate the data points
x = -3*pi:pi/10:3*pi;
y = sin(x)./x
plot(x, y);

%%
% Find the zero value at the middle of the array
index = fix(length(y)/2) + 1;
y(index) = 1;

% Plot the function
hndl = plot(x, y);

%%
% Now modify the figure using built-in functions
%   gcf     handle of current figure
%   gca     handle of axes in current figure

% (1) pink background
set(gcf, 'Color', [1 0.8 0.8]);
%%
set(gca, 'Color', [1 0.5 0.5]);

%%
% (2) turn on y-axis grid lines
set(gca, 'YGrid', 'on');

%%
% (3) change line to 2-point orange
set(hndl, 'Color', [1 0.5 0], 'LineWidth', 2);



%% Ex17-2: Selecting graphics objects

clear; clf('reset')
x = -3*pi:pi/10:3*pi;
y1 = sin(x);
y2 = cos(x);

%Plot the functions
h1 = plot(x, y1);
%%
set(h1, 'LineWidth', 2);
%%
hold on;
h2 = plot(x, y2);
%%
set(h2, 'LineWidth', 2, 'LineStyle', ':', 'Color', 'r');
%%
title('Plot of sin and cos');
xlabel('x');
ylabel('sin and cos');
legend('sine', 'cosine');
hold off

%%

k = waitforbuttonpress;

while k==0
    % Get object handle
    handle = gco;
    
    % Get object type
    type = get(handle, 'Type');
    
    % Display object type
    disp(['Object type = ' type '.']);
    
    % Diplay details?
    yn = input('Do you want to display the details? (y/n) ', 's');
    if yn == 'y'
        details = get(handle);
        disp(details);
    end
    
    % Check for another mouse click
    k = waitforbuttonpress;
end



%% 17-2: Position and units

clear; clf('reset')

% Plot a figure
x = -3*pi:pi/10:3*pi;
y = sin(x);
plot(x, y)
%%
get(gcf, 'Position')
%%
get(gcf, 'Units')



%% Ex 17-3: Positioning Objects
clear; clf('reset')
x = -3*pi:pi/10:3*pi;
y1 = sin(x);
y2 = cos(x);

% Create a new figure
figure;

%% Create first set of axes for sin(x) using
% normalized units
ha1 = axes('Position', [.05  .05  .5  .5]);
h1 = plot(x, y1);
set(h1, 'LineWidth', 2);
title('Plot of sin x');
xlabel('x');
ylabel('sin x');
axis([-8 8 -1 1]);

%%
% Create the second set of axes for cos(x)
ha2 = axes('Position', [.45  .45  .5  .5]);
h1 = plot(x, y2);
set(h1, 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
title('Plot of cos x');
xlabel('x');
ylabel('sin x');
axis([-8 8 -1 1]);

%%
% Add the text string to sin(x)
axes(ha1);
text(-pi, 0.0, 'sin(x)\rightarrow', 'HorizontalAlignment', 'right');

%%
% Add the text string to cox(x)
axes(ha2);
text(-7.5, -0.9, 'Test string 2');



%% Ex 17-4: Animation with handle graphics
clear; clf('reset')

% Create a plot and save a handle
h = plot (rand(1,20), 'b.-');

%% Change the values in the plot using the handle
set (h, 'YData', rand(1,20));

%% 17-5 Moving point

figure;

% Create a plot and save a handle
h = plot (0, 0, 'b.-');
axis ([-1 1 -1 1]);

% Show the plot properties
get (h);

for (i = 1:500)
    x = sin (4*pi*i/500);
    y = cos (4*pi*i/500);
    
    set (h, 'XData', x);
    set (h, 'YData', y);
    pause (0.01);
end

%% another example

clear; clf('reset')
x = 0; y = 0;
dx = pi/40;
% EraseMode = xor means show only current point
% Plots just the first data point
p = plot(x, y, 'o');
axis([0 20*pi -2 2])

% Repeated calls set to plot next point
for x = dx:dx:20*pi
    x = x + dx;
    y = sin(x);
    set(p, 'XData', x, 'YData', y)
    drawnow
end

%% more

lorenz

