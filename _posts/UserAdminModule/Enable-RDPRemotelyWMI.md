---
layout: post
title: Enable-RDPRemotelyWMI.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Enable-RDPRemotelyWMI/
categories:
- UserAdminModule
- RemoteConnections
tags:
- PowerShell
- User Admin Module
- RDP Remotely WMI
- RDP
- WMI
description: Enable-RDPRemotelyWMI provides a WMI-based option for enabling Remote
  Desktop on remote Windows systems. It queries the Win32_TerminalServiceSetting class...
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Enable-RDPRemotelyWMI` provides a WMI-based option for enabling Remote Desktop on remote Windows systems. It queries the `Win32_TerminalServiceSetting` class over DCOM and executes `SetAllowTSConnections(1,1)` so that both RDP and the firewall exception are activated.

**Usage examples**

```powershell
Enable-RDPRemotelyWMI -ComputerName 'legacy01'
'server01','server02' | Enable-RDPRemotelyWMI
```

Leverage this helper when CIM/WSMan is unavailable but you can still reach the host using classic WMI remoting.

---

#### Script

```powershell
function Enable-RDPRemotelyWMI {
    # You can enable RDP on a remote host by simply running the below two lines.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        $tsobj.SetAllowTSConnections(1, 1)
    }
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Enable-RDPRemotelyWMI.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RDPRemotelyWMI.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
