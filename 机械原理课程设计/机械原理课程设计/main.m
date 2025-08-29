%% 设置参数
% 双曲柄机构ABCD的杆长参数（单位：mm）
LAB = 116;  % 曲柄AB的长度
LBC = 100;  % 连杆BC的长度
LCD = 100;  % 摇杆CD的长度
LDA = 37;   % 机架DA的长度

% 第二个机构GHMN的杆长参数（单位：mm）
LGH = 100;  % 杆GH的长度
LHM = 100;  % 杆HM的长度
LMN = 95;   % 杆MN的长度
LNG = 40;   % 杆NG的长度

% 其他机构参数
m = 4;      % 质量参数
r3 = 136;   % 半径参数3
r4 = 136;   % 半径参数4
r8 = 100;   % 半径参数8
e = 50;     % 偏心距（单位：mm）
LEF = 520;  % 杆EF的长度（单位：mm）
a_CDE = 177/360*2*pi;  % 角度CDE（弧度制）

% 基圆和滚子半径参数
rb = 90;    % 基圆半径（单位：mm）
rg = 25;    % 滚子半径（单位：mm）

% 运动参数
omiga = 4500/3600*2*pi;  % 曲柄角速度：4500转/分钟转换为弧度/秒

% 初始角度设置（弧度制）
Fai_GH0 = 57.109/360*2*pi;   % 杆GH的初始角度
Fai_AB0 = 115.66/360*2*pi;   % 曲柄AB的初始角度

% 主循环：计算360度范围内的机构运动
for i = 1:360
    Fai = i-1;                    % 当前计算角度（度）
    Fai_AB = Fai/360*2*pi;        % 将角度转换为弧度制
    
    %% 双曲柄ABCD求解 
    % 调用曲柄摇杆机构求解函数，计算CD杆的角位移和角速度
    [theta,omega] = crank_rocker(Fai_AB+Fai_AB0,omiga,LAB,LBC,LCD,LDA);
    
    % 存储计算结果
    theta_CD_list(i,2) = theta/pi*180;  % 将弧度转换为度并存储
    theta_CD_list(i,1) = Fai;           % 存储对应的输入角度
    omega_CD = omega(2);                % CD杆的角速度
    
    %% 曲柄滑块DEF求解
    % [s,v] = slider_crank()  % 待完善的滑块机构求解
end

% 对角位移数据进行相对化处理，以初始位置为零点
theta_CD_list(:,2) = theta_CD_list(:,2)-theta_CD_list(1,2);

% 曲柄摇杆机构求解函数
function [theta3,omega] = crank_rocker(theta1,omega1,l1,l2,l3,l4)
    % 输入参数：
    % theta1 - 曲柄转角（弧度）
    % omega1 - 曲柄角速度（弧度/秒）
    % l1,l2,l3,l4 - 各杆长度
    % 输出参数：
    % theta3 - 摇杆角位移
    % omega - 各杆角速度向量
    
    %计算角位移
    L = sqrt(l4*l4+l1*l1-2*l1*l4*cos(theta1));
    phi = asin((l1./L)*sin(theta1)); %phi 记录直线BD到AD的角
    if l1>L  %l1为最长边时phi为钝角
        phi = pi/2-phi;
    end
    beta = acos((-l2*l2+l3*l3+L*L)/(2*l3*L)); %beta 记录直线CD到BD的角
    if theta1 > pi
        phi = -phi;
    end
    theta3 = pi - phi -beta;
    theta2 = asin((l3*sin(theta3)-l1*sin(theta1))/l2);
    %计算角速度
    A  = [-l2*sin(theta2),l3*sin(theta3);
            l2*cos(theta2),-l3*cos(theta3)];
    B = [l1*sin(theta1);-l1*cos(theta1)];
    omega = A\(omega1*B);
end

% 曲柄滑块机构求解函数
function [s3,v3] = slider_crank(theta1,omega1,l1,l2,e)
    % 输入参数：
    % theta1 - 曲柄转角（弧度）
    % omega1 - 曲柄角速度（弧度/秒）
    % l1,l2 - 曲柄和连杆长度
    % e - 偏心距
    % 输出参数：
    % s3 - 滑块位移
    % v3 - 滑块速度
    
    % 计算线位移
    theta2 = asin((e-l1*sin(theta1))/l2);    % 连杆与水平线夹角
    s3 = l1*cos(theta1)*l2*cos(theta2);      % 滑块位移计算（此处公式需要验证）

    % 计算线速度
    % 建立速度方程组矩阵
    A = [l2*sin(theta2),1;         % 速度约束矩阵
         -l2*cos(theta2),0];
    B = [-l1*sin(theta1);          % 已知项向量
         l1*cos(theta1)];
    omega = A\(omega1*B);          % 求解角速度和线速度
    v3 = omega(2);                 % 提取滑块线速度
end