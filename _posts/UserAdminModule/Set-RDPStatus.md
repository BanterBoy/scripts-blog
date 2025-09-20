---
layout: post
title: Set-RDPStatus.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Set-RDPStatus/
categories:
- UserAdminModule
- RemoteConnections
tags:
- PowerShell
- User Admin Module
- RDP Status
- RDP
description: Enables or disables RDP on specified computers.
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

Enables or disables RDP on specified computers.

#### Detailed Description

Configures the RDP settings on specified computers using CIM/WMI methods.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-RDPStatus -ComputerName "DANTOOINE" -Enable
```

**Example 2**

```powershell
Set-RDPStatus -ComputerName "DANTOOINE"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# Function: Set-RDPStatus
Function Set-RDPStatus {
    <#
    .SYNOPSIS
    Enables or disables RDP on specified computers.

    .DESCRIPTION
    Configures the RDP settings on specified computers using CIM/WMI methods.

    .PARAMETER ComputerName
    Name or IP address of the computer(s) to configure.

    .PARAMETER Enable
    Switch to enable RDP. If not specified, RDP will be disabled.

    .EXAMPLE
    Set-RDPStatus -ComputerName "DANTOOINE" -Enable

    .EXAMPLE
    Set-RDPStatus -ComputerName "DANTOOINE"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $false)]
        [switch]$Enable
    )

    foreach ($Computer in $ComputerName) {
        try {
            $Settings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Settings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{ AllowTSConnections = [int]$Enable; ModifyFirewallException = [int]$Enable } -ComputerName $Computer
            Write-Output "$($Computer): RDP $($Enable ? 'enabled' : 'disabled')."
        } catch {
            Write-Warning "Failed to set RDP status on $($Computer): $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Set-RDPStatus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-RDPStatus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

