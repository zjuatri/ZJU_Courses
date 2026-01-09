%% 初始化
clc; clear; close all;

% --- 参数设置 ---
% 修改 T 为 0.05
T = 0.05; 

%% 1. 定义传递函数
% 校正前开环 G_pre = 5 / (0.1s^2 + 0.2s)
num_pre = [5];
den_pre = [0.1, 0.2, 0];
sys_open_pre = tf(num_pre, den_pre);

% 校正后开环 G_post = 25 / (Ts^2 + s)
num_post = [25];
den_post = [T, 1, 0];
sys_open_post = tf(num_post, den_post);

%% 2. 计算闭环传递函数 (用于阶跃响应)
sys_cl_pre = feedback(sys_open_pre, 1);
sys_cl_post = feedback(sys_open_post, 1);

%% 3. 绘图 (4个独立窗口)

% --- 图1：校正前 根轨迹 ---
figure(1);
rlocus(sys_open_pre);
title('图1: 校正前 根轨迹');
grid on;

% --- 图2：校正后 根轨迹 ---
figure(2);
rlocus(sys_open_post);
title(['图2: 校正后 根轨迹 (T=', num2str(T), ')']);
grid on;

% --- 图3：校正前 闭环阶跃响应 ---
figure(3);
step(sys_cl_pre);
title('图3: 校正前 闭环阶跃响应');
grid on;

% --- 图4：校正后 闭环阶跃响应 ---
figure(4);
step(sys_cl_post);
title(['图4: 校正后 闭环阶跃响应 (T=', num2str(T), ')']);
grid on;
xlim([0 6]); % 限制 x 轴范围为 1 到 6