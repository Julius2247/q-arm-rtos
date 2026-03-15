#include "timer.h"
#include "uart.h"

static unsigned long interval;

void timer_init(void) {
    unsigned long freq;

    /* Get the system counter frequency (Hz) */
    asm volatile ("mrs %0, cntfrq_el0" : "=r" (freq));

    /* Calculate interval for 10ms tick */
    interval = freq / 100;

    /* Program timer */
    asm volatile ("msr cntp_tval_el0, %0" : : "r" (interval));

    /* Enable timer (ENABLE=1, IMASK=0) */
    asm volatile ("msr cntp_ctl_el0, %0" : : "r" (1));

    uart_puts("Generic Timer Initialized (10ms tick).\n");
}

void timer_reload(void) {
    asm volatile ("msr cntp_tval_el0, %0" : : "r" (interval));
}