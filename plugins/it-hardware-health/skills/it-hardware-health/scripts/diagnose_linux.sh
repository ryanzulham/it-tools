#!/bin/bash
# IT Hardware Health — Linux diagnostic sweep (read-only).
# Some commands (smartctl, dmidecode) need sudo; note failures rather than skipping.
# Usage: bash diagnose_linux.sh

set +e
sec() { printf '\n===== %s =====\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

sec "SYSTEM MODEL & FIRMWARE"
if have dmidecode; then sudo -n dmidecode -t system 2>/dev/null | grep -iE 'Manufacturer|Product Name|Serial Number' || echo "(dmidecode needs sudo)"; fi
cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null
cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null

sec "OS VERSION"
(. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME"); uname -r; echo "Uptime:"; uptime

sec "CPU"
if have lscpu; then lscpu 2>/dev/null | grep -iE 'Model name|^CPU\(s\)|Core|Thread'; fi
echo "Load average:"; cat /proc/loadavg 2>/dev/null

sec "MEMORY (RAM) & SWAP"
free -h 2>/dev/null
if have dmidecode; then echo "--- DIMM type/speed ---"; sudo -n dmidecode -t memory 2>/dev/null | grep -iE 'Size:|Type:|Speed:|Upgradeable' || echo "(needs sudo)"; fi
echo "--- swap activity (si/so) ---"; vmstat 1 2 2>/dev/null | tail -1

sec "STORAGE & SSD SMART"
lsblk -d -o NAME,MODEL,SIZE,ROTA,TRAN 2>/dev/null
echo "--- Free space ---"; df -h / 2>/dev/null
echo "--- SMART ---"
if have smartctl; then
  for d in /dev/sd? /dev/nvme?n1; do
    [ -b "$d" ] || continue
    echo "# $d"; sudo -n smartctl -H -A "$d" 2>/dev/null | grep -iE 'overall-health|Power_On_Hours|Wear_Leveling|Percentage Used|Reallocated|Media_Wearout' || echo "(smartctl needs sudo)"
  done
else echo "smartctl not installed (install smartmontools)"; fi

sec "BATTERY HEALTH"
if have upower; then
  BAT=$(upower -e 2>/dev/null | grep -i BAT | head -1)
  [ -n "$BAT" ] && upower -i "$BAT" 2>/dev/null | grep -iE 'state|energy-full:|energy-full-design|capacity|percentage' || echo "No battery (desktop?) — N/A"
else
  for b in /sys/class/power_supply/BAT*; do
    [ -d "$b" ] || { echo "No battery — N/A"; break; }
    echo "cycle_count: $(cat $b/cycle_count 2>/dev/null)"
    echo "energy_full: $(cat $b/energy_full 2>/dev/null) / design: $(cat $b/energy_full_design 2>/dev/null)"
  done
fi

sec "THERMAL"
if have sensors; then sensors 2>/dev/null | grep -iE 'Core|temp|Tctl' | head -10; else echo "lm-sensors not installed"; fi

sec "GPU"
if have lspci; then lspci 2>/dev/null | grep -iE 'VGA|3D|Display'; fi

sec "TOP CPU CONSUMERS"
ps -eo %cpu,%mem,comm --sort=-%cpu 2>/dev/null | head -8

printf '\n===== DIAGNOSTIC COMPLETE =====\n'
