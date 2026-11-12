#set document(title: "直线插补与加减速计算", author: "")
#set page(
  paper: "a4",
  margin: (x: 20mm, top: 18mm, bottom: 17mm),
  numbering: "1",
)
#set text(font: ("Times New Roman", "SimSun"), size: 10.5pt, lang: "zh")
#set par(justify: true, leading: 0.62em, first-line-indent: 2em)
#set table(
  inset: (x: 5pt, y: 6pt),
  stroke: 0.45pt + rgb("777777"),
  align: center + horizon,
)
#let unit(s) = math.upright(s)
#let gray = rgb("666666")
#let ink = rgb("253d56")
#let dashed = (paint: rgb("999999"), thickness: 0.5pt, dash: "dashed")
#let segment(..args) = place(top + left, line(..args))

#block(above: 0.9em, below: 0.6em)[#text(font: "SimHei", size: 12pt)[题目]]

假定某数控机床系统的加速度与减速度大小相等，$A=D=20000 thin unit("count/s²")$，最小插补时间为 $T_(min)=0.002 thin unit("s")$。位置和进给率的单位分别为 count（计数单位）和 count/s。刀具起点为 $(0,0)$，程序段如下：

#align(center)[#text(font: "Consolas", size: 11pt)[N010 G91 G01 X5 Y-3 F600]]

说明该直线插补程序段的工作原理，计算插补参数，并用图形和表格表示最终的刀具路径。位置单位用 count，进给率单位用 count/s。

#block(above: 1em, below: 0.6em)[#text(font: "SimHei", size: 12pt)[解答]]

G91 表示增量编程，G01 表示直线插补，刀具由 $(0,0)$ 沿直线运动到 $(5,-3)$，指令进给率为 $F=600 thin unit("count/s")$。本段按起、终点速度均为零计算。采用等步长插补时，两轴按固定的坐标增量同时进给，各插补点始终位于该直线上；加减速则通过改变每步的时间间隔实现。

由程序给出的两轴位移可得
$
  delta x=5, quad delta y=-3, quad
  L=sqrt((delta x)^2+(delta y)^2)=sqrt(34) approx 5.830952 thin unit("count").
$
按指令进给率和最小插补时间，名义步长及对应的步数为
$
  Delta u_0=F T_(min)=1.2 thin unit("count"), quad
  N_0=L/(Delta u_0) approx 4.859.
$
考虑到加速、减速步数对称，将总步数向上取为偶数 $N=6$，修正后的步长及对应进给率为
$
  Delta u=L/N approx 0.971825 thin unit("count"), quad
  F'= (Delta u)/T_(min) approx 485.913 thin unit("count/s").
$
两轴每步的坐标增量相应为
$
  Delta x=(delta x)/N=5/6 thin unit("count"), quad
  Delta y=(delta y)/N=-0.5 thin unit("count").
$
故第 $k$ 个插补点的坐标为 $(x_k,y_k)=(5k/6,-k/2)$，其中 $k=0,1,dots,6$。

从静止加速到 $F'$ 所需的距离，折合成插补步数为
$
  N_a=frac((F')^2,2A Delta u) approx 6.074 > N/2=3.
$
半程只有三步，不能达到 $F'$，因此没有匀速段，前三步加速，后三步减速，即 $N_1=N_3=3$、$N_2=0$。速度在中点达到最大值：
$
  f_(max)=sqrt(2A dot 3 Delta u)=sqrt(A L)
  approx 341.495 thin unit("count/s").
$

#pagebreak()

设到达第 $k$ 个插补点的时刻为 $t_k$，则该步的插补间隔为 $Delta t_k=t_k-t_(k-1)$。加速段满足 $k Delta u=A t_k^2/2$，因而
$
  t_k=sqrt(frac(2k Delta u,A)), quad f_k=A t_k quad (k=1,2,3).
$
代入 $k=1,2,3$，得到
$
  Delta t_1 &= sqrt(frac(2 Delta u,A)) approx 9.858 thin unit("ms"), \
  Delta t_2 &= sqrt(frac(4 Delta u,A))-t_1 approx 4.083 thin unit("ms"), \
  Delta t_3 &= sqrt(frac(6 Delta u,A))-t_2 approx 3.133 thin unit("ms").
$
减速段与加速段对称，有 $Delta t_4=Delta t_3$、$Delta t_5=Delta t_2$、$Delta t_6=Delta t_1$，总时间为 $T=2t_3 approx 34.150 thin unit("ms")$。减速段各点的速度按 $f_k=A(T-t_k)$ 计算，结果如下表。最短插补间隔为 $3.133 thin unit("ms")$，大于规定的 $2 thin unit("ms")$。

#v(1mm)
#figure(
  table(
    columns: (0.6fr, 1.25fr, 1.35fr, 1.35fr, 1.15fr, 1.15fr),
    table.header(
      [步数 $k$], [进给率 $f_k$\ count/s], [间隔 $Delta t_k$\ ms],
      [累计时间 $t_k$\ ms], [$x_k$\ count], [$y_k$\ count],
    ),
    [0], [0.000], [—], [0.000], [0.0000], [0.0000],
    [1], [197.162], [9.858], [9.858], [0.8333], [−0.5000],
    [2], [278.830], [4.083], [13.941], [1.6667], [−1.0000],
    [3], [341.495], [3.133], [17.075], [2.5000], [−1.5000],
    [4], [278.830], [3.133], [20.208], [3.3333], [−2.0000],
    [5], [197.162], [4.083], [24.291], [4.1667], [−2.5000],
    [6], [0.000], [9.858], [34.150], [5.0000], [−3.0000],
  ),
  caption: [各插补点的速度、时间与坐标],
)
#v(1mm)

相应的速度曲线和刀具路径如下图。路径图中两轴比例相同，圆点编号与表中的 $k$ 对应，六步后到达终点 $(5,-3)$。

#let velocity-plot() = {
  let px(t) = 9mm + t / 36 * 62mm
  let py(f) = 47mm - f / 500 * 35mm
  let times = (0, 9.858120, 13.941487, 17.074765, 20.208043, 24.291410, 34.149530)
  let speeds = (0, 197.162402, 278.829742, 341.495297, 278.829742, 197.162402, 0)
  block(width: 78mm, height: 59mm, {
    set text(size: 8pt)
    place(top + left, dx: 3mm, dy: 0mm, [$f$ / (count/s)])
    place(top + left, dx: 60mm, dy: 52mm, [$t$ / ms])
    segment(start: (px(0), py(0)), end: (px(36), py(0)), stroke: 0.65pt)
    segment(start: (px(0), py(0)), end: (px(0), py(530)), stroke: 0.65pt)
    segment(start: (px(0), py(485.913)), end: (px(34.15), py(485.913)), stroke: dashed)
    place(top + left, dx: 34mm, dy: 7mm, text(fill: gray, size: 7.5pt)[$F'=485.913$])
    for f in (0, 200, 400) {
      place(top + left, dx: 1mm, dy: py(f) - 1.7mm, [#f])
      segment(start: (px(0) - 0.8mm, py(f)), end: (px(0), py(f)), stroke: 0.5pt)
    }
    for t in (10, 20, 30) {
      place(top + left, dx: px(t) - 1.8mm, dy: py(0) + 1.4mm, [#t])
      segment(start: (px(t), py(0)), end: (px(t), py(0) + 0.8mm), stroke: 0.5pt)
    }
    segment(start: (px(17.074765), py(0)), end: (px(17.074765), py(341.495297)), stroke: dashed)
    for k in range(6) {
      segment(start: (px(times.at(k)), py(speeds.at(k))),
        end: (px(times.at(k+1)), py(speeds.at(k+1))), stroke: 1pt + ink)
    }
    for k in range(7) {
      place(top + left, dx: px(times.at(k)) - 0.65mm, dy: py(speeds.at(k)) - 0.65mm,
        circle(radius: 0.65mm, fill: ink, stroke: none))
    }
    place(top + left, dx: 34mm, dy: 19mm, text(size: 7.5pt)[341.495])
  })
}

#let path-plot() = {
  let px(x) = 10mm + x * 11mm
  let py(y) = 12mm - y * 11mm
  block(width: 78mm, height: 59mm, {
    set text(size: 8pt)
    place(top + left, dx: 1mm, dy: 0mm, [$y$ / count])
    place(top + left, dx: 55mm, dy: 0mm, [$x$ / count])
    segment(start: (px(0), py(0)), end: (px(5.5), py(0)), stroke: 0.65pt)
    segment(start: (px(0), py(0.3)), end: (px(0), py(-3.3)), stroke: 0.65pt)
    for x in range(1, 6) {
      segment(start: (px(x), py(0)), end: (px(x), py(0) - 0.8mm), stroke: 0.5pt)
      place(top + left, dx: px(x) - 0.8mm, dy: py(0) - 5mm, [#x])
    }
    for y in (-1, -2, -3) {
      segment(start: (px(0) - 0.8mm, py(y)), end: (px(0), py(y)), stroke: 0.5pt)
      place(top + left, dx: 2mm, dy: py(y) - 1.7mm, [$#y$])
    }
    segment(start: (px(5), py(0)), end: (px(5), py(-3)), stroke: dashed)
    segment(start: (px(0), py(-3)), end: (px(5), py(-3)), stroke: dashed)
    segment(start: (px(0), py(0)), end: (px(5), py(-3)), stroke: 1pt + ink)
    for k in range(7) {
      place(top + left, dx: px(5*k/6) - 0.7mm, dy: py(-k/2) - 0.7mm,
        circle(radius: 0.7mm, fill: ink, stroke: none))
      place(top + left, dx: px(5*k/6) + 1.2mm, dy: py(-k/2) - 2.2mm, [#k])
    }
    place(top + left, dx: 10mm, dy: 49mm, text(size: 8pt)[起点 $(0,0)$，终点 $(5,-3)$])
  })
}

#figure(
  grid(columns: (1fr, 1fr), gutter: 5mm,
    align(center, velocity-plot()), align(center, path-plot()),
    align(center)[#text(size: 9pt)[（a）合成进给率随时间变化]],
    align(center)[#text(size: 9pt)[（b）刀具路径与插补点]],
  ),
)

