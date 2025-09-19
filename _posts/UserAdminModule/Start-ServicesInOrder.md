---
layout: post
title: Start-ServicesInOrder.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Start-ServicesInOrder/
categories:
  - UserAdminModule
  - ProcessServiceSchedules
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

Starts a list of services in the order they are provided.

#### Detailed Description

This function starts a list of services in the order they are provided. It waits for each service to start before moving on to the next one.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Start-ServicesInOrder -ServiceNames "Service1", "Service2", "Service3"
```

Starts Service1, waits for it to start, then starts Service2, waits for it to start, then starts Service3.

**Example 2**

```powershell
$services = @(
```

"Ransomcare Admin Service", "Ransomcare Accumulative Sensors Service", "Ransomcare Database Service", "Ransomcare Hub Service", "Ransomcare ML Service", "Ransomcare Share Service", "Ransomcare Sharepoint Service", "Ransomcare Validation Service" ) Start-Services -ServiceNames $services

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Date: Unknown

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Start-ServicesInOder {

    <#
    .SYNOPSIS
    Starts a list of services in the order they are provided.

    .DESCRIPTION
    This function starts a list of services in the order they are provided. It waits for each service to start before moving on to the next one.

    .PARAMETER ServiceNames
    The names of the services to start.

    .EXAMPLE
    Start-ServicesInOrder -ServiceNames "Service1", "Service2", "Service3"
    Starts Service1, waits for it to start, then starts Service2, waits for it to start, then starts Service3.

    .EXAMPLE
    $services = @(
        "Ransomcare Admin Service",
        "Ransomcare Accumulative Sensors Service",
        "Ransomcare Database Service",
        "Ransomcare Hub Service",
        "Ransomcare ML Service",
        "Ransomcare Share Service",
        "Ransomcare Sharepoint Service",
        "Ransomcare Validation Service"
    )

    Start-Services -ServiceNames $services

    .NOTES
    Author: Unknown
    Date: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ServiceNames
    )

    foreach ($service in $ServiceNames) {
        try {
            Start-Service -Name $service -ErrorAction Stop
            do {
                Start-Sleep -Milliseconds 500
                $status = (Get-Service -Name $service).Status
            } until ($status -eq "Running")
            Write-Output "$service - started successfully."
        }
        catch {
            Write-Output "Failed to start $service - $($_.Exception.Message)"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Start-ServicesInOrder.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-ServicesInOrder.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

