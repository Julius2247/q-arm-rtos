#include "task.h"
#include "uart.h"

/* Pre-allocate stacks for 2 tasks (16KB each) */
uint64_t task_stack_a[2048] __attribute__((aligned(16)));
uint64_t task_stack_b[2048] __attribute__((aligned(16)));

tcb_t tcb_a;
tcb_t tcb_b;
tcb_t *current_task;

extern void cpu_switch_to(tcb_t *prev, tcb_t *next);

void task_init_context(tcb_t *tcb, uint64_t *stack_top, void (*func)(void)) {
    uint64_t *sp = stack_top;

    // Reserve 34 slots (272 bytes)
    sp -= 34;

    // Zero all
    for (int i = 0; i < 34; i++) sp[i] = 0;

    // sp[30] = x30, sp[32] = elr_el1, sp[33] = spsr_el1
    sp[32] = (uint64_t)func; // Where to start
    sp[33] = 0x05;           // SPSR_EL1: EL1h with interrupts enabled

    tcb->sp = sp;
}



// IMPORTANT: Simplify tasks for testing
void task_a(void) {
    while (1) {
        uart_puts("A"); 

        asm volatile ("svc #0"); 

        for (volatile int i = 0; i < 2000000; i++); // Busy wait
        // REMOVE manual cpu_switch_to here!
    }
}

void task_b(void) {
    while (1) {
        uart_puts("B");
        for (volatile int i = 0; i < 2000000; i++);
    }
}


void os_init(void)
{
    task_init_context(&tcb_a, &task_stack_a[2048], task_a);
    task_init_context(&tcb_b, &task_stack_b[2048], task_b);

    current_task = &tcb_a;

    uart_puts("OS Tasks Initialized.\n");
}