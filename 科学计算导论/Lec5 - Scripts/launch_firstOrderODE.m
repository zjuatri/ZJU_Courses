% launch_firstOrderODE

clear; clc; close all

% Solve the ODE
[t,x] = ode45(@firstOrderODE,[0 10],[100]);

% Generate values for the analytical solution
tTest = linspace(0,10,20);
xTest = 100*exp(2*tTest);

plot(t,x,'r-','LineWidth',4)
hold on
plot(tTest,xTest,'k.','MarkerSize',25)
hold off
set(gca,'YScale','log')
set(gca,'FontSize',20)
xlabel('x')
ylabel('y')
legend('ODE','Analytical')


