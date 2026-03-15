/*
 * ARM Interrupt Pipeline & Scheduler Implementation
 *
 * Hardware Interrupt Flow:
 *
 * [Hardware] ARM Generic Timer (Physical Timer)  --> src/drivers/timer.c
 *        ↓
 * [Hardware] GIC (Generic Interrupt Controller)  --> src/drivers/gic.c
 *        ↓
 * [CPU] CPU IRQ Exception                        --> ARM AArch64 Hardware
 *        ↓
 * [Arch] Exception Vector Table (VBAR_EL1)       --> src/arch/aarch64/vectors.s
 *        ↓
 * [Arch] handle_irq (Assembly Context Saving)    --> src/arch/aarch64/vectors.s
 *        ↓
 * [Kernel] irq_handler() (C-level Dispatcher)    --> src/kernel/irq.c
 *        ↓
 * [Sched] Task Switching (Scheduler)             --> src/arch/aarch64/switch.s
 *
 * In this RTOS:
 * - Physical Timer interrupt ID = 30 (PPI)
 * - Time Slice = 10ms
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
