下面给出一篇**偏力学主线**的中文文献综述草稿。由于软体机器人论文数量很大，我将“过去 3 年”界定为 **2023 年 5 月—2026 年 5 月**，并采用“英文论文优先、力学相关性优先、设计与制造相关性优先”的筛选原则；以下不是穷尽性综述，而是面向论文写作的可复现综述框架。

---

# 软体机器人设计与制造的力学研究进展：近三年英文文献综述

## 摘要

软体机器人以高柔顺性、大变形能力和环境适应性区别于传统刚性机器人，其核心科学问题并非单纯“材料变软”，而是如何在非线性材料、结构几何、驱动方式、制造工艺和控制策略之间建立可预测、可设计、可制造的力学闭环。过去三年，软体机器人研究从早期的仿生柔性执行器与气动腔体设计，逐渐转向多材料增材制造、结构可编程力学、机械超材料、物理智能、软硬混合机构、可调刚度与失稳驱动等方向。相关研究表明，软体机器人的性能瓶颈主要集中在力输出不足、刚度—柔顺性矛盾、滞后与疲劳、模型可解释性不足、制造可重复性差以及传感—驱动—结构一体化困难等方面。本文围绕设计与制造中的力学问题，梳理检索策略、代表性论文、理论框架、发展脉络、学术争议与未来机会。

---

## 1. 检索策略设计

### 1.1 推荐数据库

建议采用“综合数据库 + 工程数据库 + 出版商平台 + 预印本”的组合检索方式：

| 类型        | 推荐数据库                                                                                          | 用途                                   |
| --------- | ---------------------------------------------------------------------------------------------- | ------------------------------------ |
| 综合引文数据库   | Web of Science Core Collection, Scopus                                                         | 系统综述、引文追踪、筛选高影响力论文                   |
| 工程与机器人数据库 | IEEE Xplore, ACM Digital Library                                                               | RoboSoft、ICRA、IROS、RA-L、TRO 等会议与期刊论文 |
| 材料与化学数据库  | ACS Publications, Wiley Online Library, Elsevier ScienceDirect, SpringerLink, Nature Portfolio | 软材料、增材制造、刺激响应材料、机械超材料                |
| 医学与生物交叉   | PubMed                                                                                         | 医疗软机器人、软体内窥镜、仿生组织模拟器                 |
| 预印本与快速追踪  | arXiv, bioRxiv, Research Square                                                                | 新模型、新制造方法、控制与逆设计前沿                   |
| 灰色但有用资源   | Google Scholar, Semantic Scholar                                                               | 向后/向前引文追踪、查找开放版本                     |

近年综述普遍也采用 Google Scholar、Web of Science、Scopus 等组合路径进行检索；例如 2024 年关于软体机器人设计、制造和运行挑战的综述使用了 soft robots、deformable sensors、3D-printed robots、bio-inspired robots、soft actuators、tunable stiffness robots 等关键词，并主要筛选 2015—2023 年文献。([ResearchGate][1])

### 1.2 核心关键词与同义词

检索应围绕“软体机器人 + 力学 + 制造 + 设计方法”展开，而不是只检索 soft robot。

**主题词：**

* soft robot / soft robotics
* soft actuator / soft gripper / soft manipulator / continuum robot
* soft pneumatic actuator / fluidic elastomer actuator / dielectric elastomer actuator
* magnetic soft robot / magnetoactive soft actuator
* hydrogel actuator / ionic actuator / liquid metal soft robot
* soft robotic skin / soft sensor / proprioception

**力学相关词：**

* mechanics / continuum mechanics / nonlinear mechanics
* hyperelasticity / viscoelasticity / hysteresis / fatigue / fracture
* large deformation / finite strain / instability
* buckling / snap-through / bistability / kink instability
* stiffness tuning / variable stiffness / compliance
* Cosserat rod / beam model / shell model / finite element method
* topology optimization / inverse design / differentiable simulation
* mechanical metamaterial / architected material / origami / kirigami

**制造相关词：**

* fabrication / manufacturing / additive manufacturing
* 3D printing / 4D printing / direct ink writing / DLP / SLA / material extrusion
* multimaterial printing / embedded printing / volumetric printing
* fiber reinforcement / composite elastomer / functionally graded material
* molding / soft lithography / casting / lamination

**推荐布尔检索式示例：**

```text
("soft robot*" OR "soft actuator*" OR "continuum robot*")
AND
(mechanics OR hyperelastic* OR viscoelastic* OR "large deformation" OR "finite element" OR "Cosserat rod")
AND
(fabrication OR manufacturing OR "3D printing" OR "additive manufacturing" OR "multi-material")
AND
(2023 OR 2024 OR 2025 OR 2026)
```

```text
("soft pneumatic actuator" OR "fluidic elastomer actuator")
AND
("finite element" OR "inverse design" OR "topology optimization" OR "geometry optimization")
```

```text
("soft robot*" AND ("bistable" OR "snap-through" OR buckling OR instability))
AND
(mechanics OR "energy storage" OR "power amplification")
```

```text
("soft robot*" AND ("mechanical metamaterial" OR "architected material" OR kirigami OR origami))
AND
(fabrication OR "additive manufacturing" OR "multi-material")
```

### 1.3 筛选标准

本文建议采用如下筛选逻辑：

**纳入标准：**

1. 2023 年 5 月至 2026 年 5 月之间发表或在线发表的英文论文、综述或高质量预印本。
2. 主题与软体机器人设计、制造、执行器、柔性结构、软硬混合机构或物理智能直接相关。
3. 明确涉及力学建模、材料本构、结构失稳、有限元、拓扑优化、增材制造、可调刚度、滞后、疲劳、接触或流固耦合等问题。
4. 优先选择 Nature、Science Robotics、Nature Communications、npj Robotics、Chemical Reviews、Advanced 系列、IEEE RA-L/TRO、Soft Robotics、Sensors and Actuators A、Materials & Design 等来源。

**排除标准：**

1. 仅讨论视觉识别、路径规划或高层 AI 控制，而缺乏结构/材料/力学内容的论文。
2. 仅为应用展示但无明确机械设计、制造或性能测试的论文。
3. 非英文论文、新闻稿、专利或未能确认同行评议状态的材料，除非用于趋势辅助说明。
4. 只涉及传统刚性连续体机器人，而无软材料或柔顺结构设计的论文。

---

## 2. 代表性论文筛选与主题矩阵

下表按“力学相关性”和“设计制造相关性”选择近三年代表性英文论文与综述。

| 文献                                                                | 核心子主题        | 研究方法                | 关键发现                                             | 学术争议/局限                                                |
| ----------------------------------------------------------------- | ------------ | ------------------- | ------------------------------------------------ | ------------------------------------------------------ |
| Yasa 等，2023，*An Overview of Soft Robotics*                        | 软体机器人总体框架    | 综述：驱动、建模、控制、传感      | 将软体机器人未来方向概括为自愈、感知、生长、动力学建模和适配软体系统的控制架构          | 综述广，但力学深度不如专门的建模/制造论文 ([研究文献库][2])                     |
| Qin 等，2024，*Modeling and Simulation of Dynamics in Soft Robotics* | 动力学建模        | 综述：非线性动力学、几何处理、一维模型 | 强调软体机器人动力学需处理大变形、非线性材料和复杂几何，特别关注一维模型             | 高保真与实时控制之间仍存在矛盾 ([Springer][3])                        |
| Rod models in continuum and soft robot control，2024               | Cosserat 杆模型 | 综述：杆理论与控制策略         | 杆模型在细长软体结构中兼顾变形捕捉与计算效率                           | 对壳状、块状、多腔体或复杂接触结构适用性有限 ([arXiv][4])                    |
| Xun 等，2024，TRO                                                    | 软细长机器人动力学    | Cosserat rod 动力学建模  | 从局部应变场假设出发建立非线性动力学模型                             | 模型参数识别和复杂材料本构仍是瓶颈 ([ACM Digital Library][5])           |
| Tang 等，2024，*Science Robotics*                                    | 双稳态跳跃软机器人    | 磁驱动、双稳态结构、实验测试      | 报道磁驱动超快双稳态软跳跃器，可实现高起跳速度和超过 108 个体长的跳跃高度          | 高性能依赖特定结构与磁场条件，通用设计规律仍需抽象 ([科学协会][6])                  |
| Kumar 等，2025，*Science Robotics*                                   | 可逆 kink 失稳   | 结构失稳、软机器人跳跃         | 将传统“失效模式”kink instability 转化为可控双向跳跃机制            | 失稳驱动具有高爆发力，但控制精度和疲劳寿命存在争议 ([科学协会][7])                  |
| Wen 等，2025，*Nature Communications*                                | 磁活性双稳态执行器    | 磁驱动 + 双稳态机制         | 双稳态可实现力放大、高速运动和无持续能耗形状保持                         | 磁场系统外设复杂，尺度放大和闭环控制仍难 ([Nature][8])                     |
| Shin 等，2025，*Nature Communications*                               | 柔性机器人皮肤执行器   | 多层 3D 气动网络制造        | 薄片状执行器可在表面产生多方向运动矢量场，用于狭窄管道、手内操作和水下搬运            | 气动供能、管路集成和耐久性仍限制实际应用 ([Nature][9])                     |
| Aygül 等，2025，*Nature Communications*                              | 软机构驱动机器人     | 多材料设计与打印            | 提出将经典机构设计扩展到软机器人中的多材料打印框架，兼顾软/硬材料优势              | 软硬界面疲劳、粘接、制造公差是关键问题 ([Nature][10])                     |
| Carton 等，2025，*Science Robotics*                                  | 机械超材料软臂      | 机械超材料、柔顺恒速关节        | 通过机械超材料连接软硬边界，实现软机械臂中的柔顺恒速关节                     | 超材料结构设计复杂，承载能力与可制造性需平衡 ([科学协会][11])                    |
| Chen 等，2025，*Science Robotics* Review                             | 物理智能         | 综述：反馈、嵌入式物理智能       | 将自治软机器人理解为材料、结构、传感、控制共同形成的 physical intelligence | “智能”概念边界较宽，量化评价体系仍不统一 ([科学协会][12])                     |
| Bliah 等，2025，*Chemical Reviews*                                   | 增材制造软机器人     | 综述：材料、打印、设计、应用      | 从材料化学到应用全面梳理增材制造软机器人，强调材料选择和化学组成对性能的影响           | 化学/材料视角强，力学建模与结构优化需进一步结合 ([美国化学学会出版物][13])             |
| Raj 等，2025，Advanced 系列综述                                          | 多材料增材制造      | 综述：MMAM、材料兼容、功能梯度   | 多材料打印使复杂形状、材料梯度和集成功能成为可能                         | 材料兼容性、界面强度、打印分辨率和可重复性仍是瓶颈 ([Wiley Online Library][14]) |
| Miao 等，2025，*Materials & Design*                                  | 自感知软机器人      | 多材料 DLP 打印水凝胶       | 集成光热驱动与应变传感，材料可达 500% 拉伸并完成 500 次循环测试            | 水凝胶环境稳定性、响应速度和输出力仍受限制 ([科学出版社][15])                    |
| Ligthart 等，2025                                                   | 气动执行器逆设计     | 非线性有限元 + 神经网络元模型    | 用大规模有限元数据训练元模型，提高软气动执行器设计效率                      | 数据驱动模型可能受训练分布限制，外推可靠性需验证 ([Wiley Online Library][16])  |
| Wang 等，2025，CMAME                                                 | 磁软机器人协同设计    | 磁-弹性 MPM + 拓扑优化     | 同时优化结构、局部磁化和时变磁激励，处理大变形、动力学和接触                   | 计算成本高，实验制造与仿真模型之间仍有差距 ([科学出版社][17])                    |
| Zhang 等，2025，*npj Robotics*                                       | 薄膜执行器        | 综述：结构、材料、变形机制       | 系统总结低刚度薄膜执行器的结构设计、基本力学和变形机制                      | 薄膜结构输出力有限，易受屈曲、粘附和疲劳影响 ([Nature][18])                  |
| Feng 等，2025，*npj Robotics*                                        | 冲击/脉冲驱动      | 综述：快速响应与功率放大        | 将跳跃、弹射、人工心脏等高功率场景归入 impulsive actuation 框架       | 高功率密度通常伴随控制难度、寿命和安全性问题 ([Nature][19])                  |
| Molla 等，2026，*npj Robotics*                                       | 介电弹性体与流体执行器  | 综述：材料、制造、失效、寿命      | 介电软执行器具有轻量、大应变、高能量密度和快速响应优势                      | 高电压、击穿、寿命和封装仍是关键限制 ([Nature][20])                      |
| Eyvazian 等，2026，系统综述                                              | 非结构化环境软机器人   | 系统综述：材料、架构、驱动、控制    | 软体系统因柔顺性和适应性适合非结构化与真实环境                          | 真实场景鲁棒性、标准化测试和规模化部署仍不足 ([科学出版社][21])                   |

---

## 3. 领域理论框架：以力学为主线

### 3.1 材料本构：从“小变形弹性”转向“大变形非线性”

软体机器人通常采用硅橡胶、聚氨酯、热塑性弹性体、水凝胶、液晶弹性体、介电弹性体、磁性复合弹性体、离子凝胶和液态金属复合材料等。其工作应变往往远超传统线弹性假设适用范围，因此设计中必须处理：

1. **超弹性**：Neo-Hookean、Mooney–Rivlin、Yeoh、Ogden 等模型常用于描述橡胶类材料的大变形响应。
2. **黏弹性与滞后**：软材料存在加载—卸载路径差异，导致控制误差、能量损耗和重复定位困难。
3. **疲劳与断裂**：高循环气动、介电击穿、界面脱粘、裂纹扩展是长期可靠性的核心问题。
4. **多物理场耦合**：磁-弹性、电-弹性、热-弹性、溶胀-弹性、光-热-机械耦合等日益重要。

近三年增材制造综述尤其强调，材料化学组成、交联方式、填料分散、界面相容性与制造工艺共同决定软体机器人的力学性能，而不是“选一种软材料”即可完成设计。([美国化学学会出版物][13])

### 3.2 结构力学：几何比材料同样重要

软体机器人的运动常常不是由复杂电机实现，而是由结构几何把简单输入转化为复杂输出。典型机制包括：

* 气动腔体非对称膨胀产生弯曲；
* 纤维约束将径向膨胀转化为轴向伸缩或扭转；
* 折纸/剪纸结构通过几何折叠实现大行程变形；
* 双稳态结构通过能量势垒实现快速跳变；
* 机械超材料通过单元胞设计实现负泊松比、可调刚度或运动约束；
* 多材料梯度通过局部模量差异编码目标变形。

近年的一个显著趋势是：软体机器人设计从“材料驱动”走向“结构编码”。例如，机械超材料软臂利用结构单元实现柔顺恒速关节，试图在软体机器人的适应性和刚性机器人的结构完整性之间建立中间路径。([科学协会][11])

### 3.3 连续体建模：Cosserat 杆、有限元与降阶模型

软体机器人建模通常分为三类：

1. **解析/半解析模型**：适合简单腔体、梁、薄膜、纤维增强结构，便于设计理解。
2. **Cosserat 杆与连续体机器人模型**：适合细长软体臂、软体内窥镜、绳驱连续体结构，能处理弯曲、扭转、剪切、伸长等耦合变形。近年综述认为，杆模型在捕捉细长体变形与保持计算效率之间具有优势。([arXiv][4])
3. **有限元/材料点法/多物理场仿真**：适合复杂几何、多材料、大接触和非线性本构，但计算成本高。2024 年关于软体机器人动力学建模的综述强调，非线性动力学、几何处理和一维模型是当前建模研究重点。([Springer][3])

实际设计中常采用“高保真有限元生成数据—训练元模型—用于快速优化”的流程。Ligthart 等利用非线性有限元和神经网络元模型进行软气动执行器设计，体现了“力学仿真 + 机器学习”的趋势。([Wiley Online Library][16])

### 3.4 失稳力学：从避免失效到利用失效

传统结构设计常将屈曲、snap-through、kink 等视为失效；软体机器人则逐渐将其视为高性能运动资源。双稳态、屈曲、壳翻转、弹性能量释放可以提供高功率密度、快速响应和形状保持。2024 年磁驱动双稳态软跳跃器实现了超过 108 个体长的跳跃高度；2025 年可逆 kink instability 研究则表明，失稳可被设计为复杂地面上的双向跳跃机制。([科学协会][6])

这类研究的核心力学问题是：如何设计势能景观、能量势垒、触发阈值、释放路径与循环寿命。其争议在于，失稳机制虽然能显著提升瞬时性能，但通常牺牲连续可控性、定位精度和长期耐久性。

### 3.5 物理智能与形态计算

近年软体机器人研究越来越强调 **physical intelligence** 或 **embodied intelligence**：材料、结构、阻尼、接触、传感与驱动本身承担部分“计算”功能，从而减少传统控制器负担。2025 年 Science Robotics 综述将自主软机器人中的反馈机制、嵌入式物理智能和软体系统演化作为重点方向。([科学协会][12])

从力学角度看，物理智能并不神秘，本质上是利用结构动力学、被动顺应性、能量耗散、非线性耦合和环境接触来实现行为选择。例如，软抓手可以通过柔顺性被动适配物体形状，而不必精确计算每个接触点；软体爬行机器人可以通过摩擦各向异性和身体波动形成步态。

---

## 4. 发展历史与关键学者/著作

### 4.1 早期阶段：软材料与仿生启发

软体机器人早期动力来自仿生学、柔性材料、软光刻、气动网络和连续体机器人。与传统刚性连杆机器人不同，软体机器人从一开始就强调与章鱼、蠕虫、海星、象鼻等生物体的结构相似性。

Shepherd 等 2011 年在 PNAS 发表的 **Multigait soft robot** 是领域标志性论文之一，该机器人由弹性体构成，使用低压气动、五个执行器和简单阀系统实现多步态运动，展示了“简单驱动产生复杂运动”的软体机器人优势。([美国国家科学院院刊][22])

### 4.2 成熟阶段：综述奠定学科框架

Rus 和 Tolley 2015 年在 Nature 发表的 **Design, fabrication and control of soft robots** 是软体机器人领域最具影响力的综述之一，系统讨论了软体机器人的设计、制造与控制。PubMed 记录显示该文聚焦由柔顺材料构成的机器人设计与控制，并被广泛引用。([PubMed][23])

Laschi、Mazzolai 和 Cianchetti 2016 年在 Science Robotics 发表 **Soft robotics: Technologies and systems pushing the boundaries of robot abilities**，指出软体机器人未来挑战包括生长、进化、自愈、发育和生物降解等能力。([PubMed][24])

Mosadegh 等关于快速气动网络 PneuNets 的工作也非常关键，其设计将快速响应与可靠性结合，为软体气动执行器的工程化应用奠定基础。([哈佛数据管理系统][25])

### 4.3 近三年阶段：从“能动”到“可设计、可制造、可预测”

2023—2026 年的研究重点发生了明显转移：

1. 从单一软执行器转向**系统级集成**；
2. 从经验设计转向**有限元、逆设计和拓扑优化**；
3. 从模具浇注转向**多材料增材制造**；
4. 从追求柔软转向**柔顺性、刚度、输出力和可靠性平衡**；
5. 从控制器补偿转向**结构本身嵌入功能**；
6. 从避免屈曲失稳转向**利用失稳实现高功率运动**。

---

## 5. 设计与制造中的主要研究方向

### 5.1 软气动执行器：成熟但仍未解决标准化问题

软气动执行器是目前最成熟的软体机器人路线之一。其优势是结构简单、变形大、安全性好、材料成本低；典型制造方法包括硅胶浇注、软光刻、层压、3D 打印和织物约束。缺点是外部气源笨重、响应带宽有限、气密性和疲劳寿命难以保证。

近年研究重点从“能不能弯曲”转向：

* 腔体几何优化；
* 纤维/织物约束设计；
* 多自由度薄片气动网络；
* 自感知气动结构；
* 气动系统小型化；
* 非线性有限元与逆设计。

Shin 等提出的薄片状机器人皮肤执行器通过多层 3D 气动网络产生多方向表面运动矢量场，说明气动执行器不再局限于单根弯曲手指，而可成为可铺展、可变形的表面驱动系统。([Nature][9])

### 5.2 介电弹性体与电流体执行器：高能量密度与高电压风险并存

介电弹性体执行器和电流体执行器具有轻量、大应变、高能量密度和快速响应优势，适合仿肌肉、微型机器人和高频驱动场景。2026 年 npj Robotics 综述总结了介电弹性体和流体执行器的材料创新、制造方式、驱动模式、寿命、失效机制、控制策略和应用，指出其仍面临击穿、寿命和封装等挑战。([Nature][20])

力学关键问题包括：

* 电场 Maxwell 应力与弹性回复力平衡；
* 薄膜预拉伸与屈曲稳定性；
* 电击穿与裂纹扩展；
* 电极柔顺性与界面失效；
* 流体封装导致的非线性耦合。

### 5.3 磁驱动软机器人：适合无线、小尺度和复杂环境

磁软机器人常用于小尺度、医疗、管道、封闭空间和水下环境。其核心是将磁性颗粒嵌入弹性体，通过外部磁场实现变形或运动。近年趋势是从简单磁响应结构转向**磁化分布、结构形状和外场时序的协同设计**。

Wang 等提出的统一逆设计框架将磁-弹性材料点法与拓扑优化结合，同时优化结构、局部磁化和时变磁激励，并处理大变形、动态运动和固体接触。([科学出版社][17]) 这代表了磁软机器人从“经验磁化”向“计算设计”的转变。

### 5.4 机械超材料、折纸与剪纸：可编程结构力学

机械超材料、origami 和 kirigami 将软体机器人的设计自由度从材料层面扩展到结构层面。通过单元胞几何、折痕、切缝、层合和多稳态设计，可以获得可调刚度、可展开结构、负泊松比、局部应变集中、导向变形和能量存储功能。

Carton 等将机械超材料用于软机械臂，展示了软硬边界与机构学融合的潜力。([科学协会][11]) Aygül 等提出多材料设计和打印框架，将经典机构设计扩展到软体机器人，试图用软硬材料组合克服纯软机器人结构完整性不足和传统机器人抗冲击性不足的问题。([Nature][10])

### 5.5 多材料增材制造：从“做出来”到“把功能打印进去”

传统软体机器人常依赖多步浇注、粘接、插管和手工组装，导致重复性差、尺度受限、结构复杂度受限。增材制造尤其是多材料打印正在改变这一点。

2025 年 Chemical Reviews 综述系统讨论了软体机器人增材制造的材料、制造方法、设计方法和应用，特别强调材料化学和性能之间的关系。([美国化学学会出版物][13]) 多材料增材制造综述则指出，MMAM 能够直接制造复杂形状、多材料组成和集成功能结构，但材料兼容性、界面强度、工艺控制和功能梯度设计仍是核心挑战。([Wiley Online Library][14])

从力学角度看，多材料制造最重要的价值不是“形状复杂”，而是可以在空间中编码：

* 局部模量；
* 局部膨胀/收缩能力；
* 局部磁化方向；
* 局部导电/传感性能；
* 局部阻尼；
* 局部屈曲阈值；
* 局部疲劳安全裕度。

---

## 6. 学术争议与尚未解决的问题

### 6.1 柔顺性与承载能力的矛盾

软体机器人越柔软，越容易适应复杂环境和安全交互；但过度柔软会降低输出力、定位精度和结构稳定性。近年软硬混合机构、机械超材料、可调刚度结构和双稳态结构都在回应这一矛盾。争议在于：软体机器人是否应坚持“全软”，还是应接受软硬混合成为主流？当前趋势明显偏向后者。

### 6.2 高保真模型与实时控制的矛盾

有限元和多物理场仿真能更真实地反映软体机器人大变形行为，但难以实时运行；常曲率模型和杆模型效率高，但在复杂接触、多腔体变形和非均匀材料中误差较大。2024 年动力学综述和杆模型综述均指出，降阶模型、Cosserat rod、数据驱动代理模型是当前折中方案。([Springer][3])

### 6.3 数据驱动设计是否会削弱力学解释？

机器学习元模型、神经网络控制和可微仿真正在进入软体机器人设计。但如果缺少本构参数、边界条件、摩擦模型和实验验证，模型可能只是对训练集插值，而非真正理解力学机制。未来更有前景的方向是 **mechanics-informed learning**，即以守恒律、本构约束、几何约束和能量函数约束学习模型。

### 6.4 失稳驱动的性能与可靠性

双稳态、snap-through 和 kink instability 能显著提高速度、跳跃高度和瞬时功率，但也带来疲劳、冲击、不可逆损伤和控制不连续问题。相关研究正在将“失效模式”转化为功能机制，但工程应用仍需寿命模型和安全设计准则。([科学协会][7])

### 6.5 制造可重复性与标准测试不足

软体机器人论文常展示单个原型，但缺乏跨实验室可复现的材料参数、疲劳测试、载荷测试和失败案例。多材料打印虽然提高了结构复杂度，却引入界面脱粘、打印缺陷、固化收缩、填料沉降和各向异性等新问题。2025 年多材料增材制造综述明确将材料兼容性和工艺控制列为关键挑战。([ResearchGate][26])

---

## 7. 未来展望与研究机会

### 7.1 建立软体机器人“材料—结构—制造—性能”数据库

未来需要开放数据库，系统记录：

* 材料本构参数；
* 应变率依赖；
* 疲劳寿命；
* 断裂韧性；
* 打印参数；
* 界面强度；
* 执行器输出力、行程、带宽、效率；
* 失效模式。

这类数据库将使软体机器人设计从“实验室手艺”转向“工程设计学”。

### 7.2 面向逆设计的可微力学仿真

未来软体机器人设计会更多使用拓扑优化、可微有限元、可微材料点法和神经代理模型。尤其在磁软机器人、气动执行器和多材料结构中，结构形状、材料分布和驱动输入应被同时优化。Wang 等关于磁软机器人的协同设计已经体现了这一方向。([科学出版社][17])

### 7.3 可调刚度与软硬混合将成为主流

单纯追求柔软已经不足以满足真实任务需求。未来系统需要在抓取、移动、穿越、承载和操作之间切换力学状态。可能方向包括：

* 颗粒/层状 jamming；
* 低熔点合金；
* 相变材料；
* 机械锁止；
* 双稳态结构；
* 软硬混合机构；
* 机械超材料；
* 可展开结构。

### 7.4 失稳、冲击和能量存储机制将推动高性能软机器人

跳跃、弹射、快速抓取、人工心脏、泵送和高速游动等任务都需要高功率密度。未来研究应从能量景观角度统一分析 snap-through、buckling、kink、弹性储能和流体压力释放。2025 年 impulsive actuation 综述已将软体机器人高功率动作归入直接快速驱动与功率放大机制两类。([Nature][19])

### 7.5 制造一体化：执行、传感、计算和结构共打印

软体机器人制造未来不应只是打印一个可变形壳体，而应把传感、导线、电极、流道、磁性颗粒、刚度梯度和控制逻辑一起制造进去。Miao 等多材料 DLP 水凝胶自感知软机器人展示了驱动层与传感层一体化的趋势。([科学出版社][15])

### 7.6 从单个原型走向真实环境标准测试

软体机器人未来需要建立更接近工程应用的评价标准：

* 输出力/自重比；
* 能量效率；
* 循环寿命；
* 抗刺破与抗疲劳；
* 接触安全性；
* 定位误差；
* 载荷下变形；
* 环境适应性；
* 制造批次一致性。

2026 年系统综述指出，软体机器人在非结构化和真实环境中具有潜力，但鲁棒性、标准化和真实部署仍是关键问题。([科学出版社][21])

---

## 8. 结论

过去三年，软体机器人设计与制造研究的重心已经从“展示柔软变形能力”转向“建立可预测、可优化、可制造、可集成的力学系统”。从力学角度看，该领域的核心问题可以概括为五个层次：

1. **材料层**：如何准确描述超弹性、黏弹性、疲劳、断裂和多物理场耦合；
2. **结构层**：如何通过腔体、纤维、折纸、剪纸、超材料和双稳态结构编码变形；
3. **制造层**：如何利用多材料增材制造实现局部模量、驱动、传感和功能梯度；
4. **模型层**：如何在有限元、Cosserat 杆、降阶模型和数据驱动模型之间取得平衡；
5. **系统层**：如何把柔顺性、承载能力、控制精度、寿命和环境适应性统一起来。

总体而言，软体机器人不是“更软的传统机器人”，而是一类以材料和结构力学为计算基础的新型机器人。未来最有价值的研究机会并不在单纯提出新的软材料或新的仿生外形，而在于建立**材料—结构—制造—建模—控制—任务性能**之间的可解释映射。对于力学研究者而言，软体机器人提供了一个将非线性连续介质力学、结构稳定性、多物理场耦合、优化设计和智能制造深度结合的前沿平台。

[1]: https://www.researchgate.net/publication/379919910_Soft_Robot_Design_Manufacturing_and_Operation_Challenges_A_Review?utm_source=chatgpt.com "Soft Robot Design, Manufacturing, and Operation Challenges"
[2]: https://www.research-collection.ethz.ch/bitstreams/8c18c05e-f6b7-4a5d-852e-86a61940e627/download?utm_source=chatgpt.com "An Overview of Soft Robotics"
[3]: https://link.springer.com/article/10.1007/s43154-023-00105-z?utm_source=chatgpt.com "Modeling and Simulation of Dynamics in Soft Robotics"
[4]: https://arxiv.org/html/2407.05886v1?utm_source=chatgpt.com "Rod models in continuum and soft robot control: a review"
[5]: https://dl.acm.org/doi/abs/10.1109/TRO.2024.3386393?utm_source=chatgpt.com "Cosserat-Rod-Based Dynamic Modeling of Soft Slender ..."
[6]: https://www.science.org/doi/10.1126/scirobotics.adm8484?utm_source=chatgpt.com "Bistable soft jumper capable of fast response and high ..."
[7]: https://www.science.org/doi/10.1126/scirobotics.adq3121?utm_source=chatgpt.com "Reversible kink instability drives ultrafast jumping in ..."
[8]: https://www.nature.com/articles/s41467-025-64855-4?utm_source=chatgpt.com "Magnetoactive bistable soft actuators for programmable ..."
[9]: https://www.nature.com/articles/s41467-025-60496-9?utm_source=chatgpt.com "Soft and flexible robot skin actuator using multilayer 3D ..."
[10]: https://www.nature.com/articles/s41467-025-56025-3?utm_source=chatgpt.com "A framework for soft mechanism driven robots"
[11]: https://www.science.org/doi/10.1126/scirobotics.ads0548?utm_source=chatgpt.com "Bridging hard and soft: Mechanical metamaterials enable ..."
[12]: https://www.science.org/doi/10.1126/scirobotics.ads1292?utm_source=chatgpt.com "Advancing physical intelligence for autonomous soft robots"
[13]: https://pubs.acs.org/doi/10.1021/acs.chemrev.4c00749?utm_source=chatgpt.com "Fabrication of Soft Robotics by Additive Manufacturing"
[14]: https://advanced.onlinelibrary.wiley.com/doi/full/10.1002/adrr.202500064?utm_source=chatgpt.com "Multi‐Material Additive Manufacturing of Soft Robotic Systems ..."
[15]: https://www.sciencedirect.com/science/article/pii/S0264127525008147?utm_source=chatgpt.com "Fabrication of self-sensing soft robots via multi-material ..."
[16]: https://advanced.onlinelibrary.wiley.com/doi/full/10.1002/adts.202401014?utm_source=chatgpt.com "A Meta‐Model for The Design of Soft Pneumatic Actuators ..."
[17]: https://www.sciencedirect.com/science/article/pii/S0045782525004773?utm_source=chatgpt.com "Co-design of magnetic soft robots with large deformation ..."
[18]: https://www.nature.com/articles/s44182-025-00040-5?utm_source=chatgpt.com "Thin-film actuators (TFAs): a review | npj Robotics"
[19]: https://www.nature.com/articles/s44182-025-00045-0?utm_source=chatgpt.com "Impulsive actuation for soft robots | npj Robotics"
[20]: https://www.nature.com/articles/s44182-026-00074-3?utm_source=chatgpt.com "Advancing soft robotics: recent progress in dielectric ..."
[21]: https://www.sciencedirect.com/science/article/pii/S2215098625003192?utm_source=chatgpt.com "State-of-the-art soft robotic systems for unstructured and ..."
[22]: https://www.pnas.org/doi/10.1073/pnas.1116564108?utm_source=chatgpt.com "Multigait soft robot"
[23]: https://pubmed.ncbi.nlm.nih.gov/26017446/?utm_source=chatgpt.com "Design, fabrication and control of soft robots"
[24]: https://pubmed.ncbi.nlm.nih.gov/33157856/?utm_source=chatgpt.com "Soft robotics: Technologies and systems pushing the ..."
[25]: https://dash.harvard.edu/bitstreams/7312037d-a1d3-6bd4-e053-0100007fdf3b/download?utm_source=chatgpt.com "Pneumatic Networks for Soft Robotics that Actuate Rapidly"
[26]: https://www.researchgate.net/publication/393141038_Multi-Material_Additive_Manufacturing_of_Soft_Robotic_Systems_A_Comprehensive_Review?utm_source=chatgpt.com "(PDF) Multi‐Material Additive Manufacturing of Soft Robotic ..."
