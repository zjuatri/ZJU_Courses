clear
clc;
format long;

% 定义非线性方程组 F(x)
F_func = @(x) [
    3*x(1) - cos(x(2)*x(3)) - 0.5;
    x(1)^2 - 81*(x(2) + 0.1)^2 + sin(x(3)) + 1.06;
    exp(-x(1)*x(2)) + 20*x(3) + (10*pi - 3)/3
];

% 定义雅可比矩阵 J(x)
J_func = @(x) [
    3,            x(3)*sin(x(2)*x(3)),      x(2)*sin(x(2)*x(3));
    2*x(1),       -162*(x(2)+0.1),          cos(x(3));
    -x(2)*exp(-x(1)*x(2)), -x(1)*exp(-x(1)*x(2)), 20
];

% 初始参数
x_initial = [0.1; 0.1; -0.1]; % 初始猜测值
tol = 1e-6;                   % 精度要求
max_iter = 100;               % 最大迭代次数

fprintf('初始猜测值 x0 = [%.1f, %.1f, %.1f]''\n', x_initial(1), x_initial(2), x_initial(3));
fprintf('精度要求 ||x(k) - x(k-1)||_inf < %e\n\n', tol);

% --- 牛顿迭代法 ---
fprintf('牛顿迭代法:\n');
x_current = x_initial;
iter_count = 0;
err_norm = inf; % 初始化误差范数

for k = 1:max_iter
    Fx = F_func(x_current);
    Jx = J_func(x_current);
    
    % 检查雅可比矩阵是否奇异
    if rank(Jx) < length(x_initial)
        fprintf('雅可比矩阵在第 %d 次迭代时奇异。牛顿法失败。\n', k);
        x_current = nan(size(x_initial)); % 标记失败
        iter_count = k;
        break;
    end
    
    delta_x = Jx \ (-Fx); % 解线性方程组 Jx * delta_x = -Fx
    x_next = x_current + delta_x;
    iter_count = k;
    err_norm = norm(delta_x, inf); % 计算误差 ||x_next - x_current||_inf
    
    x_current = x_next;
    
    if err_norm < tol
        break; % 达到精度要求
    end
    
    if k == max_iter
        fprintf('牛顿法在 %d 次迭代内未收敛。\n', max_iter);
    end
end
results_newton.x = x_current;
results_newton.iter = iter_count;
results_newton.err = err_norm;

fprintf('解: [%.8f, %.8f, %.8f]''\n', results_newton.x(1), results_newton.x(2), results_newton.x(3));
fprintf('迭代次数: %d\n', results_newton.iter);
fprintf('最终误差 ||x(k) - x(k-1)||_inf: %e\n\n', results_newton.err);


% --- 简化牛顿迭代法 ---
fprintf('简化牛顿迭代法:\n');
x_current = x_initial;
iter_count = 0;
err_norm = inf;
J0 = J_func(x_initial); % 计算一次雅可比矩阵 J(x0)

% 检查初始雅可比矩阵是否奇异
if rank(J0) < length(x_initial)
    fprintf('初始雅可比矩阵 J0 奇异。简化牛顿法无法启动。\n');
    results_simp_newton.x = nan(size(x_initial));
    results_simp_newton.iter = 0;
    results_simp_newton.err = inf;
else
    for k = 1:max_iter
        Fx = F_func(x_current);
        delta_x = J0 \ (-Fx); % 使用 J0 求解
        x_next = x_current + delta_x;
        iter_count = k;
        err_norm = norm(delta_x, inf);
        
        x_current = x_next;
        
        if err_norm < tol
            break;
        end
        
        if k == max_iter
            fprintf('简化牛顿法在 %d 次迭代内未收敛。\n', max_iter);
        end
    end
    results_simp_newton.x = x_current;
    results_simp_newton.iter = iter_count;
    results_simp_newton.err = err_norm;
end

fprintf('解: [%.8f, %.8f, %.8f]''\n', results_simp_newton.x(1), results_simp_newton.x(2), results_simp_newton.x(3));
fprintf('迭代次数: %d\n', results_simp_newton.iter);
fprintf('最终误差 ||x(k) - x(k-1)||_inf: %e\n\n', results_simp_newton.err);


% --- 割线法 (Broyden法) ---
fprintf('割线法 (Broyden法):\n');
x_current = x_initial;
iter_count = 0;
err_norm = inf;

B_k = J_func(x_initial);         % 初始化 B0 = J(x0)
Fx_current_val = F_func(x_current); % F(x0)

for k = 1:max_iter
    % 检查 Bk 是否奇异
    if rank(B_k) < length(x_initial)
        fprintf('矩阵 B_k 在第 %d 次迭代时奇异。Broyden法失败。\n', k);
        x_current = nan(size(x_initial));
        iter_count = k;
        break;
    end
    
    delta_x = B_k \ (-Fx_current_val); % 求解 B_k * delta_x = -F(x_k)
    x_next = x_current + delta_x;
    iter_count = k;
    err_norm = norm(delta_x, inf);
    
    if err_norm < tol
        x_current = x_next; % 更新解后退出
        break;
    end
    
    Fx_next_val = F_func(x_next); % F(x_{k+1})
    
    s_k = x_next - x_current; % s_k = delta_x
    y_k = Fx_next_val - Fx_current_val; % y_k = F(x_{k+1}) - F(x_k)
    
    % 更新 B_k -> B_{k+1}
    sksk_inner_product = s_k' * s_k;
    if abs(sksk_inner_product) < eps % 避免除以过小的数
        fprintf('分母 s_k''*s_k (%.2e) 在第 %d 次迭代时过小。Broyden法更新可能不稳定或失败。\n', sksk_inner_product, k);
        x_current = x_next; % 保留当前计算的解
        break;
    end
    B_k = B_k + (y_k - B_k * s_k) * s_k' / sksk_inner_product;
    
    x_current = x_next;
    Fx_current_val = Fx_next_val;
    
    if k == max_iter
        fprintf('Broyden法在 %d 次迭代内未收敛。\n', max_iter);
    end
end
results_broyden.x = x_current;
results_broyden.iter = iter_count;
results_broyden.err = err_norm;

fprintf('解: [%.8f, %.8f, %.8f]''\n', results_broyden.x(1), results_broyden.x(2), results_broyden.x(3));
fprintf('迭代次数: %d\n', results_broyden.iter);
fprintf('最终误差 ||x(k) - x(k-1)||_inf: %e\n\n', results_broyden.err);


% 近似解用于比较 (0.5, 0, -0.52359877) 
approx_sol = [0.5; 0; -0.52359877];
fprintf('\n参考近似解: [%.8f, %.8f, %.8f]''\n', approx_sol(1), approx_sol(2), approx_sol(3));
fprintf('牛顿法与近似解的差的范数: %e\n', norm(results_newton.x - approx_sol, inf));
fprintf('简化牛顿法与近似解的差的范数: %e\n', norm(results_simp_newton.x - approx_sol, inf));
fprintf('割线法与近似解的差的范数: %e\n', norm(results_broyden.x - approx_sol, inf));