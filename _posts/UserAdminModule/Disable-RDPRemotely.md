---
layout: post
title: Disable-RDPRemotely.ps1
description: "Turns off Remote Desktop Protocol on specified computers via WMI or CIM."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Disable-RDPRemotely/
categories:
  - UserAdminModule
  - RemoteConnections
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

Disables Remote Desktop Protocol (RDP) on remote computers.

#### Detailed Description

The Disable-RDPRemotely function disables Remote Desktop Protocol (RDP) on one or more remote computers. It uses either CIM or WMI to perform the operation, depending on the version of PowerShell.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Disable-RDPRemotely -ComputerName 'Server01', 'Server02'
```

Disables RDP on the computers 'Server01' and 'Server02'.

**Example 2**

```powershell
'Desktop01', 'Desktop02' | Disable-RDPRemotely
```

Disables RDP on the computers 'Desktop01' and 'Desktop02' using pipeline input.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires administrative privileges on the remote computers.

- If the computer is running PowerShell version 6 or later, CIM is used to disable RDP. Otherwise, WMI is used.

- For more information, visit the help URI: http://scripts.lukeleigh.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Disables Remote Desktop Protocol (RDP) on remote computers.

.DESCRIPTION
The Disable-RDPRemotely function disables Remote Desktop Protocol (RDP) on one or more remote computers. It uses either CIM or WMI to perform the operation, depending on the version of PowerShell.

.PARAMETER ComputerName
Specifies the name of the computer(s) on which to disable RDP. This parameter accepts an array of strings, allowing you to specify multiple computer names.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.String. The function returns a string indicating the success or failure of the operation.

.NOTES
- This function requires administrative privileges on the remote computers.
- If the computer is running PowerShell version 6 or later, CIM is used to disable RDP. Otherwise, WMI is used.
- For more information, visit the help URI: http://scripts.lukeleigh.com/

.EXAMPLE
Disable-RDPRemotely -ComputerName 'Server01', 'Server02'
Disables RDP on the computers 'Server01' and 'Server02'.

.EXAMPLE
'Desktop01', 'Desktop02' | Disable-RDPRemotely
Disables RDP on the computers 'Desktop01' and 'Desktop02' using pipeline input.

#>
function Disable-RDPRemotely {
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
        # Disable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 0; ModifyFirewallException = 0 } -ComputerName $Computer
        }
        # Disable RDP using WMI
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(0, 0)
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Disable-RDPRemotely.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-RDPRemotely.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

