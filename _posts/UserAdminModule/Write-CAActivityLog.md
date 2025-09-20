---
layout: post
title: Write-CAActivityLog.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Write-CAActivityLog/
categories:
- UserAdminModule
- PKICertificateTools
tags:
- PowerShell
- User Admin Module
- Certificate Authority Activity Log
description: Writes a log entry to a specified log file with a timestamp.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Writes a log entry to a specified log file with a timestamp.

#### Detailed Description

The `Write-CAActivityLog` function automates the process of writing log entries to a specified log file. It ensures the log directory exists, appends the log entry with a timestamp, and supports verbose output for additional context. If the log directory does not exist, it is created automatically.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Write-CAActivityLog -Message "CA backup completed successfully."
```

This example writes the message "CA backup completed successfully." to the default log file.

**Example 2**

```powershell
Write-CAActivityLog -Message "Failed to revoke certificate." -LogPath "D:\Logs\CAActivity.log"
```

This example writes the message "Failed to revoke certificate." to the specified log file `D:\Logs\CAActivity.log`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: None

REQUIREMENTS

- **Write Permissions**: The user running this function must have write permissions to the specified log file and its directory.

- **Valid Log Path**: The specified log path must be accessible and valid.

BEST PRACTICES

- **Centralized Logging**: Use a centralized and secure location for log files to ensure they are accessible for auditing and troubleshooting.

- **Log Rotation**: Implement log rotation or archiving to prevent the log file from growing too large over time.

- **Error Handling**: Monitor warnings for any failures to write to the log file and address permission or path issues promptly.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Writes a log entry to a specified log file with a timestamp.

    .DESCRIPTION
    The `Write-CAActivityLog` function automates the process of writing log entries to a specified log file.
    It ensures the log directory exists, appends the log entry with a timestamp, and supports verbose output for additional context.
    If the log directory does not exist, it is created automatically.

    .PARAMETER Message
    Specifies the message to be logged. This parameter is mandatory.

    .PARAMETER LogPath
    Specifies the path to the log file where the message will be written. If not provided, the default path is `C:\CA-Logs\activity.log`.

    .EXAMPLE
    Write-CAActivityLog -Message "CA backup completed successfully."
    This example writes the message "CA backup completed successfully." to the default log file.

    .EXAMPLE
    Write-CAActivityLog -Message "Failed to revoke certificate." -LogPath "D:\Logs\CAActivity.log"
    This example writes the message "Failed to revoke certificate." to the specified log file `D:\Logs\CAActivity.log`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: None

    REQUIREMENTS
    - **Write Permissions**: The user running this function must have write permissions to the specified log file and its directory.
    - **Valid Log Path**: The specified log path must be accessible and valid.

    BEST PRACTICES
    - **Centralized Logging**: Use a centralized and secure location for log files to ensure they are accessible for auditing and troubleshooting.
    - **Log Rotation**: Implement log rotation or archiving to prevent the log file from growing too large over time.
    - **Error Handling**: Monitor warnings for any failures to write to the log file and address permission or path issues promptly.

#>

function Write-CAActivityLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [string]$LogPath = "C:\CA-Logs\activity.log" # Updated default log path to a more generic location
    )
    try {
        # Ensure the log directory exists
        if (-not (Test-Path (Split-Path $LogPath))) {
            New-Item -Path (Split-Path $LogPath) -ItemType Directory -Force | Out-Null
        }

        # Write the log entry with a timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp`t$Message" | Out-File -FilePath $LogPath -Append -Encoding UTF8
        Write-Verbose $Message
    }
    catch {
        Write-Warning "Failed to write to log file: $LogPath. Error: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Write-CAActivityLog.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Write-CAActivityLog.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

