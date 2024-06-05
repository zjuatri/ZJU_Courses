t.raw=[0, 1, 2.5, 5.0, 10.5, 12.5, 16, 20.5, 26.5, 30.5, 32];
x.raw=[0, 0.3, 1.2, 1.3, 1.6, 2.2, 2.4, 3.0, 3.6, 4.5, 4.6];
x.interp.linear=interp1(t.raw,x.raw, linspace(0,32,100), 'linear');
t.interp.linear=linspace(0,32,100);
dt = 32/100;
for i = 2:length(x.interp.linear)
dx.interp.linear(i-1) = (x.interp.linear(i) - x.interp.linear(i-1))/dt;
end

for i = 2:length(dx.interp.linear)
ddx.interp.linear(i-1) = (dx.interp.linear(i) - dx.interp.linear(i-1))/dt;
end

axes('Position',[.1 .1 .8 .25])
plot(t.interp.linear(3:100),ddx.interp.linear);
xlim([0 max(t.raw)])
ylim([-2 1])
xlabel('Time(s)')
ylabel('d^2x/dt^2(m/s^2)')

axes('Position',[.1 .4 .8 .25])
plot(t.interp.linear(2:100),dx.interp.linear);
xlim([0 max(t.raw)])
xticklabels({})
ylim([0 1])
ylabel('dx/dt(m/s)')

axes('Position',[.1 .7 .8 .25])
plot(t.interp.linear,x.interp.linear)
hold on
plot(t.raw, x.raw, 'o', 'MarkerSize', 5);
xlim([0 max(t.raw)])
xticklabels({})
ylim([0 6])
ylabel('x(m)')

pause(5)
clc

x.interp.spline=interp1(t.raw,x.raw, linspace(0,32,100), 'spline');
t.interp.spline=linspace(0,32,100);
dt = 32/100;
for i = 2:length(x.interp.spline)
dx.interp.spline(i-1) = (x.interp.spline(i) - x.interp.spline(i-1))/dt;
end

for i = 2:length(dx.interp.spline)
ddx.interp.spline(i-1) = (dx.interp.spline(i) - dx.interp.spline(i-1))/dt;
end

axes('Position',[.1 .1 .8 .25])
plot(t.interp.spline(3:100),ddx.interp.spline);
xlim([0 max(t.raw)])
ylim([-1 1])
xlabel('Time(s)')
ylabel('d^2x/dt^2(m/s^2)')

axes('Position',[.1 .4 .8 .25])
plot(t.interp.spline(2:100),dx.interp.spline);
xlim([0 max(t.raw)])
xticklabels({})
ylim([-0.5 1])
ylabel('dx/dt(m/s)')

axes('Position',[.1 .7 .8 .25])
plot(t.interp.spline,x.interp.spline)
hold on
plot(t.raw, x.raw, 'o', 'MarkerSize', 5);
xlim([0 max(t.raw)])
xticklabels({})
ylim([0 6])
ylabel('x(m)')