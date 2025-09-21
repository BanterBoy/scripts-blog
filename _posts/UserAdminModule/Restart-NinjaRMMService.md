---
layout: post
title: Restart-NinjaRMMService.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/restart-ninjarmmservice/
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

Restarts the NinjaRMM service and related processes.

#### Detailed Description

This function stops the NinjaRMMAgentPatcher process and the NinjaRMMAgent service, then restarts the NinjaRMMAgent service. It includes error handling to manage cases where the process or service is not found.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Restart-NinjaRMMService
```

This example stops and restarts the NinjaRMM service and related processes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Restart-NinjaRMMService {

    <#
    .SYNOPSIS
        Restarts the NinjaRMM service and related processes.

    .DESCRIPTION
        This function stops the NinjaRMMAgentPatcher process and the NinjaRMMAgent service,
        then restarts the NinjaRMMAgent service. It includes error handling to manage cases
        where the process or service is not found.

    .PARAMETER None
        This function does not require any parameters.

    .EXAMPLE
        Restart-NinjaRMMService
        This example stops and restarts the NinjaRMM service and related processes.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param ()

    # Attempt to stop the Ninja Patcher process
    try {
        Write-Output "Stopping Ninja Patcher process"
        Write-Verbose "Attempting to stop process: NinjaRMMAgentPatcher"
        Get-Process -Name NinjaRMMAgentPatcher -ErrorAction Stop | Stop-Process -Force
        Write-Verbose "Ninja Patcher process stopped successfully"
    }
    catch {
        Write-Output "Ninja process not found"
        Write-Verbose "NinjaRMMAgentPatcher process not found"
    }

    # Attempt to stop and restart the Ninja services
    try {
        Write-Output "Stopping Ninja services"
        Write-Verbose "Attempting to stop service: NinjaRMMAgent"
        Get-Service -Name NinjaRMMAgent -ErrorAction Stop | Stop-Service -Force -PassThru
        Write-Output "Ninja services stopped"
        Write-Verbose "NinjaRMMAgent service stopped successfully"

        Start-Sleep -Seconds 5

        Write-Verbose "Attempting to start service: NinjaRMMAgent"
        Start-Service -Name NinjaRMMAgent -PassThru
        Write-Output "Ninja services started"
        Write-Verbose "NinjaRMMAgent service started successfully"
    }
    catch {
        Write-Output "Ninja services not found"
        Write-Verbose "NinjaRMMAgent service not found"
    }
}

# Example Usage:
# Restart-NinjaRMMService -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Restart-NinjaRMMService.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Restart-NinjaRMMService.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

