### 第一类曲线积分
设$\Gamma$为空间光滑曲线，其方程为
$$\begin{cases}
    x=x(t)\\
    y=y(t)\\
    z=z(t)
\end{cases},\alpha\leq t \leq \beta$$
则
$$\displaystyle\underset{\Gamma}{\int}f(x,y,z)ds=\int^\beta_\alpha f(x(t),y(t),z(t))\sqrt{x'^2(t)+y'^2(t)+z'^2(t)}dt$$
### 第一类曲面积分
设$\sigma_{xy}$是曲面$S$在$Oxy$平面上的投影，则有
$$\displaystyle \underset{S}{\iint}f(x,y,z)dS=\displaystyle \underset{\sigma_{xy}}{\iint}f(z,y,z(x,y))\sqrt{1+z_x'^2+z_y'^2}d\sigma$$
特别的，若$f(x,y,z)\equiv 1$，则$\displaystyle\underset{S}{\iint}dS=S$
### 第二类曲线积分
#### 物理意义
设有一个力场，场的力为$\mathbf{F}(M)=P(x,y,z)\mathbf{i}+Q(x,y,z)\mathbf{j}+R(x,y,z)\mathbf{k},M(x,y,z)\in \Gamma$。设$P(x,y,z),Q(x,y,z),R(x,y,z)$在$\Gamma$上连续，试求此力场所做的功。
#### 直接计算
设$\Gamma$为空间光滑曲线，其方程为
$$\begin{cases}
    x=x(t)\\
    y=y(t)\\
    z=z(t)
\end{cases},\alpha\leq t \leq \beta$$
设点$A$对应的参数为$t_A$，点$B$对应的参数为$t_B$，$\mathbf{F}(M)=P(x,y,z)\mathbf{i}+Q(x,y,z)\mathbf{j}+R(x,y,z)\mathbf{k},M(x,y,z)\in \Gamma$则
$$\displaystyle\underset{\Gamma_{AB}}{\int}\mathbf{F}d\mathbf{s}=\underset{\Gamma_{AB}}{\int}Pdx+Qdy+Rdz\\=\int^{t_B}_{t_A}[P(x(t),y(t),z(t))x'(t)+Q(x(t),y(t),z(t))y'(t)+R(x(t),y(t),z(t))z'(t)]$$
#### 格林公式
若函数$P,Q$在有界闭区域$D\subset R^2$上连续且具有一阶连续偏导数，则
$$\displaystyle\underset{D}{\iint}\left(\frac{\partial Q}{\partial x}-\frac{\partial P}{\partial y}\right)dxdy = \underset{\Gamma}{\oint}Pdx+Qdy$$
这里$\Gamma$为区域$D$的边界曲线，并取正向。
### 第二类曲面积分
靠坐标轴正向的一面为正，靠坐标轴负向的一面为负
#### 直接计算
一投二代三符号化为二重积分
遇到dxdy，就投影到xOy面，被积函数中z=z(x,y) 
$$\displaystyle\underset{R_{xy}}{\iint}Pdxdy=\pm\underset{R_{xy}}{\iint}R[x,y,z(x,y)]dxdy$$

### 高斯公式
设空间区域$V$由分片光滑的双侧封闭曲面$S$围成，若函数$P,Q,R$在$V$上连续且有一阶连续偏导数，则
$$\displaystyle\underset{V}{\iiint}(\frac{\partial P}{\partial x}+\frac{\partial Q}{\partial y}+\frac{\partial R}{\partial z})dxdydz=\underset{S}{\oiint}Pdydz+Qdzdx+Rdxdy$$

### 斯托克斯公式
设光滑曲面$S$的边界$L$是按段光滑的连续曲线，若函数$P,Q,R$在$S$和$L$上连续，且有一阶连续偏导数，则有
$$\displaystyle\underset{S}{\iint}\left(\frac{\partial R}{\partial y}-\frac{\partial Q}{\partial z}\right)dydz+\left(\frac{\partial P}{\partial z}-\frac{\partial R}{\partial x}\right)dzdx+\left(\frac{\partial Q}{\partial x}-\frac{\partial P}{\partial y}\right)dxdy=\underset{L}{\oint} Pdx+Qdy+Rdz$$
其中$S$的侧面与$L$的方向按右手法则确定
### 梯度，散度和旋度
#### 梯度grad
梯度算子$\displaystyle\nabla=\left(\frac{\partial}{\partial x},\frac{\partial}{\partial y},\frac{\partial}{\partial z}\right)$
对于函数$f$，有$\displaystyle grad(f)=\nabla\cdot f=\left(\frac{\partial f}{\partial x},\frac{\partial f}{\partial y},\frac{\partial f}{\partial z}\right)$
#### 散度div
记$\vec{F}(x,y,z)=\left(P(x,y,z),Q(x,y,z),R(x,y,z)\right)$
有$\displaystyle div\vec{F}=\nabla\cdot\vec{F}=\frac{\partial f}{\partial x}+\frac{\partial f}{\partial y}+\frac{\partial f}{\partial z}$
#### 旋度rot
$rot\vec{F}=\nabla\times\vec{F}=\begin{matrix}
\end{matrix}$