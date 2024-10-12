## 第九章 真空中的静电场
### 库仑定律
<img src="./pic/electric_dipole.jpg" width=300 align=right></img>
$$\mathbf{F} = \frac{1}{4\pi\epsilon_0}\frac{q_1q_2}{r_{12}^2}\mathbf{e_{12}}$$

#### 电偶极子
一对等量异号点电荷$+q$和$-q$，相距为$l$。当从观察点到两电荷连线的距离$x\gg l$时，则这一对点电荷称为电偶极子
定义电偶极矩$\mathbf{p_e}=q\mathbf{l}$，$\mathbf{l}$的方向由负电荷指向正电荷
电偶极子中垂线上距两电荷中点$O$距离为$x$处的场强为
$$\mathbf{E}=-\frac{1}{4\pi \epsilon_0}\frac{\mathbf{p_e}}{x^3}$$

#### 均匀带电直线外任意一点的场强（2021 T12）
<img src="./pic/line.jpg" width=400 align=right></img>

一均匀带电直线，长为$L$，带电量为$q$，线外一点$P$到直线的垂直距离为$a$，$P$与直线两端的连线与直线间的夹角分别为$\theta_1,\theta_2$，如图所示。求$P$点的场强
解：
选取如图所示的坐标系，有$dq=\frac{q}{L}dx$
该电荷元在$P$点产生的场强的大小为
$$dE=\frac{1}{4\pi\epsilon_0}\frac{qdx}{Lr^2}$$
有$dE_x=dE\cos\theta,dE_y=dE\sin\theta$
$$\displaystyle E_x=\int dE_x=\int dE\cos\theta=\int\frac{1}{4\pi\epsilon_0}\frac{q\cos\theta}{Lr^2}dx\\\displaystyle E_y=\int dE_y=\int dE\sin\theta=\int\frac{1}{4\pi\epsilon_0}\frac{q\sin\theta}{Lr^2}dx$$
$$r=\frac{a}{\sin\theta},x=-a\cot\theta,dx=\frac{a}{\sin^2\theta}d\theta$$
$$\displaystyle E_x=\int^{\theta_2}_{\theta_1}\frac{q}{4\pi L\epsilon_0 a}\cos\theta d \theta=\frac{q}{4\pi L\epsilon_0 a}(\sin\theta_2-\sin\theta_1)\\\displaystyle E_y=\int^{\theta_2}_{\theta_1}\frac{q}{4\pi L\epsilon_0 a}\sin\theta d \theta=\frac{q}{4\pi L\epsilon_0 a}(\cos\theta_1-\cos\theta_2)$$
### 电通量
$$\Phi_e =\displaystyle\int_s\mathbf{E} \cdot d \mathbf{S}$$
### 高斯定理
通过任意闭合曲面的电通量等于该曲面所包围的所有电量的代数和除以$\epsilon_0$
$$\Phi_e = \displaystyle\int_s\mathbf{E} \cdot d \mathbf{S}=\frac{1}{\epsilon_0}\sum_iq_i$$
### 常见电势公式
#### 球壳
<img src="./pic/01.jpg" width=200 align=right>

半径为$R$，总电量为$q$的均匀带电球面形成电场中电势的分布情况为
$$U(r)=\begin{cases}
\dfrac{q}{4\pi \epsilon_0 R},r\leq R\\
    \dfrac{q}{4\pi \epsilon_0 r},r>R
\end{cases}$$
#### 电偶极子
两点电荷为$\pm q$，相距为$l$的电偶极子电场中任一点$P$的电势
<img src="./pic/02.jpg" width=200 align=right>

$$U_p=\frac{1}{4\pi\epsilon_0}\frac{ql\cos\theta}{x^2+y^2}$$

证明
$$U_P=U_1+U_2=\frac{1}{4\pi\epsilon_0}\left(\frac{q}{r_1}-\frac{q}{r_2}\right)=\frac{q}{4\pi\epsilon_0}\left(\frac{r_2-r_1}{r_1r_2}\right)$$
因为$r\gg l$,则有$r_2-r_1\approx l\cos\theta,r_1r_2=r^2$
因而
$$U_p=\frac{q}{4\pi \epsilon_0}\frac{l\cos\theta}{r^2}=\frac{1}{4\pi\epsilon_0}\frac{ql\cos\theta}{x^2+y^2}$$
#### 无限长均匀带电直线
电荷线密度为$\lambda$的无限长均匀带电直线，距带电直线$r$的$p$点的电势为
$$U_p=-\frac{\lambda}{2\pi\epsilon_0}\ln r+C$$
证明
无限长均匀带电直线周围的电场强度为
$$E=\frac{\lambda}{2\pi \epsilon_0 r}$$
如果选无穷远处作为电势零点，经过积分可知各点电势都是无穷大。
我们可以选取距带电直线$r_0$处的$p_0$点的电势为零参考点。
$$\displaystyle U_p=\int^{p_0}_p\mathbf{E}d\mathbf{l}=\int^{p_0}_p\frac{\lambda}{2\pi \epsilon_0 r}dr=-\frac{\lambda}{2\pi\epsilon_0}\ln r+\frac{\lambda}{2\pi\epsilon_0}\ln r_0$$
可以表示为
$$U_p= -\frac{\lambda}{2\pi\epsilon_0}\ln r+C$$
### 电场强度和电势的关系
$$\mathbf{E}=-\nabla U$$
## 第十章 静电场中的导体和电介质
### 静电平衡
1. 导体内部场强处处为0
2. 导体表面外侧，紧靠表面处的场强处处与表面垂直
3. 导体是个等势体，导体表面是个等势面
### 电容器的电容
两导体带有等量异号的电荷$Q$，导体间的电势差为$U_A-U_B$
$$C=\frac{Q}{U_A-U_B}$$
#### 平行板电容器
$$C=\epsilon_0\frac{S}{d}$$
#### 圆柱形电容器
两半径分别为$R_A$和$R_B$，长为$l$的圆柱面的电容
<img src="./pic/03.jpg" height=250 align=right>

$$C=\frac{2\pi\epsilon_0l}{\ln\dfrac{R_B}{R_A}}$$
证明
令内外圆柱面单位长度的带电量分别为$+\lambda$和$-\lambda$
由高斯定理，取半径为$r$的圆柱面$(R_A<r<R_B)$
$$E=\frac{\lambda}{2\pi\epsilon_0 r}$$
$$U_A-U_B=\displaystyle\int^{R_B}_{R_A}\mathbf{E}d\mathbf{r}=\int^{R_B}_{R_A}\frac{\lambda}{2\pi\epsilon_0r}dr=\frac{\lambda}{2\pi\epsilon_0}\ln\frac{R_B}{R_A}$$
$$C=\frac{Q}{U_A-U_B}=\frac{\lambda l}{U_A-U_B}=\frac{2\pi\epsilon_0l}{\ln\dfrac{R_B}{R_A}}$$
#### 球形电容器
半径分别为$R_A$和$R_B$的同心的金属球壳组成的球形电容器的电容
$$C=\frac{4\pi\epsilon_0R_AR_B}{R_B-R_A}$$
证明
设内外球壳带电荷$+Q$和$-Q$
由高斯定理，取半径为$r$的球面$(R_A<r<R_B)$
$$E=\frac{Q}{4\pi\epsilon_0r^2}$$
$$U_A-U_B=\displaystyle\int^{R_B}_{R_A}\mathbf{E}d\mathbf{r}=\int^{R_B}_{R_A}\frac{Q}{4\pi\epsilon_0r^2}=\frac{Q}{4\pi\epsilon_0}\left(\frac{1}{R_A}-\frac{1}{R_B}\right)$$
$$C=\frac{Q}{U_A-U_B}=\frac{4\pi\epsilon_0R_AR_B}{R_B-R_A}$$
### 电介质
#### 电介质对电场的影响
$$U=\frac{U_0}{\epsilon_r}$$
$$C=\epsilon_rC_0$$
$$E=\frac{E_0}{\epsilon_r}$$
$\epsilon_r$为仅与电介质有关的常数，称为电介质的**相对介电常数**
#### 电极化强度
对大多数各项同性电介质来说，$\mathbf{P}$和$\mathbf{E}$有如下关系
$$\mathbf{P}=\epsilon_0\chi_e\mathbf{E}$$
#### 极化面密度
均匀电介质极化时，极化电荷面密度$\sigma'$等于极化强度在该点表面处的法向分量。即
$$\sigma'=|\mathbf{P}|\cos\theta=\mathbf{P} \cdot \mathbf{e}_n$$
其中$\mathbf{P}$为极化强度，$\mathbf{e}_n$为该点法线方向单位矢量
#### 电介质中的场强
<img src="./pic/04.jpg" width=300 align=right>

$\chi_e$为电极化率
$$1+\chi_e=\epsilon_r$$
$$\sigma'=\sigma_0\left(1-\frac{1}{\epsilon_r}\right)$$
从而
$$\mathbf{P}=\epsilon_0\chi_e\mathbf{E}=\epsilon_0(\epsilon_r-1)\mathbf{E}$$
#### 电介质中的高斯定理
通过电场中任意闭合曲面的电位移通量，等于该闭合面所包围的自由电荷的代数和
$$\oint\mathbf{D}d\mathbf{S}=\sum q_0$$
其中$\mathbf{D}$为电位移
$$\mathbf{D}=\epsilon\mathbf{E}+\mathbf{P}=(1+\chi_e)\epsilon_0\mathbf{E}=\epsilon_r\epsilon_0\mathbf{E}=\epsilon \mathbf{E}$$
其中$\epsilon$称为电介质的介电常数或电容率
### 电场的能量
#### 能量密度积分法
单位体积电场贮存的能量$w_e$为
$$w_e=\frac{1}{2}\epsilon E^2=\frac{1}{2}DE$$
从而整个电场贮存的能量为
$$W=\int_{V}w_edv$$
#### 等效电容能量公式法
$$W=\frac{1}{2}\frac{Q^2}{C}=\frac{1}{2}QU=\frac{1}{2}CU^2$$
#### 带电体的静电能公式
$$W=\frac{1}{2}\int_qUdq$$
#### 例
均匀带电球面，半径为$R$，总电量为$Q$，求这一带电系统的能量。
解一：
带电球面在球外产生电场，电场和能量密度分别为
$$E=\frac{Q}{4\pi\epsilon_0r^2},w=\frac{1}{2}\epsilon_0E^2$$
$$dV=4\pi r^2dr$$
$$W=\int^{\infty}_{R}wdV=\frac{Q^2}{8\pi\epsilon_0R}$$
解二：
$$C=4\pi\epsilon_0R,W=\frac{1}{2}\frac{Q^2}{C}=\frac{Q^2}{8\pi\epsilon_0R}$$
解三：
$$W=\frac{1}{2}\int Udq=\frac{1}{2}\int^{Q}_0\frac{Q}{4\pi\epsilon_0R}dq=\frac{Q^2}{8\pi\epsilon_0 R}$$
## 第十一章 稳恒电流
### 电流和电流密度
电流强度$I$和电流密度矢量$\mathbf{j}$的定义
$$I=\frac{dq}{dt},j=\frac{dI}{dS}$$
也即$$dI=\mathbf{j}\cdot d\mathbf{S},I=\int_S\mathbf{j}\cdot d\mathbf{S}$$
### 电流与漂移速度
$$I=env_d\Delta S,\mathbf{j}=en\mathbf{v}_d$$
### 电流连续性方程及稳恒的条件
电流连续性方程
$$\oint_s\mathbf{j}\cdot d\mathbf{S}=-\frac{dq}{dt}$$
稳恒条件
$$\oint_s\mathbf{j}\cdot d\mathbf{S}=0$$
### 欧姆定律的微分形式
导体元两端的电势差
$$\Delta U = E\Delta l = j\Delta S\Delta R$$
即
$$j=\frac{\Delta l}{\Delta R\Delta S}E=\frac{1}{\rho}E=\gamma E$$
矢量形式为$$\mathbf{j}=\gamma \mathbf{E}$$
$\gamma$为导体的电导率