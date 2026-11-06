#include "stm32f4xx.h"

/* Blinks the LED on PC13 (on-board LED of the common "Black Pill" board). */

static volatile uint32_t g_ticks_ms;

void SysTick_Handler(void)
{
    g_ticks_ms++;
}

static void delay_ms(uint32_t ms)
{
    const uint32_t start = g_ticks_ms;
    while ((g_ticks_ms - start) < ms) {
    }
}

int main(void)
{
    /* Running from the 16 MHz HSI after reset (SystemInit leaves clocks as-is). */
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock / 1000U);

    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
    (void)RCC->AHB1ENR; /* read back: make sure the clock is on before touching GPIOC */

    /* PC13 -> general purpose output, push-pull */
    GPIOC->MODER = (GPIOC->MODER & ~GPIO_MODER_MODER13) | GPIO_MODER_MODER13_0;

    for (;;) {
        GPIOC->ODR ^= GPIO_ODR_OD13;
        delay_ms(200);
    }

}
