% =========================================================================
% 减速器输出轴：标准教科书级弯矩与扭矩校核图 (防裁剪完美版)
% =========================================================================
clear; clc; close all;

% -------------------------------------------------------------------------
% 1. 核心物理坐标与计算数据
% -------------------------------------------------------------------------
x_start = 0;      % 轴左端 (联轴器输出端)
x_A  = 193.5;     % 左轴承中心
x_C  = 270.0;     % 大齿轮中心
x_B  = 414.0;     % 右轴承中心
x_end = 424.5;    % 轴右端

% 弯矩与扭矩峰值数据
M_v = 42718;      % 铅垂面最大弯矩
M_h = 117359;     % 水平面最大弯矩
M   = 124891;     % 合成最大弯矩

T  = 406990;      % 传递转矩
aT = 244194;      % 折合转矩 (0.6 * T)

% 当量弯矩关键点 (转矩从C传到左端)
Me_A   = aT;                      % A点 (仅受扭矩)
Me_C_L = sqrt(M^2 + aT^2);        % C点左侧 (弯矩+扭矩) -> 274278
Me_C_R = M;                       % C点右侧 (仅弯矩)

% -------------------------------------------------------------------------
% 2. 窗口与排版初始化
% -------------------------------------------------------------------------
figure('Name', '输出轴校核图', 'Position', [150, 50, 800, 1000], 'Color', 'w');

% 扩大坐标系边界，防止裁剪
xlim_val = [-150, x_end + 40]; 
dx = 8; % 剖面线间距

ax = zeros(7, 1);
titles = {'(a)铅垂面受力图', '(b)水平面受力图', '(c)铅垂面弯矩图\n(N·mm)', ...
          '(d)水平面弯矩图\n(N·mm)', '(e)合成弯矩图\n(N·mm)', ...
          '(f)转矩图 (N·mm)', '(g)当量弯矩图\n(N·mm)'};

for i = 1:7
    ax(i) = axes('Position', [0.25, 0.93 - i*0.125, 0.68, 0.08]);
    hold on; axis off; xlim(xlim_val);
end

% 箭头基础参数
aw = 3.5;  ah = 0.5;  al = 2.0;

% =========================================================================
% (a) 铅垂面受力图
% =========================================================================
axes(ax(1)); ylim([-5, 5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A, al + 1.5, 'F_{vA}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

plot([x_C, x_C], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C-aw, x_C+aw, x_C], [-al+ah, -al+ah, -al], 'k');
text(x_C, -al - 1.5, 'F_r', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B, al + 1.5, 'F_{vB}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

text(-100, 0, titles{1}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (b) 水平面受力图
% =========================================================================
axes(ax(2)); ylim([-5, 5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A, al + 1.5, 'F_{hA}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

plot([x_C, x_C], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C-aw, x_C+aw, x_C], [-al+ah, -al+ah, -al], 'k');
text(x_C, -al - 1.5, 'F_t', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B, al + 1.5, 'F_{hB}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

text(-100, 0, titles{2}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (c) 铅垂面弯矩图 
% =========================================================================
axes(ax(3)); ylim([0, 70000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, M_v, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(M_v*(x-x_A)/(x_C-x_A)) + (x>x_C)*(M_v*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, M_v + 15000, num2str(M_v), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(-100, 35000, sprintf(titles{3}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (d) 水平面弯矩图 
% =========================================================================
axes(ax(4)); ylim([-180000, 0]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, -M_h, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(-M_h*(x-x_A)/(x_C-x_A)) + (x>x_C)*(-M_h*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, -M_h - 25000, num2str(M_h), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(-100, -90000, sprintf(titles{4}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (e) 合成弯矩图
% =========================================================================
axes(ax(5)); ylim([0, 200000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, M, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(M*(x-x_A)/(x_C-x_A)) + (x>x_C)*(M*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, M + 35000, num2str(round(M)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(-100, 100000, sprintf(titles{5}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (f) 转矩图 (从最左端 0 一直画到大齿轮 C)
% =========================================================================
axes(ax(6)); ylim([0, 500000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_start, x_start, x_C, x_C], [0, T, T, 0], 'k-', 'LineWidth', 1.5);
for x = x_start:dx:x_C
    plot([x, x], [0, T], 'k-', 'LineWidth', 0.8);
end
text(mean([x_start, x_C]), T + 60000, num2str(T), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(-100, 250000, titles{6}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (g) 当量弯矩图 (左侧纯扭矩 -> 中间叠加梯形 -> 右侧纯弯矩三角形)
% =========================================================================
axes(ax(7)); ylim([0, 350000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

% 轮廓线
plot([x_start, x_start, x_A, x_C, x_C, x_B], [0, aT, aT, Me_C_L, Me_C_R, 0], 'k-', 'LineWidth', 1.5);

for x = x_start:dx:x_B
    if x <= x_A
        y = aT;
    elseif x <= x_C
        y = aT + (Me_C_L - aT) * (x - x_A) / (x_C - x_A); 
    else
        y = Me_C_R * (x_B - x) / (x_B - x_C); 
    end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end

text(x_A/2, aT + 40000, num2str(aT), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(x_C-15, Me_C_L + 40000, num2str(round(Me_C_L)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'FontSize', 11);
text(x_C+25, Me_C_R + 40000, num2str(round(Me_C_R)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
text(-100, 175000, sprintf(titles{7}), 'FontSize', 11, 'FontWeight', 'bold');