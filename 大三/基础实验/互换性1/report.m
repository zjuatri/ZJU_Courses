% 折线图绘制
% 定义横坐标
x = [0 160 320 480 640 800 960 1120];

% 定义纵坐标
y = [0 0 28 23 23-177 23-177-60 23-177-60+397 23-177-60+397+109];

% 绘制折线图
figure;
plot(x, y, '-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;

% 绘制第一个点和最后一个点的连线
plot([x(1), x(end)], [y(1), y(end)], 'r-', 'LineWidth', 1.5);

% 计算红色直线在各个x点的函数值 f2(x)
f1 = y;  % 蓝色折线的y值
% 红色直线方程: y = y1 + (y2-y1)/(x2-x1) * (x-x1)
f2 = y(1) + (y(end) - y(1)) / (x(end) - x(1)) * (x - x(1));

% 计算偏差 h(x) = f1(x) - f2(x)
h = f1 - f2;

% 找到最大和最小偏差
[h_max, idx_max] = max(h);
[h_min, idx_min] = min(h);

% 画h_max的垂直线段（从红线到蓝线）
plot([x(idx_max), x(idx_max)], [f2(idx_max), f1(idx_max)], 'k-', 'LineWidth', 3);
% 在线段中间标注h_max值
text(x(idx_max) + 20, (f2(idx_max) + f1(idx_max))/2, ...
    sprintf('h_{max}=%.1f', h_max), ...
    'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold', ...
    'BackgroundColor', 'w', 'EdgeColor', 'k');

% 画h_min的垂直线段（从蓝线到红线）
plot([x(idx_min), x(idx_min)], [f1(idx_min), f2(idx_min)], 'k-', 'LineWidth', 3);
% 在线段中间标注h_min值
text(x(idx_min) + 20, (f1(idx_min) + f2(idx_min))/2, ...
    sprintf('h_{min}=%.1f', h_min), ...
    'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold', ...
    'BackgroundColor', 'w', 'EdgeColor', 'k');

hold off;
grid on;

% 添加标签
xlabel('减后读数累加值/mm');
ylabel('格数');
title('导轨直线度测量作图法');

% 显示数据点的值
for i = 1:length(x)
    text(x(i), y(i), sprintf('  (%.0f, %.0f)', x(i), y(i)), ...
        'VerticalAlignment', 'bottom', 'FontSize', 9);
end
