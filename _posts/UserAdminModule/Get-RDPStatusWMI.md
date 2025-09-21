---
layout: post
title: Get-RDPStatusWMI.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/remoteconnections/get-rdpstatuswmi/
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

`Get-RDPStatusWMI` performs the same Remote Desktop status check as the CIM variant but uses the WMI provider for environments constrained to DCOM. For each name in `-ComputerName`, the script reads the `AllowTSConnections` property and prints whether RDP is enabled.

**Usage examples**

```powershell
Get-RDPStatusWMI -ComputerName 'legacy01'
$servers | Get-RDPStatusWMI
```

Combine this diagnostic with the enable/disable functions to keep legacy systems aligned with your RDP baseline.

---

#### Script

```powershell
function Get-RDPStatusWMI {
    # Do you care to check if it is currently enabled or disabled before acting? Use the below code.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        if ($tsobj.AllowTSConnections -eq '1') {
            Write-Output "RDP Enabled"
        }
        if ($tsobj.AllowTSConnections -eq '0') {
            Write-Output "RDP Disabled"
        }
    }
}
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Get-RDPStatusWMI.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RDPStatusWMI.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
