CXX = aarch64-linux-gnu-g++
AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld

CXXFLAGS = -ffreestanding -fno-exceptions -fno-rtti -nostdlib -nostartfiles -nodefaultlibs
ASFLAGS =
LDFLAGS = -T linker.ld -nostdlib

BUILD = build

all: $(BUILD)/kernel.elf

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.o: boot/boot.S | $(BUILD)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/kernel.o: src/kernel.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/kernel.elf: $(BUILD)/boot.o $(BUILD)/kernel.o
	$(LD) $(LDFLAGS) $^ -o $@

run: $(BUILD)/kernel.elf
	qemu-system-aarch64 \
		-machine virt \
		-cpu cortex-a57 \
		-kernel $(BUILD)/kernel.elf \
		-nographic

clean:
	rm -rf $(BUILD)/*
