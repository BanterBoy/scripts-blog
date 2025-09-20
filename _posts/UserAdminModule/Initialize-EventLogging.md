---
layout: post
title: Initialize-EventLogging.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Initialize-EventLogging/
categories:
- UserAdminModule
- Logging
tags:
- PowerShell
- User Admin Module
- Event Logging
description: Initializes event logging by creating a new event log source if it does
  not exist.
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

Initializes event logging by creating a new event log source if it does not exist.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Last Edit: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Initialize-EventLogging {
    <#
    .SYNOPSIS
        Initializes event logging by creating a new event log source if it does not exist.
    
    .PARAMETER logName
        Specifies the name of the event log. The default value is "NinjaOneDeployments".
        Valid values are "Application", "System", "NinjaOneDeployments", and "AutomatedDeployment".
    
    .PARAMETER source
        Specifies the name of the event log source. The default value is "NinjaOneScripts".
        Valid values are "NinjaOneScripts" and "AutomatedDeployment".
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("Application", "System", "NinjaOneDeployments", "AutomatedDeployment")]
        [string]$logName = "NinjaOneDeployments",

        [Parameter(Mandatory = $false)]
        [ValidateSet("NinjaOneScripts", "AutomatedDeployment")]
        [string]$source = "NinjaOneScripts"
    )

    if (![string]::IsNullOrWhiteSpace($logName) -and ![string]::IsNullOrWhiteSpace($source)) {
        try {
            # Create the source if it does not exist
            if (![System.Diagnostics.EventLog]::SourceExists($source)) {
                $Message = "Initialize-EventLogging @ " + (Get-Date) + ": Creating LogSource for EventLog..."
                Write-Verbose $message
                [System.Diagnostics.EventLog]::CreateEventSource($source, $logName)
            }
            else {
                $Message = "Initialize-EventLogging @ " + (Get-Date) + ": LogSource exists already."
                Write-Verbose $message
            }
        }
        catch {
            Write-Error "An error occurred while initializing logging: $_"
        }
    }
    else {
        Write-Error "Invalid parameters. LogName and Source cannot be empty."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/Initialize-EventLogging.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Initialize-EventLogging.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

