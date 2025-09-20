---
layout: post
title: Get-VMInfoCustom.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-VMInfoCustom/
categories:
  - UserAdminModule
  - Virtualization
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

Retrieves information about a virtual machine.

#### Detailed Description

The Get-VMInfoCustom function retrieves information about a virtual machine, such as its name, power state, number of CPUs, memory size, guest operating system, IP address, datastore, and network.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-VMInfoCustom -ServerName "VM1"
```

Retrieves information about the virtual machine with the name "VM1".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves information about a virtual machine.

.DESCRIPTION
The Get-VMInfoCustom function retrieves information about a virtual machine, such as its name, power state, number of CPUs, memory size, guest operating system, IP address, datastore, and network.

.PARAMETER ServerName
The name of the virtual machine to retrieve information for.

.EXAMPLE
Get-VMInfoCustom -ServerName "VM1"
Retrieves information about the virtual machine with the name "VM1".

#>

function Get-VMInfoCustom {
    Param(
        [parameter()]
        [string]$ServerName
    )
    Get-View -ViewType VirtualMachine -Filter @{"Name" = "$($ServerName)" } | Select-Object -property Name, @{N = "PowerState"; E = { $_.Runtime.PowerState } }, @{N = "NumCpu"; E = { $_.Config.Hardware.NumCPU } }, @{N = "MemoryMB"; E = { $_.Config.Hardware.MemoryMB } }, @{N = "GuestOS"; E = { $_.Config.GuestFullName } }, @{N = "IPAddress"; E = { ($_.Guest.Net | Where-Object { $_.DeviceConfigId -eq 4000 }).IpAddress } }, @{N = "Datastore"; E = { (Get-View -Id $_.Datastore).Name } }, @{N = "Network"; E = { (Get-View -Id $_.Network).Name } }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Virtualization/Public/Get-VMInfoCustom.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-VMInfoCustom.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

