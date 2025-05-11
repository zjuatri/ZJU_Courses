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
  GPIO_InitTypeDef initStructure;
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOE,ENABLE);
	initStructure.GPIO_Pin=GPIO_Pin_5;
	initStructure.GPIO_Speed=GPIO_Speed_50MHz;
	initStructure.GPIO_Mode=GPIO_Mode_Out_PP;
	GPIO_Init(GPIOE,&initStructure);
	GPIO_ResetBits(GPIOE,GPIO_Pin_5);
	
	while(1)
	{
	  GPIO_SetBits(GPIOE,GPIO_Pin_5);
		delay_ms(1000);
		GPIO_ResetBits(GPIOE,GPIO_Pin_5);
		delay_ms(1000);
	}
	
	return 1;
	
} 
