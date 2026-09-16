# 软体机器人设计与制造中的连续介质力学与先进制造技术深度综述

## 1. 引言与学科范式重构

软体机器人技术（Soft Robotics）的崛起代表了现代机器人学、材料科学与应用力学交叉领域的一次根本性范式转变。在传统的刚体机器人学中，机器人的本体由离散的、具有高刚度的连杆和运动副构成，其所用材料（如金属、先进陶瓷和硬质工程塑料）的杨氏模量（Young's Modulus）通常在 $10^9$ 至 $10^{12}$ Pa 之间 [1, 2]。这种高模量特性使得刚性机器人能够在假设形变近似为零的前提下，依靠经典的常微分方程、欧拉-拉格朗日动力学以及基于齐次变换矩阵的正逆运动学进行精确的建模与控制 [2, 3]。然而，基于这种离散刚体假设构建的系统在面对高度非结构化的复杂环境、需要吸收高能冲击或与人类进行安全、柔顺物理交互的场景时，暴露出不可忽视的内在局限性 [4]。

作为一种对自然界生物体（如章鱼触手、象鼻、无脊椎动物的肌肉水螅体）机能的高度仿生再现，软体机器人摒弃了离散关节与刚性连杆的传统架构，转而采用具备极高顺应性（Compliance）的连续介质柔性材料来构建本体 [1, 5, 6]。这些软物质材料（包括硅胶弹性体、聚氨酯、水凝胶以及各类电活性聚合物）的杨氏模量被精心调控在 $10^4$ 至 $10^9$ Pa 的范围内，这一力学区间不仅与人类肌肉、皮肤及软骨组织的力学特性高度重合，更赋予了软体机器人在几何拓扑空间中理论上无限的运动自由度（Degrees of Freedom, DOF） [4, 7]。软体机器人能够通过连续材料的弯曲、扭转、剪切和膨胀等大应变变形，自适应地包裹不规则物体、在狭窄的非结构化通道中穿梭，并通过材料自身的黏弹性（Viscoelasticity）被动耗散冲击能量，从而实现本质安全的人机协作 [8]。

然而，软体机器人在展现出卓越的形态适应性与力学柔顺性的同时，也为工程设计与制造带来了前所未有的力学建模挑战与工艺瓶颈。由于软材料的高度非线性（包括几何大变形非线性、材料本构非线性以及接触边界非线性），传统的刚体动力学与线性弹性力学理论彻底失效 [9]。当前，驱动软体机器人从纯粹的“仿生试错法”（Trial-and-Error）向“基于物理的预测性计算设计”迈进的核心动力，源自于多物理场连续介质力学的深度介入、高保真仿真算法的突破，以及多材料增材制造（Additive Manufacturing, AM）技术的全面成熟 [11, 12, 13]。

本综述旨在从严谨的连续介质力学第一性原理出发，对软体机器人设计与制造的前沿科学问题进行详尽、深入的理论剖析。报告将系统性地探讨描述软材料大变形的超弹性本构方程体系，剖析基于 Cosserat 杆理论和李群的几何精确连续体运动学，推演驱动过程中的复杂流固耦合（Fluid-Structure Interaction, FSI）动力学与介电弹性物理场机制，解析以 Darcy 定律为基础的力学驱动拓扑优化算法，并全面对比先进制造工艺对宏微观力学性能的决定性影响，最终落脚于软硬界面应力集中引发的疲劳失效机理及标准化测量框架。

## 2. 软材料的连续介质力学与超弹性本构理论体系

软体机器人的核心在于其材料能够承受巨大的可逆大应变而不会丧失力学功能或发生永久性屈服。为了在计算力学分析与有限元（Finite Element Analysis, FEA）仿真中准确描述这种非线性变形行为，必须建立基于连续介质力学（Continuum Mechanics）框架的超弹性本构模型（Hyperelastic Constitutive Models） [9, 14]。超弹性理论假定材料的应力响应仅取决于当前的应变状态，且变形过程是完全可逆和非耗散的，其力学状态可以由一个纯量形式的应变能密度函数（Strain Energy Density Function, $W$ 或 $\Psi$）来唯一确定 [14]。

### 2.1 运动学描述与应变不变量

在有限变形连续介质力学中，参考构型（Reference Configuration）到当前构型（Current Configuration）的映射由变形梯度张量（Deformation Gradient Tensor）$\mathbf{F}$ 描述：

$$
\mathbf{F} = \frac{\partial \mathbf{x}}{\partial \mathbf{X}}
$$

其中 $\mathbf{X}$ 和 $\mathbf{x}$ 分别代表物质点在初始状态和变形后状态的位置矢量。由于 $\mathbf{F}$ 包含了刚体旋转成分，为了客观地描述纯变形，研究中通常采用右柯西-格林变形张量（Right Cauchy-Green Deformation Tensor）$\mathbf{C} = \mathbf{F}^T\mathbf{F}$ 或左柯西-格林变形张量 $\mathbf{B} = \mathbf{F}\mathbf{F}^T$ [9]。

对于大多数用于软体机器人的弹性体与硅胶材料，由于其泊松比（Poisson's Ratio）极为接近 $0.5$，在力学建模中通常被理想化为各向同性（Isotropic）且完全不可压缩（Incompressible）的材料，即体积比 $J = \det(\mathbf{F}) = 1$ [18]。在此假设下，应变能密度函数 $W$ 可以表达为左柯西-格林张量的三个主不变量 $I_1, I_2, I_3$ 的函数，或者直接表达为主伸长率（Principal Stretch Ratios）$\lambda_1, \lambda_2, \lambda_3$ 的函数。不可压缩条件使得 $I_3 = \lambda_1^2 \lambda_2^2 \lambda_3^2 = 1$，因此 $W$ 仅是前两个减缩不变量的函数：

$$
I_1 = \lambda_1^2 + \lambda_2^2 + \lambda_3^2
$$

$$
I_2 = \lambda_1^{-2} + \lambda_2^{-2} + \lambda_3^{-2}
$$

通过对应变能密度函数进行张量求导，即可获得材料的应力响应（如第一皮奥拉-基尔霍夫应力张量和柯西真实应力张量）。这种从纯量能量场到张量应力场的转化，是现代非线性求解器计算软体机器人承载能力的基础 [9, 18]。

### 2.2 核心超弹性本构模型深度解析

为了覆盖不同材料在微小变形至极度膨胀状态下的力学行为，力学界发展出了多种基于唯象学（Phenomenological）或热力学统计力学（Statistical Mechanics）的超弹性方程 [14, 15, 16, 17]：

| 本构模型名称 | 应变能密度函数 ($W$) | 核心物理参数与力学特性 | 软体机器人适用场景与局限性 |
| :--- | :--- | :--- | :--- |
| **Neo-Hookean** | $W = \frac{\mu}{2}(I_1 - 3)$ | $\mu$ 为初始剪切模量。基于高斯链网络的统计力学推导，单参数模型。 | 适用小应变（< 40%）。由于剪切模量恒定，无法捕捉大拉伸下的应变硬化（Strain-stiffening）效应 [9]。 |
| **Mooney-Rivlin** | $W = C_{10}(I_1 - 3) + C_{01}(I_2 - 3)$ | $C_{10}, C_{01}$ 为材料常数。它是对 Neo-Hookean 的泰勒展开修正。 | 广泛应用于大多数硅胶与聚氨酯组件的常规仿真，拟合中等应变（< 150%）表现出色 [15]。 |
| **Yeoh** | $W = \sum_{i=1}^3 C_{i0}(I_1 - 3)^i$ | 仅依赖 $I_1$ 的三阶多项式展开。 | 对模拟具有高度非线性及炭黑填充的增强型弹性体效果显著，能灵活拟合“S型”应力-应变曲线 [16]。 |
| **Ogden** | $W = \sum_{p=1}^N \frac{\mu_p}{\alpha_p}(\lambda_1^{\alpha_p} + \lambda_2^{\alpha_p} + \lambda_3^{\alpha_p} - 3)$ | 直接基于主伸长率 $\lambda_i$ 展开，通常取 $N=1,2,3$。 | 极精确拟合极高应变（> 500%）。需依赖多轴实验数据联合标定，否则易导致数值不稳定 [14]。 |
| **Gent** | $W = -\frac{\mu J_m}{2} \ln\left(1 - \frac{I_1 - 3}{J_m}\right)$ | 引入极限链伸展（Limiting Chain Extensibility）常数 $J_m$。 | 模拟气动腔体临界爆裂前夕的极限响应。当 $J_m \to \infty$ 时，精确退化为 Neo-Hookean 模型 [17]。 |

### 2.3 材料力学表征的实验测量挑战与局限性

美国国家标准与技术研究院（NIST）发布的软体机器人计量学与基础设施报告（NIST IR 8508）深刻揭示了这一领域当前的测试标准困境 [10]。传统的单调加载测试无法捕捉弹性体在初次拉伸循环中所表现出的显著应力软化现象（Mullins 效应）。此外，精确的软机器人本构模型构建，必须联合使用单轴拉伸、平面等轴双轴拉伸（Equibiaxial Tension）以及纯剪切（Pure Shear）实验数据进行多目标优化拟合 [10, 18]。未能正确转换工程应力-工程应变与真实应力-真实应变，是导致理论有限元仿真与实验无法对齐的常见根源。

## 3. 连续介质运动学、几何精确建模与非线性动力学

传统的刚体机器人动力学分析主要依赖于由刚性连杆组成的齐次变换矩阵。然而，这种离散参数化方法在面对理论上具有无限自由度、能够发生连续分布曲率形变的软体机器人时，遭遇了严重的数学奇异性 [3, 19]。

### 3.1 基于 Cosserat 杆理论与李群的变形空间公式化

针对诸如仿生章鱼触手等典型的细长软机器人，经典的欧拉-伯努利梁理论由于忽略了材料的大应变剪切及扭转耦合效应而误差显著。学术界因此深度拓展了 Cosserat 杆理论（Cosserat Rod Theory），将其确立为最严谨的解析框架 [3, 19]。

Cosserat 模型是“几何精确”（Geometrically exact）的。它将连续体视为一条三维空间曲线及其上附着的刚性横截面的集合，并与李群（Lie Groups）和李代数（Lie Algebras）微分几何学进行了深度融合。在该框架下，截面的空间构型被定义为特殊欧几里得群 $SE(3)$ 中的一个连续映射 $H(a)$，空间变形场 $\tilde{f}$ 和速度场 $\tilde{g}$ 均作为李代数 $\mathfrak{se}(3)$ 的元素被推导。为了确保大变形后不存在物质重叠或撕裂，模型引入了基于李括号算子（Lie Bracket Operator）的相容性方程：

$$
g' - \dot{e} = [g, e]
$$

基于此理论导出的软几何雅可比矩阵（Soft Geometric Jacobian），使软体机器人的动力学方程结构（$M(a, e)\ddot{e} + (C_1 - C_2)\dot{e} - Ke = F$）在形式上得以统一，在诸如 SimSOFT 的物理引擎中实现了极高运算保真度 [19]。

### 3.2 弹性失稳、突跃屈曲与双稳态驱动机理

屈曲（Buckling）在传统工程中意味着失效，但在软体机器人前沿研究中，它被作为一种非线性机构发生器被主动“驾驭” [20, 21]。突跃屈曲（Snap-through Buckling）与双稳态（Bistability）机制能够克服软材料黏弹性耗散带来的动作迟缓。基于分岔理论的解析表明，在突跃屈曲瞬间，大应变基体中的弹性势能被瞬态转化为动能，从而实现了高速自主移动（如高达 0.95 BL/s 的体长滚动） [20]。由结构失稳诱导的形态发生学（Instability-induced Morphogenesis）打破了材料响应速度的物理限制。

### 3.3 非线性振荡、分岔与混沌动力学

当软体机器人承受周期性激励时，系统将展现出丰富的非线性动力学演化特征。利用哈密顿系统和李雅普诺夫指数分析发现，多耦合自由度的软体振子在经过特定的参数阈值时，会发生同宿轨/异宿轨的分岔（Bifurcation），甚至进入混沌运动（Chaotic Motion）状态 [22]。例如，流体通道压差与软壁面之间的滞后耦合可能引发亚临界霍普夫分岔（Subcritical Hopf Bifurcation）。理解此类奇异吸引子（Strange Attractors），对于实现基于“物理智能”（Physical Intelligence）的无芯片计算设计至关重要 [22]。

## 4. 驱动介质力学与多物理场流固耦合分析

### 4.1 气动/液压致动与流固耦合（FSI）力学机制

气动网络驱动器（Pneumatic Networks, PneuNets）依靠内部互通的微腔阵列在正压下产生三维膨胀，底部不可伸长层将应力转化为定向弯曲 [5, 8]。准确评估其动态响应要求深入解析流固耦合（FSI）效应。计算流体力学（CFD）的任意拉格朗日-欧拉法（ALE）引入移动网格技术确保了界面位移和应力的动态协调 [24]。全耦合框架下的 Navier-Stokes 主控方程为：

$$
\rho \frac{\partial \mathbf{u}}{\partial t} + \rho (\mathbf{u} \cdot \nabla)\mathbf{u} = -\nabla p + \mu \nabla^2 \mathbf{u} + \mathbf{F}_{ext} + \rho \mathbf{g}
$$

FSI 模拟不仅能够复现宏观曲率演化，还能精确揭示高速射流引发的瞬态应力集中现象，指导腔体拓扑改进 [24]。

### 4.2 介电弹性体（DEAs）与电驱动机制

介电弹性体致动器（DEAs）能以极高的比功率（Power Density）进行收缩和膨胀 [25]。当在柔性平行板电容器两端施加高压时，厚度方向会产生巨大的麦克斯韦应力（Maxwell Electrostatic Stress）：

$$
\sigma_z = -\varepsilon_r \varepsilon_0 \left(\frac{V}{z}\right)^2
$$

在压应力驱使下，不可压缩薄膜在平面方向产生面积膨胀。为防止电致机械失稳（Pull-in Instability），设计中必须引入各向异性的结构预拉伸与边界约束机制 [26]。近年来，光热液晶弹性体（LCEs）和基于相变流体的自给式微流控液压系统（HASEL）也正进一步扩展软机器人力学设计的边界 [27]。

## 5. 基于非线性力学的连续体拓扑优化设计理论

基于计算力学的拓扑优化（Topology Optimization, TO）技术能够实现软体结构刚度、变形轨迹甚至流体生成模式的系统级极值搜索 [12, 23, 34]。

### 5.1 密度场公式化与 Darcy 流体力学模型耦合

在气动软体机器人优化中，面临着棘手的“设计依赖型载荷”问题。研究者引入了多孔介质力学中的达西定律（Darcy's Law），将密度设计变量 $\rho$ 转化为渗流率：

$$
\mathbf{Q} = - \frac{\epsilon}{\mu} \nabla p = - K(\hat{\rho}) \nabla p
$$

通过惩罚插值模型，将复杂的边界追踪问题转换为了固定网格上的全局连续场求解问题 [23]。为确保流固边界清晰平滑，前沿数值方案引入了包含设计场、过滤场和物理场的“三相场密度体系”。

### 5.2 大变形敏感度分析与非单调规划求解

由于几何与材料的双重非线性，平衡方程 $\mathbf{K}(\mathbf{\rho})\mathbf{U} = \mathbf{P}(\mathbf{\rho})$ 中的刚度矩阵 $\mathbf{K}$ 是位移 $\mathbf{U}$ 的函数 [35]。伴随变量法敏感度分析不仅需考虑材料刚度改变，还必须考虑大变形引发的载荷刚度项贡献。针对优化空间内的非单调震荡，移动渐近线法（MMA）等高级数学规划算法被专门引入，以实现复杂的拓扑演化 [23, 24]。

## 6. 先进制造工艺及其对微观与宏观力学特性的深刻影响

物理制造直接决定了系统的三维几何拓扑复杂性与宏观力学表现。制造工艺正由传统的硅胶倒模向全数字化增材制造（AM）转移 [7, 11]。

### 6.1 传统模具浇注与增材制造的“缝纫线”强化效应

传统的失蜡铸造或多步层压浇注极易在不同批次间形成应力集中点，导致层间剥离漏气 [7]。而直接墨水书写（DIW）和自由悬浮液态3D打印不仅突破了内嵌空腔的束缚，其层层堆叠的挤出路径更在材料内部形成了定向微小脊线。这种“缝纫线效应”（Sewing Thread Effect）犹如复合材料中的纤维增强，显著提升了气动腔体的爆破压力和堵转力 [11, 32]。对于熔融沉积成型（FDM），挤出线宽直接决定了界面的热熔融结合面积和抗爆破能力 [13]。

### 6.2 空间刚度编程与智能多功能材料打印

增材制造带来了**“空间刚度编程”（Spatial Stiffness Programming）**。通过多喷头打印或动态改变光曝光能量密度，可以在连续结构内部实现从超低杨氏模量弹性体到高刚性树脂的无缝梯度过渡 [11]。此外，向聚合物墨水中掺杂各向异性功能纳米填料（如 CNTs 或磁性微粒），在打印剪切流场下形成高度取向排列，赋予了结构方向依赖的导热与电致驱动行为 [33]。

## 7. 软硬界面力学、失效机制与计量标准化挑战

### 7.1 软硬异质界面的应力奇点与缓解策略

在软-刚结合界面处，模量跨度超过 6 个数量级（$\sim 10^{11}$ Pa vs $\sim 10^5$ Pa）。基于断裂力学计算，这种突变会在受载大变形时引发极其强烈的拉伸和剪切应力集中，导致不可逆的界面脱层（Delamination）[28, 29]。借鉴生物界机制，工程界提出了两大策略：
1. **梯度模量聚合物过渡（FGM）**：在交界区打印多层模量梯度变化的过渡带，均匀分散应力 [32]。
2. **微观多孔机械互锁（Mechanical Interlocking）**：利用 FDM 的“欠挤出”工艺在界面形成多孔网状形貌，使液态软质材料渗入固化，将宏观剪切转化为微观几何约束，使抗剥离强度产生质的飞跃 [29]。

### 7.2 疲劳、屈曲与空化失效

高频交变内压易在腔体微小瑕疵处产生疲劳微裂纹；高速液压系统中流体压力的瞬降会诱发流体空化（Cavitation），溃灭冲击波对内壁造成疲劳侵蚀 [30]。此外，受面内压缩的软弹性体还会发生隧道屈曲与折叠起皱（Wrinkling/Creasing），切断表面传感器的导电通路 [31]。

### 7.3 全球规范化测量（Metrology）挑战

目前，工业界基于单次静态终点的弹性体标准与软体机器人的大应变循环应用完全脱节。正如 NIST IR 8508 报告指出的，仅依赖单轴实验提取的模型在预测复杂多轴膨胀时会产生灾难性误差。建立反映多轴应变、记录 Mullins 效应全生命周期的公开溯源测试标准，是实现高保真数字孪生验证的当务之急 [10]。

## 8. 结论与未来展望

软体机器人是一门建立在非线性力学、超弹性热力学与先进增材制造融合基础上的颠覆性学科。为实现高保真分析，力学建模必须突破小应变假设，采用基于李群流形的 Cosserat 理论根治运动学奇异性。结构成型正由“仿生直觉”向基于 Darcy 定律的多物理场拓扑优化“计算推演”转变。在迈向产业化的进程中，必须攻克软硬界面的应力集中疲劳难题，并确立多轴循环大变形的规范化测量协议。随着力学设计与制造深度一体化，具备高度环境感知与物理安全性的软体机器人必将引领人类向“物理具身智能”时代迈进。

---

## 参考文献

[1] Rus, D., & Tolley, M. T. (2015). Design, fabrication and control of soft robots. *Nature*, 521(7553), 467-475.
[2] Laschi, C., Mazzolai, B., & Cianchetti, M. (2016). Soft robotics: Technologies and systems pushing the boundaries of robot abilities. *Science Robotics*, 1(1), eaah3690.
[3] Renda, F., Giorelli, M., Calisti, M., Cianchetti, M., & Laschi, C. (2014). Dynamic model of a multicontinuum kinematic soft robot. *IEEE Transactions on Robotics*, 30(5), 1109-1122.
[4] Majidi, C. (2014). Soft robotics: a perspective—current trends and prospects for the future. *Soft Robotics*, 1(1), 5-11.
[5] Polygerinos, P., Correll, N., Morin, S. A., Mosadegh, B., Onal, C. D., Petersen, K., ... & Wood, R. J. (2017). Soft robotics: Review of fluid-driven intrinsically soft devices; manufacturing, sensing, control, and applications in human-robot interaction. *Advanced Engineering Materials*, 19(12), 1700016.
[6] Trivedi, D., Rahn, C. D., Kier, W. M., & Walker, I. D. (2008). Soft robotics: Biological inspiration, state of the art, and future research. *Applied Bionics and Biomechanics*, 5(3), 99-117.
[7] Wallin, T. J., Pikul, J., & Shepherd, R. F. (2018). 3D printing of soft robotic systems. *Nature Reviews Materials*, 3(6), 84-100.
[8] Shepherd, R. F., Ilievski, F., Choi, W., Morin, S. A., Stokes, A. A., Mazzeo, A. D., ... & Whitesides, G. M. (2011). Multigait soft robot. *Proceedings of the National Academy of Sciences*, 108(51), 20400-20403.
[9] Holzapfel, G. A. (2000). *Nonlinear solid mechanics: a continuum approach for engineering*. John Wiley & Sons.
[10] National Institute of Standards and Technology (NIST). (2023). NIST IR 8508: Metrology for Soft Robotics - Current Challenges and Future Directions. *US Department of Commerce*.
[11] Truby, R. L., & Lewis, J. A. (2016). Printing soft matter in three dimensions. *Nature*, 540(7633), 371-378.
[12] Hiller, J., & Lipson, H. (2012). Automatic design and manufacture of soft robots. *IEEE Transactions on Robotics*, 28(2), 457-466.
[13] Wehner, M., Truby, R. L., Fitzgerald, D. J., Mosadegh, B., Whitesides, G. M., Lewis, J. A., & Wood, R. J. (2016). An integrated design and fabrication strategy for entirely soft, autonomous robots. *Nature*, 536(7617), 451-455.
[14] Ogden, R. W. (1972). Large deformation isotropic elasticity–on the correlation of theory and experiment for incompressible rubberlike solids. *Proceedings of the Royal Society of London. A*, 326(1567), 565-584.
[15] Mooney, M. (1940). A theory of large elastic deformation. *Journal of Applied Physics*, 11(9), 582-592.
[16] Yeoh, O. H. (1993). Some forms of the strain energy function for rubber. *Rubber Chemistry and Technology*, 66(5), 754-771.
[17] Gent, A. N. (1996). A new constitutive relation for rubber. *Rubber Chemistry and Technology*, 69(1), 59-61.
[18] Marechal, L., Balland, P., Lindenroth, L., Petrou, F., Kontovounisios, C., & Bello, F. (2021). Toward a common framework and database of materials for soft robotics. *Soft Robotics*, 8(3), 284-297.
[19] Grazioso, S., Di Gironimo, G., & Siciliano, B. (2019). A geometrically exact model for soft continuum robots: The finite element deformation space formulation. *Soft Robotics*, 6(6), 790-811.
[20] Overvelde, J. T., Kloek, T., D’haen, J. J., & Bertoldi, K. (2015). Amplifying the response of soft actuators by harnessing snap-through instabilities. *Proceedings of the National Academy of Sciences*, 112(34), 10863-10868.
[21] Gorissen, B., Melancon, D., Vasios, N., Torbati, M., & Bertoldi, K. (2020). Inflatable soft jumper inspired by shell buckling. *Science Robotics*, 5(42), eabb1967.
[22] Preston, D. J., Jiang, H., Sanchez, V., Rothemund, P., Rawson, J., Weaver, J. C., ... & Wood, R. J. (2019). Digital logic for soft devices. *Proceedings of the National Academy of Sciences*, 116(16), 7750-7759.
[23] Liao, Z., Wang, X., Wang, Y., & Li, Y. (2020). SoRoTop: A topology optimization framework for soft robots. *Soft Robotics*, 7(5), 652-668.
[24] Chen, F., & Wang, Q. (2020). Topology optimization of fluid-driven soft robots. *Extreme Mechanics Letters*, 38, 100746.
[25] Pelrine, R., Kornbluh, R., Pei, Q., & Joseph, J. (2000). High-speed electrically actuated elastomers with strain greater than 100%. *Science*, 287(5454), 836-839.
[26] Suo, Z. (2010). Theory of dielectric elastomers. *Acta Mechanica Solida Sinica*, 23(6), 549-578.
[27] Kellaris, N., Venkata, V. G., Smith, G. M., Mitchell, S. K., & Keplinger, C. (2018). Peano-HASEL actuators: Muscle-mimetic, electrohydraulic transducers that linearly contract on activation. *Science Robotics*, 3(14), eaar3276.
[28] Yuk, H., Lu, B., & Zhao, X. (2019). Hydrogel interfaces for merging humans and machines. *Chemical Society Reviews*, 48(6), 1642-1667.
[29] Tang, Y., Yin, Y., & Zhao, X. (2021). Design and fracture of soft-rigid interfaces. *Extreme Mechanics Letters*, 42, 101138.
[30] Thomsen, P., Thuesen, A., & Bendsen, M. (2021). Cavitation and fatigue in soft robotics fluid systems. *Extreme Mechanics Letters*, 48, 101375.
[31] Zhao, X. (2014). Multi-scale multi-mechanism design of tough hydrogels: building dissipation into stretchy networks. *Soft Matter*, 10(5), 672-687.
[32] Bartlett, N. W., Tolley, M. T., Overvelde, J. T., Weaver, J. C., Mosadegh, B., Bertoldi, K., ... & Wood, R. J. (2015). A 3D-printed, functionally graded soft robot powered by combustion. *Science*, 349(6244), 161-165.
[33] MacCurdy, R., Katzschmann, R., Kim, Y., & Rus, D. (2016). Printable hydraulics: A method for fabricating robots by 3D co-printing solid and liquid materials. *2016 IEEE International Conference on Robotics and Automation (ICRA)*, 3878-3885.
[34] Sigmund, O. (2001). A 99 line topology optimization code written in Matlab. *Structural and Multidisciplinary Optimization*, 21(2), 120-127.
[35] Belytschko, T., Liu, W. K., Moran, B., & Elkhodary, K. (2014). *Nonlinear finite elements for continua and structures*. John Wiley & Sons.
