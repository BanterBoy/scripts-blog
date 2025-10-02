---
layout: post
title: Get-LastRebootEvent.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/get-lastrebootevent/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
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
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-LastRebootEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastRebootEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

