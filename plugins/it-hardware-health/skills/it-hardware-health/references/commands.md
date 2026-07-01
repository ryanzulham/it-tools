# Fallback Commands (per OS)

Use these individual commands when the bundled script is unavailable or a specific reading
is missing. All are read-only.

## macOS

| Data | Command |
|---|---|
| Model / CPU / RAM total | `system_profiler SPHardwareDataType` |
| OS version | `sw_vers` |
| RAM modules & type | `system_profiler SPMemoryDataType` |
| Swap usage | `sysctl vm.swapusage` |
| Memory pressure | `top -l 1 -n 0 \| grep PhysMem` |
| Storage / NVMe / SMART | `system_profiler SPNVMeDataType` ; `diskutil info /` |
| Free space | `df -h /` |
| Battery raw (design/max/cycles) | `ioreg -r -c AppleSmartBattery \| grep -iE 'DesignCapacity\|MaxCapacity\|CycleCount'` |
| Battery condition | `system_profiler SPPowerDataType \| grep -iE 'Condition\|Cycle Count'` |
| Thermal throttling | `pmset -g therm` |
| GPU / display | `system_profiler SPDisplaysDataType` |
| CPU load | `uptime` |

Battery health % = MaxCapacity ÷ DesignCapacity × 100.

## Linux

| Data | Command |
|---|---|
| Model | `cat /sys/devices/virtual/dmi/id/product_name` ; `sudo dmidecode -t system` |
| OS | `cat /etc/os-release` ; `uname -r` |
| CPU | `lscpu` |
| Load | `cat /proc/loadavg` |
| RAM / swap | `free -h` ; `vmstat 1 2` |
| RAM modules | `sudo dmidecode -t memory` |
| Storage list | `lsblk -d -o NAME,MODEL,SIZE,ROTA,TRAN` |
| SMART | `sudo smartctl -H -A /dev/nvme0n1` (needs smartmontools) |
| Battery | `upower -i $(upower -e \| grep BAT)` or `cat /sys/class/power_supply/BAT0/*` |
| Thermal | `sensors` (needs lm-sensors) |
| GPU | `lspci \| grep -iE 'VGA\|3D'` |

## Windows (PowerShell)

| Data | Command |
|---|---|
| Model | `Get-CimInstance Win32_ComputerSystem` |
| Serial / BIOS | `Get-CimInstance Win32_BIOS` |
| OS | `Get-CimInstance Win32_OperatingSystem` |
| CPU | `Get-CimInstance Win32_Processor` |
| RAM modules | `Get-CimInstance Win32_PhysicalMemory` |
| Disk | `Get-CimInstance Win32_DiskDrive` ; `Get-PhysicalDisk` |
| SSD wear/health | `Get-PhysicalDisk \| Get-StorageReliabilityCounter` |
| Battery detail (HTML) | `powercfg /batteryreport /output "$env:TEMP\battery.html"` |
| Battery capacity (WMI) | `Get-CimInstance -Namespace root/WMI -Class BatteryFullChargedCapacity` and `BatteryStaticData` |
| GPU | `Get-CimInstance Win32_VideoController` |

Battery health % = FullChargedCapacity ÷ DesignedCapacity × 100.
