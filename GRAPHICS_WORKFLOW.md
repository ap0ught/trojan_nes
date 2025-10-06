# Graphics Workflow Guide

This guide explains how to work with graphics in the Trojan NES disassembly project.

## Overview

The Trojan ROM contains graphics data in CHR ROM format. This guide shows you how to:
1. Extract graphics from the ROM
2. View and edit graphics
3. Document tile usage
4. Integrate graphics into the build

## Quick Start

### Extract Graphics from ROM

```bash
# Place Trojan (USA).nes ROM in root directory as trojan_usa.nes
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin
```

Expected output:
```
============================================================
Trojan (USA) NES ROM Information
============================================================
PRG ROM Size: 131,072 bytes (128 KB)
CHR ROM Size: 131,072 bytes (128 KB)
Mapper:       1
Mirroring:    Vertical
Battery RAM:  No
Trainer:      No
============================================================

Extracted 131,072 bytes of CHR ROM data
CHR ROM offset in file: 0x20010

CHR ROM saved to: data/graphics/trojan_chr.bin
File size: 131,072 bytes

============================================================
CHR ROM Analysis
============================================================
Total Tiles:      8192
Pattern Tables:   32
Tiles per table:  256
...
============================================================
```

## Understanding NES Graphics

### Tile Format

- Each tile is 8x8 pixels
- 2 bits per pixel = 4 colors per tile
- 16 bytes per tile:
  - Bytes 0-7: Low bitplane
  - Bytes 8-15: High bitplane

### Pattern Tables

CHR ROM is organized into pattern tables (4KB each):
- **Pattern Table 0**: Usually sprites ($0000-$0FFF)
- **Pattern Table 1**: Usually background ($1000-$1FFF)

Each pattern table contains 256 tiles.

### Color Palettes

- 4 background palettes (for background tiles)
- 4 sprite palettes (for sprite tiles)
- Each palette has 4 colors
- Colors chosen from NES's 64-color master palette

## Viewing Graphics

### Option 1: YY-CHR (Recommended)

1. Download YY-CHR: https://www.romhacking.net/utilities/119/
2. Open YY-CHR
3. File → Open: `data/graphics/trojan_chr.bin`
4. Settings:
   - Format: NES
   - 2bpp
   - 8x8 tiles
   - Width: 16 tiles (shows 256 tiles at once)

### Option 2: Emulator Debug Tools

**Mesen:**
```bash
mesen trojan_usa.nes
# Debug → PPU Viewer → CHR Viewer
```

**FCEUX:**
```bash
fceux trojan_usa.nes
# Tools → PPU Viewer
```

### Option 3: Command Line (hex dump)

```bash
hexdump -C data/graphics/trojan_chr.bin | head -32
```

## Editing Graphics

### Workflow

1. **Extract CHR data** (as shown above)
2. **Open in YY-CHR**
   ```bash
   # Open data/graphics/trojan_chr.bin in YY-CHR
   ```
3. **Make changes**
   - Edit tiles directly
   - Copy/paste tiles
   - Rearrange pattern tables
4. **Save**
   - File → Save (overwrites trojan_chr.bin)
5. **Rebuild ROM**
   ```bash
   ./build.sh rebuild
   ```
6. **Test in emulator**
   ```bash
   fceux build/trojan.nes
   ```

### Tips for Editing

- **Backup original**: `cp data/graphics/trojan_chr.bin data/graphics/trojan_chr.bin.backup`
- **Use layers**: Edit one pattern table at a time
- **Document changes**: Note which tiles you modified
- **Test frequently**: Build and test after major changes
- **Version control**: Commit graphics changes separately

## Splitting CHR Data

For easier organization, split CHR ROM into separate files:

### Manual Split

```bash
# Pattern Table 0 (sprites) - first 4KB
dd if=data/graphics/trojan_chr.bin of=data/graphics/pattern_table_0.bin bs=4096 count=1

# Pattern Table 1 (background) - second 4KB
dd if=data/graphics/trojan_chr.bin of=data/graphics/pattern_table_1.bin bs=4096 skip=1 count=1
```

### Update Build

In `src/chr_rom.asm`, replace:
```assembly
.incbin "data/graphics/trojan_chr.bin"
```

With:
```assembly
.incbin "data/graphics/pattern_table_0.bin"  ; Sprites
.incbin "data/graphics/pattern_table_1.bin"  ; Background
```

## Documenting Tiles

Create a tile map document: `data/graphics/tile_map.txt`

Example format:
```
Pattern Table 0 - Sprites ($0000-$0FFF)
========================================
$00-$0F: Player standing frames
$10-$1F: Player walking frames
$20-$2F: Player jumping frames
$30-$3F: Player attacking frames
$40-$4F: Enemy soldier sprites
$50-$5F: Enemy archer sprites
$60-$6F: Weapon sprites (sword, shield)
$70-$7F: Item sprites (power-ups)
$80-$8F: Explosion effects
$90-$9F: Hit effects
...

Pattern Table 1 - Background ($1000-$1FFF)
===========================================
$00-$0F: Wall tiles (various types)
$10-$1F: Floor tiles
$20-$2F: Platform tiles
$30-$3F: Decorative elements
$40-$4F: UI elements (HUD borders)
$50-$5F: Text characters (numbers)
$60-$6F: Text characters (letters)
...
```

## Integration with Source Code

### Include CHR Data

The `src/chr_rom.asm` file handles CHR ROM inclusion:

```assembly
.segment "CHARS"
.incbin "data/graphics/trojan_chr.bin"
```

### Reference in Code

Reference tiles by their tile index:

```assembly
; Set player sprite to tile $00 from Pattern Table 0
LDA #$00        ; Tile index
STA $0201       ; OAM sprite tile number

; Set background tile to tile $10 from Pattern Table 1
LDA #$10        ; Tile index (+ $100 for pattern table 1)
STA PPUDATA     ; Write to PPU
```

## Advanced: Creating Custom Graphics

### Tools Needed

- Graphics editor (GIMP, Photoshop, etc.)
- YY-CHR or similar NES tile editor

### Process

1. **Design tiles**
   - Create 8x8 pixel tiles
   - Use only 4 colors per tile
   - Design in graphics editor

2. **Convert to NES format**
   - Import into YY-CHR
   - Arrange into pattern tables
   - Save as NES 2bpp format

3. **Replace in project**
   ```bash
   cp custom_graphics.bin data/graphics/trojan_chr.bin
   ```

4. **Build and test**
   ```bash
   ./build.sh rebuild
   fceux build/trojan.nes
   ```

## Troubleshooting

### "CHR ROM not found" during build

**Problem**: Build can't find CHR data file

**Solution**: 
```bash
# Extract CHR data
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin

# Or create empty CHR data for testing
dd if=/dev/zero of=data/graphics/trojan_chr.bin bs=8192 count=1
```

### Graphics look corrupted in emulator

**Problem**: Tiles appear garbled or wrong

**Causes & Solutions**:
1. **Wrong file format**
   - Ensure file is NES 2bpp format
   - Check file size (should be multiple of 4096 bytes)

2. **Wrong palette**
   - Graphics are correct but colors are wrong
   - Need to extract/set correct palette data

3. **Wrong pattern table**
   - Sprites using background tiles or vice versa
   - Check PPU control registers in code

### Build size increased significantly

**Problem**: ROM is much larger after adding graphics

**Solution**: This is expected. CHR ROM adds 8KB+ to ROM size.
- Original template: ~40KB
- With CHR ROM: ~40KB + CHR size
- Trojan has 128KB CHR ROM, so final size ~168KB

## Best Practices

1. **Version Control**
   - Commit CHR data as binary files
   - Document changes in commit messages
   - Keep original ROM separate (not in repo)

2. **Organization**
   - Split CHR data logically (sprites, backgrounds, etc.)
   - Document tile usage thoroughly
   - Use consistent naming conventions

3. **Testing**
   - Test graphics changes in emulator
   - Check both gameplay and menus
   - Verify all animations still work

4. **Backups**
   - Keep backup of original CHR data
   - Save multiple versions during major edits
   - Use git branches for experimental graphics

## Resources

### Tools

- **YY-CHR**: https://www.romhacking.net/utilities/119/
- **Mesen**: https://www.mesen.ca/
- **FCEUX**: http://fceux.com/
- **NES Screen Tool**: https://shiru.untergrund.net/software.shtml

### Documentation

- [NES Dev Wiki - CHR ROM](https://www.nesdev.org/wiki/CHR_ROM)
- [NES Dev Wiki - PPU Pattern Tables](https://www.nesdev.org/wiki/PPU_pattern_tables)
- [Graphics Format Guide](https://www.nesdev.org/wiki/PPU_palettes)

### Community

- [NES Dev Forums](https://forums.nesdev.org/)
- [ROM Hacking Discord](https://discord.gg/romhacking)
- [/r/romhacking](https://reddit.com/r/romhacking)

---

For more information, see:
- `tools/README.md` - Tool documentation
- `data/graphics/README.md` - Graphics data documentation
- `README.dev.md` - Developer guide
