### (1) 刚架支座 A 处的约束反力

通过利用结构的对称性和载荷的反对称性，并应用卡氏第二定理（最小功原理），我们可以求解该超静定结构的约束反力。

**求解过程**：
我们分析左半刚架 `ABE`，并以 `E` 点的水平力 `H_E` 为多余未知力。根据反对称结构的位移约束，`E` 点的水平位移为零，因此：
$$\frac{\partial U_{ABE}}{\partial H_E} = 0$$
其中 $U_{ABE}$ 是左半刚架的应变能。

1.  **弯矩方程** (设 `A` 为原点, `H_E` 向右为正, `y` 向上, `x` 向右):
    * **AB 杆**:  $M_{AB}(y) = M_A + H_A y$
    * **BE 杆**:  $M_{BE}(x) = M_A + H_A a + V_A x$

    通过隔离体 `ABE` 的平衡，用 $H_E$ 表示反力 ($V_A=0$, $M_E = -m/2$):
    $H_A = -H_E$
    $M_A = H_E a - m/2$

    代入后得到弯矩方程：
    * $M_{AB}(y) = (H_E a - m/2) - H_E y$
    * $M_{BE}(x) = (H_E a - m/2) - H_E a = -m/2$

2.  **求偏导数**:
    * $\frac{\partial M_{AB}}{\partial H_E} = a - y$
    * $\frac{\partial M_{BE}}{\partial H_E} = 0$

3.  **求解积分方程**:
    $$\frac{1}{EI} \int_0^a (H_E a - \frac{m}{2} - H_E y)(a-y)dy = 0$$
    积分并求解得到：
    $$H_E \frac{a^3}{3} - \frac{ma^2}{4} = 0 \implies H_E = \frac{3m}{4a}$$

4.  **计算A处反力**:
    * **水平反力**: $H_A = -H_E = -\frac{3m}{4a}$ (方向**向左**)
    * **竖直反力**: $V_A = 0$
    * **弯矩反力**: $M_A = H_E a - \frac{m}{2} = (\frac{3m}{4a})a - \frac{m}{2} = \frac{m}{4}$ (方向**逆时针**)

**答案(1)**：A处约束反力为水平向左的力 $H_A=\frac{3m}{4a}$ 和逆时针方向的力偶 $M_A=\frac{m}{4}$，竖直反力为0。

---
### (2) 刚架结构的弯矩图

根据已求出的反力，可以确定各关键点的弯矩值：
* $M_A = \frac{m}{4}$
* $M_B = M_A + H_A a = \frac{m}{4} - \frac{3m}{4a}a = -\frac{m}{2}$
* $M_{E左} = M_B = -\frac{m}{2}$
* $M_{E右} = M_{E左} + m = \frac{m}{2}$
* $M_C = \frac{m}{2}$ (根据反对称性)
* $M_D = \frac{m}{4}$ (根据反对称性)

**弯矩图** (按惯例，画在受拉一侧):



---
### (3) B 截面处的转角

B点的转角即为AB杆件顶端的转角，可通过对AB杆的弯矩方程积分得到：
$$\theta_B = \theta_A + \int_0^a \frac{M_{AB}(y)}{EI} dy$$因为A点是固定端，所以 $\theta_A=0$。$$\theta_B = \frac{1}{EI} \int_0^a (M_A + H_A y) dy = \frac{1}{EI} \int_0^a (\frac{m}{4} - \frac{3m}{4a}y) dy$$$$\theta_B = \frac{1}{EI} \left[ \frac{m}{4}y - \frac{3m}{8a}y^2 \right]_0^a$$$$\theta_B = \frac{1}{EI} \left( \frac{ma}{4} - \frac{3ma^2}{8a} \right) = \frac{1}{EI} (\frac{2ma}{8} - \frac{3ma}{8}) = -\frac{ma}{8EI}$$
负号表示转角方向为**顺时针**。

**答案(3)**：B截面处的转角大小为 $\frac{ma}{8EI}$，方向为顺时针。