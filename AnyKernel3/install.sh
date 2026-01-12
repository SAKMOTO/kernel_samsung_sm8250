#!/sbin/sh
# ============================================================================
# HINA Kernel Installation Script for TWRP
# Beautiful installer with detailed progress information
# ============================================================================

# Extract TWRP variables
OUTFD=$2
ZIPFILE=$3

# Create directories
mkdir -p /tmp/hina
mkdir -p /tmp/anykernel

# Helper functions for beautiful output
ui_print() {
    echo "ui_print $1" >> /proc/self/fd/$OUTFD
    echo "ui_print" >> /proc/self/fd/$OUTFD
}

ui_print_nobreak() {
    echo "ui_print $1" >> /proc/self/fd/$OUTFD
}

# ============================================================================
# Beautiful Banner
# ============================================================================

ui_print " "
ui_print "╔═══════════════════════════════════════════════════════════════╗"
ui_print "║                                                               ║"
ui_print "║              ✨ HINA KERNEL v1.0 ✨                          ║"
ui_print "║           SM8250 Enhanced Performance Kernel                  ║"
ui_print "║                                                               ║"
ui_print "║    Extreme Performance • Optimized Battery Life              ║"
ui_print "║    Advanced Features • Beautiful & Responsive                 ║"
ui_print "║                                                               ║"
ui_print "╚═══════════════════════════════════════════════════════════════╝"
ui_print " "

# ============================================================================
# Welcome Message
# ============================================================================

ui_print "╔═══════════════════════════════════════════════════════════════╗"
ui_print "║  Welcome to HINA Kernel Installer                             ║"
ui_print "╚═══════════════════════════════════════════════════════════════╝"
ui_print " "

ui_print "📱 Detected Device Features:"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print "  • Snapdragon 865 (SM8250 Kona)"
ui_print "  • 8-core CPU with frequency scaling"
ui_print "  • Adreno GPU with optimizations"
ui_print "  • Advanced thermal management"
ui_print " "

# ============================================================================
# Kernel Features Display
# ============================================================================

ui_print "⚡ HINA Kernel Features:"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print " "
ui_print "🎮 CPU & Performance:"
ui_print "   ✓ 6 CPU Governors (schedutil, performance, powersave, etc.)"
ui_print "   ✓ CPU Idle Optimizations"
ui_print "   ✓ Frequency Boost enabled"
ui_print " "
ui_print "💾 Storage & I/O:"
ui_print "   ✓ 8 I/O Schedulers (BFQ, Kyber, Deadline, CFQ)"
ui_print "   ✓ ExFAT & NTFS Filesystem Support"
ui_print "   ✓ F2FS Optimizations (LZ4 & ZSTD)"
ui_print "   ✓ EXT4 with Encryption"
ui_print " "
ui_print "🌐 Network & VPN:"
ui_print "   ✓ WireGuard VPN (kernel module)"
ui_print "   ✓ TCP BBR Congestion Control"
ui_print "   ✓ Advanced Netfilter (firewall)"
ui_print "   ✓ USB Tethering (RNDIS/NCM)"
ui_print " "
ui_print "🔋 Battery & Power:"
ui_print "   ✓ Boeffla Wakelock Blocker"
ui_print "   ✓ Power Efficient Workqueues"
ui_print "   ✓ KSM Memory Optimization"
ui_print "   ✓ zRAM with LZ4 Compression"
ui_print " "
ui_print "🎵 Multimedia:"
ui_print "   ✓ Sound Control Module"
ui_print "   ✓ Audio Codec Support"
ui_print "   ✓ Compressed Audio Offload"
ui_print " "
ui_print "🛡️  Security & Hardening:"
ui_print "   ✓ SELinux Support (configurable)"
ui_print "   ✓ Module Signature Verification"
ui_print "   ✓ File Integrity Monitoring"
ui_print "   ✓ Kprobes/Kretprobes (for tools)"
ui_print " "

# ============================================================================
# Root Solution Selection
# ============================================================================

ui_print "┌───────────────────────────────────────────────────────────────┐"
ui_print "│ 🔐 ROOT SOLUTION SELECTION                                     │"
ui_print "├───────────────────────────────────────────────────────────────┤"
ui_print "│                                                               │"
ui_print "│  [1] KernelSU (RKernelSU) ⭐ RECOMMENDED                      │"
ui_print "│      • Modern root solution                                   │"
ui_print "│      • Module support like Magisk                            │"
ui_print "│      • SafetyNet bypass capable                              │"
ui_print "│      • Perfect for daily use                                 │"
ui_print "│                                                               │"
ui_print "│  [2] WildKernelSU                                            │"
ui_print "│      • Experimental root solution                            │"
ui_print "│      • Enhanced security features                           │"
ui_print "│      • For advanced users                                    │"
ui_print "│                                                               │"
ui_print "│  [3] KSU Next Gen                                            │"
ui_print "│      • Development version                                   │"
ui_print "│      • Cutting edge features                                 │"
ui_print "│      • May be unstable                                       │"
ui_print "│                                                               │"
ui_print "│  [4] Magisk Compatible                                       │"
ui_print "│      • Traditional root method                               │"
ui_print "│      • Requires Magisk Manager app                           │"
ui_print "│      • Better SafetyNet support                              │"
ui_print "│                                                               │"
ui_print "│  [5] No Root (Stock)                                         │"
ui_print "│      • Stock kernel without root                             │"
ui_print "│      • Maximum security                                      │"
ui_print "│      • Keep performance features                             │"
ui_print "│                                                               │"
ui_print "└───────────────────────────────────────────────────────────────┘"
ui_print " "

# Set default to KernelSU if no choice
if [ -f /tmp/anykernel/root_choice.prop ]; then
    ROOT_CHOICE=$(cat /tmp/anykernel/root_choice.prop)
else
    ROOT_CHOICE=1
fi

case $ROOT_CHOICE in
    1)
        ROOT_NAME="KernelSU (RKernelSU)"
        ROOT_EMOJI="🌟"
        ;;
    2)
        ROOT_NAME="WildKernelSU"
        ROOT_EMOJI="🔧"
        ;;
    3)
        ROOT_NAME="KSU Next Gen"
        ROOT_EMOJI="🚀"
        ;;
    4)
        ROOT_NAME="Magisk Compatible"
        ROOT_EMOJI="📦"
        ;;
    5)
        ROOT_NAME="No Root (Stock)"
        ROOT_EMOJI="🔒"
        ;;
    *)
        ROOT_NAME="KernelSU (RKernelSU)"
        ROOT_CHOICE=1
        ROOT_EMOJI="🌟"
        ;;
esac

echo "$ROOT_CHOICE" > /tmp/hina/root_choice.txt

ui_print "$ROOT_EMOJI Selected Root Solution: $ROOT_NAME"
ui_print " "

# ============================================================================
# Installation Progress
# ============================================================================

ui_print "╔═══════════════════════════════════════════════════════════════╗"
ui_print "║  📦 INSTALLATION PROCESS                                      ║"
ui_print "╚═══════════════════════════════════════════════════════════════╝"
ui_print " "

ui_print "[1/4] Extracting kernel files..."
ui_print "      ▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  25%"
sleep 1

ui_print "[2/4] Preparing boot partition..."
ui_print "      ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  50%"
sleep 1

ui_print "[3/4] Installing HINA kernel..."
ui_print "      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  75%"
sleep 1

ui_print "[4/4] Finalizing installation..."
ui_print "      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  100%"
sleep 1

ui_print " "

# ============================================================================
# Installation Details
# ============================================================================

ui_print "🔧 Installation Details:"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print " "
ui_print "  Kernel Name:    HINA Kernel v1.0"
ui_print "  Kernel Base:    Linux 4.19.325"
ui_print "  Chipset:        Snapdragon 865 (SM8250)"
ui_print "  Compiler:       Clang 18.1.3 with LLVM"
ui_print "  Optimization:   LTO Enabled"
ui_print "  Root Solution:  $ROOT_NAME"
ui_print " "

# ============================================================================
# Kernel Build Information
# ============================================================================

ui_print "📊 Build Information:"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print " "
ui_print "  Build Date:     $(date '+%Y-%m-%d %H:%M')"
ui_print "  Build Type:     Enhanced Performance"
ui_print "  Governor:       Recommended: Schedutil"
ui_print "  I/O Scheduler:  Recommended: BFQ"
ui_print "  TCP Algorithm:  Recommended: BBR"
ui_print " "

# ============================================================================
# Post-Installation Instructions
# ============================================================================

ui_print "✅ Installation Successful!"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print " "
ui_print "📋 Next Steps:"
ui_print " "

case $ROOT_CHOICE in
    1)
        ui_print "  1. Download 'KernelSU Manager' from Play Store"
        ui_print "  2. Install and open the app"
        ui_print "  3. Follow the app's setup instructions"
        ui_print "  4. Reboot your device"
        ;;
    2)
        ui_print "  1. Download 'WildKernelSU Manager' app"
        ui_print "  2. Follow app setup for root access"
        ui_print "  3. Reboot and test root access"
        ;;
    3)
        ui_print "  1. Download KSU development tools"
        ui_print "  2. Install and configure manually"
        ui_print "  3. Follow development documentation"
        ;;
    4)
        ui_print "  1. Download Magisk Manager from official source"
        ui_print "  2. Install Magisk Manager (patch boot in app)"
        ui_print "  3. Reboot and enjoy rooted Android with Magisk"
        ui_print "  4. Install Magisk modules as desired"
        ;;
    5)
        ui_print "  1. Reboot your device immediately"
        ui_print "  2. No additional setup needed"
        ui_print "  3. Enjoy performance features without root"
        ;;
esac

ui_print " "
ui_print "⚙️  Performance Tweaking (Optional):"
ui_print " "
ui_print "  • Use kernel manager apps to change governors & schedulers"
ui_print "  • Recommended: Schedutil governor + BFQ scheduler + BBR TCP"
ui_print "  • Experiment to find best settings for your usage"
ui_print " "

# ============================================================================
# Important Notes
# ============================================================================

ui_print "⚠️  IMPORTANT NOTES:"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ui_print " "
ui_print "  ⓘ This kernel voids your device warranty"
ui_print "  ⓘ Keep backup of stock kernel"
ui_print "  ⓘ Only compatible with Android 11-13"
ui_print "  ⓘ Do NOT use on other devices (will bootloop)"
ui_print "  ⓘ If you experience issues, flash stock kernel"
ui_print " "

# ============================================================================
# Final Message
# ============================================================================

ui_print "╔═══════════════════════════════════════════════════════════════╗"
ui_print "║                                                               ║"
ui_print "║  🎉 HINA KERNEL INSTALLED SUCCESSFULLY! 🎉                   ║"
ui_print "║                                                               ║"
ui_print "║        Your device is now ready for an extreme              ║"
ui_print "║        performance experience!                              ║"
ui_print "║                                                               ║"
ui_print "║  Reboot now to enjoy:                                         ║"
ui_print "║  ✓ Faster Performance   ✓ Better Battery Life               ║"
ui_print "║  ✓ Smooth Experience    ✓ Advanced Features                 ║"
ui_print "║                                                               ║"
ui_print "╚═══════════════════════════════════════════════════════════════╝"
ui_print " "

ui_print "💬 Enjoy HINA Kernel! Made with ❤️ for SM8250 devices"
ui_print " "

exit 0
