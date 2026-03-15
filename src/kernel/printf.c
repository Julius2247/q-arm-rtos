#include <stdarg.h>
#include "uart.h"

static void _putn(unsigned long n, int base) {
    char buf[64];
    int i = 0;
    const char *digits = "0123456789ABCDEF";

    if (n == 0) {
        uart_putc('0');
        return;
    }

    while (n > 0) {
        buf[i++] = digits[n % base];
        n /= base;
    }

    while (i > 0) {
        uart_putc(buf[--i]);
    }
}

void printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);

    for (const char *p = fmt; *p != '\0'; p++) {
        if (*p != '%') {
            uart_putc(*p);
            continue;
        }

        p++;
        switch (*p) {
            case 's':
                uart_puts(va_arg(args, char *));
                break;
            case 'd':
                _putn(va_arg(args, int), 10);
                break;
            case 'x':
                uart_puts("0x");
                _putn(va_arg(args, unsigned long), 16);
                break;
            case '%':
                uart_putc('%');
                break;
            default:
                uart_putc(*p);
                break;
        }
    }
    va_end(args);
}
