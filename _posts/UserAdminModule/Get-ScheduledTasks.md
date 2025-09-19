---
layout: post
title: Get-ScheduledTasks.ps1
description: "Enumerates scheduled tasks on remote servers with filtering support."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ScheduledTasks/
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

Retrieves scheduled tasks from one or more servers.

#### Detailed Description

The Get-ScheduledTasks function retrieves scheduled tasks from one or more servers. It uses the ScheduledTasks module to interact with the Task Scheduler service on the specified servers. The function supports filtering tasks based on their state, task name, task path, description, author, and principal.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ScheduledTasks -ComputerName "Server1", "Server2" -State "Ready"
```

Retrieves all scheduled tasks in the "Ready" state from Server1 and Server2.

**Example 2**

```powershell
Get-ScheduledTasks -ComputerName "Server1" -State "Disabled"
```

Retrieves all scheduled tasks in the "Disabled" state from Server1.

**Example 3**

```powershell
Get-ScheduledTasks -ComputerName "Server1" -TaskName "*Update*"
```

Retrieves all scheduled tasks with names containing "Update" from Server1.

**Example 4**

```powershell
Get-ScheduledTasks -ComputerName "Server1" -TaskPath "\Microsoft\Windows\*"
```

Retrieves all scheduled tasks in the "\Microsoft\Windows\" path from Server1.

**Example 5**

```powershell
Get-ScheduledTasks -ComputerName "Server1" -Author "Microsoft Corporation"
```

Retrieves all scheduled tasks authored by "Microsoft Corporation" from Server1.

**Example 6**

```powershell
Get-ScheduledTasks -ComputerName "Server1" -Principal "SYSTEM"
```

Retrieves all scheduled tasks run as "SYSTEM" from Server1.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the ScheduledTasks module to be installed. If the module is not installed, an error message is displayed.

- The function uses Test-Connection cmdlet to check the connectivity to each server before retrieving tasks.

- The function returns a custom object with detailed properties for each task.

- A custom format file (ScheduledTasks.Format.ps1xml) is used for better display of the results.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves scheduled tasks from one or more servers.

.DESCRIPTION
    The Get-ScheduledTasks function retrieves scheduled tasks from one or more servers. It uses the ScheduledTasks module 
    to interact with the Task Scheduler service on the specified servers. The function supports filtering tasks based on 
    their state, task name, task path, description, author, and principal.

.PARAMETER ComputerName
    Specifies the servers from which to retrieve scheduled tasks. By default, the function retrieves tasks from the local computer.

.PARAMETER State
    Specifies the state of the tasks to retrieve. The valid values are "Ready", "Disabled", and "Running". By default, all tasks are retrieved regardless of their state.

.PARAMETER TaskName
    Specifies the name of the tasks to retrieve. Supports wildcards.

.PARAMETER TaskPath
    Specifies the path of the tasks to retrieve. Supports wildcards.

.PARAMETER TaskDescription
    Specifies the description of the tasks to retrieve. Supports wildcards.

.PARAMETER Author
    Specifies the author of the tasks to retrieve. Supports wildcards.

.PARAMETER Principal
    Specifies the principal (user) of the tasks to retrieve. Supports wildcards.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1", "Server2" -State "Ready"
    Retrieves all scheduled tasks in the "Ready" state from Server1 and Server2.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -State "Disabled"
    Retrieves all scheduled tasks in the "Disabled" state from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -TaskName "*Update*"
    Retrieves all scheduled tasks with names containing "Update" from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -TaskPath "\Microsoft\Windows\*"
    Retrieves all scheduled tasks in the "\Microsoft\Windows\" path from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -Author "Microsoft Corporation"
    Retrieves all scheduled tasks authored by "Microsoft Corporation" from Server1.

.EXAMPLE
    Get-ScheduledTasks -ComputerName "Server1" -Principal "SYSTEM"
    Retrieves all scheduled tasks run as "SYSTEM" from Server1.

.NOTES
    - This function requires the ScheduledTasks module to be installed. If the module is not installed, an error message is displayed.
    - The function uses Test-Connection cmdlet to check the connectivity to each server before retrieving tasks.
    - The function returns a custom object with detailed properties for each task.
    - A custom format file (ScheduledTasks.Format.ps1xml) is used for better display of the results.

.LINK
    http://scripts.lukeleigh.com/
#>
function Get-ScheduledTasks {
    [CmdletBinding()]        
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        [Parameter(Position = 1, Mandatory = $false)]
        [ValidateSet("Ready", "Disabled", "Running")]
        [string]$State = $null,
        
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$TaskName = "*",
        
        [Parameter(Position = 3, Mandatory = $false)]
        [string]$TaskPath = "*",

        [Parameter(Position = 4, Mandatory = $false)]
        [string]$TaskDescription = "*",

        [Parameter(Position = 5, Mandatory = $false)]
        [string]$Author = "*",

        [Parameter(Position = 6, Mandatory = $false)]
        [string]$Principal = "*"
    ) 
    
    begin {
    
        Update-FormatData -PrependPath "$PSScriptRoot\ScheduledTasks.Format.ps1xml"

        $ErrorActionPreference = "Stop"
  
        try {
            Import-Module ScheduledTasks -ErrorAction Stop
        }
        catch {
            Write-Warning "Scheduled Tasks module not installed: $_"
            return
        }
    }
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose "Processing $Computer"
      
            if (!(Test-Connection -ComputerName $Computer -BufferSize 16 -Count 1 -ErrorAction SilentlyContinue -Quiet)) {
                Write-Warning "Failed to connect to $Computer"
            }
            else {
                $TasksArray = @()
  
                try {
                    $Tasks = Get-ScheduledTask -CimSession $Computer | Where-Object {
                    ($_.State -eq $State -or !$State) -and
                    ($_.TaskName -like $TaskName) -and
                    ($_.TaskPath -like $TaskPath) -and
                    ($_.Description -like $TaskDescription) -and
                    ($_.Author -like $Author) -and
                    ($_.Principal.UserId -like $Principal)
                    }
                }
                catch {
                    Write-Warning "Failed to retrieve tasks from {$Computer}: $_"
                    continue
                }
 
                if ($Tasks) {
                    $Tasks | ForEach-Object {
                        $TaskInfo = Get-ScheduledTaskInfo -InputObject $_ -ErrorAction SilentlyContinue
                        $Action = $_.Actions | ForEach-Object { $_.Arguments }
                        $Triggers = $_.Triggers | ForEach-Object { $_.TriggerType }

                        $Object = [PSCustomObject]@{
                            Server      = $Computer
                            Name        = $_.TaskName
                            RunAsUser   = $_.Principal.UserId
                            State       = $_.State
                            TaskName    = $_.TaskName
                            Author      = $_.Author
                            LastRunTime = $TaskInfo.LastRunTime
                            NextRunTime = $TaskInfo.NextRunTime
                            TaskPath    = $_.TaskPath
                            Description = $_.Description
                            Action      = $Action -join ", "
                            Triggers    = $Triggers -join ", "
                        }
                        $TasksArray += $Object
                    }
                    $TasksArray
                }
                else {
                    Write-Warning "No tasks found on $Computer"
                }
            }
        }
    }

    end {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Get-ScheduledTasks.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ScheduledTasks.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

