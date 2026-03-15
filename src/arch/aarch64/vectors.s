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

handle_irq:
    sub     sp, sp, #256
    stp     x0, x1, [sp, #0]
    stp     x2, x3, [sp, #16]
    stp     x29, x30, [sp, #240]

    bl      irq_handler

    ldp     x0, x1, [sp, #0]
    ldp     x2, x3, [sp, #16]
    ldp     x29, x30, [sp, #240]
    add     sp, sp, #256
    eret