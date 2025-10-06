#!/usr/bin/env python3
"""
Extract CHR ROM graphics from Trojan (USA) NES ROM
Based on the approach from Donkey Kong NES Disassembly

This script reads the iNES ROM file and extracts the CHR (character) ROM
data, which contains the graphics tiles used by the game.
"""

import sys
import os
import struct

def read_ines_header(rom_data):
    """Parse the iNES header and return ROM information"""
    if len(rom_data) < 16:
        raise ValueError("ROM file too small to contain iNES header")
    
    # Check for "NES" signature
    if rom_data[0:4] != b'NES\x1a':
        raise ValueError("Not a valid iNES ROM file (missing NES signature)")
    
    # Parse header
    prg_rom_size = rom_data[4] * 16 * 1024  # PRG ROM size in 16KB units
    chr_rom_size = rom_data[5] * 8 * 1024   # CHR ROM size in 8KB units
    
    flags6 = rom_data[6]
    flags7 = rom_data[7]
    
    # Mapper number
    mapper = ((flags7 & 0xF0) | (flags6 >> 4))
    
    # Mirroring
    mirroring = "Vertical" if (flags6 & 0x01) else "Horizontal"
    
    # Battery-backed RAM
    has_battery = bool(flags6 & 0x02)
    
    # Trainer (512 bytes before PRG ROM)
    has_trainer = bool(flags6 & 0x04)
    
    return {
        'prg_size': prg_rom_size,
        'chr_size': chr_rom_size,
        'mapper': mapper,
        'mirroring': mirroring,
        'has_battery': has_battery,
        'has_trainer': has_trainer
    }

def extract_chr_rom(input_file, output_file=None):
    """
    Extract CHR ROM from NES ROM file
    
    Args:
        input_file: Path to input NES ROM file
        output_file: Path to output CHR binary file (optional)
    
    Returns:
        Bytes of CHR ROM data
    """
    
    # Read the entire ROM
    try:
        with open(input_file, 'rb') as f:
            rom_data = f.read()
    except FileNotFoundError:
        print(f"Error: ROM file '{input_file}' not found")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading ROM file: {e}")
        sys.exit(1)
    
    # Parse header
    try:
        info = read_ines_header(rom_data)
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
    
    # Display ROM information
    print("=" * 60)
    print("Trojan (USA) NES ROM Information")
    print("=" * 60)
    print(f"PRG ROM Size: {info['prg_size']:,} bytes ({info['prg_size'] // 1024} KB)")
    print(f"CHR ROM Size: {info['chr_size']:,} bytes ({info['chr_size'] // 1024} KB)")
    print(f"Mapper:       {info['mapper']}")
    print(f"Mirroring:    {info['mirroring']}")
    print(f"Battery RAM:  {'Yes' if info['has_battery'] else 'No'}")
    print(f"Trainer:      {'Yes' if info['has_trainer'] else 'No'}")
    print("=" * 60)
    
    # Check if CHR ROM exists
    if info['chr_size'] == 0:
        print("Warning: This ROM uses CHR RAM, not CHR ROM (no graphics to extract)")
        return None
    
    # Calculate offset to CHR ROM
    # iNES header (16 bytes) + optional trainer (512 bytes) + PRG ROM
    chr_offset = 16
    if info['has_trainer']:
        chr_offset += 512
    chr_offset += info['prg_size']
    
    # Extract CHR ROM
    if chr_offset + info['chr_size'] > len(rom_data):
        print("Error: ROM file truncated or invalid")
        sys.exit(1)
    
    chr_data = rom_data[chr_offset:chr_offset + info['chr_size']]
    
    print(f"\nExtracted {len(chr_data):,} bytes of CHR ROM data")
    print(f"CHR ROM offset in file: 0x{chr_offset:04X}")
    
    # Write to output file if specified
    if output_file:
        try:
            with open(output_file, 'wb') as f:
                f.write(chr_data)
            print(f"\nCHR ROM saved to: {output_file}")
            print(f"File size: {len(chr_data):,} bytes")
        except Exception as e:
            print(f"Error writing output file: {e}")
            sys.exit(1)
    
    return chr_data

def analyze_chr_patterns(chr_data):
    """Analyze CHR ROM and display pattern table information"""
    if not chr_data:
        return
    
    total_tiles = len(chr_data) // 16  # Each tile is 16 bytes
    pattern_tables = len(chr_data) // 4096  # Each pattern table is 4KB
    
    print("\n" + "=" * 60)
    print("CHR ROM Analysis")
    print("=" * 60)
    print(f"Total Tiles:      {total_tiles}")
    print(f"Pattern Tables:   {pattern_tables}")
    print(f"Tiles per table:  256")
    print("\nPattern Table Layout:")
    for i in range(pattern_tables):
        start_addr = i * 4096
        end_addr = start_addr + 4095
        print(f"  Pattern Table {i}: $0x{start_addr:04X} - $0x{end_addr:04X}")
    print("=" * 60)

def main():
    """Main entry point"""
    print("Trojan NES CHR ROM Extractor")
    print("-" * 60)
    
    # Get input file from command line or use default
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    else:
        input_file = "trojan_usa.nes"
        print(f"No input file specified, using default: {input_file}")
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"\nError: ROM file '{input_file}' not found")
        print("\nUsage: python3 extract_chr.py [rom_file] [output_file]")
        print("\nExample:")
        print("  python3 extract_chr.py trojan_usa.nes data/graphics/trojan_chr.bin")
        sys.exit(1)
    
    # Get output file from command line or use default
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    else:
        output_file = "data/graphics/trojan_chr.bin"
        print(f"No output file specified, using default: {output_file}")
    
    # Create output directory if it doesn't exist
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"Created directory: {output_dir}")
    
    print()
    
    # Extract CHR ROM
    chr_data = extract_chr_rom(input_file, output_file)
    
    # Analyze the CHR data
    if chr_data:
        analyze_chr_patterns(chr_data)
    
    print("\nExtraction complete!")

if __name__ == "__main__":
    main()
