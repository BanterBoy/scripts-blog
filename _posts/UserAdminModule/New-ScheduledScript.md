---
layout: post
title: New-ScheduledScript.ps1
date: 2025-09-19
permalink: /useradminmodule/processserviceschedules/new-scheduledscript/
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

Creates a new scheduled task that runs a PowerShell script.

#### Detailed Description

The New-ScheduledScript function creates a new scheduled task that runs a PowerShell script at a specified frequency and time. It uses the Register-ScheduledTask cmdlet to register the task with the Windows Task Scheduler.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-ScheduledScript -ScriptPath "C:\Scripts\MyScript.ps1" -TaskName "MyTask" -Description "My task description" -TriggerFrequency "Weekly" -TriggerTime "8am"
```

Creates a new scheduled task named "MyTask" that runs the script "C:\Scripts\MyScript.ps1" every week at 8am.

**Example 2**

```powershell
New-ScheduledScript -ComputerName "RemoteComputer" -ScriptPath "C:\Scripts\MyScript.ps1" -TaskName "RemoteTask" -Description "Remote task description" -TriggerFrequency "Daily" -TriggerTime "6am" -Credential (Get-Credential)
```

Creates a new scheduled task named "RemoteTask" that runs the script "C:\Scripts\MyScript.ps1" every day at 6am on the remote computer "RemoteComputer" using the specified credentials.

**Example 3**

```powershell
New-ScheduledScript -ScriptPath "C:\scepman\enroll-dc-certificate.ps1" -TaskName "EnrollDCCertificate" -Description "Enrolls DC Certificate" -TriggerFrequency "Daily" -TriggerTime "3am" -User "SYSTEM" -StartIn "C:\scepman" -ScriptArguments "-SCEPURL https://your-scepman-domain/dc -SCEPChallenge RequestPassword -LogToFile"
```

Creates a new scheduled task named "EnrollDCCertificate" that runs the script "C:\scepman\enroll-dc-certificate.ps1" every day at 3am with the specified arguments.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires administrative privileges to register the scheduled task with the Windows Task Scheduler.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates a new scheduled task that runs a PowerShell script.

.DESCRIPTION
The New-ScheduledScript function creates a new scheduled task that runs a PowerShell script at a specified frequency and time. It uses the Register-ScheduledTask cmdlet to register the task with the Windows Task Scheduler.

.PARAMETER ScriptPath
The path to the PowerShell script that will be executed by the scheduled task. The default value is "C:\Temp\ScheduledScript.ps1".

.PARAMETER TaskName
The name of the scheduled task. The default value is "ScheduledScript".

.PARAMETER Description
A description of the scheduled task. The default value is "ScheduledScript created by New-ScheduledScript function.".

.PARAMETER TriggerFrequency
The frequency at which the scheduled task should run. Valid values are "Daily", "Weekly", "AtStartup", "AtLogon", and "Once". The default value is "Daily".

.PARAMETER TriggerTime
The time at which the scheduled task should run. The default value is "1am".

.PARAMETER ComputerName
The name of the remote computer where the scheduled task will be created. If not specified, the task will be created on the local computer.

.PARAMETER Credential
The credentials to use for creating the scheduled task on a remote computer. If not specified, the current user's credentials will be used.

.PARAMETER User
The user account under which the scheduled task should run. The default value is "SYSTEM".

.PARAMETER StartIn
The directory in which the script should start.

.PARAMETER ScriptArguments
The arguments to pass to the PowerShell script.

.EXAMPLE
New-ScheduledScript -ScriptPath "C:\Scripts\MyScript.ps1" -TaskName "MyTask" -Description "My task description" -TriggerFrequency "Weekly" -TriggerTime "8am"
Creates a new scheduled task named "MyTask" that runs the script "C:\Scripts\MyScript.ps1" every week at 8am.

.EXAMPLE
New-ScheduledScript -ComputerName "RemoteComputer" -ScriptPath "C:\Scripts\MyScript.ps1" -TaskName "RemoteTask" -Description "Remote task description" -TriggerFrequency "Daily" -TriggerTime "6am" -Credential (Get-Credential)
Creates a new scheduled task named "RemoteTask" that runs the script "C:\Scripts\MyScript.ps1" every day at 6am on the remote computer "RemoteComputer" using the specified credentials.

.EXAMPLE
New-ScheduledScript -ScriptPath "C:\scepman\enroll-dc-certificate.ps1" -TaskName "EnrollDCCertificate" -Description "Enrolls DC Certificate" -TriggerFrequency "Daily" -TriggerTime "3am" -User "SYSTEM" -StartIn "C:\scepman" -ScriptArguments "-SCEPURL https://your-scepman-domain/dc -SCEPChallenge RequestPassword -LogToFile"
Creates a new scheduled task named "EnrollDCCertificate" that runs the script "C:\scepman\enroll-dc-certificate.ps1" every day at 3am with the specified arguments.

.NOTES
This function requires administrative privileges to register the scheduled task with the Windows Task Scheduler.
#>
function New-ScheduledScript {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ScriptPath = "C:\Temp\ScheduledScript.ps1",

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$TaskName = "ScheduledScript",

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Description = "ScheduledScript created by New-ScheduledScript function.",

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Daily', 'Weekly', 'AtStartup', 'AtLogon', 'Once')]
        [string]$TriggerFrequency = 'Daily',

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$TriggerTime = '1am',

        [Parameter(Mandatory = $false)]
        [string]$ComputerName,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false)]
        [string]$User = "SYSTEM",

        [Parameter(Mandatory = $false)]
        [string]$StartIn,

        [Parameter(Mandatory = $false)]
        [string]$ScriptArguments
    )

    # Define the script block to create the scheduled task
    $scriptBlock = {
        param (
            $ScriptPath,
            $TaskName,
            $Description,
            $TriggerFrequency,
            $TriggerTime,
            $User,
            $StartIn,
            $ScriptArguments
        )

        Write-Verbose "ScriptBlock: Parameters received: ScriptPath=$ScriptPath, TaskName=$TaskName, Description=$Description, TriggerFrequency=$TriggerFrequency, TriggerTime=$TriggerTime, User=$User, StartIn=$StartIn, ScriptArguments=$ScriptArguments"

        if (-Not (Test-Path $ScriptPath)) {
            throw "The script path '$ScriptPath' does not exist."
        }

        try {
            Write-Verbose "Creating new scheduled task action"
            $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy RemoteSigned -File `"$ScriptPath`" $ScriptArguments" -WorkingDirectory $StartIn

            Write-Verbose "Creating new scheduled task principal"
            $principal = if ($User -eq "SYSTEM") {
                New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
            } else {
                New-ScheduledTaskPrincipal -UserId $User -LogonType Password
            }

            Write-Verbose "Creating new scheduled task trigger"
            switch ($TriggerFrequency) {
                'Daily' {
                    $triggerTime = [datetime]::Parse($TriggerTime)
                    $trigger = New-ScheduledTaskTrigger -Daily -At $triggerTime
                }
                'Weekly' {
                    $triggerTime = [datetime]::Parse($TriggerTime)
                    $trigger = New-ScheduledTaskTrigger -Weekly -At $triggerTime
                }
                'AtStartup' {
                    $trigger = New-ScheduledTaskTrigger -AtStartup
                }
                'AtLogon' {
                    $trigger = New-ScheduledTaskTrigger -AtLogon
                }
                'Once' {
                    $triggerTime = [datetime]::Parse($TriggerTime)
                    $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
                }
            }

            Write-Verbose "Creating new scheduled task settings"
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

            Write-Verbose "Registering new scheduled task"
            Register-ScheduledTask -TaskName "$TaskName" -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description "$Description"
        }
        catch {
            if ($_.Exception.Message -match "Cannot create a file when that file already exists") {
                Write-Error "The task '$TaskName' already exists. Please choose a different name or delete the existing task."
            }
            else {
                Write-Error "Failed to create scheduled task: $_"
            }
        }
    }

    Write-Verbose "Main Function: Parameters received: ScriptPath=$ScriptPath, TaskName=$TaskName, Description=$Description, TriggerFrequency=$TriggerFrequency, TriggerTime=$TriggerTime, ComputerName=$ComputerName, User=$User, StartIn=$StartIn, ScriptArguments=$ScriptArguments"

    if ($ComputerName) {
        # Prepare the parameters for Invoke-Command
        $params = @{
            ScriptBlock  = $scriptBlock
            ArgumentList = $ScriptPath, $TaskName, $Description, $TriggerFrequency, $TriggerTime, $User, $StartIn, $ScriptArguments
            ComputerName = $ComputerName
        }
        if ($Credential) {
            $params.Credential = $Credential
        }
        Write-Verbose "Invoking command on remote computer $ComputerName"
        try {
            Invoke-Command @params -ErrorAction Stop
        }
        catch {
            if ($_.Exception.Message -match "Cannot create a file when that file already exists") {
                Write-Error "The task '$TaskName' already exists on the remote computer. Please choose a different name or delete the existing task."
            }
            else {
                Write-Error "Failed to execute remote command: $_"
            }
        }
    }
    else {
        Write-Verbose "Invoking script block locally"
        try {
            & $scriptBlock -ScriptPath $ScriptPath -TaskName $TaskName -Description $Description -TriggerFrequency $TriggerFrequency -TriggerTime $TriggerTime -User $User -StartIn $StartIn -ScriptArguments $ScriptArguments -ErrorAction Stop
        }
        catch {
            if ($_.Exception.Message -match "Cannot create a file when that file already exists") {
                Write-Error "The task '$TaskName' already exists on the local computer. Please choose a different name or delete the existing task."
            }
            else {
                Write-Error "Failed to create scheduled task locally: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/New-ScheduledScript.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-ScheduledScript.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

