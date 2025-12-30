%% 凸轮机构几何原理 - 最终修复版 (修复B点遮挡问题)
% 修复内容：
% 1. 调整绘图层级：先画滚子填充，再画B点和文字，防止被遮挡
% 2. 优化 B 点文字位置，使其更清晰
clear; clc; close all;

% --- 1. 核心参数 ---
r0 = 50.44;     % 基圆半径 (mm)
L  = 68.02;     % 摆杆长度 (mm)
a  = 104.99;    % 中心距 (凸轮轴-摆杆轴) (mm)
rr = 8.0;       % 滚子半径 (mm)

% --- 2. 数据处理 ---
s_raw = [3.385, 2.945, 0.490, 0.000, 1.088, 1.376, 2.605, 4.021, 5.522, ...
         6.778, 8.199, 9.445, 10.859, 12.205, 13.537, 14.814, 16.099, 17.434, ...
         18.765, 18.867, 18.847, 18.945, 18.957, 19.065, 19.127, 19.147, ...
         16.927, 15.472, 14.245, 13.844, 11.517, 10.196, 8.799, 7.342, 6.025, 4.549, 3.385];
theta_raw = 0:10:360;
theta_fine = linspace(0, 360, 3600);
s_fine = interp1(theta_raw, s_raw, theta_fine, 'spline');

% --- 3. 运动学计算 (反转法) ---
R_start = r0 + rr;
cos_val = (L^2 + a^2 - R_start^2) / (2 * L * a);
cos_val = max(min(cos_val, 1), -1); 
psi0 = acos(cos_val); 

delta = deg2rad(theta_fine);   
psi_vec = psi0 + (s_fine ./ L); 

Ax = a * cos(-delta);
Ay = a * sin(-delta);

Bx = Ax + L * cos(-delta + pi - psi_vec);
By = Ay + L * sin(-delta + pi - psi_vec);

dx = gradient(Bx, delta); dy = gradient(By, delta);
ds = sqrt(dx.^2 + dy.^2); ds(ds<1e-6)=1e-6;
nx = -dy ./ ds; ny = dx ./ ds;
if mean(Bx .* nx + By .* ny) > 0, nx = -nx; ny = -ny; end
Cx = Bx + rr * nx; 
Cy = By + rr * ny;

% 强制闭合轮廓
Cx = [Cx, Cx(1)]; Cy = [Cy, Cy(1)];
Bx = [Bx, Bx(1)]; By = [By, By(1)];
delta = [delta, delta(1)]; 

% --- 4. 绘图 ---
figure(1); clf;
set(gcf, 'Color', 'w', 'Position', [100, 100, 900, 850]);
hold on; axis equal; axis off;

% 4.1 绘制基础线条
plot(Cx, Cy, 'k-', 'LineWidth', 2.0);                      % 实际轮廓
plot(Bx, By, 'k--', 'LineWidth', 0.6);                     % 理论轨迹
plot(r0*cos(delta), r0*sin(delta), 'k:', 'LineWidth', 0.5);% 基圆

% 4.2 绘制圆心 O 并标注
plot(0, 0, 'k+', 'MarkerSize', 10, 'LineWidth', 1.5); 
text(-6, -8, 'O', 'FontSize', 12, 'FontName', 'Times New Roman', 'FontWeight', 'bold');

% --- 5. 绘制最大升程处的机构几何 ---
[~, max_idx] = max(s_fine); 
A_curr = [Ax(max_idx), Ay(max_idx)];
B_curr = [Bx(max_idx), By(max_idx)];
O_curr = [0, 0];

% 初始参考线
line([0, a], [0, 0], 'Color', [0.7 0.7 0.7], 'LineStyle', '-.', 'LineWidth', 0.8);
text(a+5, 0, '初始位置', 'FontSize', 9, 'Color', [0.5 0.5 0.5], 'FontName', 'SimSun');

% 几何连线
line([O_curr(1), A_curr(1)], [O_curr(2), A_curr(2)], 'Color', 'k', 'LineStyle', '-.', 'LineWidth', 1.0); % OA
line([A_curr(1), B_curr(1)], [A_curr(2), B_curr(2)], 'Color', 'k', 'LineWidth', 2.5); % AB
line([O_curr(1), B_curr(1)], [O_curr(2), B_curr(2)], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.0); % OB

% 节点 A
plot(A_curr(1), A_curr(2), 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'w', 'LineWidth', 1.2); 
text(A_curr(1), A_curr(2)+8, 'A', 'FontSize', 12, 'FontName', 'Times New Roman', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

% [关键修改] 先画滚子(白色填充)，再画B点和文字，避免遮挡！
% 1. 画滚子实体
theta_circ = linspace(0, 2*pi, 100);
fill(B_curr(1) + rr*cos(theta_circ), B_curr(2) + rr*sin(theta_circ), 'w', 'EdgeColor', 'k', 'LineWidth', 1.0);

% 2. 画滚子中心点 B
plot(B_curr(1), B_curr(2), 'ko', 'MarkerSize', 4, 'MarkerFaceColor', 'k'); 

% 3. 画文字 'B' (稍微往右上方偏移一点，避开滚子边缘)
text(B_curr(1)+6, B_curr(2)+8, 'B', 'FontSize', 12, 'FontName', 'Times New Roman');

% --- 6. 角度标注 ---

% Theta (凸轮转角)
ang_OA_curr = atan2(A_curr(2), A_curr(1));
r_theta = 20;
theta_arc_vals = linspace(0, ang_OA_curr, 50);
plot(r_theta*cos(theta_arc_vals), r_theta*sin(theta_arc_vals), 'k-', 'LineWidth', 0.8);
text(r_theta*1.3 * cos(ang_OA_curr/2), r_theta*1.3 * sin(ang_OA_curr/2), ...
    '\theta', 'FontSize', 12, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center', 'FontAngle', 'italic');

% Psi (摆角)
vec_AO = O_curr - A_curr; 
vec_AB = B_curr - A_curr; 
ang_AO = atan2(vec_AO(2), vec_AO(1));
ang_AB = atan2(vec_AB(2), vec_AB(1));

if ang_AB - ang_AO > pi, ang_AB = ang_AB - 2*pi; end
if ang_AB - ang_AO < -pi, ang_AB = ang_AB + 2*pi; end

r_psi = 30; 
psi_arc_vals = linspace(ang_AO, ang_AB, 50);
plot(A_curr(1) + r_psi*cos(psi_arc_vals), A_curr(2) + r_psi*sin(psi_arc_vals), 'k-', 'LineWidth', 0.8);

% Psi 文字在弧线内部
mid_psi = (ang_AO + ang_AB) / 2;
r_text_psi = r_psi * 0.6; 
text(A_curr(1) + r_text_psi*cos(mid_psi), A_curr(2) + r_text_psi*sin(mid_psi), ...
     '\psi', 'FontSize', 14, 'FontName', 'Times New Roman', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontAngle', 'italic');

% --- 7. 尺寸标注 ---

% [标注 a] - OA 连线外侧 (上方)
mid_OA = (O_curr + A_curr) / 2;
vec_OA = A_curr - O_curr;
vec_OA_norm = vec_OA / norm(vec_OA);
vec_perp_OA = [vec_OA_norm(2), -vec_OA_norm(1)]; 
offset_a = 10;
pos_a = mid_OA + vec_perp_OA * offset_a;

text(pos_a(1), pos_a(2), 'a', ...
    'Rotation', rad2deg(ang_AO), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
    'FontName', 'Times New Roman', 'FontSize', 11, 'FontAngle', 'italic');

% [标注 L] - AB 连线外侧 (右侧)
mid_AB = (A_curr + B_curr) / 2;
vec_AB_norm = vec_AB / norm(vec_AB);
vec_perp_right = [vec_AB_norm(2), -vec_AB_norm(1)];
offset_L = 10; 
pos_L = mid_AB + vec_perp_right * offset_L;

rot_L = rad2deg(atan2(vec_AB(2), vec_AB(1)));
if rot_L > 90 || rot_L < -90, rot_L = rot_L - 180; end

text(pos_L(1), pos_L(2), 'L', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
    'Rotation', rot_L, ...
    'FontName', 'Times New Roman', 'FontSize', 11, 'FontAngle', 'italic');

% [滚子半径 r_r]
rr_ang = ang_AB - pi/2; 
p_edge_x = B_curr(1) + rr * cos(rr_ang);
p_edge_y = B_curr(2) + rr * sin(rr_ang);
line([B_curr(1), p_edge_x], [B_curr(2), p_edge_y], 'Color', 'k', 'LineWidth', 0.8);
text(p_edge_x + 3*cos(rr_ang), p_edge_y + 3*sin(rr_ang), 'r_r', ...
    'FontSize', 10, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center', 'FontAngle', 'italic');

% [极径 rho]
text(B_curr(1)/2, B_curr(2)/2, '\rho', 'Color', 'k', ...
    'FontName', 'Times New Roman', 'FontSize', 12, 'FontAngle', 'italic', ...
    'BackgroundColor', 'w');

xlim([-80, 130]);
ylim([-100, 130]);