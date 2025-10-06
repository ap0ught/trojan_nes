# Graphics Data

This directory contains graphics data extracted from the Trojan (USA) CHR ROM.

## Quick Start

### Extract Graphics from ROM

```bash
# Run the extraction tool
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin
```

This will extract all graphics tiles from the ROM into a binary file.

## CHR ROM Structure

The NES uses tile-based graphics with 8x8 pixel tiles:
- **2 bits per pixel** (4 colors per tile)
- **16 bytes per tile** (8 bytes for low bitplane, 8 for high bitplane)
- Organized into **pattern tables**

### Tile Format

Each 8x8 pixel tile consists of 16 bytes:

```
Bytes 0-7:  Low bitplane  (bit 0 of each pixel)
Bytes 8-15: High bitplane (bit 1 of each pixel)

Combined = 2 bits per pixel = 4 possible colors per tile
```

Example tile structure:
```
Row 0: [byte 0, byte 8]  <- 8 pixels, 2 bits each
Row 1: [byte 1, byte 9]
Row 2: [byte 2, byte 10]
Row 3: [byte 3, byte 11]
Row 4: [byte 4, byte 12]
Row 5: [byte 5, byte 13]
Row 6: [byte 6, byte 14]
Row 7: [byte 7, byte 15]
```

## Pattern Tables

CHR ROM is divided into two 4KB pattern tables:

### Pattern Table 0 ($0000-$0FFF)
- **Size**: 4096 bytes (256 tiles)
- **Typical Use**: Sprite graphics
- **Trojan Contents** (to be documented):
  - Player character sprites (standing, walking, jumping, attacking)
  - Enemy sprites (soldiers, archers, bosses)
  - Weapon sprites (sword, shield)
  - Item sprites (power-ups)
  - Effect sprites (explosions, hit effects)

### Pattern Table 1 ($1000-$1FFF)
- **Size**: 4096 bytes (256 tiles)
- **Typical Use**: Background graphics
- **Trojan Contents** (to be documented):
  - Level tiles (platforms, walls, floors)
  - Decorative elements (columns, architecture)
  - UI elements (HUD borders, health indicators)
  - Text characters (numbers, letters for score/HUD)

## Color Palettes

NES supports 8 palettes total:
- **4 background palettes** (for background tiles)
- **4 sprite palettes** (for sprite tiles)

Each palette contains:
- **4 colors** (index 0 is typically transparent for sprites)
- Colors selected from the NES's 64-color master palette
- Palette data stored separately from tile data

## Files in This Directory

After extraction, this directory will contain:

- **trojan_chr.bin** - Complete CHR ROM (8KB, both pattern tables)
- **pattern_table_0.bin** - Sprite tiles only (4KB) [optional split]
- **pattern_table_1.bin** - Background tiles only (4KB) [optional split]
- **tile_map.txt** - Documentation of which tiles are used where
- **palette_data.asm** - Palette definitions for the game

## Tools for Viewing/Editing

### Recommended Tools

1. **YY-CHR** (Best for NES)
   - Download: https://www.romhacking.net/utilities/119/
   - Features: Pattern table view, palette editing, tile editing
   - Usage: Open `trojan_chr.bin` directly

2. **Mesen Emulator**
   - Download: https://www.mesen.ca/
   - Features: Real-time tile viewer, debug tools
   - Usage: Run ROM, open Debug > PPU Viewer

3. **FCEUX Emulator**
   - Download: http://fceux.com/
   - Features: Built-in PPU viewer and debugger
   - Usage: Run ROM, Tools > PPU Viewer

4. **Tile Molester**
   - Download: https://www.romhacking.net/utilities/108/
   - Features: Generic tile editor
   - Usage: More flexible but requires manual format setup

### Viewing with YY-CHR

```bash
# Open YY-CHR and load trojan_chr.bin
# Settings:
# - Format: NES
# - 2bpp (2 bits per pixel)
# - 8x8 tiles
# - 16 tiles per row (shows pattern table structure)
```

## Integration with Build System

### Option 1: Include Complete CHR ROM

In `src/chr_rom.asm`:
```assembly
.segment "CHARS"
.incbin "data/graphics/trojan_chr.bin"
```

### Option 2: Split Pattern Tables

For easier editing, split into separate files:
```assembly
.segment "CHARS"
.incbin "data/graphics/pattern_table_0.bin"  ; Sprites
.incbin "data/graphics/pattern_table_1.bin"  ; Background
```

### Option 3: Individual Tile Files

For maximum flexibility:
```assembly
.segment "CHARS"
; Pattern Table 0 - Sprites
.incbin "data/graphics/sprites/player.bin"
.incbin "data/graphics/sprites/enemies.bin"
.incbin "data/graphics/sprites/effects.bin"
; ... etc

; Pattern Table 1 - Background
.incbin "data/graphics/backgrounds/level_tiles.bin"
.incbin "data/graphics/backgrounds/ui_tiles.bin"
; ... etc
```

## Workflow

### 1. Extract Graphics

```bash
python3 tools/extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin
```

### 2. Document Tile Usage

Create `tile_map.txt` documenting which tiles are used for what purpose.

### 3. Edit Graphics (Optional)

- Open in YY-CHR or other tool
- Make modifications
- Save back to binary file

### 4. Build ROM

```bash
./build.sh
# Or
make
```

The build system will include the CHR data in the final ROM.

## Tips

- **Always backup** original CHR data before editing
- **Use version control** for graphics changes
- **Document tile usage** - note which tiles are used where
- **Test in emulator** after graphics changes
- **Watch for tile limits** - 256 tiles per pattern table
- **Palette constraints** - Only 4 colors per 8x8 tile area

## Advanced: Creating Custom Graphics

To create completely custom graphics:

1. Create 8x8 pixel tiles with 4 colors
2. Export as NES 2bpp format
3. Arrange into pattern tables (256 tiles each)
4. Save as binary files
5. Include in build

Tools that can export to NES format:
- YY-CHR
- NES Screen Tool
- Custom Python scripts

## References

- [NES Dev Wiki - CHR ROM](https://www.nesdev.org/wiki/CHR_ROM)
- [NES Dev Wiki - PPU Pattern Tables](https://www.nesdev.org/wiki/PPU_pattern_tables)
- [NES Dev Wiki - PPU Palettes](https://www.nesdev.org/wiki/PPU_palettes)
- [Tile Encoding Format](https://www.nesdev.org/wiki/PPU_pattern_tables#Encoding)
