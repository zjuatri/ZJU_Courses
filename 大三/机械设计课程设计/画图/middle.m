% =========================================================================
% 减速器中间轴：标准教科书级弯矩与扭矩校核图 (彻底修复字母裁剪问题版)
% =========================================================================
clear; clc; close all;

% -------------------------------------------------------------------------
% 1. 核心物理坐标与计算数据
% -------------------------------------------------------------------------
x_A  = 8.0;       % 左轴承中心
x_C1 = 84.0;      % 小齿轮中心(低速级)
x_C2 = 164.5;     % 大齿轮中心(高速级)
x_B  = 225.5;     % 右轴承中心
x_start = 0;      % 轴左端
x_end = 233.5;    % 轴右端

% 弯矩与扭矩峰值数据
M_v_C1 = 50587;   M_v_C2 = 32440;
M_h_C1 = 103102;  M_h_C2 = 15234;
M_C1   = 114843;  M_C2   = 35839;

T  = 126690;      % 传递转矩
aT = 76014;       % 折合转矩 (0.6 * T)

% 当量弯矩关键点
Me_C1_L = M_C1;                           
Me_C1_R = sqrt(M_C1^2 + aT^2);            
Me_C2_L = sqrt(M_C2^2 + aT^2);            
Me_C2_R = M_C2;                           

% -------------------------------------------------------------------------
% 2. 窗口与排版初始化
% -------------------------------------------------------------------------
figure('Name', '中间轴校核图', 'Position', [150, 50, 800, 1000], 'Color', 'w');
xlim_val = [-80, x_end + 30]; 
dx = 5; % 剖面线间距

ax = zeros(7, 1);
titles = {'(a)铅垂面受力图', '(b)水平面受力图', '(c)铅垂面弯矩图\n(N·mm)', ...
          '(d)水平面弯矩图\n(N·mm)', '(e)合成弯矩图\n(N·mm)', ...
          '(f)转矩图 (N·mm)', '(g)当量弯矩图\n(N·mm)'};

for i = 1:7
    ax(i) = axes('Position', [0.25, 0.93 - i*0.125, 0.68, 0.08]);
    hold on; axis off; xlim(xlim_val);
end

% 箭头基础参数
aw = 2.5;  % 箭头半宽
ah = 0.5;  % 箭头高度
al = 2.0;  % 箭头线段长度

% =========================================================================
% (a) 铅垂面受力图 (采用超级安全边界 ylim = [-5, 5])
% =========================================================================
axes(ax(1)); ylim([-5, 5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

% F_vA (向上)
plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A, al + 1.2, 'F_{vA}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_r3 (向下)
plot([x_C1, x_C1], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C1-aw, x_C1+aw, x_C1], [-al+ah, -al+ah, -al], 'k');
text(x_C1, -al - 1.2, 'F_{r3}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_r2 (向下)
plot([x_C2, x_C2], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C2-aw, x_C2+aw, x_C2], [-al+ah, -al+ah, -al], 'k');
text(x_C2, -al - 1.2, 'F_{r2}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_vB (向上)
plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B, al + 1.2, 'F_{vB}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

text(-70, 0, titles{1}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (b) 水平面受力图 (采用超级安全边界 ylim = [-5, 5])
% =========================================================================
axes(ax(2)); ylim([-5, 5]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);

% F_hA (向上)
plot([x_A, x_A], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_A-aw, x_A+aw, x_A], [al-ah, al-ah, al], 'k');
text(x_A, al + 1.2, 'F_{hA}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_t3 (向下)
plot([x_C1, x_C1], [0, -al], 'k-', 'LineWidth', 1.5);
fill([x_C1-aw, x_C1+aw, x_C1], [-al+ah, -al+ah, -al], 'k');
text(x_C1, -al - 1.2, 'F_{t3}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_t2 (向上)
plot([x_C2, x_C2], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_C2-aw, x_C2+aw, x_C2], [al-ah, al-ah, al], 'k');
text(x_C2, al + 1.2, 'F_{t2}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

% F_hB (向上)
plot([x_B, x_B], [0, al], 'k-', 'LineWidth', 1.5);
fill([x_B-aw, x_B+aw, x_B], [al-ah, al-ah, al], 'k');
text(x_B, al + 1.2, 'F_{hB}', 'Interpreter', 'tex', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontAngle', 'italic', 'HorizontalAlignment', 'center');

text(-70, 0, titles{2}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (c) 铅垂面弯矩图 (扩充 Y 轴防止数值被裁)
% =========================================================================
axes(ax(3)); ylim([0, 80000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C1, x_C2, x_B], [0, M_v_C1, M_v_C2, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    if x <= x_C1, y = M_v_C1 * (x - x_A) / (x_C1 - x_A);
    elseif x <= x_C2, y = M_v_C1 + (M_v_C2 - M_v_C1) * (x - x_C1) / (x_C2 - x_C1);
    else, y = M_v_C2 * (x_B - x) / (x_B - x_C2); end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C1, M_v_C1 + 12000, num2str(M_v_C1), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(x_C2, M_v_C2 + 12000, num2str(M_v_C2), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(-70, 40000, sprintf(titles{3}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (d) 水平面弯矩图 
% =========================================================================
axes(ax(4)); ylim([-150000, 0]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C1, x_C2, x_B], [0, -M_h_C1, -M_h_C2, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    if x <= x_C1, y = -M_h_C1 * (x - x_A) / (x_C1 - x_A);
    elseif x <= x_C2, y = -M_h_C1 - (M_h_C2 - M_h_C1) * (x - x_C1) / (x_C2 - x_C1);
    else, y = -M_h_C2 * (x_B - x) / (x_B - x_C2); end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C1, -M_h_C1 - 25000, num2str(M_h_C1), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(x_C2, -M_h_C2 - 25000, num2str(M_h_C2), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(-70, -75000, sprintf(titles{4}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (e) 合成弯矩图
% =========================================================================
axes(ax(5)); ylim([0, 160000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C1, x_C2, x_B], [0, M_C1, M_C2, 0], 'k-', 'LineWidth', 1.5);
for x = x_A:dx:x_B
    if x <= x_C1, y = M_C1 * (x - x_A) / (x_C1 - x_A);
    elseif x <= x_C2, y = M_C1 + (M_C2 - M_C1) * (x - x_C1) / (x_C2 - x_C1);
    else, y = M_C2 * (x_B - x) / (x_B - x_C2); end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end
text(x_C1, M_C1 + 25000, num2str(round(M_C1)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(x_C2, M_C2 + 25000, num2str(round(M_C2)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(-70, 80000, sprintf(titles{5}), 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (f) 转矩图
% =========================================================================
axes(ax(6)); ylim([0, 180000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_C1, x_C1, x_C2, x_C2], [0, T, T, 0], 'k-', 'LineWidth', 1.5);
for x = x_C1:dx:x_C2
    plot([x, x], [0, T], 'k-', 'LineWidth', 0.8);
end
text(mean([x_C1, x_C2]), T + 30000, num2str(T), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(-70, 90000, titles{6}, 'FontSize', 11, 'FontWeight', 'bold');

% =========================================================================
% (g) 当量弯矩图 
% =========================================================================
axes(ax(7)); ylim([0, 190000]);
plot([x_start, x_end], [0, 0], 'k-', 'LineWidth', 1.2);
plot([x_A, x_C1, x_C1, x_C2, x_C2, x_B], [0, Me_C1_L, Me_C1_R, Me_C2_L, Me_C2_R, 0], 'k-', 'LineWidth', 1.5);

for x = x_A:dx:x_B
    if x <= x_C1
        y = Me_C1_L * (x - x_A) / (x_C1 - x_A); 
    elseif x <= x_C2
        y = Me_C1_R + (Me_C2_L - Me_C1_R) * (x - x_C1) / (x_C2 - x_C1); 
    else
        y = Me_C2_R * (x_B - x) / (x_B - x_C2); 
    end
    plot([x, x], [0, y], 'k-', 'LineWidth', 0.8);
end

text(x_C1-12, Me_C1_L + 25000, num2str(round(Me_C1_L)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(x_C1+12, Me_C1_R + 25000, num2str(round(Me_C1_R)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'FontSize', 10);
text(x_C2-12, Me_C2_L + 25000, num2str(round(Me_C2_L)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(x_C2+12, Me_C2_R + 25000, num2str(round(Me_C2_R)), 'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 10);
text(-70, 95000, sprintf(titles{7}), 'FontSize', 11, 'FontWeight', 'bold');