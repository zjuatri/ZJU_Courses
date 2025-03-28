function msd_water(c,k,m,yi,vi,t_beg,t_end)
M=[];
T=[];
Y=[];
y = [yi vi];

    function dy = msd(t,y,c,k,m)
        dy1 = y(2);
        dy2 = -c/m*y(2) - k/m*y(1);
        dy = [dy1;dy2];
    end

for i = 1:size(m,2)
    [t,y]=ode45(@(t,y) msd(t,y,c,k,m(i)),[t_beg,t_end],[yi;vi]);
    for j = 1:size(t,1)
        M(end+1) = m(i);
        T(end+1) = t(j);
        Y(end+1) = y(j,1);
    end
    plot3(T,M,Y,'k-');
    hold on;
    T=[];
    M=[];
    Y=[];
    xlabel('Time(s)')
    ylabel('Mass(kg)')
    zlabel('Position(m)')
end
view(-15,30)
end
