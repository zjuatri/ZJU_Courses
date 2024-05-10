# 概率论与数理统计
## 随机变量的分布
### 概率分布函数
$$F(x)=P\left\{ X\leq k \right\}$$
可推知
$$P\left\{ x_1<X\leq x_2 \right\}=F(x_2)-F(x_1)$$
### 概率密度函数
$$F(x)=\displaystyle \int^x_{-\infty}f(t)dt$$
称$f(x)$为$X$的概率密度函数
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