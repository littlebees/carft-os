C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o}

CFLAGS = -g -std=c99 -O2

all: run

# Notice how dependencies are built as needed
kernel.bin: kernel_entry.o ${OBJ}
	docker run --rm -v ${PWD}:/app/ toolchain i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: kernel_entry.o ${OBJ}
	docker run --rm -v ${PWD}:/app/ toolchain i686-elf-ld -o $@ -Ttext 0x1000 $^ 

# Rule to disassemble the kernel - may be useful to debug
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin: boot/boot.asm
	nasm $< -f bin -o $@

os-image.bin: boot.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

run-debug: os-image.bin kernel.elf
	qemu-system-i386 -S -s -fda os-image.bin &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

toolchain:
	docker build --tag toolchain -f Dockerfile .

%.o: %.c ${HEADERS}
	docker run --rm -v ${PWD}:/app/ toolchain i686-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

%.o: boot/%.asm
	nasm $< -f elf -o $@

%.bin: boot/%.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o
