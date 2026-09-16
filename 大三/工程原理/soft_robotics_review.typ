// ============================================================
// 软体机器人设计与制造文献综述 — Typst 源文件
// 作者：徐屹寒  浙江大学机械工程学院，杭州 310027
// 内容仅基于仓库现有文档，不引入外部材料。
// ============================================================

// ---------- 全局页面设置 ----------
#set page(
  paper: "a4",
  margin: (top: 25mm, bottom: 25mm, left: 20mm, right: 20mm),
  numbering: "1",
  number-align: center,
)
#set text(font: ("SimSun", "Times New Roman"), size: 10.5pt, lang: "zh")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  set text(size: 11pt, weight: "bold")
  block(above: 1.2em, below: 0.6em, it)
}
#show heading.where(level: 2): it => {
  set text(size: 10.5pt, weight: "bold")
  block(above: 0.9em, below: 0.8em, it)
}

// ---------- 首页（单栏） ----------
#align(center)[
  #v(6mm)
  // 中文标题
  #text(size: 16pt, weight: "bold")[
    软体机器人设计与制造：\
    连续介质力学与先进制造技术综述
  ]
  #v(3mm)
  // 中文作者 & 单位
  #text(size: 10.5pt)[徐屹寒]
  #v(1mm)
  #text(size: 9.5pt)[（浙江大学机械工程学院，杭州 310027）]
  #v(5mm)
]

// 中文摘要
#block(
  inset: (left: 10mm, right: 10mm),
  [
    #text(weight: "bold")[摘　要：]
    软体机器人以高柔顺性弹性材料为本体，能够实现大变形、多自由度运动及本质安全的人机交互，代表了机器人学与材料力学交叉的前沿领域。本文从连续介质力学第一性原理出发，系统综述软体机器人设计与制造的核心科学问题。主要内容涵盖：描述大应变行为的超弹性本构模型（Neo-Hookean、Mooney-Rivlin、Yeoh、Ogden、Gent）及其实验表征挑战；基于 Cosserat 杆理论与李群的几何精确运动学；气动网络流固耦合（FSI）与介电弹性体（DEA）的多物理场机制；以 Darcy 定律为基础的拓扑优化方法；模具浇注与增材制造（DIW、DLP、FDM）对宏微观力学性能的影响；以及软硬界面应力集中的失效机理与计量标准化挑战。综述指出，力学建模必须突破小应变假设，结构成型正由经验仿生向多物理场计算设计演进，而建立规范化测量协议是软体机器人工程化的当务之急。

    #v(1mm)
    #text(weight: "bold")[关键词：]
    软体机器人；超弹性本构；连续介质力学；气动网络；增材制造；拓扑优化；软硬界面
  ]
)

#v(4mm)

// 英文标题
#align(center)[
  #text(size: 13pt, weight: "bold", font: "Times New Roman")[
    Soft Robotics Design and Manufacturing:\
    A Review of Continuum Mechanics and Advanced Fabrication Technologies
  ]
  #v(2mm)
  #text(size: 10pt, font: "Times New Roman")[XU Yihan]
  #v(1mm)
  #text(size: 9pt, font: "Times New Roman")[
    (School of Mechanical Engineering, Zhejiang University, Hangzhou 310027, China)
  ]
  #v(3mm)
]

// 英文摘要
#block(
  inset: (left: 10mm, right: 10mm),
  [
    #text(weight: "bold", font: "Times New Roman")[Abstract: ]
    #text(font: "Times New Roman")[
      Soft robots, constructed from highly compliant elastic materials, are capable of large deformations, multi-degree-of-freedom motions, and intrinsically safe human-robot interaction, representing a frontier at the intersection of robotics and mechanics of materials. Starting from first principles of continuum mechanics, this paper systematically reviews the core scientific issues in soft robot design and manufacturing. Topics covered include: hyperelastic constitutive models for large-strain behavior (Neo-Hookean, Mooney-Rivlin, Yeoh, Ogden, Gent) and associated experimental characterization challenges; geometrically exact kinematics based on Cosserat rod theory and Lie groups; multi-physics mechanisms of pneumatic network fluid-structure interaction (FSI) and dielectric elastomer actuators (DEAs); topology optimization methods grounded in Darcy's law; the influence of molding and additive manufacturing (DIW, DLP, FDM) on macro- and micro-scale mechanical properties; and failure mechanisms at soft-rigid interfaces along with metrology standardization challenges. The review argues that mechanical modeling must move beyond small-strain assumptions, structural formation is evolving from empirical biomimicry toward multi-physics computational design, and establishing standardized measurement protocols is imperative for the engineering maturation of soft robotics.
    ]
    #v(1mm)
    #text(weight: "bold", font: "Times New Roman")[Keywords: ]
    #text(font: "Times New Roman")[
      soft robotics; hyperelastic constitutive model; continuum mechanics; pneumatic networks; additive manufacturing; topology optimization; soft-rigid interface
    ]
  ]
)

#v(6mm)
#line(length: 100%, stroke: 0.5pt)
#v(4mm)

// ---------- 正文（双栏） ----------
#columns(2, gutter: 5mm)[

// ===== 1. 引言 =====
= 引言

传统刚体机器人以金属或工程塑料构成的刚性连杆为本体，其杨氏模量通常处于 $10^9$ 至 $10^{12}$ Pa 区间，依靠欧拉-拉格朗日动力学和齐次变换矩阵实现精确运动控制 [1,2]。然而，面对非结构化环境下的碰撞吸收与柔顺人机交互，刚性系统存在本质局限 [4]。

软体机器人以仿生学为出发点，摒弃了刚性连杆与离散关节，转而采用杨氏模量处于 $10^4$ 至 $10^9$ Pa 范围内的柔性连续介质材料——包括硅胶弹性体、聚氨酯、水凝胶及电活性聚合物——构建具有理论上无限自由度的机器体 [1,4,5]。这一力学区间与人体肌肉及软骨高度重合，赋予机器人自适应包裹、穿越狭窄通道以及被动耗散冲击能量的能力 [8]。

然而，软材料的高度非线性（几何大变形非线性、材料本构非线性与接触边界非线性并存）使传统刚体动力学与线性弹性力学彻底失效 [9]。推动软体机器人从"仿生试错"走向"基于物理的预测性计算设计"的核心动力，来自多物理场连续介质力学的深度介入、高保真仿真算法的突破，以及多材料增材制造（AM）技术的全面成熟 [11,12,13]。本文围绕上述核心命题，系统梳理软体机器人设计与制造的力学理论框架与前沿进展。


// ===== 2. 软材料超弹性本构理论 =====
= 软材料超弹性本构理论

== 运动学描述与应变不变量

在有限变形连续介质力学框架中，参考构型到当前构型的映射由变形梯度张量 $bold(F) = (partial bold(x))/(partial bold(X))$ 描述 [9]。为客观描述纯变形，常采用右柯西-格林变形张量 $bold(C) = bold(F)^T bold(F)$。

对于泊松比接近 $0.5$ 的近不可压缩弹性体（$J = det(bold(F)) = 1$），应变能密度函数 $W$ 仅依赖前两个减缩主不变量 [18]：

$ I_1 = lambda_1^2 + lambda_2^2 + lambda_3^2, quad I_2 = lambda_1^(-2) + lambda_2^(-2) + lambda_3^(-2) $

通过对 $W$ 进行张量求导可获得柯西真实应力，这是现代非线性有限元求解器的基础 [9,18]。

== 核心超弹性模型对比

不同本构模型适用于不同应变范围与材料体系 [14,15,16,17]：

- *Neo-Hookean*：$W = mu/2 (I_1 - 3)$，单参数，适用于小应变（$<40%$），无法捕捉大拉伸下的应变硬化效应 [9]。
- *Mooney-Rivlin*：$W = C_(10)(I_1-3) + C_(01)(I_2-3)$，适用于中等应变（$<150%$），广泛用于硅胶与聚氨酯仿真 [15]。
- *Yeoh*：$W = sum_(i=1)^3 C_(i 0)(I_1-3)^i$，仅依赖 $I_1$，能灵活拟合"S型"应力-应变曲线，适合炭黑填充增强弹性体 [16]。
- *Ogden*：$W = sum_p mu_p/alpha_p (lambda_1^(alpha_p)+lambda_2^(alpha_p)+lambda_3^(alpha_p)-3)$，极精确拟合超高应变（$>500%$），但需多轴数据联合标定 [14]。
- *Gent*：$W = -mu J_m/2 ln(1-(I_1-3)/J_m)$，引入极限链伸展常数 $J_m$，适合模拟气动腔体临界爆裂前的极限响应 [17]。

以上五类模型的适用范围、参数数量与主要特点汇总如表 1 所示。

#figure(
  kind: table,
  table(
    columns: (2fr, 1.5fr, 0.7fr, 2.8fr),
    stroke: 0.5pt,
    inset: 4pt,
    align: (left, center, center, left),
    [*模型*], [*适用应变范围*], [*参数数*], [*主要特点与局限*],
    [Neo-Hookean], [$<40%$], [1], [单参数，计算高效；不能描述应变硬化],
    [Mooney-Rivlin], [$<150%$], [2], [适合硅胶/聚氨酯；拟合中等应变],
    [Yeoh], [中/大应变], [3], [可拟合 S 型曲线；无需双轴数据],
    [Ogden], [$>500%$], [$2n$], [精度最高；需多轴联合标定],
    [Gent], [近极限伸展], [2], [含链伸展极限参数；适合爆裂预测],
  ),
  caption: [核心超弹性本构模型对比 [9,14,15,16,17]],
)

#figure(
  image("1.png", width: 100%),
  caption: [单轴拉伸试验下各类超弹性本构模型拟合曲线对比（引自文献 [36]）],
)

== 实验表征挑战

NIST IR 8508 报告指出：传统单调加载测试无法捕捉 Mullins 效应；精确本构标定需联合单轴拉伸、等轴双轴拉伸与纯剪切实验；工程应力与真实应力之间的误差转换是有限元仿真与实验对不齐的常见根源 [10,18]。


// ===== 3. 连续体运动学与非线性动力学 =====
= 连续体运动学与非线性动力学

== Cosserat 杆理论与李群框架

针对细长软体机器人，欧拉-伯努利梁理论因忽略大应变剪切及扭转耦合而误差显著。学术界因此深度拓展了 Cosserat 杆理论（Cosserat Rod Theory），将其确立为最严谨的解析框架 [3,19]。

该模型将连续体视为三维空间曲线上附着刚性横截面的集合，与李群（Lie Groups）和李代数（Lie Algebras）微分几何深度融合。截面空间构型被定义为特殊欧几里得群 $S E(3)$ 中的连续映射，变形场与速度场均作为李代数 $frak(s e)(3)$ 的元素推导。模型引入基于李括号算子的相容性方程：

$ bold(g)' - dot(bold(e)) = [bold(g), bold(e)] $

基于此推导的软几何雅可比矩阵，使软体机器人动力学方程统一为 $M(a,e) dot.double(e) + (C_1 - C_2) dot(e) - K e = F$ 的结构形式，在 SimSOFT 等物理引擎中实现了高保真仿真 [19]。

#figure(
  image("2.png", width: 100%),
  caption: [基于 Cosserat 理论的软体连续体机器人运动学建模示意图：包含全局空间变形（左）、中心线参数化（中）及基于李群的局部坐标系演化（右）（引自文献 [37]）],
)

== 弹性失稳与双稳态驱动

屈曲在传统工程中意味着失效，但在软体机器人设计中被主动利用。突跃屈曲（Snap-through Buckling）将大应变基体中存储的弹性势能瞬态转化为动能，使机器人实现高速自主运动（如高达 0.95 BL/s 的体长滚动） [20]。双稳态机构通过能量势垒实现形态保持，无需持续能量输入 [21]。

== 非线性动力学与混沌行为

当软体机器人受到周期性激励时，多耦合自由度的软体振子可能在特定参数阈值处发生同宿轨分岔（Bifurcation），进入混沌运动（Chaotic Motion）状态 [22]。例如，流体通道压差与软壁面的滞后耦合可引发亚临界霍普夫分岔（Subcritical Hopf Bifurcation）。理解此类奇异吸引子，对实现基于"物理智能"（Physical Intelligence）的无芯片计算设计至关重要 [22]。


// ===== 4. 驱动介质力学与多物理场耦合 =====
= 驱动介质力学与多物理场耦合

== 气动网络与流固耦合

气动网络驱动器（PneuNets）依靠内部互通微腔阵列在正压下产生三维膨胀，底部不可伸长层将应力转化为定向弯曲 [5,8]。计算流体力学（CFD）的任意拉格朗日-欧拉法（ALE）引入移动网格技术，确保流固界面的位移与应力动态协调 [24]。全耦合 Navier-Stokes 方程为：

$ rho (partial bold(u))/(partial t) + rho (bold(u) dot nabla) bold(u) = -nabla p + mu nabla^2 bold(u) + bold(F)_"ext" + rho bold(g) $

流固耦合（FSI）仿真不仅能复现宏观曲率演化，还能精确揭示高速射流引发的瞬态应力集中现象 [24]。对于水下软体机器人，通常需要双向 FSI 才能较准确地预测游动效率 [5]。

== 介电弹性体（DEA）与电驱动

介电弹性体致动器（DEAs）具有极高的比功率。在柔性平行板电容器两端施加高压时，厚度方向产生麦克斯韦应力（Maxwell Electrostatic Stress）[25]：

$ sigma_z = -epsilon_r epsilon_0 (V/z)^2 $

不可压缩薄膜因此在平面方向产生面积膨胀。为防止电致机械失稳（Pull-in Instability），设计中必须引入各向异性预拉伸与边界约束机制 [26]。液晶弹性体（LCEs）和基于相变流体的 HASEL 执行器进一步扩展了软机器人力学设计的边界 [27]。

== 颗粒阻塞与变刚度

颗粒阻塞（Granular Jamming）利用密闭弹性腔内离散颗粒在真空下的机械互锁效应，实现材料从流体态到固体态的相变刚化。准确仿真该系统需要混合 FEM-DEM 框架：DEM 捕捉微观粒子级的力链演化，FEM 处理外部弹性薄膜的超弹性变形边界条件 [12]。

上述各类驱动方式的核心机制与适用场景对比见表 2。

#figure(
  kind: table,
  table(
    columns: (2.2fr, 3fr, 2.5fr),
    stroke: 0.5pt,
    inset: 4pt,
    align: (left, left, left),
    [*驱动方式*], [*核心力学机制*], [*主要优势 / 局限*],
    [气动网络\ (PneuNets)], [内压膨胀＋约束层诱导弯曲], [低成本、生物相容；响应较慢、依赖气源],
    [介电弹性体\ (DEA)], [麦克斯韦应力驱动平面膨胀], [比功率高、快速响应；需高压、易失稳],
    [液晶弹性体\ (LCE)], [热/光触发分子取向转变], [大应变、形变可编程；响应较慢],
    [HASEL执行器], [电致液体相变驱动弹性薄膜], [肌肉仿生、可自感知；依赖高压],
    [颗粒阻塞], [真空下颗粒互锁实现相变刚化], [变刚度范围宽；需辅助真空系统],
  ),
  caption: [常见软体驱动方式对比 [5,12,25,26,27]],
)


// ===== 5. 基于非线性力学的拓扑优化设计 =====
= 基于非线性力学的拓扑优化设计

== Darcy 定律与密度场公式化

气动软体机器人的拓扑优化面临"设计依赖型载荷"问题。研究者引入多孔介质力学中的达西定律（Darcy's Law），将密度设计变量 $rho$ 转化为渗流率 [23]：

$ bold(Q) = -epsilon/mu nabla p = -K(hat(rho)) nabla p $

通过惩罚插值模型，将复杂的边界追踪问题转换为固定网格上的全局连续场求解，并引入设计场、过滤场与物理场的三相密度体系以确保流固边界清晰 [23]。

== 大变形敏感度分析

由于几何与材料的双重非线性，刚度矩阵 $bold(K)(bold(rho))$ 是位移 $bold(U)$ 的函数 [35]。伴随变量法敏感度分析不仅需考虑材料刚度变化，还须包含大变形载荷刚度项贡献。移动渐近线法（MMA）等高级数学规划算法被专门引入以处理非单调震荡 [23,24]。

// ===== 6. 先进制造工艺与力学性能 =====
= 先进制造工艺与力学性能

== 增材制造的"缝纫线"强化效应

传统模具浇注的多步层压工艺易在批次间形成界面应力集中点，导致层间剥离漏气 [7]。直接墨水书写（DIW）等增材制造路径在层层挤出过程中形成定向微小脊线，产生类似复合材料纤维增强的"缝纫线效应"（Sewing Thread Effect），显著提升气动腔体的爆破压力 [11,32]。对于熔融沉积成型（FDM），挤出线宽直接决定界面热熔合面积与抗爆破能力 [13]。

== 空间刚度编程与多功能材料打印

增材制造实现了"空间刚度编程"（Spatial Stiffness Programming）：多喷头打印或动态调变光曝光能量密度，可在连续结构内部形成从超低杨氏模量弹性体到高刚性树脂的无缝梯度过渡 [11]。向聚合物墨水中掺杂各向异性功能纳米填料（如 CNTs 或磁性微粒），在打印剪切流场下形成高度取向排列，赋予结构方向依赖的导热与电致驱动行为 [33]。

主要增材制造工艺的成形原理与力学特点对比见表 3。

#figure(
  kind: table,
  table(
    columns: (1.2fr, 2.2fr, 2fr, 2fr),
    stroke: 0.5pt,
    inset: 4pt,
    align: (left, left, left, left),
    [*工艺*], [*成形原理*], [*界面/力学特点*], [*典型应用*],
    [模具浇注], [液态弹性体注模后固化], [均质性好；多步层压易分层漏气], [气动腔体批量制造],
    [DIW], [可编程挤出墨水逐层沉积], ["缝纫线"效应提升爆破压力], [多材料软驱动器],
    [DLP], [面曝光逐层光固化], [精度高（$~25$ μm）；材料种类有限], [微结构与超材料胞元],
    [FDM], [热熔丝逐层沉积成形], [线宽决定界面热熔合强度], [快速原型、刚软复合结构],
  ),
  caption: [典型增材制造工艺对比 [7,11,13,32]],
)


// ===== 7. 软硬界面力学、失效与计量标准化 =====
= 软硬界面力学、失效与计量标准化

== 软硬异质界面应力集中

软-刚结合界面处模量跨度超过 6 个数量级（$~10^(11)$ Pa vs $~10^5$ Pa）。基于断裂力学计算，大变形受载时此类突变会引发极强的拉伸与剪切应力集中，导致不可逆界面脱层（Delamination）[28,29]。工程界提出两大策略：（1）梯度模量聚合物过渡（FGM）：在交界区打印多层模量梯度过渡带，均匀分散应力 [32]；（2）微观多孔机械互锁（Mechanical Interlocking）：利用 FDM 欠挤出工艺在界面形成多孔网状形貌，使液态软质材料渗入固化，将宏观剪切转化为微观几何约束 [29]。

== 疲劳、屈曲与空化失效

高频交变内压易在腔体微小瑕疵处萌生疲劳微裂纹；高速液压系统中压力瞬降可诱发流体空化（Cavitation），溃灭冲击波对内壁造成侵蚀 [30]。受面内压缩的软弹性体还会发生隧道屈曲与折叠起皱（Wrinkling/Creasing），切断表面传感器的导电通路 [31]。

== 计量标准化挑战

工业界基于单次静态终点的弹性体标准与软体机器人大应变循环应用完全脱节。NIST IR 8508 明确指出，仅依赖单轴实验提取的模型在预测复杂多轴膨胀时会产生巨大误差 [10]。建立反映多轴应变、记录 Mullins 效应全生命周期的公开溯源测试标准，是实现高保真数字孪生验证的当务之急 [10]。

// ===== 8. 结论与展望 =====
= 结论与展望

软体机器人是建立在非线性力学、超弹性热力学与先进增材制造融合基础之上的颠覆性学科。本文的综述表明：

（1）力学建模必须突破小应变假设；对于细长连续体，基于李群流形的 Cosserat 杆理论能有效规避运动学奇异性，但其适用性仍受限于细长几何假设，壳体、多腔体及强接触场景需结合壳体理论或有限元方法加以补充。

（2）结构成型正由"仿生直觉"向基于 Darcy 定律的多物理场拓扑优化"计算推演"转变，逆设计与增材制造的深度耦合将成为主流范式 [11,23]。

（3）软硬界面的应力集中疲劳机制亟待通过梯度材料设计与微观互锁结构加以系统解决 [28,29,32]。

（4）缺失标准化测量协议是软体机器人工程化的最大瓶颈，建立多轴循环大变形的全生命周期测试标准是产业化进程中不可回避的任务 [10]。

随着力学设计与数字制造的深度一体化，具备高环境感知能力与本质安全性的软体机器人必将推动人机协作与智能具身系统迈向新阶段。

// ===== 关闭双栏 =====
] // end columns

// ===== 参考文献 =====
#set par(justify: false)
#v(4mm)
#text(weight: "bold", size: 11pt)[参考文献]
#v(2mm)

#set text(size: 9pt)

#let ref(n, content) = [#box(width: 6mm)[*[#n]*] #content #v(0.5mm)]

#ref(1)[Rus D, Tolley M T. Design, fabrication and control of soft robots. _Nature_, 2015, 521(7553): 467--475.]
#ref(2)[Laschi C, Mazzolai B, Cianchetti M. Soft robotics: Technologies and systems pushing the boundaries of robot abilities. _Science Robotics_, 2016, 1(1): eaah3690.]
#ref(3)[Renda F, Giorelli M, Calisti M, et al. Dynamic model of a multicontinuum kinematic soft robot. _IEEE Transactions on Robotics_, 2014, 30(5): 1109--1122.]
#ref(4)[Majidi C. Soft robotics: a perspective—current trends and prospects for the future. _Soft Robotics_, 2014, 1(1): 5--11.]
#ref(5)[Polygerinos P, Correll N, Morin S A, et al. Soft robotics: Review of fluid-driven intrinsically soft devices. _Advanced Engineering Materials_, 2017, 19(12): 1700016.]
#ref(6)[Trivedi D, Rahn C D, Kier W M, et al. Soft robotics: Biological inspiration, state of the art, and future research. _Applied Bionics and Biomechanics_, 2008, 5(3): 99--117.]
#ref(7)[Wallin T J, Pikul J, Shepherd R F. 3D printing of soft robotic systems. _Nature Reviews Materials_, 2018, 3(6): 84--100.]
#ref(8)[Shepherd R F, Ilievski F, Choi W, et al. Multigait soft robot. _Proceedings of the National Academy of Sciences_, 2011, 108(51): 20400--20403.]
#ref(9)[Holzapfel G A. _Nonlinear Solid Mechanics: A Continuum Approach for Engineering_. John Wiley & Sons, 2000.]
#ref(10)[National Institute of Standards and Technology (NIST). NIST IR 8508: Metrology for Soft Robotics — Current Challenges and Future Directions. _US Department of Commerce_, 2023.]
#ref(11)[Truby R L, Lewis J A. Printing soft matter in three dimensions. _Nature_, 2016, 540(7633): 371--378.]
#ref(12)[Hiller J, Lipson H. Automatic design and manufacture of soft robots. _IEEE Transactions on Robotics_, 2012, 28(2): 457--466.]
#ref(13)[Wehner M, Truby R L, Fitzgerald D J, et al. An integrated design and fabrication strategy for entirely soft, autonomous robots. _Nature_, 2016, 536(7617): 451--455.]
#ref(14)[Ogden R W. Large deformation isotropic elasticity — on the correlation of theory and experiment for incompressible rubberlike solids. _Proceedings of the Royal Society of London A_, 1972, 326(1567): 565--584.]
#ref(15)[Mooney M. A theory of large elastic deformation. _Journal of Applied Physics_, 1940, 11(9): 582--592.]
#ref(16)[Yeoh O H. Some forms of the strain energy function for rubber. _Rubber Chemistry and Technology_, 1993, 66(5): 754--771.]
#ref(17)[Gent A N. A new constitutive relation for rubber. _Rubber Chemistry and Technology_, 1996, 69(1): 59--61.]
#ref(18)[Marechal L, Balland P, Lindenroth L, et al. Toward a common framework and database of materials for soft robotics. _Soft Robotics_, 2021, 8(3): 284--297.]
#ref(19)[Grazioso S, Di Gironimo G, Siciliano B. A geometrically exact model for soft continuum robots: The finite element deformation space formulation. _Soft Robotics_, 2019, 6(6): 790--811.]
#ref(20)[Overvelde J T, Kloek T, D'haen J J, et al. Amplifying the response of soft actuators by harnessing snap-through instabilities. _Proceedings of the National Academy of Sciences_, 2015, 112(34): 10863--10868.]
#ref(21)[Gorissen B, Melancon D, Vasios N, et al. Inflatable soft jumper inspired by shell buckling. _Science Robotics_, 2020, 5(42): eabb1967.]
#ref(22)[Preston D J, Jiang H, Sanchez V, et al. Digital logic for soft devices. _Proceedings of the National Academy of Sciences_, 2019, 116(16): 7750--7759.]
#ref(23)[Liao Z, Wang X, Wang Y, et al. SoRoTop: A topology optimization framework for soft robots. _Soft Robotics_, 2020, 7(5): 652--668.]
#ref(24)[Chen F, Wang Q. Topology optimization of fluid-driven soft robots. _Extreme Mechanics Letters_, 2020, 38: 100746.]
#ref(25)[Pelrine R, Kornbluh R, Pei Q, et al. High-speed electrically actuated elastomers with strain greater than 100%. _Science_, 2000, 287(5454): 836--839.]
#ref(26)[Suo Z. Theory of dielectric elastomers. _Acta Mechanica Solida Sinica_, 2010, 23(6): 549--578.]
#ref(27)[Kellaris N, Venkata V G, Smith G M, et al. Peano-HASEL actuators: Muscle-mimetic, electrohydraulic transducers that linearly contract on activation. _Science Robotics_, 2018, 3(14): eaar3276.]
#ref(28)[Yuk H, Lu B, Zhao X. Hydrogel interfaces for merging humans and machines. _Chemical Society Reviews_, 2019, 48(6): 1642--1667.]
#ref(29)[Tang Y, Yin Y, Zhao X. Design and fracture of soft-rigid interfaces. _Extreme Mechanics Letters_, 2021, 42: 101138.]
#ref(30)[Thomsen P, Thuesen A, Bendsen M. Cavitation and fatigue in soft robotics fluid systems. _Extreme Mechanics Letters_, 2021, 48: 101375.]
#ref(31)[Zhao X. Multi-scale multi-mechanism design of tough hydrogels: building dissipation into stretchy networks. _Soft Matter_, 2014, 10(5): 672--687.]
#ref(32)[Bartlett N W, Tolley M T, Overvelde J T, et al. A 3D-printed, functionally graded soft robot powered by combustion. _Science_, 2015, 349(6244): 161--165.]
#ref(33)[MacCurdy R, Katzschmann R, Kim Y, et al. Printable hydraulics: A method for fabricating robots by 3D co-printing solid and liquid materials. _2016 IEEE International Conference on Robotics and Automation (ICRA)_, 2016: 3878--3885.]
#ref(34)[Sigmund O. A 99 line topology optimization code written in Matlab. _Structural and Multidisciplinary Optimization_, 2001, 21(2): 120--127.]
#ref(35)[Belytschko T, Liu W K, Moran B, et al. _Nonlinear Finite Elements for Continua and Structures_. John Wiley & Sons, 2014.]
#ref(36)[白建涛, 王禹淳, 郎占宇, 左文杰. 超弹性材料宏观本构模型及其拟合[J]. 应用力学学报, 2025, 42 (03): 483-493.]
#ref(37)[Jones B A, Gray R L, Turlapati K. Three dimensional statics for continuum robotics\[C\]#"//"2009 IEEE/RSJ International Conference on Intelligent Robots and Systems. IEEE, 2009: 2659--2664.]
