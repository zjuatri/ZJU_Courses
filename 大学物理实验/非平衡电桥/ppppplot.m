t = [27.1	35.3	40.0	48.0	55.9	59.8	67.1	69.9];
R = [57.27	59.05	60.03	61.78	63.46	64.34	65.94	66.51];
tSpace = linspace(25,75);
p = polyfit(t,R,1)
RSpace = polyval(p,tSpace);
plot(t,R,'bo',tSpace,RSpace,'b-')
xlabel('t/℃',FontName='Times New Roman')
ylabel('R/Ω',FontName='Times New Roman')
legend('实测值','拟合直线')
title('R-t关系曲线')