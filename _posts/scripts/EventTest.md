---
layout: post
title: EventTest.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/EventLogs/EventTest.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=EventTest.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
