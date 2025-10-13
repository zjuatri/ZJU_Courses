#include "stm32f10x.h"

void delay_ms(int ms)
{
    int i;
    while(ms--)
    {
        i=7500;
        while(i--);
    }
}

int main()
{
    int count = 0;

    RCC->APB2ENR |=(1<<3);
    RCC->APB2ENR |=(1<<6);
    GPIOB->CRL &=0xFF0FFFFF;
    GPIOE->CRL &=0xFF0FFFFF;
    GPIOB->CRL |=0x00300000;
    GPIOE->CRL |=0x00300000;
  
    while(1)
    {
        if(count < 5)
        {
            GPIOB->ODR |=1<<5;
            GPIOE->ODR |=1<<5;
            delay_ms(1000);
            GPIOB->ODR &=~(1<<5);
            GPIOE->ODR &=~(1<<5);
            delay_ms(1000);
            count++;
        }
        else
        {
            GPIOB->ODR |=1<<5;
            GPIOE->ODR &=~(1<<5);
            delay_ms(1000);
            GPIOE->ODR |=1<<5;
            GPIOB->ODR &=~(1<<5);
            delay_ms(1000);
        }
    }
    return 1;
}