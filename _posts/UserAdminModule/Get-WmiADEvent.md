---
layout: post
title: Get-WmiADEvent.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-WmiADEvent/
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

Retrieves WMI events based on the specified query.

#### Detailed Description

The Get-WmiADEvent function retrieves WMI events based on the specified query. It uses the System.Management namespace to create a WMI event watcher and waits for events to occur. When an event is received, it outputs the event details.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
```

Get-WmiADEvent -query $query This example retrieves all instance creation events for Active Directory user objects within the last 10 seconds.

**Example 2**

```powershell
$query = "Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
```

Get-WmiADEvent -query $query This example retrieves all instance modification events for Active Directory computer objects within the last 10 seconds.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves WMI events based on the specified query.

.DESCRIPTION
    The Get-WmiADEvent function retrieves WMI events based on the specified query. It uses the System.Management namespace to create a WMI event watcher and waits for events to occur. When an event is received, it outputs the event details.

.PARAMETER query
    The WMI query string used to filter the events.

.EXAMPLE
    $query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
    Get-WmiADEvent -query $query

    This example retrieves all instance creation events for Active Directory user objects within the last 10 seconds.

.EXAMPLE
    $query = "Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
    Get-WmiADEvent -query $query

    This example retrieves all instance modification events for Active Directory computer objects within the last 10 seconds.
#>

Function Get-WmiADEvent {
    Param([string]$query)
  
    $Path = "root\directory\ldap"
    $EventQuery = New-Object System.Management.WQLEventQuery $query
    $Scope = New-Object System.Management.ManagementScope $Path
    $Watcher = New-Object System.Management.ManagementEventWatcher $Scope, $EventQuery
    $Options = New-Object System.Management.EventWatcherOptions
    $Options.TimeOut = [timespan]"0.0:0:1"
    $Watcher.Options = $Options
    Write-Output "("Waiting for events in response to: { 0 }" -F $($EventQuery.querystring))"
    $Watcher.Start()
    while ($true) {
        trap [System.Management.ManagementException] { continue }
  
        $Evt = $Watcher.WaitForNextEvent()
        if ($Evt) {
            $Evt.TargetInstance | Select-Object *
            Clear-Variable evt
        }
    }
}
  
# Sample usage

# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_GROUP'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
# Get-WmiADEvent $query
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/Get-WmiADEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-WmiADEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

