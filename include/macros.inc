; Trojan (USA) - Assembly Macros
; Common macros to simplify repetitive code

; ============================================================================
; PPU Macros
; ============================================================================

; Set PPU address for VRAM access
; Usage: SET_PPU_ADDR $2000
.macro SET_PPU_ADDR addr
    BIT PPUSTATUS       ; Reset PPU address latch
    LDA #>addr          ; High byte
    STA PPUADDR
    LDA #<addr          ; Low byte
    STA PPUADDR
.endmacro

; Write byte to PPU data
; Usage: WRITE_PPU_DATA value
.macro WRITE_PPU_DATA value
    LDA #value
    STA PPUDATA
.endmacro

; ============================================================================
; Wait Macros
; ============================================================================

; Wait for VBlank
.macro WAIT_VBLANK
:   BIT PPUSTATUS
    BPL :-
.endmacro

; ============================================================================
; Controller Macros
; ============================================================================

; Read controller button state
; Result in accumulator
.macro READ_CONTROLLER
    LDA #$01
    STA CONTROLLER1
    LDA #$00
    STA CONTROLLER1
    LDX #$08
:   LDA CONTROLLER1
    LSR A
    ROL controller_state
    DEX
    BNE :-
.endmacro

; ============================================================================
; Memory Macros
; ============================================================================

; Clear a page of memory
; Usage: CLEAR_PAGE $02
.macro CLEAR_PAGE page
    LDA #$00
    TAX
:   STA page<<8,X
    INX
    BNE :-
.endmacro

; Copy bytes from source to destination
; Usage: MEMCPY src, dst, count
.macro MEMCPY src, dst, count
    LDX #$00
:   LDA src,X
    STA dst,X
    INX
    CPX #count
    BNE :-
.endmacro

; ============================================================================
; Sprite Macros
; ============================================================================

; Set sprite position and tile
; Usage: SET_SPRITE index, x_pos, y_pos, tile, attr
.macro SET_SPRITE index, x_pos, y_pos, tile, attr
    LDA #y_pos
    STA SPRITE_BUFFER + (index * 4) + 0
    LDA #tile
    STA SPRITE_BUFFER + (index * 4) + 1
    LDA #attr
    STA SPRITE_BUFFER + (index * 4) + 2
    LDA #x_pos
    STA SPRITE_BUFFER + (index * 4) + 3
.endmacro

; ============================================================================
; Utility Macros
; ============================================================================

; 16-bit addition
; Usage: ADD16 dest_lo, dest_hi, value
.macro ADD16 dest_lo, dest_hi, value
    CLC
    LDA dest_lo
    ADC #<value
    STA dest_lo
    LDA dest_hi
    ADC #>value
    STA dest_hi
.endmacro

; 16-bit subtraction
; Usage: SUB16 dest_lo, dest_hi, value
.macro SUB16 dest_lo, dest_hi, value
    SEC
    LDA dest_lo
    SBC #<value
    STA dest_lo
    LDA dest_hi
    SBC #>value
    STA dest_hi
.endmacro

; Delay loop
; Usage: DELAY_CYCLES count (approximate)
.macro DELAY_CYCLES count
    LDX #count
:   DEX
    BNE :-
.endmacro
