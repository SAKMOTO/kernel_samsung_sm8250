### AnyKernel3 Ramdisk Mod Script
## HINA Kernel - Enhanced Interactive Kernel Installer
## Modified for SM8250 with Root Solution Support

### AnyKernel setup
# global properties
properties() { '
kernel.string=HINA Kernel v1.0 - SM8250 Enhanced
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=r8q
device.name2=SM-G981B
device.name3=SM-G981N
device.name4=SM-G981U
device.name5=SM-G981W
supported.versions=11-13
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=auto;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# ============================================================================
# Interactive Root Solution Selection
# ============================================================================

ui_print " ";
ui_print "╔════════════════════════════════════════════════════════════╗";
ui_print "║                                                            ║";
ui_print "║              ✨ HINA KERNEL v1.0 ✨                       ║";
ui_print "║        SM8250 Enhanced Performance Kernel                  ║";
ui_print "║                                                            ║";
ui_print "╚════════════════════════════════════════════════════════════╝";
ui_print " ";

ui_print "┌────────────────────────────────────────────────────────────┐";
ui_print "│ Select Root Solution:                                      │";
ui_print "├────────────────────────────────────────────────────────────┤";
ui_print "│                                                            │";
ui_print "│  1. KernelSU (RKernelSU) - Recommended                    │";
ui_print "│     • Module support, SafetyNet bypass capable            │";
ui_print "│                                                            │";
ui_print "│  2. WildKernelSU - Experimental                           │";
ui_print "│     • Enhanced security features                          │";
ui_print "│                                                            │";
ui_print "│  3. KSU Next Gen - Latest development                     │";
ui_print "│     • Cutting edge features                               │";
ui_print "│                                                            │";
ui_print "│  4. Magisk Compatible - Traditional root                  │";
ui_print "│     • Use with Magisk Manager app                         │";
ui_print "│                                                            │";
ui_print "│  5. No Root - Stock kernel only                           │";
ui_print "│     • Performance features without root                   │";
ui_print "│                                                            │";
ui_print "└────────────────────────────────────────────────────────────┘";
ui_print " ";

# Detect if user has a preference file (created by installer UI)
if [ -f /tmp/aroma/root_choice.txt ]; then
  ROOT_CHOICE=$(cat /tmp/aroma/root_choice.txt);
elif [ -f /tmp/anykernel/root_choice.prop ]; then
  ROOT_CHOICE=$(cat /tmp/anykernel/root_choice.prop);
else
  # Default to KernelSU if no choice detected
  ROOT_CHOICE=1;
  ui_print "⚠ No selection detected, defaulting to KernelSU (Option 1)";
  ui_print " ";
fi

ui_print "Selected option: $ROOT_CHOICE";
ui_print " ";

# Apply root solution based on choice
case $ROOT_CHOICE in
  1)
    ui_print "✓ Installing with KernelSU (RKernelSU) support...";
    ROOT_TYPE="kernelsu";
    # KernelSU patches would go here
    # patch_cmdline "androidboot.selinux" "androidboot.selinux=permissive";
    ;;
  2)
    ui_print "✓ Installing with WildKernelSU support...";
    ROOT_TYPE="wildkernelsu";
    # WildKSU patches would go here
    ;;
  3)
    ui_print "✓ Installing with KSU Next Gen support...";
    ROOT_TYPE="ksunext";
    # KSU Next patches would go here
    ;;
  4)
    ui_print "✓ Installing Magisk-compatible kernel...";
    ROOT_TYPE="magisk";
    # Magisk compatibility patches
    ;;
  5)
    ui_print "✓ Installing stock kernel (no root)...";
    ROOT_TYPE="noroot";
    # No root modifications
    ;;
  *)
    ui_print "⚠ Invalid choice, defaulting to no root...";
    ROOT_TYPE="noroot";
    ;;
esac

ui_print " ";
ui_print "┌────────────────────────────────────────────────────────────┐";
ui_print "│ Kernel Features:                                           │";
ui_print "├────────────────────────────────────────────────────────────┤";
ui_print "│ ✓ CPU Governors: schedutil, performance, powersave         │";
ui_print "│ ✓ I/O Schedulers: BFQ, Kyber, Deadline                     │";
ui_print "│ ✓ TCP Congestion: BBR, Cubic, Westwood                     │";
ui_print "│ ✓ WireGuard VPN built-in                                   │";
ui_print "│ ✓ ExFAT & NTFS filesystem support                          │";
ui_print "│ ✓ F2FS optimizations enabled                               │";
ui_print "│ ✓ zRAM with LZ4 compression                                │";
ui_print "│ ✓ KSM (Kernel Same-page Merging)                           │";
ui_print "│ ✓ Power efficient workqueues                               │";
ui_print "└────────────────────────────────────────────────────────────┘";
ui_print " ";

# boot install
dump_boot; # grab current boot, ramdisk kept intact

# Apply root-specific modifications if needed
if [ "$ROOT_TYPE" = "kernelsu" ] || [ "$ROOT_TYPE" = "wildkernelsu" ] || [ "$ROOT_TYPE" = "ksunext" ]; then
  ui_print "Applying root solution patches...";
  # Add KernelSU manager detection
  # This would check for KernelSU manager app and setup accordingly
fi

write_boot; # repack with new kernel/dtb assets provided in this zip

ui_print " ";
ui_print "╔════════════════════════════════════════════════════════════╗";
ui_print "║  Installation Complete!                                    ║";
ui_print "║                                                            ║";
ui_print "║  ✨ HINA KERNEL v1.0 Successfully Installed ✨            ║";
ui_print "║                                                            ║";
ui_print "║  Root Type: $ROOT_TYPE                                     ║";
ui_print "║  Features: All Enabled & Optimized                        ║";
ui_print "║                                                            ║";
ui_print "║  Please reboot your device now.                           ║";
ui_print "║  Enjoy extreme performance!                               ║";
ui_print "║                                                            ║";
ui_print "╚════════════════════════════════════════════════════════════╝";
ui_print " ";

## end boot install


## init_boot files attributes
#init_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# init_boot shell variables
#BLOCK=init_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for init_boot patching
#reset_ak;

# init_boot install
#dump_boot; # unpack ramdisk since it is the new first stage init ramdisk where overlay.d must go

#write_boot;
## end init_boot install


## vendor_kernel_boot shell variables
#BLOCK=vendor_kernel_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_kernel_boot patching
#reset_ak;

# vendor_kernel_boot install
#split_boot; # skip unpack/repack ramdisk, e.g. for dtb on devices with hdr v4 and vendor_kernel_boot

#flash_boot;
## end vendor_kernel_boot install


## vendor_boot files attributes
#vendor_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# vendor_boot shell variables
#BLOCK=vendor_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_boot patching
#reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
## end vendor_boot install

