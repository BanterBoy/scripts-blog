<#
.SYNOPSIS
    Demonstrates uptime using WMI

.DESCRIPTION
    This script used Win32_ComputerSystem to determine how long your system
    has been running.

.NOTES
    File Name : Get-UpTime.ps1

.LINK


.EXAMPLE
    PS C:\Get-UpTime
    System Up for: 1 days, 8 hours, 40.781 minutes

#>

[cmdletbinding(DefaultParameterSetName = 'default')]
param([Parameter(Mandatory = $True,
HelpMessage = "Please enter a ComputerName",
ValueFromPipeline = $false,
ValueFromPipelineByPropertyName = $True)]
[Alias('cn', 'ComputerName')]
[string[]]$ComputerName
)

BEGIN {}

PROCESS {
    function WMIDateStringToDate($Bootup) {
        [System.Management.ManagementDateTimeconverter]::ToDateTime($Bootup)
    }

    $Computer = "$ComputerName"
    $Computers = Get-WMIObject -class Win32_OperatingSystem -computer $Computer
    foreach ($system in $computers) {
        $Bootup = $system.LastBootUpTime
        $LastBootUpTime = WMIDateStringToDate($Bootup)
        $now = Get-Date
        $Uptime = $now - $lastBootUpTime
        $d = $Uptime.Days
        $h = $Uptime.Hours
        $m = $uptime.Minutes
        $ms= $uptime.Milliseconds
        "System Up for: {0} days, {1} hours, {2}.{3} minutes" -f $d,$h,$m,$ms
    }

END {

}
