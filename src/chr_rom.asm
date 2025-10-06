; Trojan (USA) - CHR ROM Graphics Data
; Character (tile) graphics for sprites and backgrounds

; This file includes the CHR ROM data extracted from the original ROM
; The data is organized into pattern tables as described below

; ============================================================================
; CHR ROM Structure
; ============================================================================
; Pattern Table 0: $0000-$0FFF (4KB) - Typically used for sprites
; Pattern Table 1: $1000-$1FFF (4KB) - Typically used for backgrounds
;
; Each tile is 8x8 pixels, stored as 16 bytes:
; - Bytes 0-7: Low bitplane (bit 0 of each pixel)
; - Bytes 8-15: High bitplane (bit 1 of each pixel)
; - 2 bits per pixel = 4 colors per tile (selected from palette)
;
; Total: 512 tiles (256 per pattern table)
; ============================================================================

.segment "CHARS"

; Include CHR ROM data if it exists
; To extract CHR data from ROM: python3 tools/extract_chr.py trojan_usa.nes
;
; If CHR data file doesn't exist, you can either:
; 1. Extract it from the original ROM using the extract_chr.py tool
; 2. Create custom graphics and save as binary files
; 3. Use .incbin with error handling in your build script

; Check if CHR ROM data file exists and include it
; Uncomment the following line once CHR data is extracted:
; .incbin "data/graphics/trojan_chr.bin"

; Alternatively, you can split CHR ROM into separate pattern tables:
; .incbin "data/graphics/pattern_table_0.bin"  ; Sprites (4KB)
; .incbin "data/graphics/pattern_table_1.bin"  ; Background (4KB)

; For now, fill with zeros to create a valid ROM
; This will be replaced when real CHR data is extracted
.res 8192, $00  ; 8KB of CHR ROM (2 pattern tables)

; ============================================================================
; Pattern Table 0 - Sprite Tiles ($0000-$0FFF)
; ============================================================================
; Tiles $00-$FF (256 tiles)
;
; Expected contents (to be documented after extraction):
; - Player character sprites (standing, walking, jumping, attacking)
; - Enemy sprites (various types and animations)
; - Weapon sprites (sword, shield, projectiles)
; - Item sprites (power-ups, collectibles)
; - Effect sprites (explosions, hit effects)
;
; ============================================================================

; ============================================================================
; Pattern Table 1 - Background Tiles ($1000-$1FFF)
; ============================================================================
; Tiles $00-$FF (256 tiles)
;
; Expected contents (to be documented after extraction):
; - Level tiles (platforms, walls, floors)
; - Decorative elements (columns, statues, scenery)
; - UI elements (HUD borders, health bar graphics)
; - Text characters (numbers, letters for score display)
;
; ============================================================================

; Note: Once CHR ROM is extracted, tile usage will be documented
; in data/graphics/tile_map.txt for reference
