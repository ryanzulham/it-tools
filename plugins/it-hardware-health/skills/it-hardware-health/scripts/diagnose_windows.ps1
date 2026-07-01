# IT Hardware Health - Windows diagnostic sweep (read-only).
# Run in PowerShell:  powershell -ExecutionPolicy Bypass -File diagnose_windows.ps1
# Battery report generation writes an HTML file to %TEMP% (read-only to system state otherwise).

function Section($t){ Write-Host "`n===== $t =====" }

Section "SYSTEM MODEL & FIRMWARE"
Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model, SystemFamily | Format-List
Get-CimInstance Win32_BIOS | Select-Object SerialNumber, SMBIOSBIOSVersion, ReleaseDate | Format-List

Section "OS VERSION"
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, LastBootUpTime | Format-List

Section "CPU"
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List
Write-Host ("CPU Load %: " + (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average)

Section "MEMORY (RAM)"
$os = Get-CimInstance Win32_OperatingSystem
Write-Host ("Total RAM (GB): " + [math]::Round($os.TotalVisibleMemorySize/1MB,1))
Write-Host ("Free RAM (GB):  " + [math]::Round($os.FreePhysicalMemory/1MB,1))
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed, MemoryType | Format-Table -Auto

Section "STORAGE & SSD HEALTH"
Get-CimInstance Win32_DiskDrive | Select-Object Model, @{n='SizeGB';e={[math]::Round($_.Size/1GB,0)}}, InterfaceType, Status | Format-Table -Auto
try {
  Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, @{n='Wear%';e={($_ | Get-StorageReliabilityCounter).Wear}}, @{n='PowerOnHrs';e={($_ | Get-StorageReliabilityCounter).PowerOnHours}} | Format-Table -Auto
} catch { Write-Host "Get-PhysicalDisk reliability unavailable (may need admin)" }
Get-PSDrive C | Select-Object @{n='UsedGB';e={[math]::Round($_.Used/1GB,1)}}, @{n='FreeGB';e={[math]::Round($_.Free/1GB,1)}} | Format-Table -Auto

Section "BATTERY HEALTH"
$bat = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
if ($bat) {
  $bat | Select-Object Name, EstimatedChargeRemaining, BatteryStatus | Format-List
  # Full vs design capacity from WMI (mWh)
  $full = (Get-CimInstance -Namespace root/WMI -Class BatteryFullChargedCapacity -ErrorAction SilentlyContinue).FullChargedCapacity
  $design = (Get-CimInstance -Namespace root/WMI -Class BatteryStaticData -ErrorAction SilentlyContinue).DesignedCapacity
  if ($full -and $design -and $design -gt 0) {
    Write-Host ("COMPUTED BATTERY HEALTH: " + [math]::Round($full*100/$design,0) + "%  ($full / $design mWh)")
  }
  Write-Host "Tip: full detail -> powercfg /batteryreport /output `"$env:TEMP\battery.html`""
} else { Write-Host "No battery detected (desktop?) - N/A" }

Section "THERMAL"
try {
  $t = Get-CimInstance -Namespace root/WMI -Class MSAcpi_ThermalZoneTemperature -ErrorAction Stop
  $t | ForEach-Object { Write-Host ("Zone temp C: " + [math]::Round(($_.CurrentTemperature/10)-273.15,1)) }
} catch { Write-Host "Thermal zone data unavailable (needs admin / not exposed)" }

Section "GPU & DISPLAY"
Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, CurrentHorizontalResolution, CurrentVerticalResolution | Format-List

Section "TOP CPU CONSUMERS"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 8 Name, CPU, @{n='MemMB';e={[math]::Round($_.WS/1MB,0)}} | Format-Table -Auto

Write-Host "`n===== DIAGNOSTIC COMPLETE ====="
