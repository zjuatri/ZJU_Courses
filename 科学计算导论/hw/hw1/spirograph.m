function spirograph(R,r,d)
    theta = 0:0.001:10*pi;
    x = (R+r)*cos(theta)+d*cos((R+r)/r*theta);
    y = (R+r)*sin(theta)-d*sin((R+r)/r*theta);
    plot(x,y)