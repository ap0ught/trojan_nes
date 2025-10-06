# Trojan NES Tools

This directory contains tools for working with the Trojan NES ROM and its graphics data.

## Tools

### extract_chr.py

Extracts CHR ROM (graphics tiles) from the Trojan (USA) NES ROM file.

**Usage:**
```bash
# Basic usage (uses defaults)
python3 tools/extract_chr.py trojan_usa.nes

# Specify output file
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin

# With custom paths
python3 tools/extract_chr.py /path/to/rom.nes /path/to/output.bin
```

**Features:**
- Parses iNES header
- Validates ROM structure
- Extracts CHR ROM data
- Displays ROM information (PRG size, CHR size, mapper, etc.)
- Analyzes pattern table layout

**Output:**
The script creates a binary file containing the raw CHR ROM data, which includes:
- All sprite tiles
- All background tiles
- Organized into pattern tables (4KB each)
- Each tile is 16 bytes (8x8 pixels, 2 bits per pixel)

### include_chr.asm (Coming Soon)

A tool to generate assembly include files from extracted CHR data.

### view_tiles.py (Coming Soon)

A simple tile viewer to visualize CHR ROM graphics.

## CHR ROM Format

NES graphics are stored as 8x8 pixel tiles in CHR ROM:

```
Each tile = 16 bytes
- First 8 bytes: Low bitplane (bit 0 of each pixel)
- Next 8 bytes: High bitplane (bit 1 of each pixel)
- 2 bits per pixel = 4 colors per tile
```

### Pattern Tables

CHR ROM is organized into pattern tables:
- Each pattern table = 4KB (4096 bytes)
- Each pattern table contains 256 tiles
- Pattern Table 0: Usually sprites ($0000-$0FFF)
- Pattern Table 1: Usually background ($1000-$1FFF)

## Workflow

### 1. Extract Graphics

```bash
# Extract CHR ROM from the original ROM
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin
```

### 2. View/Edit Graphics

Use external tools to view and edit the graphics:
- **YY-CHR**: Popular NES tile editor
- **Tile Molester**: Generic tile editor
- **Mesen**: NES emulator with built-in tile viewer

### 3. Include in Build

The extracted CHR data can be included in the assembly:

```assembly
.segment "CHARS"
.incbin "data/graphics/trojan_chr.bin"
```

Or split into separate files for easier editing:
```assembly
.segment "CHARS"
.incbin "data/graphics/pattern_table_0.bin"  ; Sprites
.incbin "data/graphics/pattern_table_1.bin"  ; Background
```

## Graphics Organization

Based on typical NES games, Trojan likely organizes graphics as:

### Pattern Table 0 (Sprites)
- Player character sprites
- Enemy sprites
- Weapon sprites
- Item sprites
- Explosion/effect sprites

### Pattern Table 1 (Background)
- Level tiles (walls, floors, platforms)
- Decorative elements
- UI elements (HUD tiles)
- Text characters

## Tips

- Always work with copies of the original ROM
- Back up CHR data before making changes
- Use version control for graphics modifications
- Document tile usage in comments
- Keep a tile map showing which tiles are used where

## External Tools

### For Viewing/Editing

- **YY-CHR**: https://www.romhacking.net/utilities/119/
  - Best for NES tile editing
  - Supports pattern tables
  - Shows all tiles at once

- **Tile Molester**: https://www.romhacking.net/utilities/108/
  - Generic tile editor
  - More flexible but less NES-specific

- **FCEUX**: http://fceux.com/
  - NES emulator with debugger
  - Built-in tile viewer
  - Can view tiles in real-time

- **Mesen**: https://www.mesen.ca/
  - Modern NES emulator
  - Excellent debugging tools
  - Advanced tile viewer

### For Analysis

- **NES Screen Tool**: https://shiru.untergrund.net/software.shtml
  - Create nametables (screen layouts)
  - Export as assembly data

## References

- [NES Dev Wiki - CHR ROM](https://www.nesdev.org/wiki/CHR_ROM)
- [NES Dev Wiki - PPU Pattern Tables](https://www.nesdev.org/wiki/PPU_pattern_tables)
- [NES Graphics Guide](https://www.nesdev.org/wiki/PPU_palettes)
