% =========================================================================
% 机器人正运动学 (FK) 计算
% 
% 目标: 根据DH参数和给定的5组关节角度，计算末端位置和姿态。
% 姿态表示: XY'Z'' 欧拉角 (对应 intrinsic 'xyz')
% =========================================================================

clc;
clear;
close all;

% 1. 定义DH参数 (根据您提供的DH表)
% (单位: mm, degrees)
a_i = [0; 185; 170; 0; 0; 0];
alpha_i_deg = [-90; 0; 0; 90; 90; 0];
d_i = [230; -54; 0; 77; 77; 85.5];
theta_offset_deg = [0; -90; 0; 90; 90; 0];

% 将角度转换为弧度 (rad)
alpha_i = deg2rad(alpha_i_deg);
theta_offset = deg2rad(theta_offset_deg);

% 2. 定义5组关节角 (变量 theta)
% (来自图片, 单位: rad)
theta_sets = {
    [pi/6, 0, pi/6, 0, pi/3, 0];                          % 组 1
    [pi/6, pi/6, pi/3, 0, pi/3, pi/6];                    % 组 2
    [pi/2, 0, pi/2, -pi/3, pi/3, pi/6];                   % 组 3
    [-pi/6, -pi/6, -pi/3, 0, pi/12, pi/2];                % 组 4
    [pi/12, pi/12, pi/12, pi/12, pi/12, pi/12]             % 组 5
};

fprintf('=== 机器人正运动学计算 ===\n');
fprintf('使用DH参数表 (a, alpha, d, theta_offset):\n');
disp('   No. |    a_i   | alpha_i(rad) |    d_i   | theta_offset(rad)');
disp('--------------------------------------------------------------');
for k=1:6
    fprintf('    %d  | %7.1f | %12.4f | %7.1f | %16.4f\n', k, a_i(k), alpha_i(k), d_i(k), theta_offset(k));
end
fprintf('\n');

% 4. 循环计算每一组
for i = 1:length(theta_sets)
    % 获取当前组的关节变量 (转为列向量)
    q_variable = theta_sets{i}';
    
    % 计算总的关节角 (变量 + 偏移)
    q_total = q_variable + theta_offset;
    
    % 初始化总变换矩阵为单位矩阵
    T06 = eye(4);
    
    % 5. 计算 T06 = A1 * A2 * A3 * A4 * A5 * A6
    for j = 1:6
        Ai = get_A_i(q_total(j), d_i(j), a_i(j), alpha_i(j));
        T06 = T06 * Ai;
    end
    
    % 6. 提取结果
    % 提取位置向量 (单位: mm)
    Position_mm = T06(1:3, 4);
    
    % 提取旋转矩阵
    Rotation = T06(1:3, 1:3);
    
    % 7. 转换姿态为 XY'Z'' 欧拉角 (intrinsic 'xyz')
    % 结果单位为弧度 (rad)
    eul_xyz_rad = rotm2eul(Rotation, 'xyz');
    
    % ★★★ 修改点：将弧度转换为角度 ★★★
    eul_xyz_deg = rad2deg(eul_xyz_rad);
    
    % 打印计算结果
    fprintf('--- 计算组 %d ---\n', i);
    fprintf('输入关节角 (rad): [%.4f, %.4f, %.4f, %.4f, %.4f, %.4f]\n', q_variable);
    fprintf('末端位置 (m) [X, Y, Z]:   [%.4f, %.4f, %.4f]\n', Position_mm(1)/1000, Position_mm(2)/1000, Position_mm(3))/1000;
    % ★★★ 修改点：更新打印单位为 deg ★★★
    fprintf('末端姿态 (XY''Z'' 欧拉角, deg) [rx, ry, rz]: [%.4f, %.4f, %.4f]\n\n', eul_xyz_deg(1), eul_xyz_deg(2), eul_xyz_deg(3));
end


% 3. 辅助函数：计算单个齐次变换矩阵 A_i
function A = get_A_i(theta, d, a, alpha)
    % A_i = Rot(z, theta) * Trans(z, d) * Trans(x, a) * Rot(x, alpha)
    
    cT = cos(theta);
    sT = sin(theta);
    cA = cos(alpha);
    sA = sin(alpha);
    
    A = [ cT,  -sT*cA,   sT*sA,   a*cT;
          sT,   cT*cA,  -cT*sA,   a*sT;
           0,      sA,      cA,      d;
           0,       0,       0,      1];
end