BOOT=src/kernel.asm
SOURCES=src/boot.asm src/kernel.c src/keyboard/keyboard.c
HEADERS=src/boot.h src/keyboard/keyboard.h src/keyboard/keyboard_map.h
OBJECTS=build/boot.o build/kernel.o build/keyboard.o
ISOFILE=build/pkos.iso
ISO_VOLUME_NAME=PKOS
LINKER=src/linker.ld
KERNEL=build/kernel.bin
ISO_OUT=build/pkos.iso

all: ${KERNEL}

vpath %.c src src/keyboard
vpath %.asm src src/inc

build/%.o: %.c
	gcc -m32 -ffreestanding -c $^ -o $@

build/%.o: %.asm
	nasm -f elf32 $^ -o $@

${KERNEL}: ${OBJECTS}
	@echo kernelboyo
	mkdir -p build
	ld -m elf_i386 -T ${LINKER} -o ${KERNEL_OUT} ${OBJECTS}

run: ${KERNEL}
	qemu-system-i386 -kernel ${KERNEL_OUT} -monitor stdio

# build: clean
# 	nasm -f elf32 ${BOOT} -o build/boot.o
# 	gcc -m32 -ffreestanding -c ${SOURCES} -o build/kernel.o
# 	ld -m elf_i386 -T ${LINKER} -o ${KERNEL_OUT} build/boot.o build/kernel.o
# build_debug: clean
# 	nasm -f elf32 ${BOOT} -o build/boot.o
# 	gcc -m32 -ffreestanding -c ${SOURCES} -o build/kernel.o -ggdb
# 	ld -m elf_i386 -T ${LINKER} -o ${KERNEL_OUT} build/boot.o build/kernel.o
# run: build
# 	qemu-system-i386 -kernel ${KERNEL_OUT} -monitor stdio
# run-iso: iso
# 	qemu-system-i386 -cdrom ${ISO_OUT} -monitor stdio
# debug: build_debug
# 	qemu-system-i386 -kernel ${KERNEL_OUT} -s -S &
# 	gdb -x .gdbinit
# iso: build
# 	mkdir -p build/iso/boot/grub
# 	cp grub.cfg build/iso/boot/grub
# 	cp ${KERNEL_OUT} build/iso/boot/grub
# 	grub-mkrescue -o ${ISO_OUT} build/iso
# 	rm -rf build/iso
# run-iso: iso
# 	qemu-system-i386 -cdrom ${ISOFILE}
clean:
	rm -rf build
