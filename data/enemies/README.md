# Enemy Data

This directory contains enemy definitions and behavior data.

## Enemy Types

Trojan features various enemy types including:
1. **Soldiers** - Basic enemies with simple AI
2. **Archers** - Ranged attackers
3. **Swordsmen** - Melee fighters with advanced patterns
4. **Bosses** - End-of-level encounters with unique patterns

## Data Structure

Each enemy type has associated data:
```assembly
; Enemy definition structure
enemy_hp:           .byte $10    ; Health points
enemy_damage:       .byte $02    ; Damage dealt
enemy_speed:        .byte $01    ; Movement speed
enemy_ai_type:      .byte $00    ; AI behavior index
enemy_sprite_base:  .byte $40    ; Base sprite tile
```

## AI Patterns

Enemy AI is typically implemented as state machines:
- Patrol state
- Alert state
- Attack state
- Retreat state
- Death state

## Files

Enemy data files would include:
- `enemy_definitions.asm` - Enemy type definitions
- `enemy_ai.asm` - AI routines
- `enemy_patterns.asm` - Movement and attack patterns
