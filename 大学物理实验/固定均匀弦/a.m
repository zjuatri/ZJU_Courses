m = [0 496 997 1509 2023 2540 3041 3572];
g = 9.7936;

x = lambda.^2/m/g;
p = polyfit(x,y,1);
xSpace = linspace(180,440);
yVal = polyval(p,xSpace);
plot(x,y,'o',xSpace,yVal,'r-')
xlim([150 450]);
xlabel('\lambda^2/mg [m^2/N]');
ylabel('1/f^2 [s^2]');
title('\lambda^2/mg-1/f^2关系图')
