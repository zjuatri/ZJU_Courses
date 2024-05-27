% launch_thirdOrderODE

clear; clc; close all

p = 2;
q = 1.5;
r = 0.1;

[t,x] = ode45(@thirdOrderODE,[0 10],[10 1 2],[],p,q,r);

p = plot(t,x(:,1),'k-',t,x(:,2),'b-',t,x(:,3),'r-');
set(p,'LineWidth',4)
set(gca,'FontSize',16)
xlabel('t (s)')
ylabel('pos. (m), vel. (m/s), acc. (m/s^2)')
legend('Position','Velocity','Acceleration','Location','Best')