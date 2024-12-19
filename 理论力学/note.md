# 理论力学
## 第一章 静力学公理和物体的受力分析
### 各种约束
![alt text](image.png)
<img src='./image-1.png' height=200 align=right>

### 例题1 
机构如图所示，不计各杆自重，试画出AB杆、CD杆的受力图

注意到CD杆是二力杆
<img src='./image-2.png' height=200>

点C受到$F_C$的反作用力$F_C'$，A点受到固定铰链支座约束，其约束力为一对正交分力
AB杆在A,B,C三点受到三个力。由三力汇交原理三力交于一点
<img src='./image-3.png' height=300>

## 第二章 平面力系
### 平面力偶系
<img src='./image-4.png' width=200 align=right>

力偶就是等值、反向不共线的两个力

力偶矩$M=\pm Fd$（逆时针为正，顺时针为负）

#### 平面力偶矩的性质
1. 力偶在任意坐标轴上投影为0
2. 力偶没有合力，只能由力偶来平衡
3. 力偶对任意点取矩都等于力偶矩，不因矩心改变而改变
4. 只要保持力偶矩不变，力偶可以在其作用面内任意移转，且可以改变力偶中力的大小与力偶臂的长短，对刚体的作用效果不变。

#### 力偶矩的合成与平衡
合力偶矩 $M=\sum M_i$

### 力的平移定理
作用在刚体上一点的力$\mathbf{F}$可以平移到另一点，但必须同时附加一个力偶，这个附加力偶的矩等于原来的力对新作用点的矩。
![alt text](image-5.png)
### 平面任意力系
![alt text](image-6.png)
主矢$\mathbf{F_R'}=\sum\mathbf{F_i}$，与简化中心无关
主矩$\mathbf{M_O}=\sum\mathbf{M_O}(\mathbf{F_i})$，与简化中心有关
#### 向一点简化的结果
![alt text](image-7.png)
#### 平面任意力系的平衡
![alt text](image-8.png)
由此可知，平面任意力系的平衡方程最多求解出三个未知量。因此，选取研究对象时应选择**未知量小于等于三个**的。
### 例题2
<img src='./image-9.png' width=250 align=right>

如图所示，已知$F=20kN,M=8kN·m，a=0.8m，q=100kN/m$。求支座B、C的反力。

B处为固定铰链支座约束，C处为活动铰链支座约束
<img src='./image-10.png' width=250>


如图所示
$$\left\{\begin{array}{l}
\sum F_{x}=0 \quad\quad F_{Bx}=0\\
\sum F_{y}=0 \quad\quad qa+F-F_{By}-F_C=0\\
\sum M_{B}=0 \quad -F\cdot 3a + F_C\cdot2a+qa\cdot \frac{1}{2}a=0
\end{array}\right.\\\quad\\
\Rightarrow
\left\{\begin{array}{l}
F_{Bx}=0 \\
F_{By}=95kN \\
F_C=5kN 
\end{array}\right.$$
### 例题3
<img src='./image-11.png' width=250 align=right>

连续梁由AB和BC两部分组成，其所受载荷如图所示，求固定端A和铰链支座C的约束反力。

A处为固定端约束，受到一对正交约束力和一对力偶的作用，即三个未知量；C处为活动铰链支座约束，受到一个正交约束力作用，共有四个未知量，以整体为研究对象不可取。

<img src='./image-12.png' width=250 align=right>

以BC梁为研究对象时B处为中间铰链约束，受到一对正交约束力作用，C处为活动铰链支座约束，共三个未知量
<br>

$$\left\{\begin{array}{l}
\sum F_{x}=0 \quad\quad F_{Bx}-P\cdot\cos60^\circ-F_C\cdot\sin30^\circ=0\\
\sum F_{y}=0 \quad\quad F_{By}-P\cdot\sin60^\circ+F_C\cdot\cos30^\circ=0\\
\sum M_{B}=0 \quad -M-P\cdot\sin60^\circ\cdot a+F_C\cdot\cos30^\circ\cdot2a=0
\end{array}\right.$$

$$F_{Bx}=\frac{3}{4}P+\frac{M}{2\sqrt{3}\alpha}\quad F_{By}=\frac{\sqrt{3}}{4}P-\frac{M}{2\alpha}\quad F_C=\frac{M}{\sqrt{3}\alpha}+\frac{1}{2}P$$ 

<img src='./image-13.png' width=250 align=right>

三角形分布载荷的大小为$\dfrac{1}{2}\cdot2qa$，作用点等效与距离$A$点$\dfrac{1}{3}\cdot 2a$处
$$\left\{\begin{array}{l}
\sum F_{x}=0 \quad\quad F_{Ax}-F_{Bx}^{\prime}=0\\
\sum F_{y}=0 \quad\quad F_{Ay}-q\cdot2a\cdot\frac{1}{2}-F_{By}^{\prime}=0\\
\sum M_{A}=0 \quad -M_A-2qa\cdot\frac{1}{2}\cdot\frac{1}{3}\cdot2a-F_{By}^{\prime}\cdot2a=0
\end{array}\right.$$
$$F_{Ax}=\frac{3}{4}P+\frac{M}{2\sqrt{3}a}\quad F_{Ay}=\frac{\sqrt{3}}{4}P-\frac{M}{2a}+qa\quad M_A=M-\frac{\sqrt{3}}{2}Pa-\frac{2}{3}qa^2$$
### 例题4
<img src='./image-14.png' width=250 align=right>

图示结构中物体$Q$重$1.2kN,AD=DB=2m，CD=DE=1.5m$，不计杆与滑轮自重，求$A,B$处的支座反力及杆$BC$的内力。

对整体而言，A处为固定铰链支座约束，有两个未知力，B点为活动铰链支座约束，有一个未知力，其余外力已知

画出约束力如右图
<br>
<img src='./image-15.png' width=250 align=right>

$$F_T=P=1.2kN$$
可以列出平面任意力系的平衡方程
$$\left\{\begin{array}{l}
\sum F_{x}=0 \quad\quad F_{Ax}-F_T=0\\
\sum F_{y}=0 \quad\quad F_{Ay}+F_B-P=0\\
\sum M_{A}=0 \quad F_B\cdot4-P(2+r)-F_T(1.5-r)=0
\end{array}\right.$$
$$F_{Ax}=F_T=1.2kN\quad F_{B}=1.05kN\quad F_{Ay}=0.15kN$$
下面求$BC$杆的内力，显然$BC$杆是二力杆。
<img src='./image-16.png' width=150 align=right>

将CDE杆以及重物分离出来，对$D$点取矩（因为$D$点的两个力不需要求解）
$$\sum M_D=0\\-F_{BC}\cdot\sin\theta\times1.5-p\cdot r-F_T(1.5-r)=0\\F_{BC}=-\frac{P}{\sin\theta}=-\frac{1.2kN}{\frac{2}{\sqrt{2^{2}+1.5^{2}}}}=-1.5kN$$
### 桁架内力计算
#### 节点法
节点法适用于求桁架中所有杆件内力情况
![](./image-17.png)
平面汇交力系只有两个独立的平衡方程，一般选取不超过两个未知力的节点作为研究对象
##### 解题步骤
1. 取整体为研究对象求约束反力
2. 选取节点，列平衡方程求内力
#### 例题5
<img src='./image-18.png' width=250 align=right>

如图平面桁架,求杆AF、AC的内力。已知铅垂力$F_C=4kN$,水平力$F_E=2kN$。

先取整体为研究对象
<img src='./image-19.png' width=250>

$$\left\{\begin{array}{l}
\sum F_{x}=0 \quad\quad F_{Ax}-F_E=0\\
\sum F_{y}=0 \quad\quad F_{Ay}+F_B-F_C=0\\
\sum M_{A}=0 \quad F_B\cdot3a-F_E\cdot a-F_C\cdot a=0
\end{array}\right.\\\quad\\
F_{Ax}=-2kN\quad F_{Ay}=2kN\quad F_B=2kN$$

取点A
$$\begin{cases}\sum F_x=0\\\sum F_y=0&\end{cases}\quad\Rightarrow\quad\begin{cases}F_{Ax}+F_{AC}+F_{AF}\cos45^\circ=0\\F_{Ay}+F_{AF}\sin45^\circ=0&\end{cases}$$
解得
$$\begin{cases}F_{AF}=-2\sqrt{2}kN\\F_{AC}=4kN&\end{cases}$$
#### 截面法
适用于求桁架中几根杆内力情况
![alt text](image-20.png)
平面任意力系只有3个独立平衡方程，一般截断的杆件不超过三根
### 静定与超静定问题
未知量数目等于独立方程数目，是静定问题:
未知量数目超过独立方程数目，是静不定(超静定)问题
#### 例题6
<img src='./image-21.png' width=250 align=right>

图示平面桁架,各杆长度均为1m,在节点E、G、F上分别作用载荷$F_E=10kN,F_G=7kN,F_F=5kN$，计算1,2,3杆的内力

先以桁架整体为研究对象

$$\begin{cases}\sum F_x=0\quad\quad F_{Ax}+F_F=0\\
\sum F_y=0\quad \quad F_{Ay}+F_B-F_E-F_G=0\\
\sum M_B(F)=0\quad F_E\cdot 2+F_G\cdot 1-F_{Ay}\cdot 3 -F_F\sin 60^\circ\cdot 1=0&\end{cases}$$
解得 
$$\left.\left\{\begin{array}{c}F_{Ax}=-5kN\\F_{Ay}=7.557kN\\F_{B}=9.44kN\end{array}\right.\right.$$
<img src='./image-22.png' width=250 align=right>

取截面左半部分为研究对象
$$\begin{cases}\sum M_E\left(F\right)=0\\\sum F_y=0\\\sum M_D\left(F\right)=0&\end{cases}  $$
$$\begin{cases}-F_1\cdot\sin60^\circ\cdot1-F_{Ay}\cdot1=0\\F_{Ay}+F_2\cdot\sin60^\circ-F_E=0\\F_E\cdot\frac{1}{2}+F_3\cdot\sin60^\circ\cdot1-F_{Ay}\cdot1.5+F_{Ax}\cdot\sin60^\circ\cdot1=0&\end{cases}$$
解得$$F_{1}=-8.726kN\quad F_{2}=2.821kN\quad F_{3}=12.32kN$$
<img src='./image-23.png' width=250 align=right>

## 第三章 空间力系
### 力对点的矩

$$\vec{M}_o(\vec{F})=\vec{r}\times\vec{F}$$

### 力对轴的矩
<br>
<br>

$$M_x(\vec{F})=yF_z-zF_y\quad M_y(\vec{F})=zF_x-xF_z\quad M_z(\vec{F})=xF_y-yF_x$$
$x,y,z$表示力的作用点的坐标
### 重心（形心）
#### 半圆形重心
<img src='./image-24.png' width=250>

## 第七章 点的合成运动
### 相对运动 牵连运动 绝对运动
习惯把固定在地球上的参考系称为**定参考系**，简称**定系**，以$Oxyz$坐标表示，固定在其他相对于地球运动的参考系上的坐标系称为**动坐标系**，简称**动系**，以$Ox'y'z'$坐标系表示
动点相对于定参考系的运动称为**绝对运动**，动点相对于动参考系的运动称为**相对运动**，动参考系相对于定参考系的运动称为**牵连运动**
### 点的绝对运动和相对运动之间的关系
<img src='./img/01.jpg' height=250 align=right>

$Oxy$是定参考系，$O'x'y'$是动参考系，$M$是动点，如图所示。动点$M$的绝对运动方程为
$$x=x(t),y=y(t)$$
动点$M$的相对运动方程为
$$x'=x'(t),y'=y'(t)$$
动参考系相对于定参考系的运动可以由如下三个方程完全描述：
$$x_{O'}=x_{O'}(t),y_{O'}=y_{O'}(t),\varphi=\varphi(t)$$
这三个方程称为牵连运动方程，其中$\varphi$角是从$x$轴到$x'$轴的转角，逆时针为正。动参考系与定参考系的坐标变换关系为
$$\begin{cases}
    x=x_{O'}+x'\cos\varphi-y'\sin\varphi\\
    y=y_{O'}+x'\sin\varphi+y'\cos\varphi
\end{cases}$$
### 点的速度合成定理
$$\mathbf{v}_a=\mathbf{v}_e+\mathbf{v}_r$$
动点在某瞬时的**绝对速度**等于它在该瞬时的**牵连速度**和**相对速度**的矢量和
### 点的加速度合成定理
$$\mathbf{a}_a=\mathbf{a}_r+\mathbf{a}_e+\mathbf{a}_C$$
动点在某瞬时的**绝对加速度**等于它在该瞬时的**牵连加速度**、**相对加速度**和**科氏加速度**的矢量和
$$\mathbf{a}_C=2\mathbf{\omega}\times\mathbf{v}_r$$
其中$\mathbf{\omega}$为动系绕定轴转动的角速度矢量（若动系做平动则为0）