function beam_analysis_simply_supported_point_load()
% --- 功能说明 ---
% 本程序用于计算和分析简支梁在单个集中荷载作用下的力学行为。
% 需要输入梁的长度、荷载大小及位置、材料弹性模量和截面惯性矩。
% 程序会计算并输出：
% 1. 支座反力
% 2. 最大弯矩及其位置
% 3. 最大挠度及其位置
% 同时，程序会绘制剪力图 (SFD)、弯矩图 (BMD)、转角图和挠度图。

% --- 输入参数 ---
disp('------------------------------------------------------');
disp('    简支梁在集中荷载作用下的材料力学分析程序');
disp('------------------------------------------------------');
disp('请输入梁和荷载的参数：');
L = input('梁的长度 L (m) (例如: 5): ');
P = input('集中荷载 P (N) (向下为正, 例如: 10000): ');
a = input('荷载作用位置 a (m) (从左端算起, 例如: 2): ');
E = input('材料的弹性模量 E (Pa) (例如: 200e9 代表钢材): ');
I = input('截面惯性矩 I (m^4) (例如: 8e-5): ');

% 输入参数校验
if L <= 0
    error('错误: 梁的长度 L 必须大于 0。');
end
if P < 0
    warning('提示: 输入的荷载 P 为负值，表示荷载向上。计算将按此进行。');
    % 如果希望严格向下为正，可以取消注释下一行
    % error('错误: 荷载 P 通常假定向下为正。若要表示向上荷载，请调整后续解释或修改程序。');
end
if a < 0 || a > L
    error('错误: 荷载位置 a 必须在 0 和 L 之间 (0 <= a <= L)。');
end
if E <= 0
    error('错误: 弹性模量 E 必须大于 0。');
end
if I <= 0
    error('错误: 截面惯性矩 I 必须大于 0。');
end

b = L - a; % 荷载到右支座的距离

% --- 计算过程 ---

% 1. 支座反力 (向上为正)
R_A = P * b / L; % 左支座反力
R_B = P * a / L; % 右支座反力

% 2. 定义计算点
num_points = 500; % 用于绘图的计算点数量
x_coords = linspace(0, L, num_points);

% 初始化存储数组
V = zeros(size(x_coords));          % 剪力 V(x)
M = zeros(size(x_coords));          % 弯矩 M(x)
slope_EI = zeros(size(x_coords));   % EI * theta(x)
deflection_EI = zeros(size(x_coords)); % EI * y(x) (原始计算值，可能向上为正或向下为正，取决于C1)

% 转角和挠度的积分常数 C1 (对应 EI * theta_A)
% theta_A 是梁左端的转角。对于向下荷载P，theta_A 通常是负值（顺时针）。
% C1 = EI * theta_A = -P*a*b*(L+b)/(6*L) 如果使用 Roark's Formulas (b是到右端的距离, L+b = L+L-a = 2L-a)
% C1 = -P*a*(L-a)*(2*L-a)/(6*L)
C1_val = -P * a * (L - a) * (2 * L - a) / (6 * L); %  积分常数 EI * theta_A

% 3. 计算剪力、弯矩、转角和挠度 (沿梁长)
for i = 1:length(x_coords)
    x = x_coords(i);

    % 剪力 V(x) (标准约定：左段向上为正)
    % (在a点有突变，此处计算的是 x 点的值)
    if x < a
        V(i) = R_A;
    elseif x == a && a ~= 0 % 在荷载作用点a处，剪力从 R_A 突变为 R_A - P
         if i > 1 && x_coords(i-1) < a % 如果前一个点在a左侧
            V(i) = R_A; % 可视化时，这点取 R_A，下一个点取 R_A-P，或用特殊绘图处理
         else
            V(i) = R_A - P; % 默认取右侧值
         end
    else % x > a
        V(i) = R_A - P;
    end
    
    % 弯矩 M(x) (标准约定：使梁下部受拉为正)
    if x <= a
        M(i) = R_A * x;
    else % x > a
        M(i) = R_A * x - P * (x - a);
    end

    % 转角 (EI * theta(x))
    % EI * d^2y/dx^2 = M(x)
    % EI * dy/dx = integral(M(x))dx + C1_val
    % (C1_val 是积分常数，等于 EI * theta(x=0))
    if x <= a
        slope_EI(i) = R_A * x^2 / 2 + C1_val;
    else % x > a
        slope_EI(i) = R_A * x^2 / 2 - P * (x - a)^2 / 2 + C1_val;
    end

    % 挠度 (EI * y(x)) (原始计算，基于积分，y(0)=0, y'(0)=C1_val/EI)
    % EI * y = integral(integral(M(x))dx)dx + C1_val*x + C3_val
    % 因为 y(0)=0，所以 C3_val = 0.
    % 此处的 deflection_EI 计算出的挠度，若P向下，通常为负值（表示向下挠曲）
    if x <= a
        deflection_EI(i) = R_A * x^3 / 6 + C1_val * x;
    else % x > a
        deflection_EI(i) = R_A * x^3 / 6 - P * (x - a)^3 / 6 + C1_val * x;
    end
end

% 实际转角 theta(x) (弧度)
theta_rad = slope_EI / (E * I);
theta_deg = theta_rad * 180 / pi; % 转换为角度

% 实际挠度 y(x) (m)
% 使 y 向下为正
y = -deflection_EI / (E * I); % 乘以 -1 使向下挠度为正值

% --- 结果输出 ---
fprintf('\n--- 计算结果 ---\n');
fprintf('左支座反力 R_A: %.2f N (向上为正)\n', R_A);
fprintf('右支座反力 R_B: %.2f N (向上为正)\n', R_B);

% 最大弯矩 (对于简支梁单点集中荷载，最大弯矩在荷载作用点)
M_max_val = P * a * b / L;
if a == 0 || a == L % 如果荷载在支座上
    M_max_val = 0;
    x_M_max = a;
else
    x_M_max = a;
end
fprintf('最大正弯矩 M_max: %.2f N·m, 发生在 x = %.2f m\n', M_max_val, x_M_max);

% 最大挠度及其位置 (从计算的挠度曲线中找到最大值)
[y_max_val, idx_y_max] = max(y); % y 已被处理为向下为正
x_y_max = x_coords(idx_y_max);
fprintf('最大挠度 y_max: %.4e m (向下为正), 发生在 x = %.2f m\n', y_max_val, x_y_max);

% 左右两端转角
theta_A_deg = C1_val / (E * I) * 180 / pi;
% 计算右端转角 theta_B
% EI * theta_B = R_A * L^2 / 2 - P * (L - a)^2 / 2 + C1_val
EI_theta_B = R_A * L^2 / 2 - P * (L - a)^2 / 2 + C1_val;
theta_B_deg = EI_theta_B / (E * I) * 180 / pi;
fprintf('左端转角 theta_A: %.4f 度 (顺时针为负)\n', theta_A_deg);
fprintf('右端转角 theta_B: %.4f 度 (逆时针为正)\n', theta_B_deg);


% --- 图形绘制 ---
figure('Name', '材料力学分析：简支梁（集中荷载）', 'NumberTitle', 'off', 'WindowState', 'maximized');

% 剪力图 (SFD)
subplot(2,2,1);
% 为了精确绘制剪力图的阶跃，特别处理a点
x_sfd = [0, a, a, L];
% 确保如果a=0或a=L时图形正确
if a == 0
    V_sfd = [R_A-P, R_A-P, R_A-P, R_A-P]; % 实际上是0，然后突降
    if P ~=0 % 荷载在左支点，左支点处剪力从P突降到0
        x_sfd = [0, 0, L];
        V_sfd = [P, 0, 0]; % 假设支座反力向上为P, V(0+)=0
        % 或者更精确地理解为V(0-)到V(0+)的跳变由R_A体现
        % 按标准定义，V(x) = Sum F_y (left segment)
        % V(0+) = R_A-P = 0 if a=0
        % 考虑实际剪力图形状
        plot(x_coords, V, 'r-', 'LineWidth', 1.5);
        hold on;
        plot([0,0],[R_A,R_A-P],'r-','LineWidth',1.5); % 表示在0点的跳变
    else
        plot(x_coords, V, 'r-', 'LineWidth', 1.5); % P=0, V=0
    end
elseif a == L
    V_sfd = [R_A, R_A, R_A, R_A]; % 实际上是R_A，然后在L处突降
    plot(x_coords, V, 'r-', 'LineWidth', 1.5);
    hold on;
    plot([L,L],[R_A,R_A-P],'r-','LineWidth',1.5); % 表示在L点的跳变
else
    V_sfd = [R_A, R_A, R_A-P, R_A-P];
    plot(x_sfd, V_sfd, 'r-', 'LineWidth', 1.5);
end
hold on;
plot([0, L], [0, 0], 'k--'); % 零轴线
title('剪力图 (SFD)');
xlabel('梁的长度 x (m)');
ylabel('剪力 V (N)');
grid on;
ylim([min(V)-abs(0.1*P), max(V)+abs(0.1*P)+eps]); % 调整y轴范围
hold off;

% 弯矩图 (BMD)
subplot(2,2,2);
plot(x_coords, M, 'b-', 'LineWidth', 1.5);
hold on;
plot([0, L], [0, 0], 'k--'); % 零轴线
title('弯矩图 (BMD)');
xlabel('梁的长度 x (m)');
ylabel('弯矩 M (N·m)');
grid on;
hold off;

% 转角图 (theta)
subplot(2,2,3);
plot(x_coords, theta_deg, 'g-', 'LineWidth', 1.5);
hold on;
plot([0, L], [0, 0], 'k--'); % 零轴线
title('转角图 (\theta)');
xlabel('梁的长度 x (m)');
ylabel('转角 \theta (度)');
grid on;
hold off;

% 挠度图 (Deflection)
subplot(2,2,4);
plot(x_coords, y, 'm-', 'LineWidth', 1.5); % y 已经处理为向下为正
hold on;
plot([0, L], [0, 0], 'k--'); % 零轴线
ax = gca;
ax.YDir = 'reverse'; % 使Y轴正方向（代表正的向下挠度）在图中向下显示
title('挠度图 (Deflection)');
xlabel('梁的长度 x (m)');
ylabel('挠度 y (m) (向下为正)');
grid on;
hold off;

sgtitle(sprintf('简支梁分析: L=%.2fm, P=%.1fN  a=%.2fm, E=%.2ePa, I=%.2em^4', L, P, a, E, I), 'FontSize', 14, 'FontWeight', 'bold');

disp('------------------------------------------------------');
end