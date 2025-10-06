# Instructions for Setting Up Trojan NES Disassembly

This guide will help you obtain the ROM, disassemble it, and build the project.

## Step 1: Obtain the ROM

You must legally obtain the "Trojan (USA)" NES ROM file. This can be done by:

1. **Dumping your own cartridge** (recommended for legal compliance)
   - Use a cartridge dumper device
   - Follow dumper instructions to extract ROM

2. **From legal sources**
   - The ROM is available from various legal ROM distribution sites
   - Original source URL (if accessible): https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%20Entertainment%20System%20%28Headered%29/Trojan%20%28USA%29.zip

### Expected ROM Information

```
Name:     Trojan (USA).nes
Format:   iNES (headered)
Size:     524,304 bytes (512KB)
PRG ROM:  8 x 16KB banks = 128KB
CHR ROM:  16 x 8KB banks = 128KB
Mapper:   Depends on exact cart (likely 0 or 1)
```

## Step 2: Install Required Tools

### Install cc65 Toolchain

#### On Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install cc65
```

#### On macOS:
```bash
brew install cc65
```

#### On Windows:
Download from: https://github.com/cc65/cc65/releases

Or build from source:
```bash
git clone https://github.com/cc65/cc65.git
cd cc65
make
sudo make install  # Linux/Mac
```

### Install Optional Tools

#### NES Emulator for Testing:
```bash
# FCEUX (recommended)
sudo apt-get install fceux

# Or Mesen (more accurate)
# Download from: https://www.mesen.ca/
```

#### Graphics Tools:
- **YY-CHR**: For viewing/editing CHR ROM graphics
- **Tile Molester**: Generic tile editor
- Download from: https://www.romhacking.net/

## Step 3: Initial Disassembly (First Time Setup)

If starting from scratch with the original ROM:

### 3.1 Place ROM File
```bash
cp "Trojan (USA).nes" /path/to/trojan_nes/trojan_usa.nes
```

### 3.2 Analyze ROM Header
```bash
hexdump -C trojan_usa.nes | head -n 2
```

Expected header:
```
00000000  4e 45 53 1a 08 10 01 00  00 00 00 00 00 00 00 00  |NES.............|
```

Breakdown:
- `4e 45 53 1a` = "NES" + EOF (iNES identifier)
- `08` = 8 * 16KB PRG ROM banks
- `10` = 16 * 8KB CHR ROM banks
- `01` = Mapper and mirroring flags

### 3.3 Split ROM Components

Extract PRG and CHR ROM for separate disassembly:

```bash
# Skip 16-byte header, extract PRG ROM (128KB)
dd if=trojan_usa.nes of=prg_rom.bin bs=16 skip=1 count=8192

# Extract CHR ROM (128KB)
dd if=trojan_usa.nes of=chr_rom.bin bs=16 skip=8193 count=8192
```

### 3.4 Disassemble PRG ROM

Using da65 from cc65:

```bash
# Create info file for better disassembly
cat > trojan.info << 'EOF'
RANGE { START $8000; END $FFFF; TYPE Code; }
LABEL { ADDR $FFFA; NAME "NMI_Vector"; }
LABEL { ADDR $FFFC; NAME "Reset_Vector"; }
LABEL { ADDR $FFFE; NAME "IRQ_Vector"; }
EOF

# Run disassembler
da65 --cpu 6502 prg_rom.bin -o src/trojan_disasm.asm --info trojan.info
```

### 3.5 Analyze and Organize

The raw disassembly needs organization:
1. Identify code vs data sections
2. Label subroutines
3. Add comments
4. Separate into logical files (main code, data tables, etc.)

This is a manual, iterative process that can take considerable time.

## Step 4: Build the Project

Once the source files are organized:

### 4.1 Build ROM
```bash
make
```

Or manually:
```bash
ca65 src/main.asm -o build/main.o -I include
ca65 src/vectors.asm -o build/vectors.o -I include
ld65 -C nes.cfg build/main.o build/vectors.o -o build/trojan.nes
```

### 4.2 Verify Build
```bash
# Compare checksums
md5sum build/trojan.nes trojan_usa.nes

# If they match, disassembly is perfect!
```

## Step 5: Test the ROM

```bash
# Run with FCEUX
fceux build/trojan.nes

# Or with Mesen
mesen build/trojan.nes
```

## Troubleshooting

### Build Errors

**Error: ca65: Command not found**
- Solution: Install cc65 toolchain (see Step 2)

**Error: Undefined symbol**
- Solution: Check that all symbols are properly declared with `.global` or `.globalzp`

**Error: Segment overflow**
- Solution: Check nes.cfg memory regions match your ROM size

### ROM Doesn't Work

**Black screen or crash**
- Verify iNES header is correct
- Check that reset vector points to valid code
- Ensure NMI handler is properly implemented

**Graphics glitches**
- CHR ROM may not be correctly extracted
- Verify CHR ROM segment in linker config

**Wrong behavior**
- Compare with original ROM byte-by-byte
- Use emulator debugger to trace execution
- Check that all data tables are correctly included

## Advanced: Working with Mappers

If Trojan uses a mapper (e.g., MMC1, MMC3):

1. Identify mapper from ROM header
2. Understand bank switching mechanism
3. Disassemble each bank separately
4. Implement bank switching in reassembly

Example for MMC1:
```assembly
; Select PRG ROM bank
LDA #$00        ; Bank number
STA $8000       ; Write to mapper register
```

## Resources

### Learning 6502 Assembly
- [Easy 6502](https://skilldrick.github.io/easy6502/)
- [6502 Opcodes](http://www.6502.org/tutorials/6502opcodes.html)

### NES Development
- [NES Dev Wiki](https://www.nesdev.org/wiki/)
- [NES Dev Forums](https://forums.nesdev.org/)

### ROM Hacking
- [ROM Hacking.net](https://www.romhacking.net/)
- [Data Crystal](https://datacrystal.romhacking.net/)

## Legal Considerations

**Important**: You must own a legal copy of the original Trojan NES game to use this disassembly project. This project is for educational and preservation purposes only.

- The game "Trojan" is property of Capcom
- Do not distribute ROMs or ROM hacks commercially
- Respect intellectual property rights

## Next Steps

Once you have a working disassembly:

1. Review the [TODO.md](TODO.md) for features to implement
2. Read [README.dev.md](README.dev.md) for development guidelines
3. Start documenting code sections
4. Implement planned features
5. Share your findings with the community

Happy hacking! 🎮
