% --- 1. 初始化设置 ---
clear;
clc;
close all;

% --- 2. 定义参数 ---
f0 = 1; 
f_axis = [-2*f0, -f0, 0, f0, 2*f0]; 

% --- 3. 定义频谱数据 ---
imag_data = [0, 0.5, 0, -0.5, 0];
phase_data = [0, pi/2, 0, -pi/2, 0];

% --- 4. 绘图 (图 1: 虚频谱 - 保留箭头) ---
figure('Name', '双边虚频谱 Im[X(f)]');
hold on;
grid on;

pos_idx = imag_data > 0;
neg_idx = imag_data < 0;

% 绘制正值 (使用向上箭头 '^')
if any(pos_idx)
    stem(f_axis(pos_idx), imag_data(pos_idx), ...
         'filled', 'LineWidth', 2, 'Marker', '^', ...
         'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
end
% 绘制负值 (使用向下箭头 'v')
if any(neg_idx)
    stem(f_axis(neg_idx), imag_data(neg_idx), ...
         'filled', 'LineWidth', 2, 'Marker', 'v', ...
         'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
end

plot(f_axis, zeros(size(f_axis)), 'k-', 'LineWidth', 0.5); 
text(-f0, 0.5, '1/2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12);
text(f0, -0.5, '-1/2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 12);
title('x(t) = sin(2\pi f_0 t) 的虚频谱 ', 'FontSize', 14);
xlabel('频率 f', 'Interpreter', 'tex', 'FontSize', 12);
ylabel('虚部 Im[X(f)]', 'Interpreter', 'tex', 'FontSize', 12);
ax = gca; ax.FontSize = 12;
ylim([-0.6, 0.6]); 
xticks(f_axis);
xticklabels({sprintf('-2f_0'), sprintf('-f_0'), '0', sprintf('f_0'), sprintf('2f_0')});
ax.TickLabelInterpreter = 'tex';
hold off;


% --- 5. 绘图 (图 2: 相频谱 - *** 修正为圆点 ***) ---
figure('Name', '双边相频谱 \angle X(f)');
hold on;
grid on;

% *** 修正: 找出非零点 ***
nonzero_idx = phase_data ~= 0;

% *** 修正: 使用 'o' (圆点) 作为标记 ***
if any(nonzero_idx)
    stem(f_axis(nonzero_idx), phase_data(nonzero_idx), ...
         'filled', 'LineWidth', 2, 'Marker', 'o', ... % <-- 改为 'o'
         'Color', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
end

plot(f_axis, zeros(size(f_axis)), 'k-', 'LineWidth', 0.5);

% 在非零点上标注数值
text(-f0, pi/2, '\pi/2', 'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'bottom', 'FontSize', 12, 'Interpreter', 'tex');
text(f0, -pi/2, '-\pi/2', 'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'top', 'FontSize', 12, 'Interpreter', 'tex');

% --- 图形美化 ---
title('x(t) = sin(2\pi f_0 t) 的相频谱 ', 'FontSize', 14);
xlabel('频率 f', 'Interpreter', 'tex', 'FontSize', 12);
ylabel('相位 \angle X(f) (弧度)', 'Interpreter', 'tex', 'FontSize', 12);
ax = gca; ax.FontSize = 12;
ylim([-1.2*pi, 1.2*pi]); 
xticks(f_axis);
xticklabels({sprintf('-2f_0'), sprintf('-f_0'), '0', sprintf('f_0'), sprintf('2f_0')});
ax.TickLabelInterpreter = 'tex';
yticks([-pi, -pi/2, 0, pi/2, pi]);
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'});
hold off;