.global _start

.section .text

_start:
    ldr x30, =stack_top
    mov sp, x30

    bl kmain

    b .
