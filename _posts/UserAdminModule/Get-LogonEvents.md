---
layout: post
title: Get-LogonEvents.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-LogonEvents/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- Logon Events
description: Retrieves logon events from a specified computer.
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

Retrieves logon events from a specified computer.

#### Detailed Description

The Get-LogonEvents function retrieves logon events from the Security log on a specified computer. It filters the events based on the event ID 4624, which represents successful logon events. The function returns the time the logon event occurred and the user who logged on.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LogonEvents -ComputerName "Server01"
```

Retrieves logon events from the Security log on "Server01" and displays the time and user information for each logon event.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves logon events from a specified computer.

.DESCRIPTION
    The Get-LogonEvents function retrieves logon events from the Security log on a specified computer. It filters the events based on the event ID 4624, 
    which represents successful logon events. The function returns the time the logon event occurred and the user who logged on.

.PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve logon events.

.EXAMPLE
    Get-LogonEvents -ComputerName "Server01"
    Retrieves logon events from the Security log on "Server01" and displays the time and user information for each logon event.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Get-LogonEvents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )
    
    try {
        # Retrieve logon events from the specified computer
        $events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{LogName = 'Security'; ID = 4624 } -ErrorAction Stop
        
        if ($events) {
            # Select relevant properties from each event
            $events | Select-Object -Property TimeCreated, @{Name = 'User'; Expression = { $_.Properties[5].Value } }
        }
        else {
            Write-Warning -Message "No logon events found on $ComputerName"
        }
    }
    catch {
        Write-Error -Message "Failed to retrieve logon events from $ComputerName. Error: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-LogonEvents.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LogonEvents.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

