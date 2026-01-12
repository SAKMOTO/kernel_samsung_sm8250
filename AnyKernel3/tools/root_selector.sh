#!/system/bin/sh
# AnyKernel3 Root Selection Helper
# This script is called by recovery to get user's root preference

# Create temp directory
mkdir -p /tmp/anykernel

# Show menu
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║       SM8250 Enhanced Kernel - Root Selection             ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Select your preferred root solution:"
echo ""
echo "  [1] KernelSU (RKernelSU) - Recommended"
echo "  [2] WildKernelSU - Experimental"  
echo "  [3] KSU Next Gen - Development"
echo "  [4] Magisk Compatible - Traditional"
echo "  [5] No Root - Stock kernel"
echo ""
echo -n "Enter choice [1-5]: "

# Read user input (this varies by recovery)
read ROOT_CHOICE

# Validate input
case $ROOT_CHOICE in
  1|2|3|4|5)
    echo "$ROOT_CHOICE" > /tmp/anykernel/root_choice.prop
    echo ""
    echo "✓ Selection saved: Option $ROOT_CHOICE"
    ;;
  *)
    echo "1" > /tmp/anykernel/root_choice.prop
    echo ""
    echo "⚠ Invalid input, defaulting to Option 1 (KernelSU)"
    ;;
esac

echo ""
echo "Press Enter to continue with installation..."
read dummy
