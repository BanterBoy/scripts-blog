---
layout: post
title: Wait-RemoteComputerShutdown.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shutdowncommands/wait-remotecomputershutdown/
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

Monitors remote computers and reports when each has shut down (stops responding to ping).

#### Detailed Description

Accepts computer names via pipeline or array. Pings each computer until it stops responding, then reports shutdown.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
'PC1','PC2','PC3' | Wait-RemoteComputerShutdown
```

Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Wait-RemoteComputerShutdown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Requires network connectivity and appropriate permissions.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Wait-RemoteComputerShutdown {
    <#
    .SYNOPSIS
    Monitors remote computers and reports when each has shut down (stops responding to ping).

    .DESCRIPTION
    Accepts computer names via pipeline or array. Pings each computer until it stops responding, then reports shutdown.

    .PARAMETER Name
    The name(s) of the remote computer(s) to monitor. Accepts pipeline input.

    .EXAMPLE
    'PC1','PC2','PC3' | Wait-RemoteComputerShutdown
    Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Wait-RemoteComputerShutdown

    .NOTES
    Requires network connectivity and appropriate permissions.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory, Position=0)]
        [Alias('ComputerName')]
        [string[]]$Name
    )

    process {
        foreach ($computer in $Name) {
            Write-Host "Monitoring $computer for shutdown..."
            while (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
                Write-Host "$computer is still online..."
                Start-Sleep -Seconds 2
            }
            Write-Host "$computer has shut down (no longer responding to ping)."
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Wait-RemoteComputerShutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Wait-RemoteComputerShutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

