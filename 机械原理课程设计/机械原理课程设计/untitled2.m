theta = asin(50/(520+154.21));
theta0 = theta+3/180*pi;
theta0 = pi/2-theta0 ;
theta3 = crank_rocker(pi-theta0,100,100,116,37);
a = 180-theta3*180/pi;
function theta3= crank_rocker(theta1,l1,l2,l3,l4)
    %计算角位移
    L = sqrt(l4*l4+l1*l1-2*l1*l4*cos(theta1));
    phi = asin((l1./L)*sin(theta1)); %phi 记录直线BD到AD的角
    if l1>L  %l1为最长边时phi为钝角
        phi = pi/2-phi;
    end
    beta = acos((-l2*l2+l3*l3+L*L)/(2*l3*L)); %beta 记录直线CD到BD的角
    if theta1 > pi
        phi = -phi;
    end
    theta3 = pi - phi -beta;
end
