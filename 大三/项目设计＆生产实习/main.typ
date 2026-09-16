#set page(paper: "a4", margin: (top: 2.5cm, bottom: 2.2cm, left: 2.8cm, right: 2.5cm), numbering: "1")
#set text(font: ("Times New Roman", "SimSun"), size: 10.5pt, lang: "zh")
#set par(justify: true, leading: 1em, first-line-indent: 0em)
#set heading(numbering: "1.1.")
// 模板要求：一级、二级标题均为黑体、小四号、加粗；标题后留出一行间距。
#show heading.where(level: 1): it => block(above: 1.0em, below: 0.90em)[#set text(font: ("Times New Roman", "SimHei"), size: 12pt, weight: "bold"); #it]
#show heading.where(level: 2): it => block(above: 0.85em, below: 0.90em)[#set text(font: ("Times New Roman", "SimHei"), size: 12pt, weight: "bold"); #it]
#show heading.where(level: 3): it => block(above: 0.6em, below: 0.55em)[#set text(font: ("Times New Roman", "SimHei"), size: 10.5pt, weight: "bold"); #it]
#show figure.caption: it => block(above: 0.45em)[#set text(size: 9pt); #it]
#let header-footer-gray = rgb("#808080")
#let wide-rule = line(length: 100%, stroke: (paint: header-footer-gray, thickness: 0.6pt))
#let field(content, width: 5cm) = box(width: width, height: 0.62cm, stroke: (bottom: 0.7pt))[#align(center + horizon)[#content]]
#let cover-row(label, content, width) = box(width: 7.25cm)[#text(size: 14pt)[#label]#h(0.35em)#field(content, width: width)]

// 页眉页脚
#set page(header: context {
  grid(columns: (1fr, 1fr, 1fr), align: (left, center, right),
    text(size: 8pt, fill: header-footer-gray)[机械工程学院], text(size: 8pt, fill: header-footer-gray)[2023 级生产实习], text(size: 8pt, fill: header-footer-gray)[生产实习报告])
  v(-0.2em); wide-rule
}, footer: context { align(center)[#text(fill: header-footer-gray)[－ #counter(page).display() －]] })

// 封面
#page(header: none, footer: none, margin: (top: 1cm, bottom: 2cm, left: 2.8cm, right: 2.5cm))[
  #align(center)[
    #v(1.2cm)
    // 模板采用黑色书法字校名和圆形校徽，使用从模板截图裁切的黑白标志。
    #image("zju_black_logo.png", width: 9.2cm)
    #v(1.1cm)
    #text(size: 32pt, weight: "regular")[生产实习报告]
    #v(3.20cm)
    // 模板字段为“标签 + 同行横线”，整体位于页面中线偏左位置。
    #align(center, block(width: 7.25cm)[
      #cover-row([班级：], [#text(size: 14pt)[机械2305]], 5.0cm)
      #v(0.20cm)
      #cover-row([学号：], [#text(size: 14pt)[3230103743]], 5.0cm)
      #v(0.20cm)
      #cover-row([姓名：], [#text(size: 14pt)[徐屹寒]], 5.0cm)
      #v(0.20cm)
      #cover-row([指导教师：], [#text(size: 14pt)[傅俊]], 3.95cm)
      #v(0.20cm)
      #cover-row([成绩：], [], 5.0cm)
    ])
    #v(2.55cm)
    #text(size: 14pt)[2026 年 7 月]
  ]
]

#pagebreak()
#show par: it => block[#h(2em)#it.body]
#align(center)[#text(size: 16pt, weight: "bold")[目录]]
#v(0.8cm)
#outline(title: none, indent: 1em)
#pagebreak()

#align(center)[#text(size: 12pt, weight: "bold")[摘要]]
#v(0.3cm)
本次生产实习以“ROS 机器人对弈系统”为核心项目，围绕视觉感知、棋局决策、机械臂执行、结构设计与人机交互等环节，完成了从需求分析、方案设计到实物调试的完整流程。系统通过摄像头实时采集棋盘图像，采用黑白板标定和手动角点标定建立稳定的棋盘坐标系，再以空棋盘基准图和差分分析检测新增棋子；上层使用 Minimax 与 α-β 剪枝算法生成落子决策，机械臂控制模块将目标坐标转换为末端轨迹，完成抓取、搬运、放置和复位，并将执行状态反馈给上位机。硬件方面使用 SolidWorks 建模，结合 PLA、TPU 等材料进行 3D 打印，迭代制作棋子末端执行器连接件和相机支架。实习中重点解决了视觉遮挡与光照变化、机械臂无约束路径碰撞、工作空间盲区、柔性材料打印缺陷等问题，并通过多帧稳定性判断、安全包围盒、末端姿态约束、结构补强和打印参数优化提高系统可靠性。项目还设计了可调控前端，使用户能够切换 AI 与人工模式、查看实时状态并修正棋盘占用信息。

关键词：ROS；机器视觉；机械臂；Minimax；3D 打印；人机协同

= 实习概况与项目背景

== 实习目标与任务

本项目的总体目标是搭建一套能够识别棋局、自动决策并驱动机械臂完成落子的机器人对弈系统。围绕上述目标，实习任务可分为四个方面：#linebreak()
#h(2em)第一，完成相机安装、标定和棋盘状态识别；#linebreak()
#h(2em)第二，实现棋盘坐标到机械臂工作坐标的转换以及抓取、放置动作；#linebreak()
#h(2em)第三，完成棋子连接件、相机支架等零部件的建模、打印和装配；#linebreak()
#h(2em)第四，制作前端界面，将 AI 决策、人工接管、视觉状态和执行反馈组织起来。

== 项目需求分析
系统需要在普通室内光照下稳定识别 8×8 棋盘的交点占用状态，并在每回合结束后将机械臂恢复到不遮挡摄像头的位置。视觉模块输出棋盘格坐标，决策模块根据当前棋局给出目标落点，控制模块负责安全可达的运动轨迹。对于任何一个落子，系统都应实现“识别—决策—执行—复位—再识别”的闭环流程；执行失败或识别不确定时，前端应提供人工修正入口。硬件结构还要兼顾轻量化、刚度、装配公差和可重复打印性，避免因单个连接件断裂导致整机停机。

== 系统总体架构
系统采用分层和模块化思想。底层是摄像头、机械臂、气泵和末端执行器等设备；中间层由视觉识别、坐标变换、路径规划和状态反馈节点组成；上层是棋局逻辑、Minimax 搜索和前端 Web 界面。各模块通过 ROS 话题或服务传递图像、棋盘矩阵、目标坐标和执行结果，单元可独立调试[1]。模块化解耦降低了组件之间的耦合度：视觉算法可以利用预先采集并保存的图像进行离线测试，机械臂可以用固定坐标验证轨迹，前端也能够在没有实体设备时模拟状态。这种架构为后续替换摄像头、增加不同棋类规则或接入新的机械臂保留了可能性。

= 视觉识别模块设计与实现

== 图像采集与相机标定
摄像头固定在棋盘上方，持续输出棋盘区域图像。由于镜头存在径向和切向畸变，直接使用原始像素会造成边缘格点间距不一致，因此先使用黑白棋盘格标定板采集多组不同姿态的图片，通过角点提取和相机模型求解内参、畸变系数。标定后的图像经过去畸变和透视变换，得到统一的俯视视图[2]。实际调试时，我比较了标定前后的棋盘边线和格点位置，发现边缘区域的几何误差明显减小，为后续等分算法提供了稳定输入。

#figure(image("camera_calibration.png", width: 11cm), caption: [相机标定过程]) <calibration>
@calibration 所示为使用棋盘格标定板完成相机标定后的现场画面。

== 棋盘坐标系建立
在校正图像中手动选取棋盘四个外角点，按照左上、右上、右下、左下顺序建立固定平面坐标系。通过透视变换将四边形映射为规则矩形，再按行列等分重构全部交点。@correction 给出了棋盘透视校正前后的对比，校正后棋盘被映射为规则的俯视区域，便于后续定位。

#figure(
  grid(
    columns: 2,
    gutter: 0.4cm,
    image("board_before_correction.png", height: 5.2cm),
    image("board_after_correction.png", height: 5.2cm),
  ),
  caption: [棋盘透视校正前后对比（左：校正前；右：校正后）],
) <correction>

@corner-markers 显示了用于建立坐标系的三个角点标记。相比直接检测横竖线，等分法不依赖线条连续性，能够避免棋子、反光或局部遮挡造成的直线检测失效。@grid-division 显示了在校正区域内按行列等分得到的交点结果。坐标系建立后，每个交点都有唯一的行列索引，同时保存像素坐标与机械臂平面坐标的对应关系。

#grid(
  columns: 2,
  gutter: 0.4cm,
  [#figure(image("board_corner_markers.png", height: 4.8cm), caption: [棋盘角点标记]) <corner-markers>],
  [#figure(image("board_grid_division.png", height: 4.8cm), caption: [棋盘交点等分结果]) <grid-division>],
)

== 基准图与差分检测
系统启动时采集一张无棋子的空棋盘图作为基准。当前帧先转换为灰度图，再进行归一化、轻度滤波和亮度补偿，以减弱曝光变化。将当前图像与基准图逐像素相减并阈值化，可得到新增物体区域。@difference 所示的差分图将棋盘交点附近的灰度变化直观呈现出来。以每个棋盘交点为中心取一小块区域，统计其中与空棋盘相比发生明显变化的像素比例；该比例超过设定阈值时，即判定该交点已被棋子占用。为排除手部经过、机械臂遮挡和瞬时噪声，引入候选点筛选、连通域面积限制和连续多帧一致性判断，仅当同一位置在若干帧中保持稳定才更新棋盘矩阵。

#figure(image("difference_heatmap.png", width: 12cm), caption: [棋盘状态差分图]) <difference>

== 识别流程与结果
视觉识别流程依次完成相机标定、棋盘透视校正、角点定位、交点等分和基准差分检测。调试阶段通过角点标记、等分结果和差分图对各处理步骤进行可视化。识别结果以二维数组发布给前端和决策节点。@manual-correction 展示了前端的棋盘状态与人工修正界面：当用户在界面上修正某个格点时，修正值会覆盖当前帧结果，并在下一回合重新参与差分基准更新。

#figure(image("manual_correction_ui.png", width: 15cm), caption: [前端棋盘状态与人工修正界面]) <manual-correction>

== 视觉问题及解决方法
主要问题包括：#linebreak()
#h(2em)一、环境光变化导致整幅图像亮度漂移；#linebreak()
#h(2em)二、棋子高光造成局部误检；#linebreak()
#h(2em)三、机械臂末端经过棋盘上方形成遮挡；#linebreak()
#h(2em)四、棋盘边缘线条不完整，导致传统霍夫直线检测不稳定。#linebreak()
对应措施为：#linebreak()
#h(2em)一、采用灰度归一化和局部阈值抑制亮度影响；#linebreak()
#h(2em)二、检查每个交点附近是否出现明显变化，仅将变化达到要求的交点作为候选位置；#linebreak()
#h(2em)三、规定机械臂复位后再触发视觉采集；#linebreak()
#h(2em)四、采用人工四角点加等分重构替代全自动直线提取。

= 棋局决策与机械臂控制

== Minimax 与 α-β 剪枝
棋盘状态被编码为有限离散矩阵，每个交点以空位、己方棋子或对方棋子等状态表示。AI 在当前棋局中枚举全部合法落点，将“当前局面 + 一次候选落子”视为搜索树中的一个子节点；不同的落子顺序便形成了后续的分支。由于对弈双方的目标相反，可将本方视为极大层（MAX），选择评分最高的分支；将对方视为极小层（MIN），选择使本方评分最低的分支。Minimax 算法通过双方交替选择，估计在理想应对条件下每个候选落点的最终收益[3]。

实际对局不可能无限向后搜索，因此系统设置有限搜索深度。当搜索到预设深度、终局状态或无合法落点时，算法调用评价函数对当前局面打分。评价函数综合考虑连子数量、活跃方向、中心控制和潜在威胁等因素：连子越长、可延伸方向越多，得分越高；能够直接形成连线或阻断对方威胁的落点给予更高权重。递归返回时，MAX 层保留子节点中的最大评分，MIN 层保留最小评分，根节点据此选出本回合的目标交点。

为缩短搜索时间，对搜索树使用 α-β 剪枝。α 表示 MAX 层目前已知的最佳评分下界，β 表示 MIN 层目前可接受的评分上界；当搜索过程中出现 α 大于或等于 β 时，说明该分支即使继续展开也不可能改变上层节点的选择，因此可以提前终止，无需再计算其余子节点[6]。本项目优先搜索中心位置、已有连子附近和可直接攻防的位置，以更早收紧 α、β 的范围，提高剪枝效果。在满足界面响应要求的前提下，决策节点输出评分最高的目标交点索引，坐标转换节点再将其映射为机械臂基座坐标系下的平面位置。

== 坐标变换与动作流程
目标坐标经过棋盘坐标系到世界坐标系的刚体变换，叠加棋盘高度和末端工具偏置，形成抓取和放置位姿[4]。一次完整动作包括：移动到棋子供料位置、启动气泵吸取、抬升并移动到目标点、下降放置、关闭气泵、抬升和返回初始位。每一步均设置超时和状态标志，只有在上一动作成功完成后才进入下一步。落子完成后机械臂回到初始位置，确保摄像头视野无遮挡；控制节点把“执行成功”“复位完成”“异常停止”等信息反馈给上位机。

== 机械臂 DH 参数与运动学
为描述机械臂各关节与末端执行器之间的几何关系，采用六轴串联机械臂的标准 DH 建模方法。@dh-table 给出了本项目机械臂的 DH 参数，其中 $alpha_i$ 为相邻关节轴的扭转角，$a_i$ 为连杆长度，$d_i$ 为连杆偏距，$theta_i$ 为第 $i$ 个关节的转角。该参数表定义了机械臂从基座到末端执行器的连杆尺寸和关节坐标关系。

#figure(
  table(
    columns: 5,
    align: center,
    inset: 4pt,
    stroke: 0.4pt,
    table.header([关节 $i$], [扭转角 $alpha_i$], [连杆长度 $a_i$（mm）], [连杆偏距 $d_i$（mm）], [关节变量 $theta_i$]),
    [1], [90°], [0], [103], [$theta_1$],
    [2], [0°], [225], [0], [$theta_2$],
    [3], [0°], [195], [0], [$theta_3$],
    [4], [90°], [0], [120], [$theta_4$],
    [5], [-90°], [0], [0], [$theta_5$],
    [6], [0°], [0], [85], [$theta_6$],
  ),
  caption: [机械臂 DH 参数表],
) <dh-table>

按照标准 DH 约定，第 $i$ 个关节坐标系相对于前一坐标系的齐次变换矩阵为：

#align(center)[
#text(size: 12.5pt)[$T_(i-1)^i = mat(
  cos(theta_i), -sin(theta_i) cos(alpha_i), sin(theta_i) sin(alpha_i), a_i cos(theta_i);
  sin(theta_i), cos(theta_i) cos(alpha_i), -cos(theta_i) sin(alpha_i), a_i sin(theta_i);
  0, sin(alpha_i), cos(alpha_i), d_i;
  0, 0, 0, 1
)$]
]

将六个关节变换矩阵依次相乘，可得到末端执行器相对于机械臂基座的正运动学关系：

#align(center)[$T_0^6 = T_0^1 T_1^2 T_2^3 T_3^4 T_4^5 T_5^6$]

给定关节角向量后，矩阵中的平移部分给出吸盘中心的位置，旋转部分给出末端朝向；由此可检查末端是否位于棋盘上方、吸盘是否保持竖直。

落子时，系统先将视觉模块输出的棋盘交点转换到机械臂基座坐标系，再叠加棋盘高度和吸盘偏置，得到目标末端位姿。随后求解满足该位姿的关节角组合，并检查关节角、末端高度和工作空间范围是否满足安全约束。运动轨迹不直接从当前点下降到棋盘，而是先抬升到安全高度，再移动至目标点上方，最后沿竖直方向下降放置；完成后按相反顺序抬升并复位。该流程把运动学求解与实际抓取、放置动作对应起来，便于定位不可达点和异常姿态。

== 安全约束与故障分析
无约束路径规划曾求解出机械臂“低头”穿过桌面下方的逆运动学解，造成与实验台碰撞，甚至折断气泵软管。为此，在控制总线层和路径规划器中加入三维安全包围盒，对关节角、末端高度和速度进行数值截断；同时优化基座与棋盘的相对位姿，使全部交点位于高可达性工作区。运动学求解中固定末端 Z 轴与世界 Z 轴夹角为 0°，保证吸盘始终垂直台面。对于边缘点和奇异位姿，提前进行工作空间覆盖率评估，不可达点在前端标记并禁止下发。

= 硬件设计、建模与增材制造

== 棋盘设计与激光切割
棋盘是系统进行视觉定位和机械臂落子的共同参照，采用激光切割制作。加工前在 AutoCAD 中绘制棋盘外轮廓和等距网格，并将图纸导出为 DXF 文件用于加工。@chessboard-cad 展示了棋盘的 CAD 绘制结果。切割完成后的棋盘网格既用于相机标定和交点定位，也为机械臂坐标转换提供了明确的物理位置参照。

#figure(image("chessboard_cad.png", width: 12cm), caption: [棋盘激光切割 CAD 图]) <chessboard-cad>

== 末端执行器连接件
#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.4cm,
    align: center,
    image("end_effector_model.png", height: 5cm),
    image("end_effector_physical.jpg", height: 5cm),
  ),
  caption: [末端执行器建模图与实物图（左：建模图；右：实物图）],
) <part>
连接件的一端需要与机械臂法兰可靠装配，另一端需要为气泵提供安装接口，同时为棋子吸取保留必要空间。建模时先依据实测法兰孔距建立基准面，再通过拉伸、圆角和螺纹孔完成主体结构。第一版零件壁厚偏薄，且 FDM 打印层间结合存在各向异性，在跌落和轻微碰撞测试中发生脆性断裂。第二版增加关键区域壁厚和过渡圆角，并重新安排打印方向，使主要受力方向尽量沿层面传递。

== 相机支架与装配
@bracket-parts 和 @bracket-male 分别给出了相机支架母头和公头零件的建模结果；@bracket-assembly 和 @bracket-physical 分别展示了两件装配后的模型与打印实物。相机支架承担视场稳定和快速拆装功能。设计中采用公母头插接结构实现快速装配。

#grid(
  columns: (1fr, 1fr),
  gutter: 0.4cm,
  align: center,
  [#figure(image("camera_bracket_part_a.png", height: 5.2cm), caption: [相机支架母头零件模型]) <bracket-parts>],
  [#figure(image("camera_bracket_part_b.png", height: 5.2cm), caption: [相机支架公头零件模型]) <bracket-male>],
)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.4cm,
  align: center,
  [#figure(image("camera_bracket_assembly.png", height: 5.2cm), caption: [相机支架装配模型]) <bracket-assembly>],
  [#figure(image("camera_bracket_physical.png", height: 5.2cm), caption: [相机支架打印实物]) <bracket-physical>],
)

装配前对打印件进行去毛刺和孔位修整。

== PLA 与 TPU 打印参数优化
刚性件主要采用 PLA，柔性气泵连接件采用 TPU。TPU 长丝在挤出机中容易屈曲和滞后，直接沿用 PLA 的高速度会造成挤出不均、拉丝和层间结合差。为此降低打印速度和空移速度，适当提高回抽距离，优化喷嘴温度和冷却比例，并在关键部位采用较高填充率[5]。打印后通过尺寸测量和装配试验验证公差，必要时对孔径进行补偿。材料切换必须伴随工艺参数切换，这是本次制造调试得到的重要经验。

== 迭代结果
结构补强后，连接件在多次抓取、复位和轻微碰撞测试中未再出现断裂；TPU 参数优化后，表面拉丝减少，软管连接处的气密性和耐弯折性能改善。

= 前端、人机协同与系统联调

== 前端可调控设计
#figure(image("frontend_ui.png", width: 12cm), caption: [前端棋盘、AI 与状态监控界面]) <frontend>
前端 Web 界面负责对弈流程编排、模式切换和状态展示。用户可以选择 AI 对弈或人工接管，查看棋盘占用矩阵、当前回合、机械臂动作和异常提示。当视觉识别受到遮挡、光照或局部误差影响时，用户可直接点击棋盘格修正状态。该设计没有把所有逻辑塞进 ROS，而是通过清晰接口让前端承担流程控制，从而保留自动化能力和人工干预能力。

== 系统联调过程
联调遵循由局部到整体的顺序：先用静态图片验证标定和差分，再用固定坐标测试机械臂单点动作，随后测试抓取—放置序列，最后接入 AI 和前端。每次只改变一个变量并记录日志，包括图像阈值、目标坐标、关节角、执行耗时和异常类型。

== 系统性能与局限
系统能够完成棋局状态更新和机械臂自动落子，但对极端光照、棋子严重遮挡和棋盘位置变化仍较敏感。每次对弈基准图需要重新采集，坐标变换依赖人工角点；机械臂路径主要采用预设动作，复杂障碍环境下的在线规划能力有限。后续应通过自动重定位、深度相机和更完善的异常恢复机制提升鲁棒性。

= 实习体会与建议设想

== 个人体会
这次实习中，真正花时间的是把已经能单独运行的模块接在一起调试。视觉部分刚开始会受到光照变化影响，空棋盘基准图和当前画面的差异不够稳定；后来加入多帧确认后，识别结果才更可靠。机械臂部分也让我意识到，末端能够到达目标点并不代表动作就安全，还需要检查抬升高度、运动路径和复位位置。打印连接件时，第一版的壁厚和过渡区域不够可靠，经过实际装配和碰撞测试后才知道需要调整结构。通过这些反复修改，我对视觉、控制和结构之间如何相互影响有了更具体的认识，也更习惯在调试时保留测试记录，逐项排查问题。

== 改进建议
#h(-2em)第一，建立自动化标定流程，利用 AprilTag 或棋盘格自动提取角点，减少人工操作并支持棋盘移动后的快速重定位。#linebreak()
第二，引入深度相机或轻量目标检测模型，将颜色、形状和深度信息融合，提高遮挡与复杂光照下的识别能力。#linebreak()
第三，在路径规划中加入实时碰撞检测、速度分级和力/电流异常监测，形成软限位、硬限位和急停三级安全机制。#linebreak()

= 参考文献
1. Quigley M, Conley K, Gerkey B, et al. ROS: an open-source Robot Operating System. *ICRA Workshop*, 2009.
2. Szeliski R. *Computer Vision: Algorithms and Applications*. Springer, 2022.
3. Russell S, Norvig P. *Artificial Intelligence: A Modern Approach*. Pearson, 2021.
4. Siciliano B, Khatib O. *Springer Handbook of Robotics*. Springer, 2016.
5. Gibson I, Rosen D, Stucker B. *Additive Manufacturing Technologies*. Springer, 2021.
6. Knuth D E, Moore R W. An analysis of alpha-beta pruning. *Artificial Intelligence*, 1975, 6(4): 293-326.
