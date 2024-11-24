% 准备数据 
Ix = linspace(0.1,1)
y1 = 5*Ix;
Ig=[0.16	0.38	0.58	0.84	1.00];
I = [0.80	1.80	2.80	3.90	4.90];
deltaI = [0.00	-0.10	-0.10	-0.30	-0.10];

% 创建图形窗口
figure;

% 绘制第一个Y轴的数据
yyaxis left;
plot(Ig, I, 'bo',Ix,y1,'b-'); 
ylabel('V_{标准}/V');



% 绘制第二个Y轴的数据
yyaxis right;
plot(Ig, deltaI, '--b^'); % '-r' 表示红色线条
ylabel('\Delta V/V');
ylim([-0.4,0.1])
legend('电压标准值','改装电压表示数','改装电压表校准曲线')

% 设置其他图形属性
xlabel('I_g/mA');
title('改装电压表对应真实电压和校准曲线');
