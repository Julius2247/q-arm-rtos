/*
 * ARM Interrupt Pipeline
 *
 * Hardware Interrupt Flow:
 *
 * ARM Generic Timer (Physical Timer)
 *        ↓
 * GIC (Generic Interrupt Controller)
 *        ↓
 * CPU IRQ Exception
 *        ↓
 * Exception Vector Table (vectors.s)
 *        ↓
 * handle_irq (assembly entry)
 *        ↓
 * irq_handler()  ← interrupt dispatcher
 *        ↓
 * Device-specific handler (timer driver)
 *
 * In this RTOS:
 * Physical Timer interrupt ID = 30 (PPI)
 */
 
#include "uart.h"
#include "timer.h"
#include "board.h"

/* GIC CPU Interface Registers */
#define GICC_IAR  ((volatile unsigned int *)(GIC_CPU_BASE + 0x00C))
#define GICC_EOIR ((volatile unsigned int *)(GIC_CPU_BASE + 0x010))

void irq_handler(void) {
    /* 1. Read interrupt ID from GIC (acknowledge interrupt) */
    unsigned int irq_id = *GICC_IAR;

    /* 2. Check if the interrupt is from the Physical Timer (ID 30) */
    if (irq_id == 30) {
        uart_puts("Timer Tick!\n");
        
        /* Reload timer for next 10ms tick */
        timer_reload();
    }

    /* 3. Signal End of Interrupt (EOI) */
    /* This allows the GIC to send further interrupts */
    *GICC_EOIR = irq_id;
}
