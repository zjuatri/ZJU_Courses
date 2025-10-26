clear; clc; close all;

% --- 定义三个传递函数 ---

% (1) G(s) = 1 / ((s+1)(2s+1))
G1_num = [1];
G1_den = conv([1 1], [2 1]); 
G1 = tf(G1_num, G1_den);

% (2) G(s) = 1 / (s^2(s+1)(2s+1))
G2_num = [1];
G2_den = conv([1 0 0], G1_den);
G2 = tf(G2_num, G2_den);

% (3) G(s) = (0.2s+1)(0.025s+1) / (s^2(0.005s+1)(0.001s+1))
G3_num = conv([0.2 1], [0.025 1]);
G3_den_poles = conv([0.005 1], [0.001 1]);
G3_den = conv([1 0 0], G3_den_poles);
G3 = tf(G3_num, G3_den);


% --- 绘制在三个独立的 Figure 窗口中 ---

% (1) 绘制 G1(s)
figure('Name', 'Problem 4-15 (1)', 'NumberTitle', 'off');
nyquist(G1);
title('(1) $G(s) = \frac{1}{(s+1)(2s+1)}$', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
% 默认坐标轴

% (2) 绘制 G2(s)
figure('Name', 'Problem 4-15 (2) - 局部放大', 'NumberTitle', 'off');
nyquist(G2);
title('(2) $G(s) = \frac{1}{s^2(s+1)(2s+1)}$  ', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
% 保持对 G2 的放大
axis([-2 1 -1 2]); 

% (3) 绘制 G3(s)
figure('Name', 'Problem 4-15 (3) - 极大放大', 'NumberTitle', 'off');
nyquist(G3);
title('(3) $G(s) = \frac{(0.2s+1)(0.025s+1)}{s^2(0.005s+1)(0.001s+1)}$  ', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
% **使用新的、极度放大的坐标轴范围**
axis([-0.05 0.02 -0.03 0.03]); % [xmin xmax ymin ymax]