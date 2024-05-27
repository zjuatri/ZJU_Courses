% lorenz_launcher

clear; clc; close all

% Lorenz's strange attractor

% Intitial conditions (x1, x2, x3)
x0 = [-8 8 27];

% Time span
tspan = [0 200];

% Using the ode45 solver to numerically evalute the ODEs
[t,x] = ode45('lorenz',tspan,x0);

% Getting the bounds of the x/y/z values
xMin = min(x(:,1)); xMax = max(x(:,1));
yMin = min(x(:,2)); yMax = max(x(:,2));
zMin = min(x(:,3)); zMax = max(x(:,3));

% Initializing a figure window
figure('Position',[15 50 1250 650])

% A 3d plot of the solution
subplot(3,2,1:4)
ph1 = plot3(x(1:2,1),x(1:2,2),...
    x(1:2,3),'k.-','MarkerSize',5);
axis([xMin xMax yMin yMax zMin zMax])
view([-13 22])

% Plot a view along the x-y axes
subplot(3,2,5)
ph2 = plot3(x(1:2,1),x(1:2,2),...
    x(1:2,3),'k.-','MarkerSize',5);
axis([xMin xMax yMin yMax zMin zMax])
view([0 90])

% Plot a view along the x-z axes
subplot(3,2,6)
ph3 = plot3(x(1:2,1),x(1:2,2),...
    x(1:2,3),'k.-','MarkerSize',5);
axis([xMin xMax yMin yMax zMin zMax])
view([0 0])

pauseFac = 0.0001;
modFac = 10;

winSize = 200;

% Animating the plot
for jj = 3:length(x)
    if mod(jj,modFac) == 1
        pause(sum(t(jj-modFac:jj))*pauseFac)
        if jj<winSize+1
            begInd = 1;
        else
            begInd = jj-winSize;
        end
        set(ph1,'XData',x(begInd:jj,1),'YData',...
            x(begInd:jj,2),'ZData',x(begInd:jj,3))
        set(ph2,'XData',x(begInd:jj,1),'YData',...
            x(begInd:jj,2),'ZData',x(begInd:jj,3))
        set(ph3,'XData',x(begInd:jj,1),'YData',...
            x(begInd:jj,2),'ZData',x(begInd:jj,3))
    end
end
