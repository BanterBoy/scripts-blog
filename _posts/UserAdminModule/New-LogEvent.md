---
layout: post
title: New-LogEvent.ps1
date: 2025-09-19
permalink: /useradminmodule/logging/new-logevent/
categories:
  - UserAdminModule
  - Logging
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

A function to log events.

#### Detailed Description

This function writes an event to the event log.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Log-Event -message "This is a test event."
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function New-LogEvent {
    <#
    .SYNOPSIS
    A function to log events.

    .DESCRIPTION
    This function writes an event to the event log.

    .PARAMETER logName
    The name of the log where the event will be written. Default is "NinjaOneDeployments".

    .PARAMETER source
    The source of the event. Default is "NinjaOneScripts".

    .PARAMETER entryType
    The type of the event. Must be one of "Error", "Warning", "Information", "SuccessAudit", "FailureAudit". Default is "Information".

    .PARAMETER eventId
    The ID of the event. Default is 1847.

    .PARAMETER message
    The message of the event. This parameter is mandatory.

    .EXAMPLE
    Log-Event -message "This is a test event."
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$logName = "NinjaOneDeployments",

        [Parameter(Mandatory = $false)]
        [string]$source = "NinjaOneScripts",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Error", "Warning", "Information", "SuccessAudit", "FailureAudit")]
        [string]$entryType = "Information",
        
        [Parameter(Mandatory = $false)]
        [int]$eventId = 1847,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$message
    )

    try {
        Write-EventLog -LogName $logName -Source $source -EntryType $entryType -EventId $eventId -Message $message
    }
    catch {
        Write-Error "Failed to write to event log: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/New-LogEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-LogEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

