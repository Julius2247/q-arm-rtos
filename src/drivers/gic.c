#include "board.h"

/* GIC V2 Registers (Standard for QEMU virt) */
#define GICD_BASE (GIC_DIST_BASE)
#define GICC_BASE (GIC_CPU_BASE)

#define GICD_CTLR            ((volatile unsigned int *)(GICD_BASE + 0x000))
#define GICD_ISENABLER(n)    ((volatile unsigned int *)(GICD_BASE + 0x100 + (n) * 4))
#define GICC_CTLR            ((volatile unsigned int *)(GICC_BASE + 0x000))
#define GICC_PMR             ((volatile unsigned int *)(GICC_BASE + 0x004))

void gic_init(void) {
    /* 1. Enable GIC Distributor */
    *GICD_CTLR = 1;

    /* 2. Enable Timer Interrupt (ID 30 for Physical Timer) */
    /* ID 30 is in ISENABLER[0] (bits 0-31) */
    GICD_ISENABLER(0)[0] = (1 << 30);

    /* 3. Enable GIC CPU Interface */
    *GICC_PMR = 0xFF; // Priority filter: allow all
    *GICC_CTLR = 1;   // Enable
    
}

