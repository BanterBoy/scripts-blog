---
layout: post
title: Stop-RemoteComputerShutdown.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shutdowncommands/stop-remotecomputershutdown/
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

Cancels a scheduled shutdown, restart, or hibernate operation on a remote computer.

#### Detailed Description

Wraps shutdown.exe /a to abort any pending shutdown, restart, or hibernate action on the target computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Stop-RemoteComputerShutdown -ComputerName "SRV01"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires administrative privileges and remote access permissions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Stop-RemoteComputerShutdown {
    <#
    .SYNOPSIS
    Cancels a scheduled shutdown, restart, or hibernate operation on a remote computer.

    .DESCRIPTION
    Wraps shutdown.exe /a to abort any pending shutdown, restart, or hibernate action on the target computer.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .EXAMPLE
    Stop-RemoteComputerShutdown -ComputerName "SRV01"

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName
    )

    $cmd = "shutdown.exe /m \\$ComputerName /a"

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: Cancel Scheduled Shutdown/Restart/Hibernate")) {
        try {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock { param($command) & cmd /c $command } -ArgumentList $cmd -ErrorAction Stop
            Write-Output "Scheduled shutdown/restart/hibernate on $ComputerName has been canceled successfully."
        }
        catch {
            Write-Error "Failed to cancel the scheduled action on $ComputerName. Error: $($_.Exception.Message)"
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Stop-RemoteComputerShutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-RemoteComputerShutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

