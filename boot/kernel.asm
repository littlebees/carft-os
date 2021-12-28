%include "boot/hdd.asm"

KERNEL_OFFSET equ 0x1000

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_16
    call print_nl_16

    mov bx, KERNEL_OFFSET ; Read from disk and store in 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
start_kernel:
    call KERNEL_OFFSET
    jmp $

MSG_LOAD_KERNEL db "Loading kernel into memory", 0