# 机械工程测试技术
## 傅里叶变换
### 傅里叶三角级数（单边谱）
$$x(t) = \dfrac{a_0}{2} + \sum_{n=1}^{\infty} \left( a_n \cos n\omega_0 t + b_n \sin n\omega_0 t \right)$$
或者
$$x(t) = \dfrac{a_0}{2} + \sum_{n=1}^{\infty} \left(\sqrt{a_n^2+b_n^2} \sin \left(n\omega_0 t + \mathrm{atan2} (a_n,b_n)\right)\right)$$
其中
$$\begin{cases}
\omega_0 = \dfrac{2\pi}{T} \\
\\
\displaystyle a_0 = \dfrac{2}{T} \int_{-\frac{2}{T}}^{\frac{2}{T}} x(t) dt \\
\\
\displaystyle a_n = \dfrac{2}{T} \int_{-\frac{2}{T}}^{\frac{2}{T}} x(t) \cos n\omega_0 t dt \\
\\
\displaystyle b_n = \dfrac{2}{T} \int_{-\frac{2}{T}}^{\frac{2}{T}} x(t) \sin n\omega_0 t dt
\end{cases}$$

显然当$x(t)$为奇函数时$a_0 = a_n = 0$，当$x(t)$为偶函数时$b_n = 0$。
### $\mathrm{atan2}$与$\arctan$
$\arctan$接受一个参数，其值域为$(-\dfrac{\pi}{2}, \dfrac{\pi}{2})$，也就是说，它没法识别$-135^\circ$这样的角度，而一个信号完全可能落后另一个信号$135^\circ$（因为$\sin$的周期是$2\pi$）。
因此需要一个能够识别角度象限的$\mathrm{atan2}$函数，它接受两个参数，即$a_n$和$b_n$。它能根据 $a_n$ 和 $b_n$ 的正负号，准确地判断出相位角所在的四个象限。
$a_n = -1$, $b_n = -1$时，
$\arctan(1) = \pi/4$ ；$\text{atan2}(a_n, b_n) = \text{atan2}(-1, -1) = -3\pi/4$。
### 例题（幅频谱和相角谱）
<img src="./pic/01.png" align = right width = 300 />

求图所示周期方波信号的傅里叶级数的三角函数展开式，并画出其幅频谱和相角谱。

$$x(t) =
\begin{cases}
-A & -T_0/2 \le t < 0 \\
A & 0 \le t \le T_0/2
\end{cases}$$因为 $x(t)$ 是奇函数，所以：$$a_0 = 0$$$$a_n = 0 \quad (\text{for } n \ge 1)$$计算 $b_n$（令 $\omega_0 = 2\pi/T_0$）：$$\begin{aligned}
b_n &= \dfrac{2}{T_0} \int_{-T_0/2}^{T_0/2} x(t) \sin(n\omega_0 t) dt \\
&= \dfrac{2}{T_0} \cdot 2 \int_{0}^{T_0/2} A \sin(n\omega_0 t) dt \\
&= \dfrac{4A}{T_0} \left[ -\dfrac{\cos(n\omega_0 t)}{n\omega_0} \right]_{0}^{T_0/2} \\
&= -\dfrac{4A}{n\omega_0 T_0} \left[ \cos\left(n\omega_0 \dfrac{T_0}{2}\right) - \cos(0) \right]
\end{aligned}$$因为 $\omega_0 T_0 = 2\pi$，所以 $\omega_0 \dfrac{T_0}{2} = \pi$：$$\begin{aligned}
b_n &= -\dfrac{4A}{n(2\pi)} [\cos(n\pi) - 1] \\
&= -\dfrac{2A}{n\pi} (\cos(n\pi) - 1)
\end{aligned}$$分析 $b_n$ 的值：当 $n$ 为偶数时 (n = 2, 4, ...): $\cos(n\pi) = 1$，所以 $b_n = 0$。当 $n$ 为奇数时 (n = 1, 3, ...): $\cos(n\pi) = -1$，所以 $b_n = -\dfrac{2A}{n\pi} (-1 - 1) = \dfrac{4A}{n\pi}$。总结 $b_n$：$$b_n =
\begin{cases}
\dfrac{4A}{n\pi} & n \text{ 为奇数} \\
0 & n \text{ 为偶数}
\end{cases}$$
三角函数展开式将 $a_n$ 和 $b_n$ 代入傅里叶级数：$$x(t) = a_0 + \sum_{n=1}^{\infty} (a_n \cos(n\omega_0 t) + b_n \sin(n\omega_0 t))$$$$x(t) = \sum_{n=1, 3, 5...}^{\infty} \dfrac{4A}{n\pi} \sin(n\omega_0 t)$$展开为：$$x(t) = \dfrac{4A}{\pi} \left( \sin(\omega_0 t) + \dfrac{1}{3}\sin(3\omega_0 t) + \dfrac{1}{5}\sin(5\omega_0 t) + \dots \right)$$


幅频谱 $A_n$ 是信号在第 $n$ 次谐波频率 $n\omega_0$ 上的幅值。$$A_n = \sqrt{a_n^2 + b_n^2} \quad (n \ge 1)$$幅频谱是 $A_n$ 关于 $n\omega_0$的离散函数图。
相频谱 $\phi_n$ 是信号在第 $n$ 次谐波频率 $n\omega_0$ 上的相位。
$$\phi_n = \text{atan2}(a_n, b_n) \quad (n \ge 1)$$
相频谱是 $\phi_n$ 关于 $n\omega_0$的离散函数图。

<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="./pic/02.png" style="height: 300px;">
  <img src="./pic/03.png" style="height: 300px;">
</div>

应用傅里叶级数的三角函数展开式得到的是周期信号的单边频谱。
### 傅里叶复指数级数（双边谱）
$$x(t) = \sum_{n=-\infty}^{\infty} C_n e^{j n \omega_0 t} = \sum_{n=-\infty}^{\infty} |C_n| e^{j \varphi_n} e^{j n \omega_0 t} \quad n=0, \pm 1, \pm 2, \pm 3, \dots$$
其中
$$ C_n = \dfrac{1}{T} \int_{-T/2}^{T/2} x(t) e^{-j n \omega_0 t} dt$$
<!-- $$|L_n| = \dfrac{An}{2} = \dfrac{\sqrt{a_n^2 + b_n^2}}{2} \quad \angle L_n = \phi_n = -\arctan \dfrac{b_n}{a_n}$$ -->
欧拉公式
$$\cos \varphi = \dfrac{e^{j\varphi} + e^{-j\varphi}}{2}$$$$\sin \varphi = \dfrac{j(e^{-j\varphi}-e^{j\varphi} )}{2}$$

### 例题
<img src="./pic/01.png" align = right width = 300 />

求图所示周期方波信号的傅里叶级数的复指数展开式，并画出其幅频谱和相角谱。