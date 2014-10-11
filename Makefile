C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}
all: os-image

run: all
	bochs -q

os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin : kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^  --oformat binary -melf_i386

%.o : %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@ -m32

%.o : %.asm
	nasm $< -f elf -o $@

%.bin : %.asm
	nasm $< -f bin -I "boot/" -o $@


clean:
	rm -rf *.bin *.o os-image *.dis
	rm -rf kernel/*.o boot/*.bin drivers/*.o

kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
