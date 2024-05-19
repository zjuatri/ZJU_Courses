clear; clc; close all

x = linspace(-2*pi,2*pi,100);
y = x;
[X,Y] = meshgrid(x,y);
Z = sin(X)+cos(Y);
h = surface(Z);
shading interp
axis off
set(gcf,'Color','w')
 
for jj = 1:1000
    pause(0.05)
    Z = sin(X+jj*pi/100) + cos(Y+jj*pi/100);
    set(h,'CData',Z)
end
