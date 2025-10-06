# Makefile for Trojan NES Disassembly
# Requires cc65 toolchain

# Assembler and linker
CA65 = ca65
LD65 = ld65

# Project name
PROJECT = trojan

# Source files
SRC_DIR = src
INC_DIR = include
BUILD_DIR = build

# Source files
SOURCES = $(SRC_DIR)/main.asm $(SRC_DIR)/vectors.asm
INCLUDES = $(INC_DIR)/constants.inc $(INC_DIR)/macros.inc

# Object files
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/vectors.o

# Output ROM
ROM = $(BUILD_DIR)/$(PROJECT).nes

# Assembler flags
ASFLAGS = -I $(INC_DIR) -l $(BUILD_DIR)/$*.lst

# Linker flags
LDFLAGS = -C nes.cfg -m $(BUILD_DIR)/$(PROJECT).map

# Default target
all: $(ROM)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Link object files to create ROM
$(ROM): $(OBJECTS) | $(BUILD_DIR)
	$(LD65) $(LDFLAGS) -o $(ROM) $(OBJECTS)
	@echo "ROM built successfully: $(ROM)"

# Assemble main.asm
$(BUILD_DIR)/main.o: $(SRC_DIR)/main.asm $(INCLUDES) | $(BUILD_DIR)
	$(CA65) $(ASFLAGS) -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.asm

# Assemble vectors.asm
$(BUILD_DIR)/vectors.o: $(SRC_DIR)/vectors.asm $(INCLUDES) | $(BUILD_DIR)
	$(CA65) $(ASFLAGS) -o $(BUILD_DIR)/vectors.o $(SRC_DIR)/vectors.asm

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Rebuild everything
rebuild: clean all

# Run in emulator (requires fceux)
run: $(ROM)
	@if command -v fceux > /dev/null; then \
		fceux $(ROM); \
	else \
		echo "Error: fceux emulator not found"; \
		echo "Install with: sudo apt-get install fceux"; \
		exit 1; \
	fi

# Compare with original ROM (if available)
verify: $(ROM)
	@if [ -f trojan_usa.nes ]; then \
		md5sum $(ROM) trojan_usa.nes; \
	else \
		echo "Original ROM not found: trojan_usa.nes"; \
	fi

# Help target
help:
	@echo "Trojan NES Disassembly - Makefile targets:"
	@echo "  all      - Build the ROM (default)"
	@echo "  clean    - Remove build artifacts"
	@echo "  rebuild  - Clean and build"
	@echo "  run      - Build and run in emulator"
	@echo "  verify   - Compare built ROM with original"
	@echo "  help     - Show this help message"

.PHONY: all clean rebuild run verify help
