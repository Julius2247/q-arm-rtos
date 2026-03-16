#include "printf.h"
#include "task.h"
#include "uart.h"

extern tcb_t tcb_a, tcb_b, *current_task;

/**
 * syscall_handler - C dispatcher for SVC exceptions
 * @id: Syscall ID from x8
 * @arg0: First argument from x0
 */
void syscall_handler(unsigned long id, unsigned long arg0) {
    switch (id) {
        case 0: /* os_yield */
            /* Simply toggle current_task to the other one */
            current_task = (current_task == &tcb_a) ? &tcb_b : &tcb_a;
            break;

        case 1: /* os_sleep */
            {
                unsigned int ms = (unsigned int)arg0;
                current_task->sleep_ticks = ms / 10;
                current_task->state = TASK_SLEEPING;
                /* Context switch since current task is now blocked */
                current_task = (current_task == &tcb_a) ? &tcb_b : &tcb_a;
                printf("\n[SVC] Task Sleep: %d ms\n", ms);
            }
            break;

        default:
            printf("\n[SVC] Unknown ID: %d\n", (int)id);
            break;
    }
}

