function [x,y] = basketball(g,c,x0,y0,vx0,vy0,tstep,tmax)
t = 0;
x=[x0];
y=[y0];
vx=[vx0];
vy=[vy0];
while t <tmax
    if t + tstep <= tmax
        ax = -c*vx(end)*sqrt(vx(end)^2 + vy(end)^2);
        ay = -g-c*vy(end)*sqrt(vx(end)^2 + vy(end)^2);
        vx(end+1) = vx(end) + ax*tstep;
        vy(end+1) = vy(end) + ay*tstep;
        x(end+1) = x(end) + vx(end)*tstep;
        y(end+1) = y(end) + vy(end)*tstep;
        t = t + tstep;
    else
        % if t + tstep < tmax, make the time of the last point tmax.
        tstep = tmax - t;
        ax = -c*vx(end)*sqrt(vx(end)^2 + vy(end)^2);
        ay = -g-c*vy(end)*sqrt(vx(end)^2 + vy(end)^2);
        vx(end+1) = vx(end) + ax*tstep;
        vy(end+1) = vy(end) + ay*tstep;
        x(end+1) = x(end) + vx(end)*tstep;
        y(end+1) = y(end) + vy(end)*tstep;
        t = t + tstep;
    end
end
end