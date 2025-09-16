
clear;
clc;

% --- 问题参数 ---
n = 120; % 矩阵维度

% --- 构建系数矩阵 A 和右端向量 b_vec ---
% A 是一个三对角矩阵
main_diag = 2 * ones(n, 1);
sub_diag = -1 * ones(n-1, 1);
super_diag = -1 * ones(n-1, 1);

A = diag(main_diag) + diag(super_diag, 1) + diag(sub_diag, -1);

% 构建 b_vec
b_vec = zeros(n, 1);
b_vec(1) = 1;
for j = 2:n-1
    b_vec(j) = j;
end
b_vec(n) = n;

fprintf('--- 问题 b) --- \n');
% 计算谱半径和条件数 (使用解析特征值)
% 对于 [-1, 2, -1] 类型的三对角矩阵，特征值为 lambda_k = 2 - 2*cos(k*pi/(n+1))
% 这里我们的矩阵对角线是2，次对角线是-1，所以特征值是 2 - 2*cos(k*pi/(n+1))
% k = 1, ..., n
k_vals = (1:n)';
cos_terms = cos(k_vals * pi / (n + 1));
eigenvalues_A = 2 - 2 * cos_terms;

lambda_min_A = min(eigenvalues_A); % 对应 k=1 时，cos 最大
lambda_max_A = max(eigenvalues_A); % 对应 k=n 时，cos 最小 (最负)

% 谱半径 rho(A) = max(|lambda_i|)
% 由于所有特征值 lambda_k = 2 - 2*cos(k*pi/(n+1)) > 0 (因为 cos < 1)
% 所以 rho(A) = lambda_max_A
spectral_radius_A = lambda_max_A;
fprintf('系数矩阵 A 的谱半径: %f\n', spectral_radius_A);

% 条件数 cond_2(A) = lambda_max(A) / lambda_min(A) (因为 A 是对称正定矩阵)
condition_number_A2 = lambda_max_A / lambda_min_A;
fprintf('系数矩阵 A 的条件数 (2-范数): %f\n', condition_number_A2);
fprintf('\n');

fprintf('--- 问题 c) --- \n');
% 迭代法参数
tol = 1e-8;       % 收敛容差
max_iter = 200000;   % 最大迭代次数
x0 = zeros(n, 1); % 初始解向量

% --- c.1) 追赶法  ---
fprintf('求解中 (追赶法)... \n');
x_thomas = thomas_algorithm(diag(A,-1), diag(A), diag(A,1), b_vec);
fprintf('追赶法求解完成。\n');
% disp('追赶法解向量 x_thomas (部分):');
% disp_solution_summary(x_thomas);

% --- c.2) 高斯-塞德尔迭代法  ---
% 矩阵 A 是对称且严格(或弱)对角占优的，因此高斯-塞德尔法收敛。
fprintf('求解中 (高斯-塞德尔法)... \n');
[x_gs, iter_gs] = gauss_seidel(A, b_vec, x0, tol, max_iter);
fprintf('高斯-塞德尔法求解完成，迭代次数: %d\n', iter_gs);
% disp('高斯-塞德尔法解向量 x_gs (部分):');
% disp_solution_summary(x_gs);

% --- c.3) SOR 迭代法 ---
% 计算最优 omega
% rho_BJ 是Jacobi迭代矩阵的谱半径。对于该类型矩阵, rho_BJ = cos(pi/(n+1))
rho_BJ = cos(pi / (n + 1));
omega_opt = 2 / (1 + sqrt(1 - rho_BJ^2)); % omega_opt = 2 / (1 + sin(pi/(n+1)))
fprintf('计算得到的最优松弛因子 omega_opt: %f\n', omega_opt);

fprintf('求解中 (SOR法)... \n');
[x_sor, iter_sor] = sor_method(A, b_vec, omega_opt, x0, tol, max_iter);
fprintf('SOR法求解完成，迭代次数: %d\n', iter_sor);


fprintf('\n--- 解向量摘要 (前3个元素, 中间元素, 后3个元素) ---\n');
fprintf('%15s %15s %15s %15s\n', '索引', '追赶法', '高斯-塞德尔', 'SOR法');
indices_to_show = [1; 2; 3; round(n/2); n-2; n-1; n];
for idx = indices_to_show'
    fprintf('%15d %15.6f %15.6f %15.6f\n', idx, x_thomas(idx), x_gs(idx), x_sor(idx));
end

fprintf('\n--- 解向量之间的差异 (范数) ---\n');
fprintf('norm(x_thomas - x_gs, inf): %e\n', norm(x_thomas - x_gs, inf));
fprintf('norm(x_thomas - x_sor, inf): %e\n', norm(x_thomas - x_sor, inf));
fprintf('norm(x_gs - x_sor, inf): %e\n', norm(x_gs - x_sor, inf));


% --- 函数定义 ---

% 追赶法 
% a: 次对角线 (长度 n-1), A(i,i-1) -> a(i-1) for A's i=2..n
% b: 主对角线 (长度 n)
% c: 超对角线 (长度 n-1), A(i,i+1) -> c(i) for A's i=1..n-1
% d: 右端向量 (长度 n)
function x = thomas_algorithm(a_sub, b_main, c_super, d_rhs)
    N = length(d_rhs);
    cp = zeros(N-1, 1); % 存储修改后的超对角线元素
    dp = zeros(N, 1);   % 存储修改后的右端向量元素
    x = zeros(N, 1);    % 解向量

    % 向前消元
    cp(1) = c_super(1) / b_main(1);
    dp(1) = d_rhs(1) / b_main(1);

    for k = 2:N-1
        denom = b_main(k) - a_sub(k-1) * cp(k-1);
        cp(k) = c_super(k) / denom;
        dp(k) = (d_rhs(k) - a_sub(k-1) * dp(k-1)) / denom;
    end
    
    % 处理 dp 的最后一个元素
    denom_N = b_main(N) - a_sub(N-1) * cp(N-1);
    dp(N) = (d_rhs(N) - a_sub(N-1) * dp(N-1)) / denom_N;

    % 回代求解
    x(N) = dp(N);
    for k = N-1:-1:1
        x(k) = dp(k) - cp(k) * x(k+1);
    end
end

% 高斯-塞德尔迭代法
function [x, iter] = gauss_seidel(A, b, x0, tol, max_iter)
    N = length(b);
    x = x0;
    D = diag(diag(A));
    L = -tril(A, -1);
    U = -triu(A, 1);
    
    % 迭代格式: x_new = inv(D-L) * (U*x_old + b)
    % 或者逐元素更新
    for iter = 1:max_iter
        x_old = x;
        for i = 1:N
            sigma1 = 0;
            if i > 1
                sigma1 = A(i, 1:i-1) * x(1:i-1); % 使用本轮已更新的 x
            end
            sigma2 = 0;
            if i < N
                sigma2 = A(i, i+1:N) * x_old(i+1:N); % 使用上一轮的 x_old
            end
            x(i) = (b(i) - sigma1 - sigma2) / A(i,i);
        end
        
        if norm(x - x_old, inf) < tol
            return;
        end
    end
    warning('高斯-塞德尔法在达到最大迭代次数 %d 后未收敛到容差 %e', max_iter, tol);
end

% SOR 迭代法
function [x, iter] = sor_method(A, b, omega, x0, tol, max_iter)
    N = length(b);
    x = x0;
    
    for iter = 1:max_iter
        x_old = x;
        for i = 1:N
            sigma1 = 0;
            if i > 1
                sigma1 = A(i, 1:i-1) * x(1:i-1); % 使用本轮已更新的 x
            end
            sigma2 = 0;
            if i < N
                sigma2 = A(i, i+1:N) * x_old(i+1:N); % 使用上一轮的 x_old
            end
            
            % 计算当前分量的高斯-塞德尔迭代值
            x_gs_i = (b(i) - sigma1 - sigma2) / A(i,i);
            
            % 应用SOR公式
            x(i) = (1 - omega) * x_old(i) + omega * x_gs_i;
        end
        
        if norm(x - x_old, inf) < tol
            return;
        end
    end
    warning('SOR法在达到最大迭代次数 %d 后未收敛到容差 %e', max_iter, tol);
end
