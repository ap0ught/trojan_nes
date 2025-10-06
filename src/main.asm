; Trojan (USA) - Main Game Code
; Disassembled from original NES ROM
; Platform: Nintendo Entertainment System
; Processor: 6502

.include "../include/constants.inc"
.include "../include/macros.inc"

; ============================================================================
; iNES Header
; ============================================================================
.segment "HEADER"
    .byte "NES", $1A    ; iNES header identifier
    .byte $08           ; 8 * 16KB PRG ROM
    .byte $10           ; 16 * 8KB CHR ROM
    .byte $01           ; Mapper 0, horizontal mirroring
    .byte $00           ; Mapper 0 continued
    .byte $00, $00, $00, $00, $00, $00, $00, $00

; ============================================================================
; Zero Page Variables
; ============================================================================
.segment "ZEROPAGE"
    ; System variables
    frame_counter:      .res 1
    game_state:         .res 1
    
    ; Player variables
    player_x:           .res 1
    player_y:           .res 1
    player_direction:   .res 1
    player_state:       .res 1
    player_health:      .res 1
    player_lives:       .res 1
    
    ; Enemy variables
    enemy_active:       .res 8
    enemy_type:         .res 8
    enemy_x:            .res 8
    enemy_y:            .res 8
    enemy_state:        .res 8
    enemy_health:       .res 8

; ============================================================================
; Main Code Segment
; ============================================================================
.segment "CODE"

; ----------------------------------------------------------------------------
; RESET - System initialization
; ----------------------------------------------------------------------------
.proc reset
    SEI                 ; Disable interrupts
    CLD                 ; Clear decimal mode (NES 6502 doesn't support it)
    
    ; Disable APU frame IRQ
    LDX #$40
    STX APU_FRAME_COUNTER
    
    ; Disable PPU
    LDX #$00
    STX PPUCTRL
    STX PPUMASK
    
    ; Wait for first VBlank
:   BIT PPUSTATUS
    BPL :-
    
    ; Initialize stack pointer
    LDX #$FF
    TXS
    
    ; Clear RAM
    LDA #$00
    TAX
:   STA $0000,X
    STA $0100,X
    STA $0200,X
    STA $0300,X
    STA $0400,X
    STA $0500,X
    STA $0600,X
    STA $0700,X
    INX
    BNE :-
    
    ; Wait for second VBlank
:   BIT PPUSTATUS
    BPL :-
    
    ; Initialize game state
    JSR init_game
    
    ; Enable NMI and rendering
    LDA #%10000000
    STA PPUCTRL
    
    ; Enable sprites and background
    LDA #%00011110
    STA PPUMASK
    
    ; Enter main loop
    JMP main_loop
.endproc

; ----------------------------------------------------------------------------
; INIT_GAME - Initialize game variables
; ----------------------------------------------------------------------------
.proc init_game
    ; Set initial game state
    LDA #STATE_TITLE
    STA game_state
    
    ; Initialize player
    LDA #$80
    STA player_x
    LDA #$C0
    STA player_y
    LDA #PLAYER_HEALTH_MAX
    STA player_health
    LDA #PLAYER_LIVES_DEFAULT
    STA player_lives
    
    ; Clear enemies
    LDX #$00
:   LDA #$00
    STA enemy_active,X
    INX
    CPX #$08
    BNE :-
    
    RTS
.endproc

; ----------------------------------------------------------------------------
; MAIN_LOOP - Main game loop
; ----------------------------------------------------------------------------
.proc main_loop
    ; Wait for VBlank flag
:   LDA vblank_flag
    BEQ :-
    LDA #$00
    STA vblank_flag
    
    ; Update game based on current state
    LDA game_state
    CMP #STATE_TITLE
    BEQ update_title
    CMP #STATE_GAMEPLAY
    BEQ update_gameplay
    CMP #STATE_PAUSE
    BEQ update_pause
    CMP #STATE_GAMEOVER
    BEQ update_gameover
    
    JMP main_loop

update_title:
    JSR update_title_screen
    JMP main_loop

update_gameplay:
    JSR update_game_logic
    JMP main_loop

update_pause:
    JSR update_pause_screen
    JMP main_loop

update_gameover:
    JSR update_gameover_screen
    JMP main_loop
.endproc

; ----------------------------------------------------------------------------
; UPDATE_TITLE_SCREEN - Title screen logic
; ----------------------------------------------------------------------------
.proc update_title_screen
    ; Read controller input
    JSR read_controller
    
    ; Check for start button
    LDA controller_state
    AND #BUTTON_START
    BEQ done
    
    ; Transition to gameplay
    LDA #STATE_GAMEPLAY
    STA game_state
    
done:
    RTS
.endproc

; ----------------------------------------------------------------------------
; UPDATE_GAME_LOGIC - Main gameplay logic
; ----------------------------------------------------------------------------
.proc update_game_logic
    ; Read controller input
    JSR read_controller
    
    ; Update player
    JSR update_player
    
    ; Update enemies
    JSR update_enemies
    
    ; Check collisions
    JSR check_collisions
    
    ; Update score and UI
    JSR update_ui
    
    RTS
.endproc

; ----------------------------------------------------------------------------
; UPDATE_PLAYER - Player movement and actions
; ----------------------------------------------------------------------------
.proc update_player
    ; Read controller for movement
    LDA controller_state
    
    ; Check left
    AND #BUTTON_LEFT
    BEQ check_right
    DEC player_x
    LDA #DIRECTION_LEFT
    STA player_direction
    
check_right:
    LDA controller_state
    AND #BUTTON_RIGHT
    BEQ check_jump
    INC player_x
    LDA #DIRECTION_RIGHT
    STA player_direction
    
check_jump:
    LDA controller_state
    AND #BUTTON_A
    BEQ check_attack
    ; Handle jump
    JSR player_jump
    
check_attack:
    LDA controller_state
    AND #BUTTON_B
    BEQ done
    ; Handle attack
    JSR player_attack
    
done:
    RTS
.endproc

; ----------------------------------------------------------------------------
; UPDATE_ENEMIES - Enemy AI and movement
; ----------------------------------------------------------------------------
.proc update_enemies
    LDX #$00
loop:
    ; Check if enemy is active
    LDA enemy_active,X
    BEQ next
    
    ; Update enemy based on type
    LDA enemy_type,X
    ; Enemy AI logic would go here
    
next:
    INX
    CPX #$08
    BNE loop
    
    RTS
.endproc

; ----------------------------------------------------------------------------
; Placeholder subroutines
; ----------------------------------------------------------------------------
.proc update_pause_screen
    RTS
.endproc

.proc update_gameover_screen
    RTS
.endproc

.proc read_controller
    RTS
.endproc

.proc check_collisions
    RTS
.endproc

.proc update_ui
    RTS
.endproc

.proc player_jump
    RTS
.endproc

.proc player_attack
    RTS
.endproc

; ============================================================================
; VBlank flag (updated by NMI)
; ============================================================================
.segment "BSS"
vblank_flag:        .res 1
controller_state:   .res 1
