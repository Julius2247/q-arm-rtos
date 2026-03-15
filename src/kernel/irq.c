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
#include "task.h"

/* GIC CPU Interface Registers */
#define GICC_IAR  ((volatile unsigned int *)(GIC_CPU_BASE + 0x00C))
#define GICC_EOIR ((volatile unsigned int *)(GIC_CPU_BASE + 0x010))

/* External definitions from task management */
extern tcb_t tcb_a;
extern tcb_t tcb_b;
extern tcb_t *current_task;
extern void cpu_switch_to(tcb_t *prev, tcb_t *next);

void irq_handler(void) {
    unsigned int irq_id = *GICC_IAR;
    if (irq_id == 30) {
        uart_puts("|");
        timer_init();
        // Toggle task
        current_task = (current_task == &tcb_a) ? &tcb_b : &tcb_a;
    }
    *GICC_EOIR = irq_id;
}
