# Trojan (USA) NES Disassembly Project

This project contains a disassembly of the NES game "Trojan" (USA version), originally released by Capcom in 1987.

## About Trojan

Trojan is an action platformer game for the Nintendo Entertainment System. Players control a warrior fighting through various levels filled with enemies, culminating in boss battles.

## Project Structure

```
trojan_nes/
├── README.md           # This file - Project overview
├── README.dev.md       # Developer documentation
├── TODO.md             # Feature roadmap and planned improvements
├── src/                # Disassembled source files
│   ├── main.asm        # Main game code
│   ├── prg_rom.asm     # PRG ROM disassembly
│   ├── chr_rom.asm     # CHR ROM data
│   └── vectors.asm     # Interrupt vectors
├── include/            # Include files and definitions
│   ├── constants.inc   # Game constants
│   └── macros.inc      # Assembly macros
├── data/               # Game data files
│   ├── levels/         # Level data
│   ├── enemies/        # Enemy definitions
│   └── graphics/       # Graphics data
└── build/              # Build scripts and configuration

```

## Requirements

To build this project, you will need:

- **cc65** toolchain (ca65, ld65, da65)
- **Make** or build system of choice
- **Original ROM file** (not included - must be legally obtained)

## Getting Started

### 1. Obtain the ROM

You must legally obtain the original "Trojan (USA)" ROM file. Place it in the root directory as `trojan_usa.nes`.

**ROM Information:**
- Game: Trojan (USA)
- Platform: Nintendo Entertainment System (Headered)
- Source: No-Intro set

### 2. Disassembly (If starting fresh)

If you need to create the initial disassembly:

```bash
# Using da65 from cc65
da65 trojan_usa.nes -o src/trojan.asm
```

### 3. Building

#### Using the Build Script (Recommended)

```bash
# Make the script executable (first time only)
chmod +x build.sh

# Build the ROM
./build.sh

# Or use specific commands
./build.sh build    # Build the ROM
./build.sh clean    # Clean build artifacts
./build.sh rebuild  # Clean and rebuild
./build.sh verify   # Build and verify against original ROM
./build.sh help     # Show help message
```

#### Using Make

```bash
make              # Build the ROM
make clean        # Clean build artifacts
make rebuild      # Clean and rebuild
make run          # Build and run in emulator (requires fceux)
make verify       # Compare with original ROM
```

#### Manual Build

```bash
# Assemble the source
ca65 -I include src/main.asm -o build/main.o
ca65 -I include src/vectors.asm -o build/vectors.o

# Link to create ROM
ld65 -C nes.cfg build/main.o build/vectors.o -o build/trojan.nes
```

## Features

- Complete disassembly of game logic
- Documented code sections
- Modular source structure
- Build system for reassembly

## Contributing

Contributions are welcome! Please see [README.dev.md](README.dev.md) for developer guidelines and see [TODO.md](TODO.md) for planned features.

## Legal Notice

This is a disassembly project for educational and preservation purposes. You must own a legal copy of the original game to use this project. The game "Trojan" is property of Capcom.

## Resources

- [NES Dev Wiki](https://www.nesdev.org/wiki/)
- [cc65 Documentation](https://cc65.github.io/)
- [6502 Instruction Reference](http://www.6502.org/tutorials/6502opcodes.html)

## License

The disassembled code is provided for educational purposes. Original game content is copyright Capcom.