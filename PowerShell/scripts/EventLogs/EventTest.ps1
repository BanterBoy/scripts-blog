<#
.Synopsis
	Compare event log access using Get-EventLog and Get-WinEvent.

	Public Domain. Use at your own risk.  Author makes no warranties
	and assumes no liabilities.
.Notes 
    Name:       EventTest.ps1
    Author:     Mark Berry, MCB Systems, http://www.mcbsys.com
	Created:    04/01/2011
    Last Edit:  04/01/2011
.Description
	First, get Warning and Error events from the last 24 hours from the specified 
	machine, first using Get-EventLog, then using Get-WinEvent.
	Second, get Audit Failure events  from the last 24 hours from the specified 
	machine, first using Get-EventLog, then using Get-WinEvent.
	Output how long each query takes to the console.
#>

# Usage:  start PowerShell as Administrator.  In the $ComputerName variable below,
# type the name of a Vista or later computer on your network that allows remote 
# event log queries.  Or just use the default to run against the local machine.
$ComputerName = $env:computername
# $ComputerName = "SERVER01" 

# Test Application log with Get-EventLog
$StopWatch = [Diagnostics.Stopwatch]::StartNew()
$StartTime = [DateTime]::Now.AddHours( - 24)
$IncludeEntryTypes = ("Warning", "Error")
[array] $Events = @()
$Events += Get-EventLog -ComputerName $ComputerName -LogName Application -After $StartTime | Where-Object { ($IncludeEntryTypes -contains $_.EntryType) }
$StopWatch.Stop()			
Write-Host $ComputerName ":  Get-EventLog on Application log found" $Events.Count "events. Elapsed time:" $StopWatch.Elapsed

# Test Application log with Get-WinEvent
$StopWatch = [Diagnostics.Stopwatch]::StartNew()
$XMLFilter = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=2 or Level=3) 
	  and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@
[array] $Events = @()
$Events += Get-WinEvent -ComputerName $ComputerName -FilterXml $XMLfilter
$StopWatch.Stop()			
Write-Host $ComputerName ":  Get-WinEvent on Application log found" $Events.Count "events. Elapsed time:" $StopWatch.Elapsed

# Test Security log with Get-EventLog
$StopWatch = [Diagnostics.Stopwatch]::StartNew()
$StartTime = [DateTime]::Now.AddHours( - 24)
$IncludeEntryTypes = ("FailureAudit")
[array] $Events = @()
$Events += Get-EventLog -ComputerName $ComputerName -LogName Security -After $StartTime | Where-Object { ($IncludeEntryTypes -contains $_.EntryType) }
$StopWatch.Stop()			
Write-Host $ComputerName ":  Get-EventLog on Security log found" $Events.Count "events. Elapsed time:" $StopWatch.Elapsed


# Test Security log with Get-WinEvent
$StopWatch = [Diagnostics.Stopwatch]::StartNew()
$XMLFilter = @'
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[band(Keywords,4503599627370496) 
	  and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@
[array] $Events = @()
$Events += Get-WinEvent -ComputerName $ComputerName -FilterXml $XMLfilter
$StopWatch.Stop()			
Write-Host $ComputerName ":  Get-WinEvent on Security log found" $Events.Count "events. Elapsed time:" $StopWatch.Elapsed

