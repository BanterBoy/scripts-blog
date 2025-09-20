---
layout: post
title: Enable-RDPRemotelyCIM.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Enable-RDPRemotelyCIM/
categories:
  - UserAdminModule
  - RemoteConnections
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

Use `Enable-RDPRemotelyCIM` to turn on Remote Desktop across one or more systems via the CIM `Win32_TerminalServiceSetting` class. The function enables both the service and the firewall exception by calling `SetAllowTSConnections` with `AllowTSConnections=1` and `ModifyFirewallException=1` for each computer supplied.

**Usage examples**

```powershell
Enable-RDPRemotelyCIM -ComputerName 'host01'
Import-Csv .\servers.csv | Select-Object -ExpandProperty Name | Enable-RDPRemotelyCIM
```

Run the script from an elevated session that has network access and appropriate permissions to configure the remote hosts.

---

#### Script

```powershell
function Enable-RDPRemotelyCIM {
    # You can enable RDP on a remote host by simply running the below two lines.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
        $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections=1;ModifyFirewallException=1} -ComputerName $Computer
    }

}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Enable-RDPRemotelyCIM.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RDPRemotelyCIM.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
