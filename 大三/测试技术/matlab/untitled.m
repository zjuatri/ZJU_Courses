% --- 1. 定义信号参数 ---
clear; clc; close all;
A = 1;        % 方波幅值 (设为 1)
T0 = 2;       % 信号周期 (设为 2)
omega0 = 2*pi / T0; % 基波角频率 (pi)

% --- 2. 绘制相角谱 (以 sin 为基准) ---
figure(1); % 在第一个窗口中打开
set(figure(1), 'Name', '', 'NumberTitle', 'off');

% 定义要计算的奇次谐波 (n=1, 3, 5, ...)
n_max = 9;
n_odd = 1:2:n_max;

% --- 修正部分 ---
% 以 sin(n*w0*t + psi_n) 为基准
% x(t) = Sum[ (4A/n/pi) * sin(n*w0*t) ]
% 通过比较，相位 psi_n = 0 (对于所有 n_odd)
Psi_odd = zeros(size(n_odd));

% 只绘制奇次谐波的相位
stem(n_odd, Psi_odd, 'filled', 'LineWidth', 2, 'Color', 'g');
hold on; % 确保 stem 的点在 x 轴上可见
plot(0:n_max+1, zeros(n_max+2, 1), 'k--'); % 画一条 y=0 的虚线
hold off;

grid on;
title('相角谱 \psi(\omega)  [基准: sin(n\omega_0t + \psi_n)]');
xlabel('角频率 \omega');
ylabel('相位 (rad)');
xlim([0, n_max + 1]);

% --- 设置 x 轴刻度标签 ---
x_tick_pos = [0, n_odd];
x_tick_labels = {'0'};
for n_val = n_odd
    if n_val == 1
        x_tick_labels{end+1} = '$\omega_0$';
    else
        x_tick_labels{end+1} = sprintf('$%d\\omega_0$', n_val);
    end
end
xticks(x_tick_pos);
xticklabels(x_tick_labels);
set(gca, 'TickLabelInterpreter', 'latex'); % 使用 LaTeX 解释器

% --- 设置 y 轴刻度 ---
ylim([-pi, pi]); % 给 y=0 上下一些空间
yticks([-pi/2, 0, pi/2]);
yticklabels({'-\pi/2', '0', '\pi/2'});