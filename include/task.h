#ifndef TASK_H
#define TASK_H

#include <stdint.h>

/* Task State Definitions */
#define TASK_READY      0
#define TASK_SLEEPING   1

/**
 * Task Control Block (TCB)
 * Contains the execution context and scheduling state for a task.
 */
typedef struct {
    uint64_t *sp;           /* Current stack pointer */
    volatile uint32_t state;         /* Task execution state */
    volatile uint32_t sleep_ticks;   /* Ticks remaining to sleep (1 tick = 10ms) */
} tcb_t;

/* Task Management Prototypes */
void os_init(void);
void task_init_context(tcb_t *tcb, uint64_t *stack_top, void (*task_func)(void));

#endif
