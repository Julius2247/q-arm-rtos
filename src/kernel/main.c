#include "uart.h"
#include "timer.h"

void gic_init(void); // Prototype for now

void main(void) {
    uart_init();
    uart_puts("q-arm-rtos: System Booting...\n");

    /* Initialize GIC First */
    gic_init();

    /* Initialize Heartbeat */
    timer_init();

    /* Unmask IRQ in CPU */
    asm volatile ("msr daifclr, #2"); 

    uart_puts("AArch64 Kernel Initialized.\n");

    while (1) {
        asm volatile ("wfi"); // Wait For Interrupt (Save power/CPU)
    }
}
