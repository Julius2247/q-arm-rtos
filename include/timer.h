/*
Timer interrupt
        ↓
       GIC
        ↓
Exception Vector (ASM)
        ↓
IRQ entry (ASM)
        ↓
irq_handler_c() (C)
        ↓
device handler (C)
        ↓
return to ASM
        ↓
eret
*/

#ifndef TIMER_H
#define TIMER_H

void timer_init(void);
void timer_reload(void);

#endif

