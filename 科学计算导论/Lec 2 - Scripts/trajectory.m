function [hmax, dmax] = trajectory(v0, theta)
% trajectory calculates the max height and distance of a 
% projectile and plots its trajectory
% Example 11-2
% Input arguments:
%   v0       Initial velocity in m/s
%   theta    Angel in degrees
% Output arguments:
%   hmax     Maximum height in m
%   dmax     Maximum distance in m

g = 9.81;
% Calculate the components of the velocity
v0x = v0*cos(theta*pi/180);
v0y = v0*sin(theta*pi/180);
% Find the time at maximum altitude
thmax = v0y/g;
% Calculate maximum altitude
hmax = v0y^2/(2*g);
% Calculate total flight time
ttot = 2*thmax;
% Calcualte maximum distance
dmax = v0x*ttot;
% Plot the trajectory
% Time vector with 200 points
tplot = linspace(0, ttot, 200);
% Calculate x and y coordinates for the projectile
x = v0x*tplot;
y = v0y*tplot - 0.5*g*tplot.^2;
plot(x, y)
xlabel('Distance (m)')
ylabel('Height (m)')
title('Projectile Trajectory')