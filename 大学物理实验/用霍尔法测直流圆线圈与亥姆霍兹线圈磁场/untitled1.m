mu = 4*pi*10^(-7);
N=400;
I=0.4;
R=0.1;
x = linspace(-5,5,100);
b = (mu*N*I*(R^2)/2)./((x./100).^2 + R^2).^(3/2) * 10^6;
X=[5.00	4.00	3.00	2.00	1.00	0.00	-1.00	-2.00	-3.00	-4.00	-5.00];
B=[703	786	862	925	972	981	957	914	845	773	691];
plot(X,B,'ro',x,b,'b-');
xlabel('X/cm',FontName="Times New Roman",FontAngle="italic");
ylabel('B/\mu T',FontName="Times New Roman",FontAngle="italic");
title('载流圆线圈轴线上磁场的分布','FontName','黑体');
x = 5;
B = (mu*N*I*(R^2)/2)/((x/100)^2 + R^2)^(3/2) * 10^6
legend('实测值','理论值',fontname='黑体')