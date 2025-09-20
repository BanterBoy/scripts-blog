---
layout: post
title: Get-RDPStatusCIM.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RDPStatusCIM/
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

`Get-RDPStatusCIM` queries the `Win32_TerminalServiceSetting` CIM class to report whether Remote Desktop is enabled or disabled on each target computer. The function writes `"RDP Enabled"` or `"RDP Disabled"` for every host in the `-ComputerName` list.

**Usage examples**

```powershell
Get-RDPStatusCIM -ComputerName 'srv01','srv02'
$computers | Get-RDPStatusCIM
```

Use the output to determine whether to call the enable or disable helpers before making firewall or RDP changes.

---

#### Script

```powershell
function Get-RDPStatusCIM {
    # Do you care to check if it is currently enabled or disabled before acting? Use the below code.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-CimInstance -ClassName "Win32_TerminalServiceSetting" -Namespace "root/CIMV2/TerminalServices" -ComputerName $Computer
        if ($tsobj.AllowTSConnections -eq '1') {
            Write-Output "RDP Enabled"
        }
        if ($tsobj.AllowTSConnections -eq '0') {
            Write-Output "RDP Disabled"
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Get-RDPStatusCIM.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDPStatusCIM.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
