# Local System Information v3
# Shows details of currently running PC
# Thom McKiernan 11/09/2014

$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
Clear-Host

Write-Host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
"Manufacturer: " + $computerSystem.Manufacturer
"Model: " + $computerSystem.Model
"Serial Number: " + $computerBIOS.SerialNumber
"CPU: " + $computerCPU.Name
"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
"User logged In: " + $computerSystem.UserName
"Last Reboot: " + $computerOS.LastBootUpTime

Get-PSDrive -PSProvider 'FileSystem' | Format-Table @{Label="Drive"; Expression= {$_.name}}, @{Label="Used Space GB";Expression= {[math]::truncate($_.used / 1GB)}}, @{Label="Free Space GB";Expression= {[math]::truncate($_.free / 1GB)}}, @{Label="Percent Free";Expression= {"{0:P}" -f ($_.free / ($_.free + $_.used))}}, @{Label="Total Size"; Expression= {[math]::truncate(($_.free + $_.used) /1GB)}} -AutoSize
