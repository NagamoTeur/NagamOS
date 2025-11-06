ASM = nasm
QEMU = qemu-system-x86_64
BUILD = build
BOOT_SRC = boot/boot.asm
BOOT_BIN = $(BUILD)/boot.bin

all: $(BOOT_BIN)

$(BUILD):
	mkdir -p $(BUILD)

$(BOOT_BIN): $(BOOT_SRC) | $(BUILD)
	$(ASM) -f bin $< -o $@

run: all
	$(QEMU) -drive format=raw,file=$(BOOT_BIN)

clean:
	rm -rf $(BUILD)/*
