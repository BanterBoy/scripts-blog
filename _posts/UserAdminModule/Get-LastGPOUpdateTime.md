---
layout: post
title: Get-LastGPOUpdateTime.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-LastGPOUpdateTime/
categories:
  - UserAdminModule
  - ADFunctions
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

Retrieves the last Group Policy update time for a specified computer.

#### Detailed Description

The Get-LastGPOUpdateTime function queries the registry of a remote or local computer to retrieve the last Group Policy update time. It calculates the time span since the last update and returns the result as a custom object.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LastGPOUpdateTime -ComputerName "Computer01"
```

This example retrieves the last Group Policy update time for the computer named "Computer01".

**Example 2**

```powershell
Get-LastGPOUpdateTime
```

This example retrieves the last Group Policy update time for the local computer.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date Version: 1.0

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the last Group Policy update time for a specified computer.

.DESCRIPTION
The Get-LastGPOUpdateTime function queries the registry of a remote or local computer to retrieve the last Group Policy update time. It calculates the time span since the last update and returns the result as a custom object.

.PARAMETER ComputerName
The name of the computer to query. If not specified, the function will query the local computer.

.EXAMPLE
Get-LastGPOUpdateTime -ComputerName "Computer01"
This example retrieves the last Group Policy update time for the computer named "Computer01".

.EXAMPLE
Get-LastGPOUpdateTime
This example retrieves the last Group Policy update time for the local computer.

.OUTPUTS
The function returns a custom object with the following properties:
- ComputerName: The name of the computer.
- LastGPOUpdateTime: The date and time of the last Group Policy update.
- DaysSinceLastUpdate: The number of days since the last update.
- TimeSinceLastUpdate: The time span since the last update in the format "hours, minutes, seconds".

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>
function Get-LastGPOUpdateTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {
        $gpResult = if ($ComputerName -eq $env:COMPUTERNAME) {
            # Local computer
            [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
        } else {
            # Remote computer
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            }
        }
        $lastGPUpdateDate = Get-Date ($gpResult)
        $timeSinceLastUpdate = New-TimeSpan -Start $lastGPUpdateDate -End (Get-Date)

        $result = [PSCustomObject]@{
            ComputerName         = $ComputerName
            LastGPOUpdateTime    = $lastGPUpdateDate
            DaysSinceLastUpdate  = $timeSinceLastUpdate.Days
            TimeSinceLastUpdate  = ("{0} hours, {1} minutes, {2} seconds" -f $timeSinceLastUpdate.Hours, $timeSinceLastUpdate.Minutes, $timeSinceLastUpdate.Seconds)
        }

        return $result
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Verbose "An error occurred while querying the Group Policy update time on $($ComputerName): $errMsg"

        $errorDetails = [PSCustomObject]@{
            ComputerName = $ComputerName
            Error        = $errMsg
        }

        return $errorDetails
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-LastGPOUpdateTime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastGPOUpdateTime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

