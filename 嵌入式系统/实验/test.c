#include "stm32f10x.h"

// 初始化SysTick定时器（内核时钟源）
void Delay_Init(void) {
    SysTick->CTRL = 0;                   // 禁用SysTick
    SysTick->LOAD = SystemCoreClock/8000 - 1; // 1ms中断（假设72MHz主频）
    SysTick->VAL = 0;                     // 清空计数器
    SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk; // 启用SysTick
}

// 毫秒级延时（非阻塞，低CPU占用）
void delay_ms(uint32_t ms) {
    uint32_t start = SysTick->VAL;
    while (ms--) {
        // 等待计数器溢出（约1ms）
        while (((start - SysTick->VAL) & 0xFFFFFF) < (SystemCoreClock/8000));
        start = SysTick->VAL;
    }
}