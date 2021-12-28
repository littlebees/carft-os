[bits 16]
print_16:
    pusha
start_print_16:
    mov al, [bx] ; 'bx' is the base address for the string
    cmp al, 0 
    je done_print_16

    ; the part where we print with the BIOS help
    mov ah, 0x0e
    int 0x10 ; 'al' already contains the char

    ; increment pointer and do next loop
    add bx, 1
    jmp start_print_16

done_print_16:
    popa
    ret

print_nl_16:
    pusha
    
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    
    popa
    ret

[bits 32] ; using 32-bit protected mode

; this is how constants are defined
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each character

print_32:
    pusha
    mov edx, VIDEO_MEMORY

start_print_32:
    mov al, [ebx] ; [ebx] is the address of our character
    mov ah, WHITE_ON_BLACK

    cmp al, 0 ; check if end of string
    je done_print_32

    mov [edx], ax ; store character + attribute in video memory
    add ebx, 1 ; next char
    add edx, 2 ; next video memory position

    jmp start_print_32

done_print_32:
    popa
    ret
