# 概率论与数理统计
## 随机变量的分布
### 分布函数
$$F(x)=P\left\{ X\leq k \right\}$$
可推知
$$P\left\{ x_1<X\leq x_2 \right\}=F(x_2)-F(x_1)$$
二元情况下有
$$F(x,y)=P\{X\leq x,Y\leq y\}$$
$$P\{x_1<X\leq x_2,y_1<Y\leq y_2\}=F(x_2,y_2)-F(x_1,y_2)-F(x_2,y_1)+F(x_1,y_1)$$
### 密度函数
$$F(x)=\displaystyle \int^x_{-\infty}f(t)dt$$
称$f(x)$为$X$的概率密度函数
$$f(x)=F'(x)$$
二元情况下有
$$F(x,y)=\displaystyle \int^x_{-\infty}\int^y_{-\infty}f(u,v)dudv$$
$$P\{(X,Y)\in D\}= \iint \limits_Df(x,y)dxdy$$
$$\dfrac{\partial^2F(x,y)}{\partial x \partial y}=f(x,y)$$
### 边际密度函数
$$f_X(x)=\displaystyle\int^{+\infty}_{-\infty}f(x,y)dy\\
f_Y(y)=\displaystyle\int^{+\infty}_{-\infty}f(x,y)dx$$
### 反函数的密度函数
$Y=g(X)$，若函数$g$是一处处可导的严格单调函数，其值域为$D$，记$y=g(x)$的反函数为$x=h(y)$，则$Y$的密度函数为
$$f_Y(y)=\begin{cases}
    f_X(h(y))\cdot|h'(y)|,y\in D\\
    0,y\notin D
\end{cases}$$
### 联合分布律
$$P\{X = x_i,Y = y_j\}=p_{ij},i,j=1,2,...$$
### 边际分布律
$$P\{X=x_i\}=\displaystyle \sum^{+\infty}_{j=1}p_{ij}=p_i\\
P\{Y=y_j\}=\displaystyle \sum^{+\infty}_{i=1}p_{ij}=p_j$$
### 条件分布律
$$P\{X=x_i|Y=y_j\}=\frac{P\{X=x_i,Y=y_j\}}{P\{Y=y_j\}},i=1,2,...$$
即给定给定$Y=y_j$条件下的条件分布律
## 重要随机变量的概率分布
### 0-1(p)分布，两点分布
- 符号: $X\sim 0-1(p)$
- 概率分布律：
$$P\left\{ X=k \right\}=p^k(1-p)^{1-k}, k=0,1.$$
### 二项分布，n重伯努利实验
- 符号： $X\sim B(n,p)$
- 概率分布律：
$$P\left\{ X=k \right\}=C_n^kp^k(1-p)^{n-k},k=0,1,2,...,n.$$
### 泊松分布
- 符号： $X\sim P(\lambda)$
- 概率分布律：
$$P\left\{ X=k \right\}=\frac{e^{-\lambda}\lambda^k}{k!},k=0,1,2,...$$
### 均匀分布
- 符号：$X\sim U(a,b)$
- 概率密度函数
$$f(x)=\begin{cases}
\dfrac{1}{b-a},x\in(a,b)\\
0,其他    
\end{cases}$$
- 分布函数
$$F(x)=\begin{cases}
    0,x<a\\
    \dfrac{x-a}{b-a},a\leq x<b\\
    1,x\geq b
\end{cases}$$
### 正态分布
- 符号：$X\sim N(\mu,\sigma)$
- 概率密度函数$f(x)=\dfrac{1}{\sqrt{2\pi}\sigma}e^{-\dfrac{(x-\mu)^2}{2\sigma^2}}$（标准正态分布$f(x)=\dfrac{1}{\sqrt{2\pi}}e^{-\dfrac{x^2}{2}}$）
### 指数分布
- 符号：$X\sim E(\lambda)$
- 密度函数
$$f(x)=\begin{cases}
    \lambda e^{-\lambda x},x>0\\
    0,x\leq 0
\end{cases}$$
- 分布函数
$$F(x)=\displaystyle \int^x_{-\infty}f(t)dt=\begin{cases}
    1-e^{-\lambda x},x>0\\
    0,x\leq 0
\end{cases}$$