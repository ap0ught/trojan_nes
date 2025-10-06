# Trojan NES - Developer Documentation

This document provides detailed information for developers working on the Trojan NES disassembly project.

## Development Environment Setup

### Required Tools

1. **cc65 Toolchain**
   ```bash
   # Install on Ubuntu/Debian
   sudo apt-get install cc65
   
   # Install on macOS
   brew install cc65
   
   # Or build from source
   git clone https://github.com/cc65/cc65.git
   cd cc65
   make
   sudo make install
   ```

2. **Additional Tools**
   - Text editor with 6502 assembly support (VS Code, Vim, etc.)
   - Hex editor (for binary analysis)
   - NES emulator for testing (FCEUX, Mesen, etc.)

## Project Architecture

### Memory Map

The NES uses a 6502 processor with the following memory layout:

```
$0000-$07FF: RAM (2KB, mirrored)
$0800-$1FFF: RAM mirrors
$2000-$2007: PPU registers
$2008-$3FFF: PPU register mirrors
$4000-$4017: APU and I/O registers
$4018-$401F: APU and I/O test mode
$4020-$FFFF: Cartridge space (PRG ROM, PRG RAM, mapper registers)
```

### Code Organization

#### src/main.asm
Main game logic including:
- Initialization routines
- Game state management
- Main game loop
- Input handling

#### src/prg_rom.asm
Program ROM sections:
- Bank 0: Common code
- Bank 1+: Level-specific code (if using mapper)

#### src/chr_rom.asm
Character ROM data:
- Sprite tiles
- Background tiles
- Pattern tables

#### src/vectors.asm
Interrupt vectors:
- NMI (Non-Maskable Interrupt) - VBlank handler
- RESET - Startup routine
- IRQ - Hardware interrupt handler

### Data Structures

#### Player Data Structure
```assembly
; Player position and state
player_x:           .res 1    ; X position
player_y:           .res 1    ; Y position
player_state:       .res 1    ; Current state (standing, jumping, etc.)
player_health:      .res 1    ; Health points
player_direction:   .res 1    ; Facing direction
```

#### Enemy Data Structure
```assembly
; Enemy attributes
enemy_type:         .res 8    ; Enemy type ID
enemy_x:            .res 8    ; X positions
enemy_y:            .res 8    ; Y positions
enemy_state:        .res 8    ; Current states
enemy_health:       .res 8    ; Health values
```

## Building the Project

### Manual Build Process

1. **Assemble source files**
   ```bash
   ca65 src/main.asm -o build/main.o -l build/main.lst
   ca65 src/vectors.asm -o build/vectors.o
   ```

2. **Link objects**
   ```bash
   ld65 -C nes.cfg build/main.o build/vectors.o -o trojan.nes -m build/trojan.map
   ```

3. **Verify build**
   ```bash
   # Compare with original ROM
   md5sum trojan.nes trojan_usa.nes
   ```

### Build Configuration (nes.cfg)

Example linker configuration:
```
MEMORY {
    ZEROPAGE: start = $0000, size = $0100, type = rw, fill = yes, fillval = $00;
    RAM:      start = $0100, size = $0700, type = rw, fill = yes, fillval = $00;
    BSS:      start = $0800, size = $0800, type = rw, fill = yes, fillval = $00;
    HEADER:   start = $0000, size = $0010, fill = yes, fillval = $00;
    PRG:      start = $8000, size = $8000, fill = yes, fillval = $FF;
    CHR:      start = $0000, size = $2000, fill = yes, fillval = $00;
}

SEGMENTS {
    ZEROPAGE: load = ZEROPAGE, type = zp;
    RAM:      load = RAM,      type = rw;
    BSS:      load = BSS,      type = bss;
    HEADER:   load = HEADER,   type = ro;
    CODE:     load = PRG,      type = ro;
    RODATA:   load = PRG,      type = ro;
    VECTORS:  load = PRG,      type = ro, start = $FFFA;
    CHARS:    load = CHR,      type = ro;
}
```

## Disassembly Workflow

### Initial Disassembly

1. **Extract ROM information**
   ```bash
   # View ROM header
   hexdump -C trojan_usa.nes | head -n 2
   ```

2. **Run da65 disassembler**
   ```bash
   da65 --cpu 6502 trojan_usa.nes -o src/raw_disasm.asm
   ```

3. **Identify code sections**
   - Separate code from data
   - Label subroutines
   - Comment unclear sections

### Code Analysis

#### Finding Subroutines
Look for JSR (Jump to Subroutine) instructions:
```assembly
JSR $8100    ; Calls subroutine at $8100
```

#### Identifying Data Tables
Look for sequential data access patterns:
```assembly
LDX #$00
LDA data_table,X
```

#### Game State Management
Track state variables and their usage:
```assembly
LDA game_state
CMP #$00        ; Title screen
BEQ title_screen
CMP #$01        ; Gameplay
BEQ gameplay
```

## Graphics and Tiles

### CHR ROM Structure

The CHR ROM contains 8x8 pixel tiles:
- 2 bits per pixel (4 colors per tile)
- 16 bytes per tile
- Pattern table 0: Sprites
- Pattern table 1: Background

### Tile Extraction

```bash
# Extract tiles using NES graphics tools
# Various tools available: YY-CHR, Tile Molester, etc.
```

## Sound and Music

### APU (Audio Processing Unit)

The NES APU has 5 channels:
- 2 pulse wave channels
- 1 triangle wave channel
- 1 noise channel
- 1 DMC (sample) channel

### Music Engine

Document the game's music engine:
- Sound effect routines
- Music data format
- Note/frequency tables

## Testing

### Emulator Testing

1. **FCEUX** - Good debugging features
   ```bash
   fceux trojan.nes
   ```

2. **Mesen** - Excellent debugging and analysis tools
   ```bash
   mesen trojan.nes
   ```

### Verification

- Compare behavior with original ROM
- Test all game modes
- Verify no regressions
- Check for side effects of modifications

## Debugging

### Common Issues

1. **Bank switching errors**
   - Verify mapper configuration
   - Check bank select writes

2. **Timing issues**
   - Ensure proper NMI handling
   - Check for race conditions

3. **Graphics glitches**
   - Verify PPU writes during VBlank
   - Check attribute table data

### Debug Build

Add debug symbols and comments:
```assembly
.proc initialize
    ; Clear RAM
    LDX #$00
    LDA #$00
:   STA $0000,X
    INX
    BNE :-
    RTS
.endproc
```

## Code Style Guidelines

### Naming Conventions

- **Labels**: Use descriptive names with underscores
  ```assembly
  player_update:
  enemy_spawn:
  ```

- **Constants**: Use uppercase
  ```assembly
  SCREEN_WIDTH = 256
  SPRITE_COUNT = 64
  ```

- **Variables**: Use lowercase with prefixes
  ```assembly
  var_player_x = $0020
  var_enemy_count = $0030
  ```

### Comments

- Comment every major section
- Explain non-obvious operations
- Document memory addresses
- Reference original game behavior

### Indentation

- Use consistent spacing (2 or 4 spaces)
- Align operands for readability
- Group related code with blank lines

## Contributing

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes with clear commits
4. Test thoroughly
5. Submit pull request with description

### Code Review Checklist

- [ ] Code builds successfully
- [ ] Changes are documented
- [ ] No regressions introduced
- [ ] Follows style guidelines
- [ ] Comments explain the changes

## Resources

### 6502 Assembly
- [6502 Instruction Set](http://www.6502.org/tutorials/6502opcodes.html)
- [Easy 6502](https://skilldrick.github.io/easy6502/)

### NES Development
- [NES Dev Wiki](https://www.nesdev.org/wiki/)
- [NES Dev Forums](https://forums.nesdev.org/)
- [NESDev on GitHub](https://github.com/topics/nesdev)

### Tools
- [cc65 Home Page](https://cc65.github.io/)
- [FCEUX Emulator](http://fceux.com/)
- [Mesen Emulator](https://www.mesen.ca/)
- [YY-CHR Graphics Editor](https://www.romhacking.net/utilities/119/)

## Contact

For questions and discussions, please open an issue on GitHub or join the NES development community forums.

## Appendix: Memory Locations

### Zero Page Variables
```
$00-$0F: System variables
$10-$1F: Player data
$20-$3F: Enemy data
$40-$4F: Graphics buffers
$50-$FF: General purpose
```

### Game State Constants
```
STATE_TITLE     = $00
STATE_GAMEPLAY  = $01
STATE_PAUSE     = $02
STATE_GAMEOVER  = $03
```

### PPU Registers
```
PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
OAMADDR   = $2003
OAMDATA   = $2004
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007
```
