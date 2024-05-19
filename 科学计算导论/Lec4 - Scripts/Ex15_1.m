% Example 15-1: Piston and Crank Mechanism
%
THDrpm=500; r=0.12; c=0.25;
% Change units to radians/sec
THD = THDrpm*2*pi/60;
% Time for one revolution of the crank
tf = 2*pi/THD;
% Time step vector with 200 elements
t = linspace(0, tf, 200);
% Theta for each t
TH = THD*t;
% Distance d2 squared for each t
d2s = c^2-r^2*sin(TH).^2;
% Calculate x substituting d2s
x = r*cos(TH) + sqrt(d2s);
% Calculate the velocity substituting d2s
xd = -r*THD*sin(TH) - (r^2*THD*sin(2*TH))./(2*sqrt(d2s));
% Calculate the acceleration
xdd = -r*THD^2*cos(TH) - (4*r^2*THD^2*cos(2*TH).*d2s +...
    (r^2*sin(2*TH)*THD).^2)./(4*d2s.^(3/2));
% Use subplot command to get multiple plots in one window
subplot(3, 1, 1)
% Plot position x vs. t
plot(t, x)
grid
xlabel('Time (sec)')
ylabel('Position (m)')
% Plot velocity cd vs. t
subplot(3, 1, 2)
plot(t, xd)
grid
xlabel('Time (sec)')
ylabel('Velocity (m/sec)')
% Plot acceleration vs. t
subplot(3, 1, 3)
plot(t, xdd)
grid
xlabel('Time (sec)')
ylabel('Acceleration (m/sec^2)')
