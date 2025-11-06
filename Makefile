ASM = nasm
CC = i686-elf-gcc
LD = i686-elf-ld
QEMU = qemu-system-x86_64
BUILD = build
BOOT = boot
KERNEL = kernel

all: $(BUILD)/os-image.bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.bin: $(BOOT)/pm.asm | $(BUILD)
	$(ASM) -f bin $< -o $@

$(BUILD)/kernel.o: $(KERNEL)/kernel.c
	$(CC) -ffreestanding -m32 -c $< -o $@

$(BUILD)/kernel.bin: $(BUILD)/kernel.o
	$(LD) -Ttext 0x1000 --oformat binary $< -o $@

$(BUILD)/os-image.bin: $(BUILD)/boot.bin $(BUILD)/kernel.bin
	cat $^ > $@

run: all
	$(QEMU) -drive format=raw,file=$(BUILD)/os-image.bin

clean:
	rm -rf $(BUILD)/*
