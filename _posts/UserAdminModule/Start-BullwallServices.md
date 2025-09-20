---
layout: post
title: Start-BullwallServices.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Start-BullwallServices/
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

Starts the Ransomcare services in a specific order.

#### Detailed Description

This function starts the Ransomcare services in a specified order. It waits for each service to start before proceeding to start the next service. If a service fails to start, it logs an error message.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Start-RansomcareServices
```

Starts all the Ransomcare services in order, waiting for each to start before proceeding to the next.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Date] This function requires administrative privileges.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Start-RansomcareServices {
    <#
    .SYNOPSIS
        Starts the Ransomcare services in a specific order.

    .DESCRIPTION
        This function starts the Ransomcare services in a specified order. It waits for each service to start before proceeding to start the next service. If a service fails to start, it logs an error message.

    .NOTES
        Author: Luke Leigh
        Date: [Date]
        This function requires administrative privileges.

    .EXAMPLE
        Start-RansomcareServices
        Starts all the Ransomcare services in order, waiting for each to start before proceeding to the next.

    .PARAMETER None
        This function does not accept any parameters.
    #>

    [CmdletBinding()]
    param ()

    # List of Ransomcare services to be started in order
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

    foreach ($service in $services) {
        try {
            Write-Verbose "Attempting to start $service..."
            Start-Service -Name $service -ErrorAction Stop
            
            # Wait for the service to start
            do {
                Start-Sleep -Milliseconds 500
                $status = (Get-Service -Name $service).Status
            } until ($status -eq "Running")

            Write-Output "$service - started successfully."
            Write-Verbose "$service is now running."
        }
        catch {
            Write-Error "Failed to start {$service}: $($_.Exception.Message)"
        }
    }
}

# Example usage:
# Start-RansomcareServices -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Start-BullwallServices.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-BullwallServices.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

