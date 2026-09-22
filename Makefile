CXX = aarch64-linux-gnu-g++
AS  = aarch64-linux-gnu-as
LD  = aarch64-linux-gnu-ld

CXXFLAGS = -ffreestanding -fno-exceptions -fno-rtti \
           -nostdlib -nostartfiles -nodefaultlibs \
           -mgeneral-regs-only -Wall -Wextra -MMD -MP
ASFLAGS  =
LDFLAGS  = -T linker.ld -nostdlib

BUILD = build
SRCS  = $(wildcard src/*.cpp)
OBJS  = $(patsubst src/%.cpp,$(BUILD)/%.o,$(SRCS))

all: $(BUILD)/kernel.elf

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.o: boot/boot.S | $(BUILD)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/%.o: src/%.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/kernel.elf: $(BUILD)/boot.o $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

run: $(BUILD)/kernel.elf
	qemu-system-aarch64 \
		-machine virt \
		-cpu cortex-a57 \
		-kernel $(BUILD)/kernel.elf \
		-nographic

clean:
	rm -rf $(BUILD)/*

.PHONY: all run clean

-include $(OBJS:.o=.d)
