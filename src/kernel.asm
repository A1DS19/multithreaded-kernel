[BITS 32]
global _start

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    mov ax, DATA_SEG ; load the data segment
    mov ds, ax       ; load the data segment
    mov es, ax       ; load the extra segment
    mov fs, ax       ; load the stack segment
    mov gs, ax       ; load the stack pointer
    mov ss, ax       ; load the stack segment
    mov ebp, 0x00200000 ; set the base pointer
    mov esp, ebp        ; set the stack pointer

    in al, 0x92         ; read the CMOS status register
    or al, 2            ; set the bit 4 of the CMOS status register
    out 0x92, al        ; write the CMOS status register

    jmp $