# Graphics Data

This directory contains graphics data extracted from CHR ROM.

## CHR ROM Structure

The NES uses tile-based graphics with 8x8 pixel tiles:
- 2 bits per pixel (4 colors per tile)
- 16 bytes per tile (8 bytes for low bitplane, 8 for high bitplane)
- Organized into pattern tables

## Pattern Tables

- **Pattern Table 0** ($0000-$0FFF): Typically used for sprites
- **Pattern Table 1** ($1000-$1FFF): Typically used for backgrounds

## Tile Organization

Common tile groupings in Trojan:
- Player character sprites (walking, jumping, attacking)
- Enemy sprites
- UI elements (health bar, score display)
- Background tiles (walls, floors, scenery)
- Special effects (explosions, weapons)

## Color Palettes

NES supports 4 background palettes and 4 sprite palettes:
- Each palette has 4 colors (including transparency)
- Palette data stored separately from tile data

## Extraction Tools

To extract graphics:
- **YY-CHR** - Tile viewer/editor
- **Tile Molester** - Generic tile editor
- **NES CHR Editor** - Specialized for NES

## Files

Graphics data files:
- `chr_rom.bin` - Raw CHR ROM data
- `sprites.chr` - Sprite tiles
- `backgrounds.chr` - Background tiles
- `palettes.asm` - Palette definitions
