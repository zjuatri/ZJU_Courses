nu = [5.196	5.491	6.876	7.402	8.213];
nureal = nu.*(10^14);
U = [-0.690	-0.809	-1.374	-1.590	-1.928];
nuSpace = linspace(5,9,100);
p = polyfit(nu,U,1)
USpace = polyval(p,nuSpace);
plot(nu,U,'bo',nuSpace,USpace,'b-')
ylabel('U_a/V')
xlabel('\nu/10^{14}Hz')
legend('测量值','拟合所得直线')
title('U_a-\nu关系图',FontName='黑体')