#include "printf.h"
#include <stdint.h>

/* Symbols defined in linker.ld */
extern char __heap_start;
extern char __heap_end;

/* Pointer to the next available memory location */
static char *heap_ptr = &__heap_start;

/**
 * kmalloc - Simple kernel memory allocator
 * @size: Number of bytes to allocate
 * 
 * Returns a 16-byte aligned pointer to the allocated memory.
 */
void *kmalloc(uint32_t size) {
    /* Align size to 16-byte boundary for AArch64 hardware requirements */
    size = (size + 15) & ~15;

    /* Check for memory overflow */
    if (heap_ptr + size > &__heap_end) {
        printf("[Malloc] Error: Out of memory!\n");
        return 0;
    }

    void *ptr = heap_ptr;
    heap_ptr += size;

    /* Optional: Print allocation for debugging */
    printf("[Malloc] Allocated %d bytes at 0x%x\n", size, (unsigned long)ptr);
    
    return ptr;
}

