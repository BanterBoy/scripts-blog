---
layout: post
title: Remove-ScheduledScript.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/remove-scheduledscript/
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

Removes a scheduled task from specified computers.

#### Detailed Description

The Remove-ScheduledScript function removes a scheduled task from specified computers. It checks if the task exists and unregisters it if found. If the task is not found, it displays an error message.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-ScheduledScript -TaskName "MyTask" -ComputerName "RemoteComputer1", "RemoteComputer2"
```

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

**Example 2**

```powershell
"RemoteComputer1", "RemoteComputer2" | Remove-ScheduledScript -TaskName "MyTask"
```

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

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
Removes a scheduled task from specified computers.

.DESCRIPTION
The Remove-ScheduledScript function removes a scheduled task from specified computers. It checks if the task exists and unregisters it if found. If the task is not found, it displays an error message.

.PARAMETER TaskName
The name of the scheduled task to be removed.

.PARAMETER ComputerName
The names of the computers from which the scheduled task should be removed. The default value is the local computer.

.PARAMETER Credential
Specifies a user account that has permission to perform the operation on the remote computers. If not specified, the current user's credentials are used.

.EXAMPLE
Remove-ScheduledScript -TaskName "MyTask" -ComputerName "RemoteComputer1", "RemoteComputer2"

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

.EXAMPLE
"RemoteComputer1", "RemoteComputer2" | Remove-ScheduledScript -TaskName "MyTask"

This example removes the scheduled task named "MyTask" from the remote computers named "RemoteComputer1" and "RemoteComputer2".

.INPUTS
System.String.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Today's Date

.LINK
https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/unregister-scheduledtask?view=windowsserver2019-ps
#>
function Remove-ScheduledScript {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $TaskName,
        
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {
        foreach ($computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$TaskName on $computer", "Remove scheduled task")) {
                $scriptBlock = {
                    param ($TaskName)
                    try {
                        if (Get-ScheduledTask -TaskName $TaskName -TaskPath \ -ErrorAction SilentlyContinue) {
                            Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false
                        }
                        else {
                            Write-Error "No scheduled task found with the name $TaskName"
                        }
                    }
                    catch {
                        Write-Error "Failed to remove scheduled task: $_"
                    }
                }

                if ($computer -eq $env:COMPUTERNAME) {
                    & $scriptBlock -TaskName $TaskName
                }
                else {
                    $sessionParams = @{
                        ComputerName = $computer
                    }
                    if ($Credential) {
                        $sessionParams.Credential = $Credential
                    }
                    $session = New-PSSession @sessionParams
                    Invoke-Command -Session $session -ScriptBlock $scriptBlock -ArgumentList $TaskName
                    Remove-PSSession -Session $session
                }
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Remove-ScheduledScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-ScheduledScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

