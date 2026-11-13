% =========================================================================
% 减速器输入轴：标准教科书级弯矩与扭矩校核图 (无基准线 + 强制显示受力字母)
% =========================================================================
clear; clc; close all;

% -------------------------------------------------------------------------
% 1. 核心坐标与计算数据
% -------------------------------------------------------------------------
x_A = 164.5;   % 左轴承
x_C = 224.0;   % 齿轮中心
x_B = 383.0;   % 右轴承
x_start = 0;   % 轴左端
x_end = 392.5; % 轴右端

M_v = 13816;   M_h = 37959;   M = 40395;   
T = 29150;     aT = 17490;    Me_L = 44019;  Me_R = 40395;

% -------------------------------------------------------------------------
% 2. 窗口与排版初始化
% -------------------------------------------------------------------------
figure('Name', '标准教科书轴系校核图', 'Position', [150, 50, 750, 950], 'Color', 'w');

% 扩大坐标系的物理边界，防止左侧标题和字母被系统自动裁剪
xlim_val = [-130, x_end + 20]; 
dx = 8; % 垂直剖面线的间距

ax = zeros(7, 1);
titles = {'(a)铅垂面受力图', '(b)水平面受力图', '(c)铅垂面弯矩图\n(N·mm)', ...
          '(d)水平面弯矩图\n(N·mm)', '(e)合成弯矩图\n(N·mm)', ...
          '(f)转矩图 (N·mm)', '(g)当量弯矩图\n(N·mm)'};

for i = 1:7
    ax(i) = axes('Position', [0.28, 0.92 - i*0.125, 0.65, 0.08]);
    hold on; axis off;
    xlim(xlim_val);
end

% 箭头基础参数
aw = 3.5;  % 箭头半宽
ah = 0.35; % 箭头高度
al = 1.2;  % 箭头总长

% =========================================================================
% 图 (a) 铅垂面受力图 (带精确字母标注)
% =========================================================================
axes(ax(1)); ylim([-2.5, 2.5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

% F_vA (向上)
plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A + 5, al + 0.3, 'F_{vA}', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

% F_r (向下)
plot([x_C, x_C], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C-aw, x_C+aw, x_C], [-al+ah, -al+ah, -al], 'k');
text(x_C + 5, -al - 0.3, 'F_r', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

% F_vB (向上)
plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B - 25, al + 0.3, 'F_{vB}', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

text(-120, 0, titles{1}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (b) 水平面受力图 (带精确字母标注)
% =========================================================================
axes(ax(2)); ylim([-2.5, 2.5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

% F_hA (向上)
plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A + 5, al + 0.3, 'F_{hA}', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

% F_t (向下)
plot([x_C, x_C], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C-aw, x_C+aw, x_C], [-al+ah, -al+ah, -al], 'k');
text(x_C + 5, -al - 0.3, 'F_t', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

% F_hB (向上)
plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B - 25, al + 0.3, 'F_{hB}', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');

text(-120, 0, titles{2}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (c) 铅垂面弯矩图
% =========================================================================
axes(ax(3)); ylim([0, 18000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, M_v, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(M_v*(x-x_A)/(x_C-x_A)) + (x>x_C)*(M_v*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, M_v + 3500, num2str(M_v), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(-120, M_v/2, sprintf(titles{3}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (d) 水平面弯矩图
% =========================================================================
axes(ax(4)); ylim([-45000, 0]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, -M_h, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(-M_h*(x-x_A)/(x_C-x_A)) + (x>x_C)*(-M_h*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, -M_h - 8500, num2str(M_h), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(-120, -M_h/2, sprintf(titles{4}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (e) 合成弯矩图
% =========================================================================
axes(ax(5)); ylim([0, 50000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C, x_B], [0, M, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    y = (x<=x_C)*(M*(x-x_A)/(x_C-x_A)) + (x>x_C)*(M*(x_B-x)/(x_B-x_C));
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C, M + 9000, num2str(round(M)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(-120, M/2, sprintf(titles{5}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (f) 转矩图
% =========================================================================
axes(ax(6)); ylim([0, 40000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_start, x_start, x_C, x_C], [0, T, T, 0], 'k-', 'LineWidth', 1.5);
for x = x_start:dx:x_C
    plot([x, x], [0, T], 'k-', 'LineWidth', 0.8);
end
text(mean([x_start, x_C]), T + 8500, num2str(T), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(-120, T/2, titles{6}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% 图 (g) 当量弯矩图
% =========================================================================
axes(ax(7)); ylim([0, 55000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_start, x_start, x_A, x_C, x_C, x_B], [0, aT, aT, Me_L, Me_R, 0], 'k-', 'LineWidth', 1.5);

for x = x_start:dx:x_B
    if x <= x_A
        y = aT; 
    elseif x <= x_C
        y = aT + (Me_L - aT) * (x - x_A) / (x_C - x_A); 
    else
        y = Me_R * (x_B - x) / (x_B - x_C); 
    end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(mean([x_start, x_A]), aT + 7500, num2str(aT), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(x_C-15, Me_L + 7500, num2str(round(Me_L)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(x_C+25, Me_R + 7500, num2str(round(Me_R)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman');
text(-120, Me_L/2, sprintf(titles{7}), 'FontSize', 11, 'FontWeight', 'bold');

% 垂直辅助线已全部移除，代码结束