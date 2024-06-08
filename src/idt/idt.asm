section .asm

global idt_load

extern int21h_handler
global int21h

global no_interrupt
extern no_interrupt_handler

global enable_interrupts
global disable_interrupts

enable_interrupts:
    sti
    ret

disable_interrupts:
    cli
    ret

idt_load:
    push ebp
    
    mov ebp, esp
    mov ebx, [ebp + 8]
    lidt [ebx]

    pop ebp
    ret

int21h:
    cli
    pusha
    call int21h_handler
    popad
    sti
    iret

no_interrupt:
    cli
    pusha
    call no_interrupt_handler
    popad
    sti
    iret