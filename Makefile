all: run

# Notice how dependencies are built as needed
kernel.bin: kernel_entry.o kernel.o
	docker run --rm -v ${PWD}:/app/ toolchain i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel/kernel.c
	docker run --rm -v ${PWD}:/app/ toolchain i686-elf-gcc -ffreestanding -c $< -o $@

# Rule to disassemble the kernel - may be useful to debug
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin: boot/boot.asm
	nasm $< -f bin -o $@

os-image.bin: boot.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm -f *.bin *.o *.dis
