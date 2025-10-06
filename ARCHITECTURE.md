# Trojan NES - Architecture Overview

This document provides a high-level overview of the project architecture and the NES hardware it targets.

## Project Structure Diagram

```
trojan_nes/
│
├── Documentation
│   ├── README.md              ← Start here!
│   ├── README.dev.md          ← Developer guide
│   ├── TODO.md                ← Feature roadmap
│   ├── INSTRUCTIONS.md        ← Setup guide
│   ├── PROJECT_STATUS.md      ← Current status
│   └── ARCHITECTURE.md        ← This file
│
├── Build System
│   ├── Makefile               ← Build automation
│   ├── nes.cfg                ← Linker configuration
│   └── .gitignore             ← Version control rules
│
├── Source Code (src/)
│   ├── main.asm               ← Main game logic
│   ├── vectors.asm            ← Interrupt handlers
│   ├── (future) player.asm   ← Player logic
│   ├── (future) enemy.asm    ← Enemy AI
│   ├── (future) graphics.asm ← Graphics routines
│   └── (future) sound.asm    ← Sound engine
│
├── Include Files (include/)
│   ├── constants.inc          ← Hardware constants
│   └── macros.inc             ← Assembly macros
│
├── Game Data (data/)
│   ├── levels/                ← Level layouts
│   ├── enemies/               ← Enemy definitions
│   └── graphics/              ← CHR ROM data
│
└── Build Output (build/)
    ├── *.o                    ← Object files
    ├── *.lst                  ← Assembly listings
    ├── *.map                  ← Memory map
    └── trojan.nes             ← Final ROM
```

## NES Hardware Architecture

### CPU: Ricoh 2A03 (Modified 6502)

```
┌─────────────────────────────────────────────┐
│              NES Console                     │
│                                              │
│  ┌──────────────┐       ┌─────────────────┐ │
│  │   CPU        │───────│  Program ROM    │ │
│  │  (2A03)      │       │   (PRG ROM)     │ │
│  │  @ 1.79 MHz  │       │   32KB/128KB    │ │
│  └──────┬───────┘       └─────────────────┘ │
│         │                                    │
│         ├──────┐                            │
│         │      │                            │
│  ┌──────▼──┐  │  ┌─────────────────┐       │
│  │  RAM    │  └──│  Character ROM  │       │
│  │  2KB    │     │   (CHR ROM)     │       │
│  └─────────┘     │   8KB/128KB     │       │
│                  └────────┬────────┘       │
│  ┌──────────────┐         │                │
│  │   APU        │         │                │
│  │  (Audio)     │         │                │
│  └──────────────┘  ┌──────▼────────┐      │
│                     │      PPU       │      │
│  ┌──────────────┐  │  (Graphics)    │      │
│  │ Controllers  │  │   @ 5.37 MHz   │      │
│  └──────────────┘  └────────┬───────┘      │
│                              │              │
└──────────────────────────────┼──────────────┘
                               │
                          ┌────▼─────┐
                          │   TV     │
                          │  Screen  │
                          └──────────┘
```

### Memory Map

```
+---------------+ $FFFF
|               |
|  PRG ROM      | Program code and data
|  (Cartridge)  | Mapped by mapper
|               |
+---------------+ $8000
|               |
|  SRAM         | Battery-backed save RAM
|  (Optional)   | (if present)
|               |
+---------------+ $6000
|               |
|  Expansion    | Rarely used
|               |
+---------------+ $4020
|  APU & I/O    | Sound and controller registers
+---------------+ $4000
|  PPU Regs     | Graphics chip registers
+---------------+ $2000
|               |
|  RAM Mirrors  | Mirrors of $0000-$07FF
|               |
+---------------+ $0800
|  RAM          | 2KB work RAM
+---------------+ $0000
```

### Zero Page ($0000-$00FF)

Fast-access memory for frequently used variables:
```
$00-$0F: System/temporary variables
$10-$1F: Player variables
$20-$3F: Enemy variables
$40-$5F: Graphics buffers
$60-$7F: Sound variables
$80-$FF: General purpose
```

### Stack ($0100-$01FF)

Hardware stack used by:
- JSR/RTS (subroutine calls)
- PHA/PLA (push/pull accumulator)
- PHP/PLP (push/pull processor status)
- Interrupts (NMI, IRQ)

### PPU (Picture Processing Unit)

```
Graphics Pipeline:

CHR ROM (Tiles)
      ↓
Pattern Tables
      ↓
Nametables (Screen Layout)
      ↓
Attribute Tables (Colors)
      ↓
Palettes
      ↓
Screen Output
```

#### PPU Memory Map

```
+---------------+ $3FFF
|  Mirrors      |
+---------------+ $3F20
|  Palettes     | Sprite & background colors
+---------------+ $3F00
|  Mirrors      |
+---------------+ $3000
|               |
|  Nametables   | Screen tile layout
|  (4 screens)  | Only 2 physical on NES
|               |
+---------------+ $2000
|               |
|  Pattern      | Background tiles
|  Table 1      | 256 tiles
|               |
+---------------+ $1000
|               |
|  Pattern      | Sprite tiles
|  Table 0      | 256 tiles
|               |
+---------------+ $0000
```

### APU (Audio Processing Unit)

5 sound channels:
```
┌──────────────┐
│  Pulse 1     │ - Square wave (melody)
├──────────────┤
│  Pulse 2     │ - Square wave (harmony)
├──────────────┤
│  Triangle    │ - Triangle wave (bass)
├──────────────┤
│  Noise       │ - Pseudo-random (percussion)
├──────────────┤
│  DMC         │ - Sample playback
└──────────────┘
```

## Game Loop Architecture

```
Start
  ↓
Reset Vector
  ↓
Initialize Hardware
  ↓
Clear RAM
  ↓
Load Initial Game State
  ↓
Enable NMI & Rendering
  ↓
┌─────────────────┐
│  Main Loop      │←──────┐
│                 │       │
│  ┌───────────┐  │       │
│  │ Wait for  │  │       │
│  │  VBlank   │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
│  ┌───────────┐  │       │
│  │ Update    │  │       │
│  │ Game      │  │       │
│  │ Logic     │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
│  ┌───────────┐  │       │
│  │ Prepare   │  │       │
│  │ Graphics  │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
└────────┼────────┘       │
         └────────────────┘

During VBlank (NMI):
  ↓
Update PPU
  ↓
Update Sprites (DMA)
  ↓
Update Scroll
  ↓
Return to Main Loop
```

## Game State Machine

```
        ┌──────────────┐
        │  Power On    │
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │ Title Screen │←───────┐
        └──────┬───────┘        │
               ↓                │
        ┌──────────────┐        │
    ┌───│   Gameplay   │        │
    │   └──────┬───────┘        │
    │          ↓                │
    │   ┌──────────────┐        │
    │   │    Pause     │        │
    │   └──────┬───────┘        │
    │          ↓                │
    │   ┌──────────────┐        │
    └──→│  Game Over   │────────┘
        └──────────────┘
```

## Data Flow Diagram

```
Controller Input
       ↓
┌──────────────┐
│  Read Input  │
└──────┬───────┘
       ↓
┌──────────────┐     ┌──────────────┐
│ Update Player│────→│ Check        │
│   State      │     │ Collisions   │
└──────┬───────┘     └──────┬───────┘
       ↓                    ↓
┌──────────────┐     ┌──────────────┐
│ Update Enemy │     │ Update Score │
│    AI        │     │   & UI       │
└──────┬───────┘     └──────┬───────┘
       ↓                    ↓
┌──────────────────────────────────┐
│    Update Sprite Positions       │
└────────────────┬─────────────────┘
                 ↓
         ┌───────────────┐
         │  NMI Handler  │
         │  (VBlank)     │
         └───────┬───────┘
                 ↓
         ┌───────────────┐
         │  DMA Transfer │
         │  Sprites to   │
         │  PPU          │
         └───────┬───────┘
                 ↓
              Screen
```

## Code Organization

### Modular Structure

```
main.asm
  ├── includes
  │   ├── constants.inc
  │   └── macros.inc
  │
  ├── initialization
  │   ├── reset vector
  │   ├── clear RAM
  │   └── init hardware
  │
  ├── main loop
  │   ├── wait for vblank
  │   ├── game state dispatcher
  │   └── game logic
  │
  └── game states
      ├── title screen
      ├── gameplay
      ├── pause
      └── game over

vectors.asm
  ├── NMI handler (VBlank)
  ├── IRQ handler (unused)
  └── reset vector
```

## Build Process Flow

```
Source Files        Assembly      Linking        Output
(.asm, .inc)       (ca65)        (ld65)        (.nes)
     │                 │             │             │
     ├──main.asm──────►│             │             │
     ├──vectors.asm───►│             │             │
     ├──constants.inc─►│             │             │
     └──macros.inc────►│             │             │
                       │             │             │
                       ├──main.o────►│             │
                       └──vectors.o─►│             │
                                     │             │
                                     ├──nes.cfg    │
                                     │             │
                                     └────────────►trojan.nes
```

## Performance Considerations

### CPU Cycles

- NES CPU runs at ~1.79 MHz
- ~29,780 CPU cycles per frame (at 60 Hz)
- Must fit all game logic within VBlank (~2,273 cycles)

### PPU Updates

- Can only update PPU during VBlank
- VBlank duration: ~2,273 CPU cycles
- Sprite DMA: 513 cycles
- Leaves ~1,760 cycles for other PPU updates

### Memory Constraints

- Only 2KB RAM available
- Must carefully manage memory usage
- Use zero page for frequently accessed variables
- Consider memory pooling for objects

## Optimization Strategies

1. **Use Zero Page**: Fast 2-cycle access
2. **Minimize PPU Access**: Only during VBlank
3. **Loop Unrolling**: Trade space for speed
4. **Table Lookup**: Replace calculations
5. **Efficient Branching**: Most likely cases first

## Mapper Architecture (If Used)

```
Mapper provides:
  ├── Bank Switching
  │   ├── PRG ROM banks
  │   └── CHR ROM banks
  │
  ├── Additional RAM
  │   └── Save game storage
  │
  └── IRQ Generation
      └── Scanline counter
```

## Future Expansion Points

Based on TODO.md:

1. **Tilemapper**: Tool for level editing
2. **Player Locations**: Spawn point system
3. **BGM Player**: Music engine interface
4. **Character System**: VS mode expansion
5. **Enemy Database**: AI and behavior system
6. **Boss Run Mode**: Level sequence editor

## Testing Architecture

```
Source Changes
      ↓
   Assemble
      ↓
    Link
      ↓
  Generate ROM
      ↓
   Emulator Test
      ├── Functionality
      ├── Graphics
      ├── Sound
      └── Performance
      ↓
  Hardware Test
      └── Real NES
```

## Documentation Standards

- Comment every major section
- Label all subroutines descriptively
- Document memory locations
- Explain non-obvious operations
- Reference original game behavior

## References

- **NES Dev Wiki**: https://www.nesdev.org/wiki/
- **6502 Reference**: http://www.6502.org/
- **cc65 Docs**: https://cc65.github.io/

---

This architecture provides a solid foundation for understanding and working with the Trojan NES disassembly project.
