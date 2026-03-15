// src/arch/aarch64/vectors.s
/*
 * AArch64 Exception Vector Table
 *
 * CPU jumps here when an exception or interrupt occurs.
 * IRQ entry calls handle_irq, which dispatches interrupts
 * to the C-level irq_handler().
 */

.section ".text.vectors"
.align 11

.global vectors
vectors:
    // Current EL with SP0
    .align 7
    b handle_invalid_exception // Synchronous
    .align 7
    b handle_invalid_exception // IRQ
    .align 7
    b handle_invalid_exception // FIQ
    .align 7
    b handle_invalid_exception // SError

    // Current EL with SPx
    .align 7
    b handle_invalid_exception // Synchronous
    .align 7
    b handle_irq               // IRQ - This is where Timer lands
    .align 7
    b handle_invalid_exception // FIQ
    .align 7
    b handle_invalid_exception // SError

    // Lower EL (AArch64)
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception

    // Lower EL (AArch32)
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception

handle_invalid_exception:
    b handle_invalid_exception

// src/arch/aarch64/vectors.s

handle_irq:
    /* 1. Context Saving: Save all 31 registers (x0-x30) */
    /* Total size: 34 slots * 8 bytes = 272 bytes (16-byte aligned) */
    sub     sp, sp, #272
    stp     x0,  x1,  [sp, #16 * 0]
    stp     x2,  x3,  [sp, #16 * 1]
    stp     x4,  x5,  [sp, #16 * 2]
    stp     x6,  x7,  [sp, #16 * 3]
    stp     x8,  x9,  [sp, #16 * 4]
    stp     x10, x11, [sp, #16 * 5]
    stp     x12, x13, [sp, #16 * 6]
    stp     x14, x15, [sp, #16 * 7]
    stp     x16, x17, [sp, #16 * 8]
    stp     x18, x19, [sp, #16 * 9]
    stp     x20, x21, [sp, #16 * 10]
    stp     x22, x23, [sp, #16 * 11]
    stp     x24, x25, [sp, #16 * 12]
    stp     x26, x27, [sp, #16 * 13]
    stp     x28, x29, [sp, #16 * 14]
    str     x30, [sp, #16 * 15]

    /* 2. Save Exception State (ELR and SPSR) */
    /* These define WHERE to return and HOW to return (mode/flags) */
    mrs     x0, elr_el1
    mrs     x1, spsr_el1
    stp     x0, x1, [sp, #16 * 16]

    /* 3. Update Current Task's TCB with the new SP */
    ldr     x0, =current_task
    ldr     x1, [x0]             /* x1 = address of old TCB */
    mov     x2, sp
    str     x2, [x1]             /* old_tcb->sp = sp */

    /* 4. Call C-level Interrupt Handler to pick the next task */
    bl      irq_handler

    /* 5. Switch to the NEW current_task's stack */
    ldr     x0, =current_task
    ldr     x1, [x0]             /* x1 = address of next TCB */
    ldr     x2, [x1]             /* x2 = next_tcb->sp */
    mov     sp, x2

    /* 6. Context Restore: Restore Exception State */
    ldp     x0, x1, [sp, #16 * 16]
    msr     elr_el1, x0
    msr     spsr_el1, x1

    /* 7. Context Restore: Restore all 31 registers */
    ldr     x30, [sp, #16 * 15]
    ldp     x28, x29, [sp, #16 * 14]
    ldp     x26, x27, [sp, #16 * 13]
    ldp     x24, x25, [sp, #16 * 12]
    ldp     x22, x23, [sp, #16 * 11]
    ldp     x20, x21, [sp, #16 * 10]
    ldp     x18, x19, [sp, #16 * 9]
    ldp     x16, x17, [sp, #16 * 8]
    ldp     x14, x15, [sp, #16 * 7]
    ldp     x12, x13, [sp, #16 * 6]
    ldp     x10, x11, [sp, #16 * 5]
    ldp     x8,  x9,  [sp, #16 * 4]
    ldp     x6,  x7,  [sp, #16 * 3]
    ldp     x4,  x5,  [sp, #16 * 2]
    ldp     x2,  x3,  [sp, #16 * 1]
    ldp     x0,  x1,  [sp, #16 * 0]
    add     sp, sp, #272

    /* 8. Jump to next task using Exception Return */
    eret
