#!/bin/bash
# IT Hardware Health — macOS diagnostic sweep (read-only).
# Prints a labeled section-by-section hardware dump for analysis.
# Usage: bash diagnose_macos.sh

set +e
sec() { printf '\n===== %s =====\n' "$1"; }

sec "SYSTEM MODEL & FIRMWARE"
system_profiler SPHardwareDataType 2>/dev/null

sec "OS VERSION"
sw_vers 2>/dev/null
system_profiler SPSoftwareDataType 2>/dev/null | grep -iE 'System Version|Kernel|Time since boot'

sec "CPU"
sysctl -n machdep.cpu.brand_string 2>/dev/null
echo "Physical cores: $(sysctl -n hw.physicalcpu 2>/dev/null) | Logical: $(sysctl -n hw.logicalcpu 2>/dev/null)"
echo "Load average / uptime:"; uptime

sec "MEMORY (RAM)"
system_profiler SPMemoryDataType 2>/dev/null
echo "--- Physical memory ---"
echo "Total RAM bytes: $(sysctl -n hw.memsize 2>/dev/null)"

sec "MEMORY PRESSURE & SWAP"
sysctl vm.swapusage 2>/dev/null
echo "--- top summary ---"
top -l 1 -n 0 2>/dev/null | grep -iE 'PhysMem|VM:'

sec "STORAGE & SSD SMART"
system_profiler SPNVMeDataType 2>/dev/null | grep -iE 'Model|Capacity|TRIM|S.M.A.R.T'
echo "--- Free space ---"
df -h / 2>/dev/null
echo "--- SMART (root disk) ---"
diskutil info / 2>/dev/null | grep -i smart

sec "BATTERY HEALTH"
# Raw values for computing health %: MaxCapacity / DesignCapacity * 100
ioreg -r -c AppleSmartBattery 2>/dev/null | grep -iE '"DesignCapacity"|"MaxCapacity"|"AppleRawMaxCapacity"|"CycleCount"|"Temperature"|"PermanentFailureStatus"' | sort -u
echo "--- Condition & charge ---"
system_profiler SPPowerDataType 2>/dev/null | grep -iE 'Cycle Count|Condition|Full Charge Capacity|State of Charge|Charging|Fully Charged'
# Compute health percentage if both values present
# Match the standalone "key" = value lines (spaces around =), not the packed BatteryData blob.
DESIGN=$(ioreg -r -c AppleSmartBattery 2>/dev/null | grep -oE '"DesignCapacity" = [0-9]+' | head -1 | grep -oE '[0-9]+')
MAXCAP=$(ioreg -r -c AppleSmartBattery 2>/dev/null | grep -oE '"MaxCapacity" = [0-9]+' | head -1 | grep -oE '[0-9]+')
if [ -n "$DESIGN" ] && [ -n "$MAXCAP" ] && [ "$DESIGN" -gt 0 ] 2>/dev/null; then
  echo "COMPUTED BATTERY HEALTH: $((MAXCAP * 100 / DESIGN))%  ($MAXCAP / $DESIGN mAh)"
fi

sec "THERMAL / CPU THROTTLING"
pmset -g therm 2>/dev/null

sec "GPU & DISPLAY"
system_profiler SPDisplaysDataType 2>/dev/null | grep -iE 'Chipset|VRAM|Resolution|Display Type'

sec "TOP CPU CONSUMERS"
ps -Ao %cpu,%mem,comm -r 2>/dev/null | head -8

sec "RECENT KERNEL PANICS"
ls -1 /Library/Logs/DiagnosticReports/*.panic 2>/dev/null | tail -5 || echo "No panic reports found"

printf '\n===== DIAGNOSTIC COMPLETE =====\n'
