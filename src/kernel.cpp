#include "uart.h"

extern "C" void kmain()
{
    uart_init();
    uart_puts("Hello");
    while (true)
    {
    }
}
