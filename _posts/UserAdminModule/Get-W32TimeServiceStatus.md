---
layout: post
title: Get-W32TimeServiceStatus.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-W32TimeServiceStatus/
categories:
  - UserAdminModule
  - Utilities
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

Retrieves the status of the W32Time service on a specified computer.

#### Detailed Description

The Get-W32TimeServiceStatus function retrieves the status of the W32Time service on a specified computer. It uses the Get-Service cmdlet to get the service information and returns an object with the computer name, service name, and service status.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-W32TimeServiceStatus -ComputerName "Server01"
```

Retrieves the status of the W32Time service on the computer named "Server01".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires administrative privileges to retrieve the service status on remote computers.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the status of the W32Time service on a specified computer.

.DESCRIPTION
The Get-W32TimeServiceStatus function retrieves the status of the W32Time service on a specified computer. It uses the Get-Service cmdlet to get the service information and returns an object with the computer name, service name, and service status.

.PARAMETER ComputerName
Specifies the name of the computer to retrieve the W32Time service status from. If not specified, the local computer name is used.

.EXAMPLE
Get-W32TimeServiceStatus -ComputerName "Server01"
Retrieves the status of the W32Time service on the computer named "Server01".

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject. The function returns an object with the following properties:
- ComputerName: The name of the computer.
- ServiceName: The name of the W32Time service.
- ServiceStatus: The status of the W32Time service.

.NOTES
This function requires administrative privileges to retrieve the service status on remote computers.

.LINK
Get-Service
#>

function Get-W32TimeServiceStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $service = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-Service -Name "w32time" }
    } catch {
        Write-Error "Failed to get service status: $_"
        return
    }

    $outputObject = New-Object PSObject

    $outputObject | Add-Member -NotePropertyName "ComputerName" -NotePropertyValue $ComputerName
    $outputObject | Add-Member -NotePropertyName "ServiceName" -NotePropertyValue $service.Name
    $outputObject | Add-Member -NotePropertyName "ServiceStatus" -NotePropertyValue $service.Status

    return $outputObject
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-W32TimeServiceStatus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-W32TimeServiceStatus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

