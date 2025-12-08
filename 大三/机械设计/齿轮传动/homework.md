## T6-12：试设计单击闭合式减速用外啮合直齿圆柱齿轮传动。

**已知条件：**
* 传动比 $i=4.6$
* 传递功率 $P=30\text{ kW}$
* 转速 $n_1=730\text{ r/min}$
* 长期双向传动，载荷有中等冲击
* 要求结构紧凑
* $z_1=27$
* 大小齿轮都用 40Cr 表面淬火

---

### （1）齿轮材料的选择

长期双向传动，要求结构紧凑且齿轮进行表面淬火，因此选用的齿轮为硬齿面齿轮。
大小齿轮均用 **40Cr 调质钢**，表面淬火，查表 6-5 可得：**48~55HRC**。

---

### （2）校核齿根弯曲强度

一对钢制外啮合齿轮的轮齿弯曲强度设计公式用式：

$$m \geq \sqrt[3]{ \frac{2 K T_1}{\psi_d z_1^2} \left( \frac{Y_{FS}}{[\sigma_F]} \right) } \quad (\text{mm})$$

**① 计算小齿轮传递的扭矩 $T_1$**
$$T_1 = 9.55 \times 10^6 \frac{P_1}{n_1} = 9.55 \times 10^6 \times \frac{30}{730} = 392466 \, (\text{N} \cdot \text{mm})$$

**② 确定齿数**
小齿轮齿数 $z_1 = 27$，大齿轮齿数 $z_2 = z_1 \times i = 124.2$，取 $z_2 = 124$。

**③ 确定精度等级**
转速不高，功率不大，选择齿轮精度为 **8级**。

**④ 确定齿宽系数**
取 $\psi_d = 0.6$ （查表 6-9 得：0.4~0.9）。

**⑤ 确定载荷综合系数**
载荷有中等冲击，对称布置，轴的刚度较大，取载荷综合系数 $K = 2.1$ （2.1~2.3）。

**⑥ 确定复合齿形系数**
根据 $z_1$、$z_2$ 由图 6-30 查的 $Y_{Fs1} = 4.19$，$Y_{Fs2} = 3.92$。

**⑦ 确定许用弯曲应力 $[\sigma_F]$**
由图 6-31 查得 $\sigma_{Flim1} = \sigma_{Flim2} = \sigma_{Flim} = 480 \sim 880\text{ MPa}$，取 $\sigma_{Flim} = 800\text{ MPa}$。
由表 6-8 查得，表值 $S_{Hmin} = 1.5$。对于长期双向传动的齿轮因其齿根受对称循环弯曲应力，应将表值 $\sigma_{Flim}$ 乘以 0.7 故有：

$$[\sigma_{F1}] = [\sigma_{F2}] = \frac{\sigma_{Flim} \times 0.7}{S_{Fmin}} = \frac{800 \times 0.7}{1.5} = 373\text{ MPa}$$

**⑧ 计算模数**
$$m \geq \sqrt[3]{ \frac{2 K T_1}{\psi_d z_1^2} \left( \frac{Y_{FS}}{[\sigma_F]} \right) } = \sqrt[3]{ \frac{2 \times 2.1 \times 392466}{0.6 \times 27^2} \left( \frac{4.19}{373} \right) } = 3.485\text{ mm}$$

由表 6-1 取标准值 **$m = 4\text{ mm}$**。

**⑨ 计算齿轮主要尺寸及圆周速度**

* **分度圆直径：**
    $$d_1 = m z_1 = 27 \times 4 = 108\text{ mm}; \quad d_2 = m z_2 = 124 \times 4 = 496\text{ mm}$$

* **中心距：**
    $$a = \frac{m}{2}(z_1 + z_2) = \frac{4}{2}(27 + 124) = 302\text{ mm}$$

* **齿轮齿宽：**
    $$b = \psi_d \cdot d_1 = 0.6 \times 108 = 64.8\text{ mm}$$
    取大齿轮实际齿宽 **$b_2 = 65\text{ mm}$** (满足 $b_2 > b$)。
    为了便于安装和补偿轴向尺寸误差，齿轮减速器中一般将小齿轮实际齿宽 $b_1$ 比大齿轮实际齿宽大 $5 \sim 10\text{ mm}$，故取小齿轮实际齿宽 **$b_1 = 70\text{ mm}$**。

* **圆周速度：**
    $$v = \frac{\pi d_1 n_1}{60 \times 1000} = \frac{\pi \times 108 \times 730}{60 \times 1000} = 4.13\text{ m/s}$$
    由表 6-4 可知取用 **8级精度**。

---

### （3）校核齿面接触强度

一对钢制外啮合齿轮齿面接触强度的校核公式用式：

$$\sigma_H = Z_E Z_H \sqrt{ \frac{(\mu \pm 1)}{\mu} \frac{2 K T_1}{b d_1^2} } \leq [\sigma_H] \quad (\text{mm})$$

**① 确定许用接触应力**
由图 6-28 查得 $\sigma_{Hlim1} = \sigma_{Hlim2} = \sigma_{Hlim} = 980 \sim 1370\text{ MPa}$，取 $\sigma_{Hlim} = 1300\text{ MPa}$。
由表 6-8 查得 $S_{Hmin} = 1.25$，故有：

$$[\sigma_H] = [\sigma_{H1}] = [\sigma_{H2}] = \frac{\sigma_{Hlim}}{S_{Hlim}} = \frac{1300}{1.25} = 1040\text{ MPa}$$

**② 式中已知参数**
$K = 2.1$，$T_1 = 392466 (\text{N} \cdot \text{mm})$，$m = 4\text{ mm}$，$b = 65\text{ mm}$ (计算接触强度时取较小齿宽)。

**③ 确定系数**
查表 6-7 可得弹性系数 $Z_E = 189.8 \sqrt{\text{MPa}}$。
对于标准圆柱齿轮 $Z_H = 2.5$。

**④ 校核计算**

**对于小齿轮（实际上由于材料相同，只需校核一次，但公式中分母用的是 $b_1$ 和 $b_2$ 区别）：**

$$\sigma_{H1} = Z_E Z_H \sqrt{ \frac{(\mu + 1)}{\mu} \frac{2 K T_1}{b_1 d_1^2} } = 189.8 \times 2.5 \sqrt{ \frac{4.6 + 1}{4.6} \times \frac{2 \times 2.1 \times 392466}{65 \times 108^2} } = 771.96\text{ MPa}$$
$$\sigma_{H1} = 771.96\text{ MPa} < 1040\text{ MPa} = [\sigma_{H1}]$$


$$\sigma_{H2} = Z_E Z_H \sqrt{ \frac{(\mu + 1)}{\mu} \frac{2 K T_1}{b_2 d_1^2} } = 189.8 \times 2.5 \sqrt{ \frac{4.6 + 1}{4.6} \times \frac{2 \times 2.1 \times 392466}{70 \times 108^2} } = 743.88\text{ MPa}$$
$$\sigma_{H2} = 743.88\text{ MPa} < 1040\text{ MPa} = [\sigma_{H2}]$$

**结论：齿面接触强度校核计算安全。**