clc; clear; close all;

%% 1. 数据录入 (来源于您提供的"更新后的完整表格 (载荷 400N)")
% 横坐标：特性数 lambda = eta * n / p (表格单位是 x 10^-4)
lambda_data = [ ...
    0.07, 1.26, 1.96, 2.45, ...
    5.74, 7.70, 9.94, 11.13, ...
    13.09, 14.70, 17.15, 17.85, ...
    19.95, 21.63, 23.45, 25.20, ...
    26.74, 27.93];

% 纵坐标：摩擦系数 f
f_data = [ ...
    0.4143, 0.2000, 0.2071, 0.2143, ...
    0.2214, 0.2286, 0.2357, 0.2429, ...
    0.2500, 0.2571, 0.2643, 0.2714, ...
    0.2786, 0.2857, 0.2929, 0.3000, ...
    0.3071, 0.3143];

%% 2. 绘制图形 (参考 Stribeck 曲线样式)
figure('Color', 'w', 'Position', [300, 300, 700, 500]);
hold on; box on;

% 绘制曲线：蓝色实线 + 实心圆点
plot(lambda_data, f_data, '-o', ...
    'Color', [0.26, 0.45, 0.77], ...       % 线条颜色 (参考图中的蓝色)
    'LineWidth', 2, ...                    % 线宽
    'MarkerSize', 7, ...                   % 标记点大小
    'MarkerFaceColor', [0.26, 0.45, 0.77], ... % 标记点填充颜色
    'MarkerEdgeColor', [0.26, 0.45, 0.77]);    % 标记点边缘颜色

%% 3. 图形修饰
% 标题和坐标轴
title('滑动轴承的摩擦特性曲线', 'FontSize', 16, 'FontWeight', 'normal'); % 字体加粗可改为'bold'
xlabel('\lambda = \eta n / p  (\times 10^{-4})', 'FontSize', 12); % 注意单位是 10^-4
ylabel('摩擦系数 f', 'FontSize', 12);

% 设置坐标轴范围 (根据数据自动调整，稍微留白)
xlim([0, 30]); 
ylim([0, 0.45]);

% 添加网格线 (参考图中也就是普通的网格)
grid on;
set(gca, 'GridLineStyle', '-', 'GridColor', [0.8 0.8 0.8], 'GridAlpha', 0.8);

% 优化坐标轴刻度字体
set(gca, 'FontSize', 11);

% (可选) 标注最低点 - 混合润滑与流体润滑的分界点
[min_f, min_idx] = min(f_data);
min_lambda = lambda_data(min_idx);
% text(min_lambda, min_f - 0.03, sprintf('最低点\n(%.2f, %.4f)', min_lambda, min_f), ...
%      'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'r');

hold off;