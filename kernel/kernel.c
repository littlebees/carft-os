#include "../cpu/isr.h"
#include "../cpu/timer.h"
#include "../drivers/keyboard.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"

void kernel_main() {
    isr_install();
    __asm__ volatile("sti");
    /* IRQ0: timer */
    //init_timer(50);
    /* IRQ1: keyboard */
    init_keyboard();

    kprint("Type something, it will go through the kernel\n"
        "Type END to halt the CPU\n> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        kprint("Stopping the CPU. Bye!\n");
        __asm__ volatile("hlt");
    }
    kprint("You said: ");
    kprint(input);
    kprint("\n> ");
}