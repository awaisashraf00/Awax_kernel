#include "uart.h"

#define UART_BASE 0x09000000UL

#define UART_DR   0x00
#define UART_FR   0x18

#define UART_FR_TXFF (1 << 5)

static inline volatile unsigned int* reg(unsigned long offset)
{
    return (volatile unsigned int*)(UART_BASE + offset);
}

void uart_init()
{
    // QEMU's PL011 is ready to use; real hardware needs baud/LCR_H/CR setup here.
}

void uart_putc(char c)
{
    while (*reg(UART_FR) & UART_FR_TXFF)
    {
    }

    *reg(UART_DR) = (unsigned char)c;
}

void uart_puts(const char* str)
{
    while (*str)
    {
        if (*str == '\n')
            uart_putc('\r');
        uart_putc(*str++);
    }
}
