function Get-LastRebootEvent {
 
    <# 
.VERSION 0.1.1
 
.GUID 93dfb2d8-1330-49b7-a86c-0d9ff8b44846
 
.AUTHOR Jeffrey Snover
 
.COMPANYNAME Microsoft
 
.COPYRIGHT
 
.TAGS
 
.LICENSEURI
 
.PROJECTURI
 
.ICONURI
 
.EXTERNALMODULEDEPENDENCIES
 
.REQUIREDSCRIPTS
 
.EXTERNALSCRIPTDEPENDENCIES
 
.RELEASENOTES
This script was inspired by PowerShell.Com blog:
  http://powershell.com/cs/blogs/tips/archive/2016/05/20/harvesting-reboot-time-from-eventlog.aspx
 
 
#>

    <#
 
.DESCRIPTION
 Get the last reboot information from multiple machines
.Example
JPS> Get-LastReboot -ComputerName SRV,SRV2
 
ComputerName LastReboot DaysAgo HoursAgo
------------ ---------- ------- --------
SRV1 4/23/2016 5:55:42 AM 28 674
SRV2 4/1/2016 7:34:13 PM 49 1188
 
.Example
JPS> Get-LastReboot -ComputerName SRV -count 3
 
ComputerName LastReboot DaysAgo HoursAgo
------------ ---------- ------- --------
SRV 4/23/2016 5:55:42 AM 28 674
SRV 4/1/2016 7:34:13 PM 49 1188
SRV 3/20/2016 10:01:45 PM 61 1474
 
.Example
JPS> Get-LastReboot SRV 3
 
ComputerName LastReboot DaysAgo HoursAgo
------------ ---------- ------- --------
SRV 4/23/2016 5:55:42 AM 28 674
SRV 4/1/2016 7:34:13 PM 49 1188
SRV 3/20/2016 10:01:45 PM 61 1474
 
.NOTES
This script was inspired by PowerShell.Com blog:
  http://powershell.com/cs/blogs/tips/archive/2016/05/20/harvesting-reboot-time-from-eventlog.aspx
 
#> 
    param(
        [Parameter(Mandatory = 0, Position = 0)]
        [string[]]$ComputerName = ".",
        [Parameter(Mandatory = 0, Position = 1)]
        $Count = 1
    )

    foreach ($e in Get-EventLog -LogName System -Source Microsoft-Windows-Kernel-General -InstanceId 12 -Newest $Count -ComputerName $ComputerName) {
        $reboot = [DateTime]$e.ReplacementStrings[-1]
        $ago = New-TimeSpan -Start $reboot
        [pscustomobject]@{
            ComputerName = $e.MachineName
            LastReboot   = $reboot; 
            DaysAgo      = $ago.Days
            HoursAgo     = [int]$ago.TotalHours
        }
    }
}
