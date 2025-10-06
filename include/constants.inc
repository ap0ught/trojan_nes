; Trojan (USA) - Constants and Definitions
; Common constants used throughout the codebase

; ============================================================================
; PPU Registers
; ============================================================================
PPUCTRL     = $2000
PPUMASK     = $2001
PPUSTATUS   = $2002
OAMADDR     = $2003
OAMDATA     = $2004
PPUSCROLL   = $2005
PPUADDR     = $2006
PPUDATA     = $2007
OAMDMA      = $4014

; ============================================================================
; APU Registers
; ============================================================================
APU_PULSE1_CTRL     = $4000
APU_PULSE1_SWEEP    = $4001
APU_PULSE1_TIMER_LO = $4002
APU_PULSE1_TIMER_HI = $4003
APU_PULSE2_CTRL     = $4004
APU_PULSE2_SWEEP    = $4005
APU_PULSE2_TIMER_LO = $4006
APU_PULSE2_TIMER_HI = $4007
APU_TRIANGLE_CTRL   = $4008
APU_TRIANGLE_TIMER_LO = $400A
APU_TRIANGLE_TIMER_HI = $400B
APU_NOISE_CTRL      = $400C
APU_NOISE_PERIOD    = $400E
APU_NOISE_LENGTH    = $400F
APU_DMC_CTRL        = $4010
APU_DMC_LOAD        = $4011
APU_DMC_ADDR        = $4012
APU_DMC_LENGTH      = $4013
APU_STATUS          = $4015
APU_FRAME_COUNTER   = $4017

; ============================================================================
; Controller Registers
; ============================================================================
CONTROLLER1 = $4016
CONTROLLER2 = $4017

; ============================================================================
; Controller Button Masks
; ============================================================================
BUTTON_A        = %10000000
BUTTON_B        = %01000000
BUTTON_SELECT   = %00100000
BUTTON_START    = %00010000
BUTTON_UP       = %00001000
BUTTON_DOWN     = %00000100
BUTTON_LEFT     = %00000010
BUTTON_RIGHT    = %00000001

; ============================================================================
; Game States
; ============================================================================
STATE_TITLE     = $00
STATE_GAMEPLAY  = $01
STATE_PAUSE     = $02
STATE_GAMEOVER  = $03

; ============================================================================
; Player Constants
; ============================================================================
PLAYER_HEALTH_MAX       = $10
PLAYER_LIVES_DEFAULT    = $03
DIRECTION_LEFT          = $00
DIRECTION_RIGHT         = $01

; ============================================================================
; Screen Constants
; ============================================================================
SCREEN_WIDTH    = 256
SCREEN_HEIGHT   = 240
SPRITE_SIZE     = 8

; ============================================================================
; Enemy Types
; ============================================================================
ENEMY_TYPE_SOLDIER      = $00
ENEMY_TYPE_ARCHER       = $01
ENEMY_TYPE_SWORDSMAN    = $02
ENEMY_TYPE_BOSS         = $FF

; ============================================================================
; Memory Locations
; ============================================================================
SPRITE_BUFFER   = $0200     ; OAM sprite buffer
STACK_PAGE      = $0100     ; Stack page

; ============================================================================
; External References
; ============================================================================
.globalzp frame_counter, game_state
.globalzp player_x, player_y, player_direction, player_state
.globalzp player_health, player_lives
.globalzp enemy_active, enemy_type, enemy_x, enemy_y
.globalzp enemy_state, enemy_health

.global vblank_flag, controller_state
.global reset, nmi_handler, irq_handler
.global init_game, main_loop
.global update_title_screen, update_game_logic
.global update_pause_screen, update_gameover_screen
.global update_player, update_enemies
.global read_controller, check_collisions, update_ui
.global player_jump, player_attack
