---
layout: post
title: Invoke-RemoteComputerShutdown.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Invoke-RemoteComputerShutdown/
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

Schedules a shutdown, restart, or hibernate operation on a remote computer.

#### Detailed Description

Wraps the native Windows shutdown.exe command to remotely schedule shutdown, restart, or hibernate actions. Supports force and abort options. Uses Invoke-Command for remote execution.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Shutdown" -Timeout 60 -Comment "Maintenance window" -Force
```

**Example 2**

```powershell
Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Restart" -Timeout 120
```

**Example 3**

```powershell
Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Abort
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires administrative privileges and remote access permissions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Invoke-RemoteComputerShutdown {
<#
    .SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation on a remote computer.

    .DESCRIPTION
    Wraps the native Windows shutdown.exe command to remotely schedule shutdown, restart, or hibernate actions.
    Supports force and abort options. Uses Invoke-Command for remote execution.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .PARAMETER Action
    The action to perform: Shutdown, Restart, or Hibernate.

    .PARAMETER Timeout
    The delay in seconds before the action is executed (0-315360000).

    .PARAMETER Comment
    A comment describing the reason for the action.

    .PARAMETER Force
    Forces running applications to close.

    .PARAMETER Abort
    Cancels a scheduled shutdown/restart/hibernate.

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Shutdown" -Timeout 60 -Comment "Maintenance window" -Force

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Restart" -Timeout 120

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Abort

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action,

        [Parameter(Position = 2)]
        [ValidateRange(0, 315360000)]
        [int]$Timeout = 30,

        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Comment = "Scheduled by PowerShell",

        [switch]$Force,

        [switch]$Abort
    )

    switch ($Action) {
        "Shutdown" { $actionParam = "/s" }
        "Restart" { $actionParam = "/r" }
        "Hibernate" { $actionParam = "/h" }
    }

    $forceParam = if ($Force) { "/f" } else { "" }

    $cmd = "shutdown.exe /m \\$ComputerName $actionParam /t $Timeout /c `"$Comment`" $forceParam"

    if ($Abort) {
        $cmd = "shutdown.exe /m \\$ComputerName /a"
    }

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: $Action", "Command: $cmd")) {
        try {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock { param($command) & cmd /c $command } -ArgumentList $cmd -ErrorAction Stop
            Write-Output "Action '$Action' scheduled on $ComputerName successfully."
        }
        catch {
            Write-Error "Failed to schedule action '$Action' on $ComputerName. Error: $($_.Exception.Message)"
            if ($_.Exception.InnerException) {
                Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Invoke-RemoteComputerShutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-RemoteComputerShutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

