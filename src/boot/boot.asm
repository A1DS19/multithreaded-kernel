ORG 0x7c00       ; origin of the program
BITS 16     ; 16-bit mode to run on real mode

CODE_SEG equ gdt_code - gdt_start ; calculate the size of the code segment
DATA_SEG equ gdt_data - gdt_start ; calculate the size of the data segment

_start:
    jmp short start ; jump to the start of the program
    nop             ; no operation

times 33 db 0       ; fill the first 33 bytes with 0 after short jump

start:
    jmp 0:step2 ; jump to the start of the program

step2:    
    cli             ; clear interrupts
    mov ax, 0x00  ; set the data segment to 0x07C0
    mov ds, ax      ; load the data segment
    mov es, ax      ; load the extra segment
    mov ss, ax      ; load the stack segment
    mov sp, 0x7c00  ; load the stack pointer
    sti             ; enables interrupts

.load_protected:
    cli               ; clear interrupts
    lgdt [gdt_descriptor] ; load the GDT
    mov eax, cr0      ; load the control register 0
    or eax, 0x1       ; set the protected mode bit
    mov cr0, eax      ; load the control register 0
    jmp CODE_SEG:load32 ; jump to the protected mode

gdt_start:         ; start of the GDT
gdt_null:          ; null descriptor   
    dd 0x0         ; set the base to 0
    dd 0x0         ; set the limit to 0

gdt_code:          ; code descriptor
    dw 0xffff      ; set the limit to 0xffff 0-15 bits
    dw 0           ; set the base to 0
    db 0           ; set the base to 0
    db 0x9a        ; set the access byte
    db 11001111b   ; set the flags
    db 0           ; set the base to 0

gdt_data:          ; data descriptor DS, ES, SS, FS, GS
    dw 0xffff      ; set the limit to 0xffff 0-15 bits
    dw 0           ; set the base to 0
    db 0           ; set the base to 0
    db 0x92        ; set the access byte
    db 11001111b   ; set the flags
    db 0           ; set the base to 0

gdt_end:           ; end of the GDT

gdt_descriptor:    ; GDT descriptor
    dw gdt_end - gdt_null - 1 ; set the size of the GDT
    dd gdt_start               ; set the base of the GDT

[BITS 32]
load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    jmp CODE_SEG:0x100000

ata_lba_read:
    mov ebx, eax, ; Backup the LBA
    
    ; Send the LBA to the ATA controller
    shr eax, 24
    or eax, 0xe0
    mov dx, 0x1f6
    out dx, al
    ; Send the total sector count to the ATA controller
    mov eax, ecx
    mov dx, 0x1f2
    out dx, al

    ; Send the LBA to the ATA controller
    mov eax, ebx
    mov dx, 0x1f3
    out dx, al

    ; Send more of the LBA to the ATA controller
    mov dx, 0x1f4
    mov eax, ebx ; Restore the LBA
    shr eax, 8
    out dx, al

    mov dx, 0x1f5
    mov eax, ebx ; Restore the LBA
    shr eax, 16
    out dx, al

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

.next_sector:
    push ecx

.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

    mov ecx, 256
    mov dx, 0x1f0
    rep insw

    pop ecx
    loop .next_sector

    ret

times 510-($-$$) db 0   ; fill 510 bytes with 0
dw 0xaa55               ; boot signature