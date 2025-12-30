%% 凸轮运动精密测量实验 - 位移特性曲线绘制
% 功能：绘制实验数据点及平滑拟合曲线（无理论对比，无极值标注）
clear; clc;

% --- 1. 数据准备 ---
% 实验位移数据 (已扣除基准值)
s_data = [3.385, 2.945, 0.490, 0.000, 1.088, 1.376, 2.605, 4.021, 5.522, ...
          6.778, 8.199, 9.445, 10.859, 12.205, 13.537, 14.814, 16.099, 17.434, ...
          18.765, 18.867, 18.847, 18.945, 18.957, 19.065, 19.127, 19.147, ...
          16.927, 15.472, 14.245, 13.844, 11.517, 10.196, 8.799, 7.342, 6.025, 4.549];

% 角度数据
theta_deg = 0:10:350;

% --- 2. 数据处理 ---
% 生成平滑插值曲线 (用于展示实验数据的连续变化)
theta_fine = linspace(0, 360, 500); % 插值范围延伸至360
s_fine = interp1(theta_deg, s_data, theta_fine, 'spline'); % 三次样条插值

% --- 3. 绘图设置 ---
figure(1); clf;
set(gcf, 'Color', 'w', 'Position', [100, 100, 800, 500]); % 保持较宽的长宽比
hold on; box on;

% --- 4. 绘制图形 ---
% A. 绘制实验数据拟合曲线 (蓝色实线)
h2 = plot(theta_fine, s_fine, '-', 'Color', [0 0.4470 0.7410], 'LineWidth', 2.0);

% B. 绘制实验数据散点 (带填充的圆点)
h3 = plot(theta_deg, s_data, 'o', ...
    'MarkerEdgeColor', 'w', ...       % 白色描边
    'MarkerFaceColor', [0.8500 0.3250 0.0980], ... % 橙色填充
    'MarkerSize', 8, 'LineWidth', 1.0);

% --- 5. 标注与美化 ---
% 标题与轴标签
% 注意：将字体统一改为 SimSun (宋体) 以防止中文字符显示不全
title('\bf{凸轮从动件位移随转角变化曲线}', 'FontSize', 14, 'FontName', 'SimSun');
xlabel('凸轮转角 \theta (^\circ)', 'FontSize', 12, 'FontName', 'SimSun'); 
ylabel('从动件位移 s (mm)', 'FontSize', 12, 'FontName', 'SimSun');

% 坐标轴设置
xlim([0, 360]); % 修改：X轴范围 0 到 360
ylim([0, 24]);
set(gca, 'XTick', 0:45:360, 'FontSize', 10, 'LineWidth', 1.0); 
grid on; set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.6); % 虚线网格

% 图例设置 (只保留实验数据相关图例)
legend([h3, h2], ...
    {'实验测量点', '实验拟合曲线'}, ...
    'Location', 'NorthWest', 'FontSize', 10, 'FontName', 'SimSun');

hold off;