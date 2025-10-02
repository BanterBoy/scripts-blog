---
layout: post
title: Stop-ScheduledScript.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/stop-scheduledscript/
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

Stops a scheduled task by its name.

#### Detailed Description

The Stop-ScheduledScript function stops a scheduled task by its name. It first checks if the task exists using the Get-ScheduledTask cmdlet, and if found, stops the task using the Stop-ScheduledTask cmdlet.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Stop-ScheduledScript -TaskName "MyTask"
```

Stops the scheduled task named "MyTask".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Stops a scheduled task by its name.

.DESCRIPTION
    The Stop-ScheduledScript function stops a scheduled task by its name. It first checks if the task exists using the Get-ScheduledTask cmdlet, and if found, stops the task using the Stop-ScheduledTask cmdlet.

.PARAMETER TaskName
    Specifies the name of the scheduled task to stop.

.EXAMPLE
    Stop-ScheduledScript -TaskName "MyTask"
    Stops the scheduled task named "MyTask".

.INPUTS
    System.String

.OUTPUTS
    None

.NOTES
    Author: Your Name
    Date:   Current Date

#>
#requires -PSEdition Desktop
function Stop-ScheduledScript {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TaskName
    )

    if ($PSCmdlet.ShouldProcess("$TaskName", "Stop scheduled task")) {
        try {
            if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
                Stop-ScheduledTask -TaskName $TaskName
            }
            else {
                Write-Error "No scheduled task found with the name $TaskName"
            }
        }
        catch {
            Write-Error "Failed to stop scheduled task: $_"
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Stop-ScheduledScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-ScheduledScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

