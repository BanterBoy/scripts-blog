---
layout: post
title: Get-AllScheduledScripts.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-AllScheduledScripts/
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

Retrieves scheduled scripts from the local machine.

#### Detailed Description

The Get-AllScheduledScripts function retrieves all scheduled tasks on the local machine that execute PowerShell scripts.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-AllScheduledScripts
```

Retrieves all scheduled scripts on the local machine.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Current Date] Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves scheduled scripts from the local machine.

.DESCRIPTION
    The Get-AllScheduledScripts function retrieves all scheduled tasks on the local machine that execute PowerShell scripts.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Get-AllScheduledScripts

    Retrieves all scheduled scripts on the local machine.

.OUTPUTS
    System.Management.Automation.TaskScheduler.ScheduledTask[]

    This function returns an array of ScheduledTask objects representing the scheduled scripts.

.NOTES
    Author: Luke Leigh
    Date: [Current Date]
    Version: 1.0

.LINK
    [Link to any related documentation or resources]

#>
function Get-AllScheduledScripts {
    Get-ScheduledTask | Where-Object { $_.Actions.Execute -eq 'powershell.exe' } | ForEach-Object {
        $task = $_
        $taskInfo = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath

        $lastTaskResultDescription = switch ($taskInfo.LastTaskResult) {
            0 { "The operation completed successfully." }
            2147750687 { "The task is already running." }
            2147750686 { "The task will be triggered by user logon." }
            2147942402 { "The system cannot find the file specified." }
            2147942405 { "Access is denied." }
            default { "Unknown error." }
        }

        if ($taskInfo.LastTaskResult -eq 267011 -and $taskInfo.LastRunTime -eq "30/11/1999 00:00:00") {
            $lastTaskResultDescription = "New Task - Task Schedule not yet started."
        }
        elseif ($taskInfo.LastTaskResult -eq 267011) {
            $lastTaskResultDescription = "The task is currently running."
        }

        $output = New-Object PSObject
        $output | Add-Member -MemberType NoteProperty -Name "TaskName" -Value $task.TaskName
        $output | Add-Member -MemberType NoteProperty -Name "TaskPath" -Value $task.TaskPath
        $output | Add-Member -MemberType NoteProperty -Name "State" -Value $task.State
        $output | Add-Member -MemberType NoteProperty -Name "LastRunTime" -Value $taskInfo.LastRunTime
        $output | Add-Member -MemberType NoteProperty -Name "NextRunTime" -Value $taskInfo.NextRunTime
        $output | Add-Member -MemberType NoteProperty -Name "LastTaskResult" -Value $lastTaskResultDescription
        $output | Add-Member -MemberType NoteProperty -Name "NumberOfMissedRuns" -Value $taskInfo.NumberOfMissedRuns

        $output
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Get-AllScheduledScripts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AllScheduledScripts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

