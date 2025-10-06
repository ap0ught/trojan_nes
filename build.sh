#!/bin/bash
# Build script for Trojan NES Disassembly Project
# This script automates the build process and provides helpful feedback

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="trojan"
SRC_DIR="src"
INC_DIR="include"
BUILD_DIR="build"
ROM_OUTPUT="${BUILD_DIR}/${PROJECT_NAME}.nes"

# Print functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Trojan NES Build Script${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if cc65 is installed
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command -v ca65 &> /dev/null; then
        print_error "ca65 (cc65 assembler) not found!"
        echo ""
        echo "Please install cc65 toolchain:"
        echo "  Ubuntu/Debian: sudo apt-get install cc65"
        echo "  macOS: brew install cc65"
        echo "  Or build from source: https://github.com/cc65/cc65"
        exit 1
    fi
    
    if ! command -v ld65 &> /dev/null; then
        print_error "ld65 (cc65 linker) not found!"
        exit 1
    fi
    
    print_success "All dependencies found"
}

# Create build directory
setup_build_dir() {
    print_info "Setting up build directory..."
    
    if [ ! -d "${BUILD_DIR}" ]; then
        mkdir -p "${BUILD_DIR}"
        print_success "Created ${BUILD_DIR} directory"
    else
        print_success "Build directory exists"
    fi
}

# Clean build artifacts
clean_build() {
    print_info "Cleaning build artifacts..."
    
    if [ -d "${BUILD_DIR}" ]; then
        rm -rf "${BUILD_DIR}"
        print_success "Build artifacts cleaned"
    else
        print_warning "No build artifacts to clean"
    fi
}

# Assemble source files
assemble_sources() {
    print_info "Assembling source files..."
    
    # Assemble main.asm
    if [ -f "${SRC_DIR}/main.asm" ]; then
        print_info "  Assembling main.asm..."
        ca65 -I ${INC_DIR} -o ${BUILD_DIR}/main.o -l ${BUILD_DIR}/main.lst ${SRC_DIR}/main.asm
        print_success "  main.o created"
    else
        print_error "Source file not found: ${SRC_DIR}/main.asm"
        exit 1
    fi
    
    # Assemble vectors.asm
    if [ -f "${SRC_DIR}/vectors.asm" ]; then
        print_info "  Assembling vectors.asm..."
        ca65 -I ${INC_DIR} -o ${BUILD_DIR}/vectors.o -l ${BUILD_DIR}/vectors.lst ${SRC_DIR}/vectors.asm
        print_success "  vectors.o created"
    else
        print_error "Source file not found: ${SRC_DIR}/vectors.asm"
        exit 1
    fi
}

# Link object files
link_rom() {
    print_info "Linking ROM..."
    
    if [ ! -f "nes.cfg" ]; then
        print_error "Linker configuration not found: nes.cfg"
        exit 1
    fi
    
    ld65 -C nes.cfg -o ${ROM_OUTPUT} -m ${BUILD_DIR}/${PROJECT_NAME}.map ${BUILD_DIR}/main.o ${BUILD_DIR}/vectors.o
    
    if [ -f "${ROM_OUTPUT}" ]; then
        print_success "ROM created: ${ROM_OUTPUT}"
        
        # Show ROM size
        ROM_SIZE=$(stat -f%z "${ROM_OUTPUT}" 2>/dev/null || stat -c%s "${ROM_OUTPUT}" 2>/dev/null)
        print_info "ROM size: ${ROM_SIZE} bytes"
    else
        print_error "Failed to create ROM"
        exit 1
    fi
}

# Verify ROM against original (if available)
verify_rom() {
    print_info "Verifying ROM..."
    
    if [ -f "trojan_usa.nes" ]; then
        print_info "Original ROM found, comparing checksums..."
        echo ""
        echo "Built ROM:"
        md5sum ${ROM_OUTPUT}
        echo "Original ROM:"
        md5sum trojan_usa.nes
        echo ""
        
        BUILT_MD5=$(md5sum ${ROM_OUTPUT} | awk '{print $1}')
        ORIG_MD5=$(md5sum trojan_usa.nes | awk '{print $1}')
        
        if [ "${BUILT_MD5}" = "${ORIG_MD5}" ]; then
            print_success "ROM matches original! Perfect disassembly."
        else
            print_warning "ROM does not match original (expected for template)"
        fi
    else
        print_warning "Original ROM not found (trojan_usa.nes)"
        print_info "Place original ROM in root directory to verify build"
    fi
}

# Display build summary
show_summary() {
    echo ""
    print_header
    print_success "Build completed successfully!"
    echo ""
    print_info "Output files:"
    echo "  ROM:     ${ROM_OUTPUT}"
    echo "  Map:     ${BUILD_DIR}/${PROJECT_NAME}.map"
    echo "  Listings: ${BUILD_DIR}/*.lst"
    echo ""
    print_info "Next steps:"
    echo "  • Test ROM: fceux ${ROM_OUTPUT}"
    echo "  • View map: cat ${BUILD_DIR}/${PROJECT_NAME}.map"
    echo "  • Clean build: ./build.sh clean"
    print_header
}

# Show usage
show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  build     Build the ROM (default)"
    echo "  clean     Remove build artifacts"
    echo "  rebuild   Clean and build"
    echo "  verify    Build and verify against original ROM"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Build the ROM"
    echo "  $0 clean        # Clean build artifacts"
    echo "  $0 rebuild      # Clean and rebuild"
    echo "  $0 verify       # Build and verify"
}

# Main build function
build_rom() {
    print_header
    check_dependencies
    setup_build_dir
    assemble_sources
    link_rom
    show_summary
}

# Parse command line arguments
case "${1:-build}" in
    build)
        build_rom
        ;;
    clean)
        print_header
        clean_build
        print_success "Clean completed"
        ;;
    rebuild)
        print_header
        clean_build
        echo ""
        build_rom
        ;;
    verify)
        build_rom
        verify_rom
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac

exit 0
