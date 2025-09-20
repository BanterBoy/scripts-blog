---
layout: post
title: Get-TimeSource.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-TimeSource/
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

Retrieves the time source of a specified computer.

#### Detailed Description

The Get-TimeSource function retrieves the time source of a specified computer using the w32tm command-line tool. It returns a custom PSObject with the computer name and the time source.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-TimeSource -ComputerName "Server01"
```

Retrieves the time source of the computer named "Server01".

**Example 2**

```powershell
Get-TimeSource -ComputerName $env:COMPUTERNAME
```

Retrieves the time source of the local computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires administrative privileges on the target computer to retrieve the time source.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the time source of a specified computer.

.DESCRIPTION
The Get-TimeSource function retrieves the time source of a specified computer using the w32tm command-line tool. It returns a custom PSObject with the computer name and the time source.

.PARAMETER ComputerName
Specifies the name of the computer for which to retrieve the time source.

.EXAMPLE
Get-TimeSource -ComputerName "Server01"
Retrieves the time source of the computer named "Server01".

.EXAMPLE
Get-TimeSource -ComputerName $env:COMPUTERNAME
Retrieves the time source of the local computer.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSObject
A custom PSObject with the following properties:
- ComputerName: The name of the computer.
- TimeSource: The time source of the computer.

.NOTES
This function requires administrative privileges on the target computer to retrieve the time source.

.LINK
https://docs.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings

#>

function Get-TimeSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    if ([string]::IsNullOrEmpty($ComputerName)) {
        throw "ComputerName parameter cannot be empty or null"
    }

    try {
        $w32tmOutput = w32tm /query /computer:$ComputerName /source 2>&1
        if ($LASTEXITCODE -ne 0) {
            $errorMessage = "Failed to retrieve time source from $($ComputerName): $w32tmOutput"
            Write-Warning $errorMessage
            return $null
        }
        $NtpServer = $w32tmOutput.Trim()
    }
    catch {
        Write-Warning "Failed to retrieve time source from $($ComputerName): $_"
        return $null
    }

    # Create a custom PSObject to return
    $output = New-Object PSObject
    $output | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $ComputerName
    $output | Add-Member -MemberType NoteProperty -Name "TimeSource" -Value $NtpServer

    return $output
}

# Example usage
# Get-TimeSource -ComputerName $env:COMPUTERNAME
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-TimeSource.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-TimeSource.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

