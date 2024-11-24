% 准备数据 
Ix = linspace(0.1,1)
y1 = 5*Ix;
Ig=[0.18 0.36 0.61 0.8 0.98];
I = [0.9 1.8 3 3.8 4.8];
deltaI = [0.00 0 0.05 -0.2 -0.2];

% 创建图形窗口
figure;

% 绘制第一个Y轴的数据
yyaxis left;
plot(Ig, I, 'bo',Ix,y1,'b-'); 
ylabel('I_{标准}/mA');



% 绘制第二个Y轴的数据
yyaxis right;
plot(Ig, deltaI, '--b^'); % '-r' 表示红色线条
ylabel('\Delta I/mA');
legend('电流标准值','改装电流表示数','改装电流表校准曲线')

% 设置其他图形属性
xlabel('I_g/mA');
title('改装电流表对应真实电流和校准曲线');
