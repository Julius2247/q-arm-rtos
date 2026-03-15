ENTRY(_start)
SECTIONS
{
    . = 0x40000000;

    /* Code and read-only data */
    .text : { KEEP(*(.text.boot)) *(.text) }
    .rodata : { *(.rodata) }

    /* Initialized and uninitialized data */
    .data : { *(.data) }
    .bss : {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss)
        __bss_end = .;
    }

    /* --- Define Heap Region --- */
    . = ALIGN(16);          /* Ensure heap starts at 16-byte boundary */
    __heap_start = .;       /* Start symbol for kernel allocator */
    
    . += 0x100000;          /* Reserve 1MB for Heap (adjust as needed) */
    
    __heap_end = .;         /* End symbol for kernel allocator */
    /* -------------------------- */

    /* Boot stack for Core 0 */
    . = ALIGN(16);
    . += 0x4000;            /* 16KB Boot Stack */
    stack_top = .;
}
