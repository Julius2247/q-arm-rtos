.global cpu_switch_to
cpu_switch_to:
    /* 1. Save Context */
    mov     x8, sp
    stp     x19, x20, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x27, x28, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
    str     x8, [sp, #-16]!      // Save current SP

    mov     x8, sp
    str     x8, [x0]             // Store into prev->sp

    /* 2. Restore Context */
    ldr     x8, [x1]             // Load from next->sp
    mov     sp, x8

    ldr     x8, [sp], #16        // Pop original SP
    ldp     x29, x30, [sp], #16  // Pop x29, x30
    ldp     x27, x28, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
