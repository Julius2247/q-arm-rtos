/* src/arch/aarch64/vectors.s */

/* --- 1. MACRO DEFINITIONS (Must be at the very top) --- */
.macro kernel_entry
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

    mrs     x10, elr_el1
    mrs     x11, spsr_el1
    stp     x10, x11, [sp, #16 * 16]

    ldr     x10, =current_task
    ldr     x11, [x10]
    mov     x12, sp
    str     x12, [x11]
.endm

.macro kernel_exit
    ldr     x10, =current_task
    ldr     x11, [x10]
    ldr     x12, [x11]
    mov     sp, x12

    ldp     x10, x11, [sp, #16 * 16]
    msr     elr_el1, x10
    msr     spsr_el1, x11

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
    eret
.endm

/* --- 2. VECTOR TABLE --- */
.section ".text.vectors"
.align 11
.global vectors
vectors:
    /* Case 1: Current EL with SP0 (0x000-0x180) */
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception

    /* Case 2: Current EL with SPx (0x200-0x380) */
    .align 7
    b handle_sync     /* 0x200: SVC */
    .align 7
    b handle_irq      /* 0x280: Timer */
    .align 7
    b handle_invalid_exception
    .align 7
    b handle_invalid_exception

    /* Case 3: Lower EL AArch64 (0x400-0x580) */
    .align 7
    .space 128 * 4
    
    /* Case 4: Lower EL AArch32 (0x600-0x780) */
    .align 7
    .space 128 * 4

/* --- 3. EXCEPTION HANDLERS --- */
handle_invalid_exception:
    b handle_invalid_exception

handle_sync:
    kernel_entry            /* Save full register context to stack */

    /* 
     * Prepare arguments for C function: 
     * void syscall_handler(unsigned long id, unsigned long arg0)
     *
     * Following AArch64 Calling Convention:
     * x0: 1st argument (Syscall ID)
     * x1: 2nd argument (First parameter, e.g., ms)
     *
     * Data is retrieved from the saved stack frame:
     * [sp, #64] contains original x8 (Syscall ID)
     * [sp, #0]  contains original x0 (Argument 0)
     */
    ldr     x0, [sp, #64]    /* Load original x8 into x0 */
    ldr     x1, [sp, #0]     /* Load original x0 into x1 */

    bl      syscall_handler  /* Jump to C-level syscall dispatcher */

    kernel_exit             /* Restore context and return to task (eret) */


handle_irq:
    kernel_entry
    bl      irq_handler
    kernel_exit
