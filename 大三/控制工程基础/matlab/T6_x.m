% --- 1. 定义系统 (根据 图 6.5) ---
s = tf('s');
% 开环传递函数 G(s)
G = 1000 * (0.2*s + 1) / (s * (2*s + 1) * (0.015*s + 1) * (0.005*s + 1));

% --- 2. 计算误差传递函数 ---
% 假设为单位反馈系统, Phi_e(s) = 1 / (1 + G(s))
Phi_e = 1 / (1 + G);

% --- 3. 定义输入信号的已知约束 ---
wm = 0.5; % 最大角速度 (rad/s)
em = 1;   % 最大角加速度 (rad/s^2)

% --- 4. 计算输入信号的实际参数 ---
% omega = em / wm
omega = em / wm;
% A = wm / omega (A 即 theta_m)
A = wm / omega; 

% --- 5. 计算指定频率下的稳态误差幅值 ---
% 计算 Phi_e(j*omega) 的幅值
% freqresp 函数返回的是 G(jw) 的复数值
[resp_phi_e, ~] = freqresp(Phi_e, omega);
mag_phi_e = abs(resp_phi_e);

% 稳态误差的幅值 Ae = A * |Phi_e(j*omega)|
Ae = A * mag_phi_e;

% --- 6. 在控制台输出计算结果 ---
fprintf('--- 系统定义 ---\n');
disp('G(s) =');
G
disp('Phi_e(s) = 1 / (1 + G(s)) =');
Phi_e
fprintf('\n--- 输入信号参数 ---\n');
fprintf('角频率 omega = %.2f rad/s\n', omega);
fprintf('幅值 A (theta_m) = %.2f rad\n', A);
fprintf('\n--- 稳态误差计算 ---\n');
fprintf('在 omega = %.2f 处, 误差传递函数幅值 |Phi_e(j*omega)| = %.6f\n', omega, mag_phi_e);
fprintf('最终的稳态误差幅值 Ae = A * |Phi_e(j*omega)| = %.6f rad\n', Ae);

% --- 7. 绘制误差传递函数的Bode图 ---
% 绘制Bode图可以直观地看到系统在不同频率下的误差抑制能力
figure;
bode(Phi_e);
grid on;
title('伯德图');