%% 摆动滚子从动件凸轮 - 生成原理与轮廓求解可视化
% 功能：通过“反转法”绘制滚子运动的密集残影，直观展示凸轮轮廓是如何被“包络”出来的
clear; clc; close all;

% --- 1. 实验参数 ---
a = 104.99;       % 中心距 (mm)
l = 68.02;        % 摆杆长度 (mm)
rr = 8.0;         % 滚子半径 (mm)
r_base_ref = 50.44; % 参考基圆半径 (用于确定初始位置)

% --- 2. 运动数据 (摆动角度规律) ---
% s_raw 为摆动角度变化量 (单位：度)
s_raw = [3.385, 2.945, 0.490, 0.000, 1.088, 1.376, 2.605, 4.021, 5.522, ...
         6.778, 8.199, 9.445, 10.859, 12.205, 13.537, 14.814, 16.099, 17.434, ...
         18.765, 18.867, 18.847, 18.945, 18.957, 19.065, 19.127, 19.147, ...
         16.927, 15.472, 14.245, 13.844, 11.517, 10.196, 8.799, 7.342, 6.025, 4.549, 3.385];
theta_raw = 0:10:360; 

% 数据插值 (为了获得平滑的包络效果)
theta_fine = linspace(0, 360, 3600); 
phi_rad = deg2rad(theta_fine); % 凸轮转角
% 插值摆角增量
delta_psi_deg = interp1(theta_raw, s_raw, theta_fine, 'spline');
delta_psi_rad = deg2rad(delta_psi_deg);

% --- 3. 初始位置计算 (确定几何闭环) ---
% 假设 s=0 (数据最小值) 时，滚子处于最低点，距离中心 O 为 r_base_ref + rr
min_dist_O_B = r_base_ref + rr; 
% 在三角形 OAB 中应用余弦定理计算初始摆角 psi0
% OB^2 = OA^2 + AB^2 - 2*OA*AB*cos(psi0)
cos_psi0 = (a^2 + l^2 - min_dist_O_B^2) / (2 * a * l);
psi0 = acos(cos_psi0);

% 总摆角 psi (相对于摆杆轴连线 OA 的夹角)
% 注意：s_raw 是变化量，最低点 s=0
s_min = min(s_raw);
% 归一化：确保最小值对应 0 增量
psi_total = psi0 + deg2rad(delta_psi_deg - s_min); 

% --- 4. 反转法运动学计算 ---
% 凸轮固定不动 (0,0)
% 摆杆轴 A 绕凸轮反向转动 (-phi)
xA = a * cos(-phi_rad);
yA = a * sin(-phi_rad);

% 滚子中心 B 的位置
% 几何逻辑：
% 1. 向量 OA 的角度是 -phi
% 2. 摆杆 AB 相对于 OA 向内偏转 psi_total 角度
%    在三角形中，若 A 在右侧，摆杆指向左侧，角度为 pi - psi
theta_arm = -phi_rad + (pi - psi_total);

xc = xA + l * cos(theta_arm);
yc = yA + l * sin(theta_arm);

% --- 5. 计算实际轮廓 (数学求解) ---
% 计算切向量
dx = gradient(xc, phi_rad);
dy = gradient(yc, phi_rad);
ds = sqrt(dx.^2 + dy.^2);

% 计算法向量 (垂直于切线)
nx = -dy ./ ds;
ny =  dx ./ ds;

% 【核心修正】点积法确保法向量指向圆心 (内侧)
% 如果法向量指向外侧，点积为正，则取反
if mean(xc .* nx + yc .* ny) > 0
    nx = -nx;
    ny = -ny;
end

% 实际轮廓点
xa = xc + rr * nx;
ya = yc + rr * ny;

% --- 6. 绘图：原理可视化 ---
figure('Color', 'w', 'Position', [100, 100, 1000, 900]);
hold on; axis equal; axis off;

% A. 绘制摆杆轴的轨迹圆 (展示公转)
plot(a*cos(0:0.01:2*pi), a*sin(0:0.01:2*pi), 'Color', [0.8 0.8 0.8], 'LineStyle', '--');
text(0, a+5, '摆杆轴公转轨迹', 'HorizontalAlignment', 'center', 'Color', [0.5 0.5 0.5]);

% B. 绘制滚子的“密集残影” (展示包络过程)
% 这是展示“如何求出轮廓”的关键：画出滚子在不同时刻的位置
step = 60; % 绘图间隔 (每隔约 6 度画一个滚子)
for i = 1:step:length(phi_rad)
    % 当前滚子中心
    cx = xc(i); cy = yc(i);
    % 绘制滚子圆圈 (细灰色线)
    viscircles([cx, cy], rr, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5, 'EnhanceVisibility', false); 
end

% C. 绘制几个关键位置的机构实体 (为了看清结构)
draw_idx = [1, 900, 1800, 2700]; % 0, 90, 180, 270 度
for k = draw_idx
    curr_xA = xA(k); curr_yA = yA(k);
    curr_xc = xc(k); curr_yc = yc(k);
    % 画摆杆
    line([curr_xA, curr_xc], [curr_yA, curr_yc], 'Color', [0.2 0.2 0.2], 'LineWidth', 1);
    % 画摆杆轴点
    plot(curr_xA, curr_yA, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'w');
end

% D. 绘制最终计算出的凸轮轮廓 (加粗黑线)
% 这条线应该完美相切于所有灰色圆圈的内侧
plot(xa, ya, 'k-', 'LineWidth', 3);

% E. 绘制中心和标注
plot(0, 0, 'k+', 'MarkerSize', 15, 'LineWidth', 2);
text(0, -10, '凸轮中心 O', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% F. 添加指示箭头和文字说明原理
% 找一个位置引出说明
anno_idx = 1400; % 约140度位置
p_arrow_start = [xa(anno_idx)-40, ya(anno_idx)+40];
p_arrow_end = [xa(anno_idx), ya(anno_idx)];
draw_arrow(p_arrow_start, p_arrow_end);
text(p_arrow_start(1), p_arrow_start(2)+5, '所有滚子圆的内包络线', 'FontSize', 11, 'FontWeight', 'bold');
text(p_arrow_start(1), p_arrow_start(2)-5, '即为凸轮轮廓', 'FontSize', 11);

% 标题
title({'摆动滚子从动件凸轮轮廓生成原理'; 'The Generation of Cam Profile via Inversion Method'}, ...
    'FontSize', 14);

% --- 辅助函数 ---
function draw_arrow(p1, p2)
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'k-', 'LineWidth', 1);
    % 简单箭头头
    v = p2 - p1; u = v/norm(v);
    sz = 5;
    R1 = [cos(2.6), -sin(2.6); sin(2.6), cos(2.6)];
    R2 = [cos(-2.6), -sin(-2.6); sin(-2.6), cos(-2.6)];
    a1 = p2 + (u*R1*sz')';
    a2 = p2 + (u*R2*sz')';
    fill([p2(1), a1(1), a2(1)], [p2(2), a1(2), a2(2)], 'k');
end