#!/bin/bash
# ============================================================================
# Samsung SM8250 Kona Kernel Build Script
# ============================================================================
# Device Support: r8q, f2q, z3q, y2q, x1q, c1q, c2q, bloomxq, gts7 series
# Author: Modified for enhanced features & performance
# ============================================================================

set -e

# Color definitions for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║          Samsung SM8250 Kernel Build System                   ║"
    echo "║          Enhanced with Performance Optimizations              ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  ${WHITE}$1${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${NC}\n"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

prompt_choice() {
    local title="$1"
    shift
    local options=("$@")
    
    echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}${title}${NC}"
    echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
    
    local i=1
    for option in "${options[@]}"; do
        echo -e "${CYAN}│${NC}  ${GREEN}${i}.${NC} ${option}"
        ((i++))
    done
    
    echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"
}

# ============================================================================
# Initialize Submodules
# ============================================================================

print_banner

print_section "Initializing Git Submodules"

if [ -f .gitmodules ]; then
    UNINITIALIZED_SUBMODULES=$(git submodule status | grep '^-' || true)
    
    if [ -n "$UNINITIALIZED_SUBMODULES" ]; then
        print_warning "Found uninitialized submodules"
        git submodule update --init --recursive
        if [ $? -eq 0 ]; then
            print_success "Submodules initialized successfully"
        else
            print_error "Failed to initialize submodules"
            exit 1
        fi
    else
        print_success "All submodules are already initialized"
    fi
else
    print_info "No submodules found in this repository"
fi

# ============================================================================
# Device Configuration
# ============================================================================

# Available models
VALID_MODELS=("r8q" "f2q" "z3q" "y2q" "x1q" "c1q" "c2q" "bloomxq" "gts7l" "gts7lwifi" "gts7xl" "gts7xlwifi")

# Models that support EUR region
EUR_MODELS=("r8q" "gts7l" "gts7lwifi" "gts7xl" "gts7xlwifi" "f2q" "bloomxq")

# Available regions
VALID_REGIONS=("eur" "kor" "chn" "usa")

# Input validation function
validate_choice() {
    local choice="$1"
    shift
    local valid_values=("$@")
    
    for value in "${valid_values[@]}"; do
        if [[ "$choice" == "$value" ]]; then
            return 0
        fi
    done
    
    return 1
}

# ============================================================================
# User Input - Device Selection
# ============================================================================

print_section "Device Selection"

prompt_choice "Select your device model:" \
    "r8q (Galaxy S20)" \
    "f2q (Galaxy Z Flip)" \
    "z3q (Galaxy Z Fold2)" \
    "y2q (Galaxy S20+)" \
    "x1q (Galaxy S20 Ultra)" \
    "c1q/c2q (Galaxy Note20)" \
    "bloomxq (Galaxy S20 FE)" \
    "gts7l/xl (Galaxy Tab S7/S7+)"

read -p "$(echo -e ${WHITE}Enter device codename:${NC} )" model_choice
model_choice=$(echo "$model_choice" | tr '[:upper:]' '[:lower:]')

if ! validate_choice "$model_choice" "${VALID_MODELS[@]}"; then
    print_error "Invalid model choice! Exiting."
    exit 1
fi

print_success "Selected device: $model_choice"

# ============================================================================
# User Input - Optional Features
# ============================================================================

print_section "Kernel Features Configuration"

# SELinux permissive option
echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Force SELinux to Permissive?${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}1.${NC} No (Enforcing - Recommended for security)"
echo -e "${CYAN}│${NC}  ${GREEN}2.${NC} Yes (Permissive - For testing/root)"
echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"
read -p "$(echo -e ${WHITE}Your choice [1/2]:${NC} )" selinux_choice

if [[ "$selinux_choice" == "2" || "$selinux_choice" == "yes" ]]; then
    PERMISSIVE=true
    print_warning "SELinux will be set to PERMISSIVE"
else
    PERMISSIVE=false
    print_success "SELinux will remain ENFORCING"
fi

# Performance features option
echo -e "\n${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Enable Performance Optimizations?${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  Includes: Custom governors, I/O schedulers, WireGuard"
echo -e "${CYAN}│${NC}  ExFAT support, TCP BBR, and more"
echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}1.${NC} Yes (Recommended)"
echo -e "${CYAN}│${NC}  ${GREEN}2.${NC} No (Stock features only)"
echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"
read -p "$(echo -e ${WHITE}Your choice [1/2]:${NC} )" perf_choice

if [[ "$perf_choice" == "2" || "$perf_choice" == "no" ]]; then
    PERFORMANCE_FEATURES=false
    print_info "Using stock kernel features"
else
    PERFORMANCE_FEATURES=true
    print_success "Performance features ENABLED"
fi

# ============================================================================
# Build Configuration Summary
# ============================================================================

print_section "Build Configuration Summary"

echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Device Model:${NC}         $model_choice"
echo -e "${CYAN}│${NC} ${WHITE}SELinux Mode:${NC}         $([ "$PERMISSIVE" = true ] && echo "Permissive" || echo "Enforcing")"
echo -e "${CYAN}│${NC} ${WHITE}Performance:${NC}          $([ "$PERFORMANCE_FEATURES" = true ] && echo "Enabled" || echo "Disabled")"
echo -e "${CYAN}│${NC} ${WHITE}Platform:${NC}             Android 11"
echo -e "${CYAN}│${NC} ${WHITE}Chipset:${NC}              Snapdragon 865 (Kona)"
echo -e "${CYAN}│${NC} ${WHITE}Compiler:${NC}             Clang with LLVM"
echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"

sleep 2

# ============================================================================
# Build Environment Setup
# ============================================================================

print_section "Build Environment Setup"

# Build paths
PRODUCT_OUT=out
KERNEL_DIR=$(pwd)
BUILD_ROOT_DIR=$KERNEL_DIR/..
KERNEL_OUT_DIR=$PRODUCT_OUT/obj/KERNEL_OBJ

# Create output directory
if ! [ -d "$KERNEL_OUT_DIR" ]; then
    print_info "Creating output directory: $KERNEL_OUT_DIR"
    mkdir -p "$KERNEL_OUT_DIR" || { print_error "Failed to create KERNEL_OUT_DIR"; exit 1; }
fi

# Target properties
MODEL=$model_choice
CHIPSET_NAME=kona
KERNEL_ARCH=arm64

export PROJECT_NAME="${MODEL}"
[ -z "${PLATFORM_VERSION}" ] && export PLATFORM_VERSION=11

# Kernel configuration files
KERNEL_DEFCONFIG="vendor/${CHIPSET_NAME}-perf_defconfig"
COMMON_DEFCONFIG="vendor/samsung/kona-sec-common.config"
PROJECT_CONFIG="vendor/samsung/${MODEL}.config"

if [ "$PERMISSIVE" = true ]; then
    SLNX_DEFCONFIG="vendor/permissive.config"
fi

if [ "$PERFORMANCE_FEATURES" = true ]; then
    PERFORMANCE_CONFIG="vendor/performance.config"
fi

# Compiler setup
KERNEL_LLVM_BIN=$(which clang)
export CC="clang"
export LLVM=1
export LLVM_IAS=1
export DTC_OVERLAY_TEST_EXT="$KERNEL_DIR/tools/ufdt_apply_overlay"

# CPU core count for parallel build
BUILD_JOB_NUMBER=$(grep -c processor /proc/cpuinfo)

print_success "Build environment configured"
print_info "Using $BUILD_JOB_NUMBER CPU cores for compilation"

# ============================================================================
# Kernel Build Function
# ============================================================================

FUNC_BUILD_KERNEL() {
    local __dts_dir="${KERNEL_OUT_DIR}/arch/${KERNEL_ARCH}/boot/dts"

    print_section "Kernel Compilation Started"
    
    echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}Configuration Details:${NC}"
    echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC}  Base config:     $KERNEL_DEFCONFIG"
    echo -e "${CYAN}│${NC}  Common config:   $COMMON_DEFCONFIG"
    echo -e "${CYAN}│${NC}  Device config:   $PROJECT_CONFIG"
    [ -n "$PERFORMANCE_CONFIG" ] && echo -e "${CYAN}│${NC}  Performance:     $PERFORMANCE_CONFIG"
    [ -n "$SLNX_DEFCONFIG" ] && echo -e "${CYAN}│${NC}  SELinux:         $SLNX_DEFCONFIG"
    echo -e "${CYAN}│${NC}  Output:          $PRODUCT_OUT"
    echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}\n"

    print_info "Generating kernel configuration..."
    make -C "$KERNEL_DIR" O="$KERNEL_OUT_DIR" $KERNEL_MAKE_PARAM ARCH="$KERNEL_ARCH" \
        $KERNEL_DEFCONFIG \
        $COMMON_DEFCONFIG \
        $PROJECT_CONFIG \
        $PERFORMANCE_CONFIG \
        $KSU_DEFCONFIG \
        $SLNX_DEFCONFIG

    print_success "Configuration generated"
    
    print_info "Starting compilation (this may take 30-60 minutes)..."
    make -C "$KERNEL_DIR" O="$KERNEL_OUT_DIR" -j"$BUILD_JOB_NUMBER" $KERNEL_MAKE_PARAM ARCH="$KERNEL_ARCH"

    if [ $? -eq 0 ]; then
        print_success "Kernel compilation completed!"
    else
        print_error "Kernel compilation failed!"
        exit 1
    fi

    print_info "Generating device tree blob (DTB)..."
    cat "$__dts_dir/vendor/qcom"/*.dtb > "$PRODUCT_OUT/dtb.img"
    
    print_info "Cleaning up temporary DTBOs..."
    rm -rf "$__dts_dir/samsung/*"

    print_info "Copying DTBO image..."
    cp "$KERNEL_OUT_DIR/arch/arm64/boot/dtbo.img" "$PRODUCT_OUT"

    print_info "Copying kernel Image..."
    rsync -cv "$KERNEL_OUT_DIR/arch/arm64/boot/Image" "$PRODUCT_OUT/Image"

    echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${WHITE}Build Artifacts Generated:${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════════╣${NC}"
    ls -lh "$PRODUCT_OUT/Image" | awk '{print "'"${GREEN}║${NC}  Image:  " $9 " ("$5")"}'
    ls -lh "$PRODUCT_OUT/dtb.img" | awk '{print "'"${GREEN}║${NC}  DTB:    " $9 " ("$5")"}'
    ls -lh "$PRODUCT_OUT/dtbo.img" | awk '{print "'"${GREEN}║${NC}  DTBO:   " $9 " ("$5")"}'
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}\n"

    print_success "Kernel build completed successfully!"
}

# ============================================================================
# Boot Image Build Function
# ============================================================================

FUNC_BUILD_BOOTIMG() {
    print_section "Boot Image Creation"
    
    BUILD_ENV="$KERNEL_DIR/build_env/WORK_DIR"
    TARGET="$KERNEL_DIR/build_env/$MODEL"
    BOOT_IMG_REPO="https://github.com/ata-kaner/r8q_archive/releases/download/stock_kernel/boot_r8q.img"

    if ! [ -d "$TARGET" ]; then
        mkdir -p "$TARGET" || { print_error "Failed to create target directory"; exit 1; }
    fi

    if ! [ -f "$BUILD_ENV/boot.img" ]; then
        print_info "Downloading stock boot image..."
        curl -L -s -o "$BUILD_ENV/boot.img" "$BOOT_IMG_REPO" || { print_error "Failed to download boot.img"; exit 1; }
        print_success "Boot image downloaded"
    fi

    cd "$BUILD_ENV"

    print_info "Unpacking stock boot image..."
    ./magiskboot-x86 unpack boot.img

    print_info "Injecting custom kernel..."
    cp "$KERNEL_DIR/$PRODUCT_OUT/dtb.img" ./dtb
    rsync -cv "$KERNEL_DIR/$PRODUCT_OUT/Image" ./kernel

    print_info "Repacking boot image..."
    ./magiskboot-x86 repack boot.img "custom_$MODEL.img"

    rsync -cv "./custom_$MODEL.img" "$TARGET/boot.img"
    print_success "Boot image created: $TARGET/boot.img"

    ./magiskboot-x86 cleanup
    rm "./custom_$MODEL.img"

    print_info "Copying DTBO..."
    cp "$KERNEL_DIR/$PRODUCT_OUT/dtbo.img" "$TARGET/dtbo.img"
    
    print_success "Boot image build completed!"
}

# ============================================================================
# Main Build Execution
# ============================================================================

(
    FUNC_BUILD_KERNEL
    FUNC_BUILD_BOOTIMG
)

# ============================================================================
# Build Summary
# ============================================================================

print_section "Build Complete - Summary"

echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${WHITE}✓ Kernel compilation successful${NC}"
echo -e "${GREEN}║${NC}  ${WHITE}✓ Boot image created${NC}"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  ${CYAN}Output directory:${NC} build_env/$MODEL/"
echo -e "${GREEN}║${NC}  ${CYAN}Flashable files:${NC}"
echo -e "${GREEN}║${NC}    • boot.img (flash via Odin/Fastboot)"
echo -e "${GREEN}║${NC}    • dtbo.img (device tree overlay)"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  ${YELLOW}Next steps:${NC}"
echo -e "${GREEN}║${NC}    1. Create AnyKernel3 flashable zip"
echo -e "${GREEN}║${NC}    2. Flash via custom recovery (TWRP/OrangeFox)"
echo -e "${GREEN}║${NC}    3. Or flash boot.img via Odin (AP slot)"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"

print_success "All done! Happy flashing! 🚀"
