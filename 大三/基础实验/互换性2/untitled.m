% 清除环境
clc; clear; close all;

% ---------------- 1. 数据录入 ----------------
% 展开长度 S (mm) - (剔除第15个异常数据)
S_all = [0, 2.5, 3.4, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22.7, 23.5];

% 指示表指示偏差 K (μm) - (剔除第15个异常数据)
% 序号1识别为4，序号12修正为31
K_all = [4, 11, 11, 11, 13, 15.5, 21, 24, 24, 24, 31, 31, 32, 31];

% ---------------- 2. 数据筛选 (22齿规则) ----------------
S_start = 3.4;  % 起评点
S_end = 22.7;   % 终评点

% 找到有效评定范围内的索引
valid_idx = find(S_all >= S_start & S_all <= S_end);

% 提取有效数据
S_valid = S_all(valid_idx);
K_valid = K_all(valid_idx);

% ---------------- 3. 计算齿廓实际偏差 ----------------
% 只在有效范围内寻找最大值和最小值
k_max_val = max(K_valid);
k_min_val = min(K_valid);
delta_Fa = k_max_val - k_min_val;

% 找到最值对应的 S 坐标 (用于绘图定位)
% 注意：find返回的是在 K_valid 中的索引，需要对应回 S_valid
idx_max = find(K_valid == k_max_val, 1);
idx_min = find(K_valid == k_min_val, 1);
s_at_max = S_valid(idx_max);
s_at_min = S_valid(idx_min);

% ---------------- 4. 绘图设置 ----------------
figure('Color', 'w'); 

% --- A. 绘制非评定区域 (虚线，灰色) ---
plot(K_all, S_all, 'k--o', 'LineWidth', 1, 'Color', [0.6 0.6 0.6], 'MarkerFaceColor', 'w');
hold on;

% --- B. 绘制有效评定区域 (实线，黑色) ---
plot(K_valid, S_valid, 'k-o', 'LineWidth', 2, 'MarkerFaceColor', 'k', 'MarkerSize', 5);

% --- C. 绘制中心参考线 (X=0) ---
plot([0, 0], [0, max(S_all)+2], 'k-', 'LineWidth', 1);

% --- D. 绘制起评点和终评点界限 (水平辅助线) ---
x_lims = [-max(abs(K_all))*1.2, max(abs(K_all))*1.2];
plot(x_lims, [S_start, S_start], 'b-.', 'LineWidth', 0.8); % 起评线
plot(x_lims, [S_end, S_end], 'b-.', 'LineWidth', 0.8);     % 终评线

% 标注起评和终评文字
text(x_lims(1)*0.9, S_start+0.5, '起评点 (S=3.4)', 'Color', 'b', 'FontSize', 9);
text(x_lims(1)*0.9, S_end+0.5, '终评点 (S=22.7)', 'Color', 'b', 'FontSize', 9);

% ---------------- 5. 坐标轴调整 ----------------
ax = gca;
xlim(x_lims);
ylim([0, max(S_all) + 2]);

% 设置标签
xlabel('指示表指示偏差 K (\mum)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('展开长度 S (mm)', 'FontSize', 12, 'FontWeight', 'bold', 'Rotation', 0);

% 添加网格
grid on;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.3;

% 添加标题
title(['齿形误差测量 (22齿, \Delta F_a = ', num2str(delta_Fa), ' \mum)'], 'FontSize', 14);

% ---------------- 6. 用图形表示偏差 (双箭头) ----------------

% 绘制过有效范围内最大值和最小值的竖直辅助红虚线
plot([k_min_val, k_min_val], [S_start, S_end], 'r--', 'LineWidth', 1.5); 
plot([k_max_val, k_max_val], [S_start, S_end], 'r--', 'LineWidth', 1.5); 

% 绘制表示偏差距离的双向箭头线
% 选择有效区域的中间位置绘制箭头
arrow_y = (S_start + S_end) / 2; 

% 为了箭头美观，绘制两段 quiver
quiver(k_min_val, arrow_y, k_max_val-k_min_val, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5); % 向右
quiver(k_max_val, arrow_y, k_min_val-k_max_val, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5); % 向左

% 标记有效范围内的最大值点和最小值点
plot(k_max_val, s_at_max, 'rs', 'MarkerSize', 8, 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
plot(k_min_val, s_at_min, 'bs', 'MarkerSize', 8, 'LineWidth', 1.5, 'MarkerFaceColor', 'b');

hold off;