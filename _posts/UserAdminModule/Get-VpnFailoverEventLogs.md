---
layout: post
title: Get-VpnFailoverEventLogs.ps1
date: 2025-09-19
permalink: /useradminmodule/security/get-vpnfailovereventlogs/
categories:
  - UserAdminModule
  - Security
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

Retrieves the event logs created by the Switch-VpnFailover function.

#### Detailed Description

The Get-VpnFailoverEventLogs function retrieves event log entries from the "Application" log where the source is "Switch-VpnFailover".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-VpnFailoverEventLogs
```

Retrieves all event logs created by the Switch-VpnFailover function in the past 7 days.

**Example 2**

```powershell
Get-VpnFailoverEventLogs -StartTime (Get-Date).AddDays(-1)
```

Retrieves event logs created by the Switch-VpnFailover function in the past day.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-VpnFailoverEventLogs {
    <#
    .SYNOPSIS
    Retrieves the event logs created by the Switch-VpnFailover function.

    .DESCRIPTION
    The Get-VpnFailoverEventLogs function retrieves event log entries from the "Application" log where the source is "Switch-VpnFailover".

    .PARAMETER StartTime
    The start time for filtering event logs. Only events after this time will be retrieved. Default is 7 days ago.

    .PARAMETER EndTime
    The end time for filtering event logs. Only events before this time will be retrieved. Default is the current time.

    .INPUTS
    None. This function does not accept pipeline input.

    .OUTPUTS
    System.Diagnostics.EventLogEntry. This function outputs event log entries.

    .EXAMPLE
    Get-VpnFailoverEventLogs
    Retrieves all event logs created by the Switch-VpnFailover function in the past 7 days.

    .EXAMPLE
    Get-VpnFailoverEventLogs -StartTime (Get-Date).AddDays(-1)
    Retrieves event logs created by the Switch-VpnFailover function in the past day.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Specify the start time for filtering event logs.")]
        [DateTime]$StartTime = (Get-Date).AddDays(-7),

        [Parameter(Mandatory = $false, HelpMessage = "Specify the end time for filtering event logs.")]
        [DateTime]$EndTime = (Get-Date)
    )

    process {
        try {
            # Get event logs from the Application log with the source "Switch-VpnFailover"
            Get-EventLog -LogName Application -Source "Switch-VpnFailover" |
            Where-Object { $_.TimeGenerated -ge $StartTime -and $_.TimeGenerated -le $EndTime }
        }
        catch {
            Write-Error "Failed to retrieve event logs: $_"
        }
    }
}

# Example usage:
# Get-VpnFailoverEventLogs
# Get-VpnFailoverEventLogs -StartTime (Get-Date).AddDays(-1)
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Get-VpnFailoverEventLogs.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-VpnFailoverEventLogs.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

