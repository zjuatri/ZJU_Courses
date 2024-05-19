clear; clc; close all

x = 0:pi/100:2*pi;
y = sin(x);
 
p1 = plot(x,y,'k-','LineWidth',3);
axis tight
 
for jj = 1:1000
    pause(0.01)
    y = sin(x+jj*pi/100);
    set(p1,'XData',x,'YData',y)
end
