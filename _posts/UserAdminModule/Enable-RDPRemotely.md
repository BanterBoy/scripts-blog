---
layout: post
title: Enable-RDPRemotely.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/remoteconnections/enable-rdpremotely/
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

Enables Remote Desktop Protocol (RDP) on one or more remote computers.

#### Detailed Description

The Enable-RDPRemotely function enables Remote Desktop Protocol (RDP) on one or more remote computers. It uses CIM (Common Information Model) to enable RDP on computers running PowerShell version 6 or later, and WMI (Windows Management Instrumentation) for older versions of PowerShell.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Enable-RDPRemotely -ComputerName 'Computer01', 'Computer02'
```

Enables RDP on the computers named 'Computer01' and 'Computer02'.

**Example 2**

```powershell
'Computer01', 'Computer02' | Enable-RDPRemotely
```

Enables RDP on the computers named 'Computer01' and 'Computer02' using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Enables Remote Desktop Protocol (RDP) on one or more remote computers.

.DESCRIPTION
The Enable-RDPRemotely function enables Remote Desktop Protocol (RDP) on one or more remote computers. It uses CIM (Common Information Model) to enable RDP on computers running PowerShell version 6 or later, and WMI (Windows Management Instrumentation) for older versions of PowerShell.

.PARAMETER ComputerName
Specifies the name of the computer(s) on which to enable RDP. This parameter accepts an array of strings, allowing you to specify multiple computer names.

.EXAMPLE
Enable-RDPRemotely -ComputerName 'Computer01', 'Computer02'
Enables RDP on the computers named 'Computer01' and 'Computer02'.

.EXAMPLE
'Computer01', 'Computer02' | Enable-RDPRemotely
Enables RDP on the computers named 'Computer01' and 'Computer02' using pipeline input.

.INPUTS
System.String

.OUTPUTS
System.String

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>
#requires -PSEdition Desktop
function Enable-RDPRemotely {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        # Enable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 1; ModifyFirewallException = 1 } -ComputerName $Computer
        }
        # Enable RDP using CIM
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(1, 1)
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Enable-RDPRemotely.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RDPRemotely.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

