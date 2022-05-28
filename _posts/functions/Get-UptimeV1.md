---
layout: post
title: Get-UptimeV1.ps1
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
        $ms = $uptime.Milliseconds
        "System Up for: {0} days, {1} hours, {2}.{3} minutes" -f $d, $h, $m, $ms
    }

    END {

    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-UptimeV1.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UptimeV1.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
