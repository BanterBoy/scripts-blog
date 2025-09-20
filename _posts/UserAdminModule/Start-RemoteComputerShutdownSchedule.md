---
layout: post
title: Start-RemoteComputerShutdownSchedule.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Start-RemoteComputerShutdownSchedule/
categories:
  - UserAdminModule
  - ShutdownCommands
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

Schedules a shutdown, restart, or hibernate operation on a remote computer at a specific time.

#### Detailed Description

Calculates the timeout required for shutdown.exe based on the desired shutdown time, then calls Invoke-RemoteComputerShutdown.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime (Get-Date).AddMinutes(30) -Action "Shutdown" -Comment "End of day shutdown" -Force
```

**Example 2**

```powershell
Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime "2025-09-01 23:00" -Action "Restart"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires administrative privileges and remote access permissions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Start-RemoteComputerShutdownSchedule {
    <#
    .SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation on a remote computer at a specific time.

    .DESCRIPTION
    Calculates the timeout required for shutdown.exe based on the desired shutdown time, then calls Invoke-RemoteComputerShutdown.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .PARAMETER ShutdownTime
    The date and time when the action should occur.

    .PARAMETER Action
    The action to perform: Shutdown, Restart, or Hibernate.

    .PARAMETER Comment
    A comment describing the reason for the action.

    .PARAMETER Force
    Forces running applications to close.

    .EXAMPLE
    Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime (Get-Date).AddMinutes(30) -Action "Shutdown" -Comment "End of day shutdown" -Force

    .EXAMPLE
    Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime "2025-09-01 23:00" -Action "Restart"

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [datetime]$ShutdownTime,

        [Parameter()]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action = "Shutdown",

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Comment = "Scheduled by PowerShell",

        [switch]$Force
    )

    $currentDateTime = Get-Date
    $timeDifference = [int]($ShutdownTime - $currentDateTime).TotalSeconds

    if ($timeDifference -le 0) {
        Write-Error "The specified time has already passed. Please specify a future time."
        return
    }
    if ($timeDifference -gt 315360000) {
        Write-Error "Timeout exceeds maximum allowed by shutdown.exe (315360000 seconds)."
        return
    }

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: $Action at $ShutdownTime")) {
        try {
            Invoke-RemoteComputerShutdown -ComputerName $ComputerName -Action $Action -Timeout $timeDifference -Comment $Comment -Force:$Force
        }
        catch {
            Write-Error "Failed to schedule shutdown on $ComputerName. Error: $($_.Exception.Message)"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Start-RemoteComputerShutdownSchedule.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-RemoteComputerShutdownSchedule.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

