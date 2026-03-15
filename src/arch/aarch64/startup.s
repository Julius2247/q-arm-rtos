.section ".text.boot"
.global _start

_start:
    /* Read CPU ID */
    mrs     x0, mpidr_el1
    and     x0, x0, #0xFF
    /* If not Core 0, go to infinite loop (sleep) */
    cbz     x0, master
hang:
    wfe
    b       hang

master:
    /* Setup stack pointer */
    ldr     x0, =stack_top
    mov     sp, x0

    /* Set the Exception Vector Base Address Register (VBAR_EL1) */
    ldr     x0, =vectors
    msr     vbar_el1, x0

    /* Jump to C main */
    bl      main
    b       hang
