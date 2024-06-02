ORG 0x7c00  ; origin of the program
BITS 16    ; 16-bit mode

start:
    mov si, message ; load the address of the message
    call print      ; call the print function
    jmp $           ; infinite loop

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

message: db "Hello, World!", 0  ; the message to print

times 510-($-$$) db 0   ; fill 510 bytes with 0
dw 0xaa55               ; boot signature