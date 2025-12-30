% 1. 定义传递函数
% 分子系数 num = 1
% 分母是两个多项式的乘积：(0.1s + 1) * (0.2s + 1)
% 使用 conv 函数进行多项式乘法（卷积）

num = 1;
den1 = [0.2, 1]; % 对应 0.1s + 1
den2 = [0.2, 1]; % 对应 0.2s + 1
den = conv(den1, den2); % 计算分母展开后的系数

% 创建传递函数对象
sys = tf(num, den);

% 2. 绘制伯德图 (Bode Plot)
figure(1);          % 打开第一个绘图窗口
bode(sys);          % 绘制伯德图
grid on;            % 显示网格
title('伯德图'); 

% 3. 绘制乃氏图 (Nyquist Plot)
figure(2);          % 打开第二个绘图窗口
nyquist(sys);       % 绘制乃氏图
grid on;            % 显示网格
title('乃氏图');