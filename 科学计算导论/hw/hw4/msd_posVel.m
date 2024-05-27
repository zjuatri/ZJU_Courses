function msd_posVel(c,k,m,yi,vi,t_beg,t_end)
y = [yi vi];
    function dy = msd(t,y,c,k,m)
        dy1 = y(2);
        dy2 = -c/m*y(2) - k/m*y(1); 
        dy = [dy1;dy2];
    end
[t,y]=ode45(@(t,y) msd(t,y,c,k,m),[t_beg,t_end],[yi;vi]);
yyaxis left
plot(t,y(:,1),'b-','LineWidth',3)
ylabel('Position(m)')
ylim([-20 30])

yyaxis right
plot(t,y(:,2),'r-','LineWidth',3)
ylabel('Velocity(m/s)')
ylim([-4 6])
xlabel('Time(sec)')
end