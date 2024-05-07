function spirograph(R,r,d)
    theta = 0:0.001:10*pi;
    x = (R+r)*sin(theta)+d*cos((R+r)/r*theta);
    y = (R+r)*sin(theta)+d*cos((R+r)/r*theta);
    plot(x,y)