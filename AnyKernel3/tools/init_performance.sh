#!/system/bin/sh
# HINA Kernel - Performance Initialization Script
# Optimizes I/O scheduler and CPU frequency scaling for faster app launches
# Version: 2.0

# Log function
log() {
    echo "[HINA-PERF] $1" >> /dev/kmsg 2>/dev/null
}

log "Starting HINA Kernel performance tuning..."

# ============================================================================
# BFQ I/O Scheduler Optimization
# ============================================================================
set_bfq_scheduler() {
    local block_device=$1
    local path="/sys/block/${block_device}/queue/scheduler"
    
    if [ -f "$path" ]; then
        if grep -q "bfq" "$path"; then
            echo "bfq" > "$path" 2>/dev/null
            log "Set BFQ scheduler for $block_device"
        fi
    fi
}

# Apply BFQ to all block devices (UFS, SD card, etc.)
for device in mmcblk* sda* sdb*; do
    if [ -d "/sys/block/$device" ]; then
        set_bfq_scheduler "$device"
    fi
done

# BFQ-specific tunings for optimal latency
if [ -d "/sys/module/bfq/parameters" ]; then
    # Low-latency mode for interactive performance
    echo 1 > /sys/module/bfq/parameters/low_latency 2>/dev/null
    log "Enabled BFQ low-latency mode"
    
    # Disable strict queuing for better responsiveness
    echo 0 > /sys/module/bfq/parameters/strict_no_dispatch 2>/dev/null
fi

# ============================================================================
# CPU Frequency Scaling Optimization (schedutil)
# ============================================================================
log "Tuning CPU schedutil governor..."

# Set schedutil as the default governor for all CPUs
for cpu_path in /sys/devices/system/cpu/cpu*/cpufreq; do
    if [ -d "$cpu_path" ]; then
        if grep -q "schedutil" "$cpu_path/scaling_available_governors"; then
            echo "schedutil" > "$cpu_path/scaling_governor" 2>/dev/null
        fi
    fi
done

# Optimize schedutil rate limits for faster frequency transitions
# (These values improve responsiveness for app launches)
if [ -d "/sys/devices/system/cpu/cpufreq/schedutil" ]; then
    # Up rate limit: respond faster to load spikes (500ms default -> 100ms)
    echo 100 > /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us 2>/dev/null
    
    # Down rate limit: less aggressive scaling down (500ms -> 300ms)
    echo 300 > /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us 2>/dev/null
    
    log "Configured schedutil rate limits (up:100us, down:300us)"
fi

# ============================================================================
# CPU Utilization Clamping (uclamp) - Faster App Launches
# ============================================================================
log "Enabling CPU uclamp boost for app launches..."

# Set uclamp_max for foreground tasks to ensure higher performance
# This prevents CPUs from capping frequency too aggressively
if [ -d "/proc/sys/kernel/sched" ]; then
    # Foreground application boost (uclamp_max = 100% = max frequency)
    echo 1024 > /proc/sys/kernel/sched_util_clamp_max_post_init 2>/dev/null
    log "Set maximum uclamp for CPU optimization"
fi

# ============================================================================
# Memory & I/O Optimization
# ============================================================================

# Tune VFS cache pressure for faster app launches
# Lower values = kernel keeps more memory for file cache (helps with I/O)
echo 30 > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
log "Set vm.vfs_cache_pressure=30 (optimized for cache)"

# Increase dirty ratio for better I/O batching
echo 20 > /proc/sys/vm/dirty_ratio 2>/dev/null
echo 5 > /proc/sys/vm/dirty_background_ratio 2>/dev/null
log "Optimized dirty page ratios"

# Enable readahead for faster app loads
for block in /sys/block/*/queue; do
    if [ -f "$block/read_ahead_kb" ]; then
        echo 512 > "$block/read_ahead_kb" 2>/dev/null
    fi
done
log "Enabled readahead (512KB)"

# ============================================================================
# GPU Power Management
# ============================================================================
log "GPU power level configuration..."

# Set GPU initial power level (pwrlevel 6 = 381 MHz for balanced start)
if [ -d "/sys/class/kgsl/kgsl-3d0" ]; then
    # Allow GPU to scale up from moderate frequency
    echo 6 > /sys/class/kgsl/kgsl-3d0/pwrscale/base_level 2>/dev/null
    log "GPU configured to default power level 6"
fi

# ============================================================================
# Scheduler Class Tuning
# ============================================================================
log "Tuning kernel scheduler..."

# CFS scheduler latency (lower = more responsive to task switches)
echo 6000000 > /proc/sys/kernel/sched_latency_ns 2>/dev/null

# Minimal granularity (lower = finer grained scheduling)
echo 1000000 > /proc/sys/kernel/sched_min_granularity_ns 2>/dev/null

log "Scheduler latency tuned for responsiveness"

# ============================================================================
# Final Status
# ============================================================================
log "✓ HINA Kernel v2.0 performance optimizations complete!"
log "  • BFQ I/O scheduler enabled"
log "  • schedutil rate limits optimized"
log "  • CPU uclamp boost activated"
log "  • Memory cache tuned for fast launches"
log "  • GPU configured for balanced performance"
