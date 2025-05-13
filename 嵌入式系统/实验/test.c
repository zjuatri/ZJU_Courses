#include "stm32f10x.h"

// 延时函数
void delay_ms(int ms)
{
    int i;
    while (ms--)
    {
        i = 7500;
        while (i--);
    }
}

// 初始化 GPIO
void GPIO_InitPorts(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;

    // 使能 GPIOB 和 GPIOE 的时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB | RCC_APB2Periph_GPIOE, ENABLE);

    // 初始化 DS0（GPIOB_PIN_5）和 DS1（GPIOE_PIN_5）为推挽输出模式
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;  // 推挽输出
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; // 50MHz 输出速度
    GPIO_Init(GPIOB, &GPIO_InitStructure);            // 初始化 GPIOB_PIN_5
    GPIO_Init(GPIOE, &GPIO_InitStructure);            // 初始化 GPIOE_PIN_5

    // 初始化蜂鸣器（假设连接到 GPIOE_PIN_6）
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
    GPIO_Init(GPIOE, &GPIO_InitStructure);

    // 初始化按键（假设 KEY0、KEY1 和 KEY_UP 分别连接到 GPIOA_PIN_0、GPIOA_PIN_1 和 GPIOA_PIN_2）
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING; // 浮空输入
    GPIO_Init(GPIOA, &GPIO_InitStructure);
}

// 按键扫描函数
void Key_Scan(void)
{
    static uint8_t buzzer_state = 0; // 蜂鸣器状态变量

    // 检测 KEY0 是否按下
    if (GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0) == 0)
    {
        GPIO_SetBits(GPIOB, GPIO_Pin_5); // DS0 长亮
        GPIO_SetBits(GPIOE, GPIO_Pin_5); // DS1 长亮
        GPIO_SetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器关闭
        delay_ms(20); // 消抖
    }
    // 检测 KEY1 是否按下
    else if (GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_1) == 0)
    {
        GPIO_ResetBits(GPIOB, GPIO_Pin_5); // DS0 不亮
        GPIO_ResetBits(GPIOE, GPIO_Pin_5); // DS1 不亮
        GPIO_SetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器关闭
        delay_ms(20); // 消抖
    }
    // 检测 KEY_UP 是否按下
    else if (GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_2) == 0)
    {
        if (buzzer_state == 0)
        {
            GPIO_SetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器关闭
            buzzer_state = 1;
        }
        else
        {
            GPIO_ResetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器打开
            buzzer_state = 0;
        }
        delay_ms(20); // 消抖
    }
    else
    {
        // 如果没有按键按下，保持蜂鸣器状态不变
        if (buzzer_state == 0)
        {
            GPIO_SetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器关闭
        }
        else
        {
            GPIO_ResetBits(GPIOE, GPIO_Pin_6); // 蜂鸣器打开
        }
    }
}

int main(void)
{
    // 初始化 GPIO
    GPIO_InitPorts();

    while (1)
    {
        Key_Scan(); // 调用按键扫描函数
        delay_ms(10); // 简单的延时，避免过快扫描
    }

    return 0;
}