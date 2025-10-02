---
layout: post
title: Get-ShutdownExample.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shutdowncommands/get-shutdownexample/
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

Displays an example PowerShell script for scheduling remote server shutdowns.

#### Detailed Description

This function outputs a sample script showing how to import servers from a CSV and schedule shutdowns with error handling.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ShutdownExample
```

Displays the shutdown scheduling example code in the console.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function Get-ShutdownExample {
    <#
    .SYNOPSIS
        Displays an example PowerShell script for scheduling remote server shutdowns.
    
    .DESCRIPTION
        This function outputs a sample script showing how to import servers from a CSV
        and schedule shutdowns with error handling.
    
    .EXAMPLE
        Get-ShutdownExample
        Displays the shutdown scheduling example code in the console.
    #>

    [CmdletBinding()]
    param()

    $scriptBlock = @'
# Import server list from CSV
$results = Import-Csv -Path "C:\GitRepos\ShutdownServers.csv"

# Array to store failed shutdowns
$failedShutdowns = @()

# Schedule shutdown for each server
foreach ($entry in $results) {
    $computer = $entry.ServerName
    try {
        Start-RemoteComputerShutdownSchedule -ComputerName $computer `
            -ShutdownTime (Get-Date -Date "16:00") `
            -Action "Shutdown" `
            -Comment "Scheduled shutdown at 4pm" `
            -Force
        Write-Host "Shutdown scheduled for $computer"
    }
    catch {
        Write-Warning "Failed to schedule shutdown for ${$computer}: $_"
        $failedShutdowns += $computer
    }
}

# Report failed shutdowns
if ($failedShutdowns.Count -gt 0) {
    Write-Host "`nThe following servers failed to schedule shutdown:"
    $failedShutdowns | ForEach-Object { Write-Host "- $_" }
} else {
    Write-Host "`nAll shutdowns scheduled successfully."
}
'@

    $scriptBlock
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Get-ShutdownExample.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ShutdownExample.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

