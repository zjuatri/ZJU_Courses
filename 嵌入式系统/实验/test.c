#include "stm32xxxx.h" // 根据具体芯片型号包含头文件

volatile static uint32_t ms_delay; // 声明为volatile防止编译器优化

// SysTick中断服务函数
void SysTick_Handler(void)
{
    if (ms_delay > 0)
    {
        ms_delay--;
    }
}

// 延时函数
void Delay_ms(uint32_t ms)
{
    ms_delay = ms;
    while (ms_delay > 0)
    {
        __WFI(); // 进入休眠模式，等待中断唤醒（不会占用CPU资源）
    }
}

// 系统时钟配置时初始化SysTick（通常在SystemInit()中）
void SysTick_Init(void)
{
    SysTick->LOAD = (SystemCoreClock / 1000) - 1; // 设置1ms重载值
    SysTick->VAL = 0;                             // 清除当前值
    SysTick->CTRL = SysTick_CTRL_TICKINT_Msk |    // 启用中断
                    SysTick_CTRL_ENABLE_Msk;      // 启动定时器
}