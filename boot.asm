ORG 0       ; origin of the program
BITS 16     ; 16-bit mode to run on real mode

_start:
    jmp short start ; jump to the start of the program
    nop             ; no operation

times 33 db 0       ; fill the first 33 bytes with 0 after short jump
start:
    jmp 0x7c0:step2 ; jump to the start of the program

step2:    
    cli             ; clear interrupts
    mov ax, 0x07C0  ; set the data segment to 0x07C0
    mov ds, ax      ; load the data segment
    mov es, ax      ; load the extra segment
    mov ax, 0x00    ; set the stack pointer to 0x0000
    mov ss, ax      ; load the stack segment
    mov sp, 0x7c00  ; load the stack pointer
    sti             ; enables interrupts

    mov ah, 2       ; read the sector from the disk
    mov al, 1       ; read one sector
    mov ch, 0       ; cylinder number
    mov cl, 2       ; sector number
    mov dh, 0       ; head number
    mov bx, buffer  ; load the buffer
    int 0x13        ; call BIOS disk interrupt
    jc error        ; jump to error if there is an error

    mov si, buffer  ; load the buffer
    call print      ; call the print function

    jmp $           ; infinite loop

error:
    mov si, error_message ; load the error message
    call print            ; call the print function
    jmp $                 ; infinite loop

print:
    mov bx, 0       ; set the page number to 0
.loop:              ; loop to print the message
    lodsb           ; load the next byte from the message
    cmp al, 0       ; check if it is the null character
    je .done        ; if it is, we are done
    call print_char ; call the print_char function
    jmp .loop       ; repeat the loop
.done:              ; done printing the message     
  ret               ; return from the function 

print_char:
    mov ah, 0eh ; teletype output
    int 0x10    ; call BIOS video interrupt
    ret         ; return from the function

error_message: db "Failed to load sector", 0

times 510-($-$$) db 0   ; fill 510 bytes with 0
dw 0xaa55               ; boot signature

buffer: