---
layout: post
title: Get-W32TimeSource.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-W32TimeSource/
categories:
- UserAdminModule
- Utilities
tags:
- PowerShell
- User Admin Module
- W 32 Time Source
description: Retrieves detailed information about the Windows Time service (w32time)
  on a specified computer.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Retrieves detailed information about the Windows Time service (w32time) on a specified computer.

#### Detailed Description

The Get-W32TimeSource function retrieves detailed information about the Windows Time service (w32time) on a specified computer. It uses the w32tm command to query the status and verbose information of the Windows Time service.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-W32TimeSource -ComputerName "Server01"
```

Retrieves the Windows Time service information from the remote computer named "Server01".

**Example 2**

```powershell
Get-W32TimeSource
```

Retrieves the Windows Time service information from the local computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Current Date Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves detailed information about the Windows Time service (w32time) on a specified computer.

.DESCRIPTION
The Get-W32TimeSource function retrieves detailed information about the Windows Time service (w32time) on a specified computer. It uses the w32tm command to query the status and verbose information of the Windows Time service.

.PARAMETER ComputerName
Specifies the name of the computer to retrieve the Windows Time service information from. If not specified, the local computer name is used.

.EXAMPLE
Get-W32TimeSource -ComputerName "Server01"
Retrieves the Windows Time service information from the remote computer named "Server01".

.EXAMPLE
Get-W32TimeSource
Retrieves the Windows Time service information from the local computer.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject
The function returns a PSObject containing the following properties:
- ComputerName: The name of the computer from which the information is retrieved.
- LeapIndicator: The leap indicator value.
- Stratum: The stratum value.
- Precision: The precision value.
- RootDelay: The root delay value.
- RootDispersion: The root dispersion value.
- ReferenceId: The reference ID value.
- LastSuccessfulSyncTime: The last successful synchronization time.
- Source: The time source.
- PollInterval: The poll interval value.
- PhaseOffset: The phase offset value.
- ClockRate: The clock rate value.
- StateMachine: The state machine value.
- TimeSourceFlags: The time source flags.
- ServerRole: The server role.
- LastSyncError: The last synchronization error.
- TimeSinceLastGoodSyncTime: The time since the last good synchronization time.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0
#>
function Get-W32TimeSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $w32tmOutput = w32tm /query /status /verbose /computer:$ComputerName
    } catch {
        Write-Error "Failed to run w32tm command: $_"
        return
    }

    $outputLines = $w32tmOutput -split "`n"

    $outputObject = New-Object PSObject

    $outputObject | Add-Member -NotePropertyName "ComputerName" -NotePropertyValue $ComputerName

    $headings = @{
        "Leap Indicator" = "LeapIndicator";
        "Stratum" = "Stratum";
        "Precision" = "Precision";
        "Root Delay" = "RootDelay";
        "Root Dispersion" = "RootDispersion";
        "ReferenceId" = "ReferenceId";
        "Last Successful Sync Time" = "LastSuccessfulSyncTime";
        "Source" = "Source";
        "Poll Interval" = "PollInterval";
        "Phase Offset" = "PhaseOffset";
        "ClockRate" = "ClockRate";
        "State Machine" = "StateMachine";
        "Time Source Flags" = "TimeSourceFlags";
        "Server Role" = "ServerRole";
        "Last Sync Error" = "LastSyncError";
        "Time since Last Good Sync Time" = "TimeSinceLastGoodSyncTime"
    }

    foreach ($line in $outputLines) {
        foreach ($heading in $headings.Keys) {
            if ($line -match "$($heading):\s(.*)") {
                $outputObject | Add-Member -NotePropertyName $headings[$heading] -NotePropertyValue $Matches[1]
                break
            }
        }
    }

    return $outputObject
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-W32TimeSource.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-W32TimeSource.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

