% --- 1. 初始化设置 ---
clear;
clc;
close all;

% --- 2. 定义参数 ---
A_val = 1; % 假设 A=1 用于绘图
A_str = 'A'; % 用于标签的字符串
n_range = -3:3; % 谐波次数 n

% --- 3. 计算横轴数据 (w/w0 的值) ---
w_axis_data = 2 * n_range; % 数据点: [-6, -4, -2, 0, 2, 4, 6]

% --- 4. 计算幅频谱 |Cn| (用于绘图) ---
Cn_mag = (2 * A_val) ./ (pi * abs(1 - 4 * n_range.^2));

% --- 5. 计算相频谱 (用于绘图) ---
Cn_phase = zeros(size(n_range)); 
Cn_phase(n_range > 0) = pi;     
Cn_phase(n_range < 0) = -pi;    

% --- 6. 生成标签 (为 'latex' 解释器添加 $ 符号) ---

% 幅度标签
amp_labels = cell(size(n_range));
for i = 1:length(n_range)
    n = n_range(i);
    if n == 0
        amp_labels{i} = sprintf('$\\frac{2%s}{\\pi}$', A_str);
    else
        denom = abs(1 - 4*n^2);
        amp_labels{i} = sprintf('$\\frac{2%s}{%d\\pi}$', A_str, denom);
    end
end

% 相位标签
phase_labels = cell(size(n_range));
for i = 1:length(n_range)
    n = n_range(i);
    if n == 0
        phase_labels{i} = '0';
    elseif n > 0
        phase_labels{i} = '$\pi$';
    else
        phase_labels{i} = '$-\pi$';
    end
end

% --- 7. 生成 X 轴刻度标签 (为 'latex' 解释器添加 $ 符号) ---
x_tick_labels = cell(size(n_range));
for i = 1:length(w_axis_data)
    w_val = w_axis_data(i);
    if w_val == 0
        x_tick_labels{i} = '0';
    else
        x_tick_labels{i} = sprintf('$%d\\omega_0$', w_val);
    end
end


% --- 8. 绘图 (图 1: 幅频谱) ---
figure('Name', '双边幅频谱');
hold on;
stem(w_axis_data, Cn_mag, 'filled', 'LineWidth', 2, 'MarkerSize', 8);

% 添加分式标签 (必须用 'latex' 渲染 \frac)
y_offset_amp = max(Cn_mag) * 0.05;
for i = 1:length(w_axis_data)
    text(w_axis_data(i), Cn_mag(i) + y_offset_amp, amp_labels{i}, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 12, 'Color', 'k', ...
        'Interpreter', 'latex'); % <-- 保留 'latex'
end

% --- 标题和轴标签使用 'tex' 解释器 ---
% 'tex' 可以处理中文和简单的符号 |C_n|
title('双边幅频谱 |C_n|', 'Interpreter', 'tex', 'FontSize', 14); % <-- *** 修正: 'latex' 改为 'tex' ***
xlabel('\omega', 'Interpreter', 'tex', 'FontSize', 14); % <-- *** 修正: 'latex' 改为 'tex', 移除 $ ***
ylabel('幅度', 'FontSize', 12);
% ---
grid on;
ax = gca;
ax.FontSize = 12;

% 刻度标签 (xticklabels) 必须用 'latex' 渲染 \omega_0
xticks(w_axis_data);
xticklabels(x_tick_labels);
ax.TickLabelInterpreter = 'latex'; % <-- 保留 'latex'
hold off;


% --- 9. 绘图 (图 2: 相频谱) ---
figure('Name', '双边相频谱');
hold on;
stem(w_axis_data, Cn_phase, 'filled', 'LineWidth', 2, 'MarkerSize', 8);

% 添加相位标签 (使用 'latex' 渲染 \pi)
y_offset_phase = 0.3;
for i = 1:length(w_axis_data)
    text(w_axis_data(i), Cn_phase(i) + y_offset_phase, phase_labels{i}, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, 'Color', 'k', ...
        'Interpreter', 'latex'); % <-- 保留 'latex'
end

% --- 标题和轴标签使用 'tex' 解释器 ---
% 'tex' 可以处理中文和简单的符号 \phi_n
title('双边相频谱 \phi_n', 'Interpreter', 'tex', 'FontSize', 14); % <-- *** 修正: 'latex' 改为 'tex', 移除 $ ***
xlabel('\omega', 'Interpreter', 'tex', 'FontSize', 14); % <-- *** 修正: 'latex' 改为 'tex', 移除 $ ***
ylabel('相位 (弧度)', 'FontSize', 12);
% ---
grid on;
ax = gca;
ax.FontSize = 12;

% 刻度标签 (xticklabels) 必须用 'latex' 渲染 \omega_0
xticks(w_axis_data);
xticklabels(x_tick_labels);
ax.TickLabelInterpreter = 'latex'; % <-- 保留 'latex'

% Y 轴刻度标签 (yticks) 必须用 'latex' 渲染 \pi
yticks([-pi, 0, pi]);
yticklabels({'$$-\pi$$', '0', '$$\pi$$'});
ax.TickLabelInterpreter = 'latex'; % 确保 Y 轴也用 latex
ylim([-1.2*pi, 1.2*pi]);
hold off;