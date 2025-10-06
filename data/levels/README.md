# Level Data

This directory contains level data extracted from the Trojan ROM.

## Level Format

Each level consists of:
- Tile layout data
- Enemy spawn points
- Item locations
- Background graphics references
- Collision map

## Level Files

Level data would be stored in binary or assembly format:
- `level_1.bin` - First level data
- `level_2.bin` - Second level data
- etc.

## Structure

Level data typically includes:
```
Offset  Size  Description
------  ----  -----------
$00     1     Level width (in screens)
$01     1     Level height (in screens)
$02     N     Tile data (RLE compressed or raw)
...     ...   Enemy spawn table
...     ...   Item spawn table
```

## Notes

- Levels may use run-length encoding (RLE) for compression
- Screen transitions are handled by the main game engine
- Boss levels have special data structures
