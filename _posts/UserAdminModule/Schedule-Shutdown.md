---
layout: post
title: Schedule-Shutdown.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shutdowncommands/schedule-shutdown/
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

Executes a shutdown, restart, or hibernate command on a remote computer using shutdown.exe.

#### Detailed Description

This function provides a PowerShell wrapper around the shutdown.exe command-line utility to perform remote shutdown, restart, or hibernate operations. It includes comprehensive error handling, parameter validation, and security features.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Invoke-RemoteShutdown -ComputerName "Server01" -Action "Restart" -Timeout 60 -Comment "Planned maintenance restart"
```

**Example 2**

```powershell
Invoke-RemoteShutdown -ComputerName "192.168.1.100" -Action "Shutdown" -Force -UseDirectMethod
```

**Example 3**

```powershell
Invoke-RemoteShutdown -ComputerName "Server01" -Abort
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: PowerShell Automation Team Version: 2.0 Requires: PowerShell 5.1 or later

This function requires appropriate permissions on the target computer and may require PowerShell remoting (WinRM) to be enabled unless UseDirectMethod is specified.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation at a specific date and time.

.DESCRIPTION
    This function calculates the time difference between the current time and the specified shutdown time,
    then calls Invoke-RemoteShutdown to schedule the operation. Includes comprehensive validation and
    error handling.

.PARAMETER ComputerName
    The name or IP address of the target computer. Must be a valid computer name or IP address format.

.PARAMETER ShutdownTime
    The date and time when the operation should occur. Must be a future date/time.

.PARAMETER Action
    The action to perform. Valid values are "Shutdown", "Restart", or "Hibernate". Default is "Shutdown".

.PARAMETER Comment
    A comment to display to users on the target computer. Limited to 512 characters.

.PARAMETER Force
    Forces running applications to close without saving. Use with caution.

.PARAMETER Credential
    Credentials to use for the remote operation. If not specified, current user credentials are used.

.PARAMETER UseDirectMethod
    Uses direct shutdown.exe execution instead of PowerShell remoting. Useful when WinRM is not available.

.EXAMPLE
    Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date "23:00") -Action "Shutdown" -Comment "End of day shutdown"

.EXAMPLE
    Schedule-Shutdown -ComputerName "192.168.1.100" -ShutdownTime (Get-Date).AddHours(2) -Action "Restart" -Force

.EXAMPLE
    $cred = Get-Credential
    Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date "2023-12-31 23:59") -Credential $cred

.NOTES
    Author: PowerShell Automation Team
    Version: 2.0
    Requires: PowerShell 5.1 or later
    
    The maximum timeout supported by shutdown.exe is 315360000 seconds (approximately 10 years).

.LINK
    Invoke-RemoteShutdown
#>
function Schedule-Shutdown {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the computer name or IP address")]
        [ValidateScript({
            if ($_ -match '^[a-zA-Z0-9\-\.]+$' -or $_ -match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
                $true
            } else {
                throw "ComputerName must be a valid computer name or IP address"
            }
        })]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Enter the date and time for the operation")]
        [ValidateScript({
            if ($_ -gt (Get-Date)) {
                $true
            } else {
                throw "ShutdownTime must be a future date and time"
            }
        })]
        [datetime]$ShutdownTime,

        [Parameter(Position = 2, HelpMessage = "Select the action to perform")]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action = "Shutdown",

        [Parameter(Position = 3, HelpMessage = "Comment to display (max 512 characters)")]
        [ValidateLength(0, 512)]
        [string]$Comment = "Scheduled by PowerShell",

        [Parameter(HelpMessage = "Force applications to close without saving")]
        [switch]$Force,

        [Parameter(HelpMessage = "Credentials for remote access")]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(HelpMessage = "Use direct shutdown.exe instead of PowerShell remoting")]
        [switch]$UseDirectMethod
    )

    begin {
        Write-Verbose "Starting Schedule-Shutdown for computer: $ComputerName at time: $ShutdownTime"
    }

    process {
        try {
            # Calculate the time difference in seconds
            $currentDateTime = Get-Date
            $timeDifference = ($ShutdownTime - $currentDateTime).TotalSeconds
            
            Write-Verbose "Current time: $currentDateTime"
            Write-Verbose "Scheduled time: $ShutdownTime"
            Write-Verbose "Time difference: $timeDifference seconds"

            # Validate the time difference is still positive (double-check)
            if ($timeDifference -le 0) {
                throw "The specified time has already passed. Please specify a future time. Current time: $currentDateTime, Specified time: $ShutdownTime"
            }

            # Validate the timeout is within shutdown.exe limits
            if ($timeDifference -gt 315360000) {
                throw "The timeout ($timeDifference seconds) exceeds the maximum allowed by shutdown.exe (315360000 seconds / ~10 years). Please specify a closer time."
            }

            # Round to nearest second for shutdown.exe
            $timeoutSeconds = [math]::Round($timeDifference)
            Write-Verbose "Rounded timeout: $timeoutSeconds seconds"

            # Prepare parameters for Invoke-RemoteShutdown
            $invokeParams = @{
                ComputerName = $ComputerName
                Action = $Action
                Timeout = $timeoutSeconds
                Comment = $Comment
                Force = $Force
                UseDirectMethod = $UseDirectMethod
                Verbose = $VerbosePreference
            }

            if ($Credential) {
                $invokeParams.Credential = $Credential
            }

            # Show what will happen
            $timeSpan = New-TimeSpan -Seconds $timeoutSeconds
            $friendlyTime = if ($timeSpan.Days -gt 0) {
                "{0} days, {1:D2}:{2:D2}:{3:D2}" -f $timeSpan.Days, $timeSpan.Hours, $timeSpan.Minutes, $timeSpan.Seconds
            } else {
                "{0:D2}:{1:D2}:{2:D2}" -f $timeSpan.Hours, $timeSpan.Minutes, $timeSpan.Seconds
            }

            $actionDescription = "$Action scheduled for $ShutdownTime (in $friendlyTime)"

            if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", $actionDescription)) {
                # Invoke the remote shutdown with the calculated timeout
                Invoke-RemoteShutdown @invokeParams
            }
        }
        catch {
            Write-Error "Failed to schedule '$Action' on '$ComputerName' for time '$ShutdownTime': $($_.Exception.Message)"
            Write-Verbose "Full error details: $($_.Exception | Out-String)"
        }
    }

    end {
        Write-Verbose "Schedule-Shutdown completed"
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Schedule-Shutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Schedule-Shutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

