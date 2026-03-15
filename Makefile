CROSS_COMPILE = aarch64-elf-
CC      = $(CROSS_COMPILE)gcc
LD      = $(CROSS_COMPILE)ld
QEMU    = qemu-system-aarch64

# Directory configuration
SRC_DIR = src
BUILD_DIR = build
INC_DIR = include

# Compiler flags
CFLAGS  = -Wall -Wextra -march=armv8-a -nostdlib -nostartfiles -ffreestanding -I$(INC_DIR) -g
LDFLAGS = -T linker.ld

# Source files (Relative to SRC_DIR)
SRCS = arch/aarch64/startup.s \
       kernel/main.c \
       drivers/uart.c

# Object files (Placed in BUILD_DIR)
OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(basename $(SRCS))))

TARGET = $(BUILD_DIR)/q-arm-rtos.elf

all: $(TARGET)

# Link the kernel
$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(LD) $(LDFLAGS) $(OBJS) -o $(TARGET)

# Compile Assembly files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile C files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	$(QEMU) -M virt -cpu cortex-a53 -nographic -kernel $(TARGET)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run clean
