# Trojan NES Disassembly - Project Status

## Current State

This project provides a complete framework for disassembling and rebuilding the Trojan (USA) NES ROM.

### ✅ Completed

- [x] Project structure setup
- [x] Directory organization (src, include, data, build)
- [x] Build system (Makefile)
- [x] Linker configuration (nes.cfg)
- [x] Core assembly templates (main.asm, vectors.asm)
- [x] Constants and macros (constants.inc, macros.inc)
- [x] Documentation (README.md, README.dev.md, TODO.md)
- [x] Setup instructions (INSTRUCTIONS.md)
- [x] .gitignore configuration

### 🔄 In Progress

The following requires the actual ROM file to be obtained and disassembled:

- [ ] Complete disassembly of PRG ROM
- [ ] Complete disassembly of CHR ROM
- [ ] Identification and labeling of all subroutines
- [ ] Documentation of game logic
- [ ] Data structure documentation

### 📝 Notes

**ROM File**: The project is ready to accept the Trojan ROM for disassembly. Users must legally obtain the ROM themselves.

**Build Status**: The template assembly files are syntactically correct but contain placeholder code. Once the actual ROM is disassembled, these files will be replaced with the real game code.

## File Overview

### Core Files

| File | Status | Description |
|------|--------|-------------|
| `README.md` | ✅ Complete | Project overview and getting started guide |
| `README.dev.md` | ✅ Complete | Developer documentation and architecture |
| `INSTRUCTIONS.md` | ✅ Complete | Step-by-step ROM setup and disassembly guide |
| `TODO.md` | ✅ Complete | Feature roadmap |
| `.gitignore` | ✅ Complete | Excludes ROM files and build artifacts |
| `Makefile` | ✅ Complete | Build automation |
| `nes.cfg` | ✅ Complete | Linker configuration for NES |

### Source Files

| File | Status | Description |
|------|--------|-------------|
| `src/main.asm` | 🔄 Template | Main game code (placeholder structure) |
| `src/vectors.asm` | 🔄 Template | Interrupt vectors (placeholder) |

### Include Files

| File | Status | Description |
|------|--------|-------------|
| `include/constants.inc` | ✅ Complete | NES hardware constants and game definitions |
| `include/macros.inc` | ✅ Complete | Useful assembly macros |

### Data Directories

| Directory | Status | Description |
|-----------|--------|-------------|
| `data/levels/` | 📁 Ready | For level data (awaiting ROM data) |
| `data/enemies/` | 📁 Ready | For enemy definitions (awaiting ROM data) |
| `data/graphics/` | 📁 Ready | For CHR ROM graphics (awaiting ROM data) |

## Next Steps

### Immediate Actions

1. **Obtain ROM**: Get a legal copy of Trojan (USA) NES ROM
2. **Initial Disassembly**: Run da65 on the ROM
3. **Code Analysis**: Identify and label code sections
4. **Data Extraction**: Separate data tables from code

### Short-term Goals

1. **Complete PRG ROM Disassembly**
   - Identify all subroutines
   - Label memory locations
   - Add comments

2. **Extract CHR ROM Graphics**
   - Document tile organization
   - Create palette definitions
   - Map sprite usage

3. **Document Game Structure**
   - Map game states
   - Document player mechanics
   - Identify enemy AI

### Long-term Goals

See [TODO.md](TODO.md) for the complete feature roadmap:
1. Tilemapper tool
2. Player location documentation
3. BGM player
4. VS mode character expansion
5. Boss/enemy documentation
6. Boss rush mode

## How to Contribute

### Prerequisites

- Legal copy of Trojan (USA) ROM
- cc65 toolchain installed
- NES emulator (FCEUX or Mesen)
- Basic understanding of 6502 assembly

### Getting Started

1. Follow [INSTRUCTIONS.md](INSTRUCTIONS.md) to set up
2. Read [README.dev.md](README.dev.md) for development guidelines
3. Pick a task from [TODO.md](TODO.md)
4. Make changes and test thoroughly
5. Submit a pull request

### Areas Needing Help

- **Code Documentation**: Adding comments to disassembled code
- **Data Identification**: Finding and labeling data structures
- **Feature Implementation**: Working on TODO items
- **Testing**: Verifying builds match original ROM
- **Graphics**: Extracting and documenting CHR ROM

## Technical Details

### Build Process

```
Source Files (.asm)
       ↓
    ca65 (assembler)
       ↓
  Object Files (.o)
       ↓
    ld65 (linker)
       ↓
   ROM File (.nes)
```

### Memory Layout

```
$0000-$07FF: RAM
$0800-$1FFF: RAM mirrors
$2000-$2007: PPU registers
$4000-$4017: APU and I/O
$6000-$7FFF: Battery-backed RAM (if present)
$8000-$FFFF: Program ROM
```

### ROM Structure

```
+-----------------+
| iNES Header     | 16 bytes
+-----------------+
| PRG ROM         | 128KB (8 x 16KB banks)
+-----------------+
| CHR ROM         | 128KB (16 x 8KB banks)
+-----------------+
```

## Quality Metrics

### Code Coverage
- [ ] 0% - Boot/Reset code
- [ ] 0% - Game state management
- [ ] 0% - Player logic
- [ ] 0% - Enemy logic
- [ ] 0% - Graphics rendering
- [ ] 0% - Sound engine
- [ ] 0% - Level data

### Documentation
- [x] 100% - Project structure
- [x] 100% - Build system
- [x] 100% - Development guidelines
- [ ] 0% - Code comments
- [ ] 0% - Data structures

## Version History

### v0.1.0 (Current)
- Initial project structure
- Build system setup
- Documentation framework
- Template assembly files

### Planned Releases

**v0.2.0** - Initial Disassembly
- Complete PRG ROM disassembly
- Basic code organization
- Build produces working ROM

**v0.3.0** - Documentation
- All subroutines labeled
- Code sections commented
- Data structures documented

**v1.0.0** - Full Disassembly
- Complete and accurate disassembly
- Comprehensive documentation
- All TODO items addressed

## Resources

- **Project Repository**: Check GitHub for latest updates
- **Issue Tracker**: Report bugs and request features
- **Discussions**: Share findings and ask questions
- **Wiki**: (Coming soon) Detailed game mechanics

## License

This project is for educational and preservation purposes. The game "Trojan" is property of Capcom. Users must own a legal copy of the game to use this project.

---

**Last Updated**: October 2025
**Project Status**: Framework Complete, Awaiting ROM Disassembly
