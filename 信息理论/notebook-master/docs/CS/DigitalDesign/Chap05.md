# Chap 5 Digital Hardware Implementation

## 可重编程技术 | Programmable implementation technologies

直接更改电路来修改电路功能被称为硬编程，而可重编程技术让我们能够不更改硬件布线的情况下，实现**逻辑功能的重新编辑**。

!!! example "FPGA"

    [现场可编程逻辑门阵列(Field Programmable Gate Array)FPGA](https://zh.wikipedia.org/zh-cn/%E7%8E%B0%E5%9C%BA%E5%8F%AF%E7%BC%96%E7%A8%8B%E9%80%BB%E8%BE%91%E9%97%A8%E9%98%B5%E5%88%97)

    - [查找表(lookup table)LUT](https://zh.m.wikipedia.org/zh-hans/%E6%9F%A5%E6%89%BE%E8%A1%A8)

**编程技术(programming technologies)** 在硬件层面有三种实现手段：

1. 控制连接来实现（不是可重编程）；
    - 掩码编程 | Mask programing
    - 熔丝 | Fuse
    - 反熔丝 | Anti-fuse
    ![Alt text](images/e905e997c02a63e8fc4feff82f9200b3.png)
2. 控制门级电路电压；
    - Single-bit storage element
    - Stored charge on a floating gate
        - Erasable
        - Electrically erasable
        - Flash (as in Flash Memory)
3. 使用查找表(Look Up Table - LUT)；
    - Storage elements for the function
        - 比如使用一个 `MUX`，并将输入端接内存，通过修改内存的值来修改 `MUX` 的行为，进而实现函数重编程
        ![Alt text](images/image-10.png)

课程中介绍的可重编程的器件主要有如下四种：

*1.* [只读内存 Read Only Memory (ROM)](#rom-read-only-memory)

*2.* [可编程阵列逻辑 Programmable Array Logic (PAL^®^)](#pal-programmable-array-logic)

*3.* [可编程逻辑阵列 Programmable Logic Array (PLA)](#pla-programmable-logic-array)

*4.* [Complex Programmable Logic Device (CPLD) or Field-Programmable Gate Array(FPGA)](#lookup-tables)

前三者都只能重写一次，如下是它们的重写内容：

![Alt text](images/image-11.png)

- PROM是不改变项的内容，只缩短相加的项数；
- PAL是不改变项数，可以改变项的内容；
- PLA是项数可以改变，也可以改变项的内容；

---

!!! info "引入"
    由于之后出现的电路图会非常庞大，所以需要引入一些逻辑符号。

### 逻辑符号介绍

!!! example "Buffer"
    ![Alt text](images/image-12.png){width=20%}
    > 简化表示一个变量的自身和其非；

!!! example "Wire connecting"
    在可编程逻辑电路中，线的连接不再只有单纯的连通和不连通的关系：

    对于两条相交导线：

    ![Alt text](images/image-24.png)
    
    - 如果没有特殊符号，则表示这个交叉点 is not connected ；
    - 如果有一个 ❌，则表示这个交叉点 programmable；
    - 如果只有一个加粗的点，则表示这个交叉点 not programmable；

特别的，如果一个元器件的所有输入都是 programmable，我们也可以选择把这个 ❌ 画到逻辑门上（如下图 e 和 f）。

![Alt text](images/image-25.png)

---

### ROM | Read Only Memory

ROM 的基本结构如下：

![](img/57.png)

而 ROM 的大小如下计算（以上图为例）：

$$
\begin{aligned}
    \text{ROM  size}  &=  \text{address  width}  \times  \text{word  width}&\\
                   &=  2^2  \times  4  =  16  bit&
\end{aligned}
$$

!!! example "eg"

    更清晰的表示其内部逻辑的，可以将 ROM 写成这样：

    ![](img/58.png)

#### 题目例子

!!! question "计算三位输入的平方"

我们先写出真值表：

![Alt text](images/image-13.png)

可以发现，要六位输出才能实现，其中 $B_0=A_0$ ， $B_1$ 为常量 $1$，我们现在要找到一个可重编程的ROM，来实现这个功能。

![Alt text](images/image-14.png)

其中，ROM的内部结构可用真值表判断哪里需要进行重编程，
通过下图表示：

![Alt text](images/image-15.png){width=50%}

---

### PAL | Programmable Array Logic

PAL 的基本结构如下：

![Alt text](images/image-16.png)

可以看到，与ROM不同的是，PAL形成项的地方是可编程的，而ROM是不可编程的。所以PAL可以改变项的内容，但是不能改变项的数量与连接方式。

其具有一个缺陷是，因为表达函数的方法不是通过 SOM 或者 POM 的形式，所以不一定能够完备表达函数（项数不够）。

在此基础上的一个改进是，通过将一个既有的 PAL 输出当作输入，输入到另外一个函数中，来弥补项不足的问题。

???+ example "弥补项的方法"
    ![Alt text](images/image-17.png)

!!! note "Have a try"

    下图实现了怎样的逻辑？
    ![Alt text](images/image-18.png)
---

### PLA | Programmable Logic Array

PLA 的基本结构如下：

![Alt text](images/image-19.png)

与 PAL 的区别在于，在输出的时候也能对输出组合进行重编程。

其同 PAL 一样具有一个缺陷是，因为表达函数的方法不是通过 SOM 或者 POM 的形式，所以不一定能够完备表达函数。

在基础上的一个改进是在输出的时候再做一次异或（不用非门，只动连接点：体现了可重编程的思想），以产生新的项，来弥补项不足的问题。

![Alt text](images/image-20.png)

可以发现，出现了新的项。

---

### 查找表 | Lookup Tables

![](img/63.png){width=50%}

通过让数据源接内存，并通过修改真值表内的值，即修改内存里的值，来实现数据源的变化，来改变 `MUX` 的行为。

但是在实际应用中，函数输入的数量会变化，因此我们需要通过灵活组合的方法（比如通过四选二选一的方式，用三个二选一的 `MUX` 来实现四选一）来实现多输入。

??? note "多个二选一的 `MUX` 实现多输入"

    ![Alt text](images/image-21.png)

    具体过程：

    ![Alt text](images/image-22.png)

常见的 `LUT` 大小以 16bits 或 64bits 的 4 输入或 6 输入为主。

由于 `LUT` 存的本质上是真值表，所以它可以实现任意输入符合要求的逻辑函数。

所以，问题就变化为如何用较小的 `LUT` 来组合实现复杂的逻辑函数。

`LUT` 的基本结构如下：

![](img/64.png)

`FPGA` 的基本结构如下：

![](img/65.png)

其主要分为三个组成部分：

- CLB(Configurable Logic Block)
    - 大量存储 `LUT`
- SM(Switch Matrix)
    - 可编程的交换矩阵
- IOB(Input & Output Block)
    - 可编程的输入输出单元

---

#### CLB

CLB 是 `FPGA` 中的基础逻辑单元。

![Alt text](images/image-23.png)

---

#### SM

通过相当复杂的算法， `SM` 会根据目标逻辑，选择链接不同的 `CLB` 以实现复杂逻辑。

它具有这些基本属性：

1. Flexibility: 评估一条线可以连接到多少线；
2. Topology: 哪些线可以被连接到；
3. Routability: 有多少回路可以被路由；

![](img/68.png)

---

#### IOB

`IOB` 用来对外部设备进行连接，用来控制输入和输出。

![](img/67.png)

---

??? example "eg for `FPGA`"
    通过 `FPGA` 实现 $f=x_1x_2+\overline{x_2x_3}$：

    分解问题：$f_1 = x_1x_2,  f_2=\overline{x_2x_3},  f=f_1+f_2$。

    ![](img/69.png)

在软件层面编程完后，会生成位流文件(`bitfile`)，下载到板时会更新 `FPGA` 中的内容。

---

## 小结 | Summary

!!! summary "组合函数的实现方法"
    到目前为止，不管是可重编程还是不可重编程，都已经介绍了很多方法，这里进行一次小结：

    1. `Decoder`s & `OR` gates
         - 将译码出来的需要的目标组合都 `OR` 在一起；
    2. `MUX`s
         - 通过多路选择器实现任意逻辑函数； 
    3. `ROM`s
    4. `PAL`s
    5. `PLA`s
    6. `LUT`s
