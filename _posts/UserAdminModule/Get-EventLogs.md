---
layout: post
title: Get-EventLogs.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/logging/get-eventlogs/
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

Retrieves event logs from a specified computer.

#### Detailed Description

The Get-EventLogs function retrieves event logs from a specified computer. It uses the Get-WinEvent cmdlet to retrieve the logs and returns the log information as a collection of custom objects.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-EventLogs -ComputerName "Server01" -LogName "Application"
```

Retrieves the "Application" event log from the "Server01" computer.

**Example 2**

```powershell
Get-EventLogs -ComputerName "Server02"
```

Retrieves all event logs from the "Server02" computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Retrieves event logs from a specified computer.

.DESCRIPTION
The Get-EventLogs function retrieves event logs from a specified computer. It uses the Get-WinEvent cmdlet to retrieve the logs and returns the log information as a collection of custom objects.

.PARAMETER ComputerName
The name of the computer from which to retrieve the event logs.

.PARAMETER LogName
The name of the event log to retrieve. By default, all event logs are retrieved.

.EXAMPLE
Get-EventLogs -ComputerName "Server01" -LogName "Application"
Retrieves the "Application" event log from the "Server01" computer.

.EXAMPLE
Get-EventLogs -ComputerName "Server02"
Retrieves all event logs from the "Server02" computer.

#>
function Get-EventLogs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $false)]
        [string]$LogName = '*'
    )

    try {
        $logs = Get-WinEvent -ComputerName $ComputerName -ListLog $LogName -ErrorAction Stop
        $logs | ForEach-Object {
            [PSCustomObject]@{
                LogName            = $_.LogName
                LogType            = $_.LogType
                LogIsolation       = $_.LogIsolation
                IsEnabled          = $_.IsEnabled
                IsClassicLog       = $_.IsClassicLog
                LogFilePath        = $_.LogFilePath
                LogMode            = $_.LogMode
                MaximumSizeInBytes = $_.MaximumSizeInBytes
                RecordCount        = $_.RecordCount
                OldestRecordNumber = $_.OldestRecordNumber
                ProviderNames      = $_.ProviderNames
            }
        }
    }
    catch {
        Write-Output $_.Exception.Message
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/Get-EventLogs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-EventLogs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

