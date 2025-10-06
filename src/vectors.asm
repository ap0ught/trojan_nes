; Trojan (USA) - Interrupt Vectors
; NES interrupt handlers

.include "../include/constants.inc"

; ============================================================================
; NMI Handler - Called every VBlank (~60 times per second)
; ============================================================================
.segment "CODE"
.proc nmi_handler
    ; Save registers
    PHA
    TXA
    PHA
    TYA
    PHA
    
    ; Set VBlank flag
    LDA #$01
    STA vblank_flag
    
    ; Update sprites (OAM DMA)
    LDA #$00
    STA OAMADDR
    LDA #$02        ; High byte of $0200 (sprite buffer)
    STA OAMDMA
    
    ; Update scroll position
    LDA #$00
    STA PPUSCROLL
    STA PPUSCROLL
    
    ; Restore registers
    PLA
    TAY
    PLA
    TAX
    PLA
    
    RTI
.endproc

; ============================================================================
; IRQ Handler - Hardware interrupt (rarely used on NES)
; ============================================================================
.proc irq_handler
    RTI
.endproc

; ============================================================================
; Interrupt Vectors
; ============================================================================
.segment "VECTORS"
    .word nmi_handler   ; $FFFA-$FFFB: NMI vector
    .word reset         ; $FFFC-$FFFD: Reset vector
    .word irq_handler   ; $FFFE-$FFFF: IRQ vector
