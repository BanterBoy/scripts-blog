---
layout: post
title: Stop-NonRespondingProcesses.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/stop-nonrespondingprocesses/
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

Monitors and stops non-responding processes after a specified timeout.

#### Detailed Description

This function continuously monitors processes with a window and stops those that are non-responding for longer than the specified timeout. The user is presented with a selection of non-responding processes to kill.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Stop-NonRespondingProcesses
```

Continuously monitors and stops non-responding processes based on user selection.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Monitors and stops non-responding processes after a specified timeout.

.DESCRIPTION
    This function continuously monitors processes with a window and stops those that are non-responding for longer than the specified timeout. 
    The user is presented with a selection of non-responding processes to kill.

.PARAMETER None
    This function does not take any parameters.

.EXAMPLE
    PS C:\> Stop-NonRespondingProcesses
    Continuously monitors and stops non-responding processes based on user selection.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>
#requires -PSEdition Desktop

function Stop-NonRespondingProcesses {
    [CmdletBinding()]
    param ()

    $timeout = 3
    # Initialize a hash table to keep track of processes
    $hash = @{}
    
    # Verbose output indicating the start of the function
    Write-Verbose "Starting Stop-NonRespondingProcesses function..."

    # Use an endless loop to continuously monitor processes
    do {
        Write-Verbose "Checking processes for non-responding state..."
        Get-Process |
        # Filter for processes with a window
        Where-Object MainWindowTitle |
        ForEach-Object {
            # Use process ID as key to the hash table
            $key = $_.Id
            # If the process is responding, reset the counter
            if ($_.Responding) {
                $hash[$key] = 0
                Write-Verbose "Process $key ($($_.Name)) is responding."
            }
            # Else, increment the counter by one
            else {
                $hash[$key]++
                Write-Verbose "Process $key ($($_.Name)) is not responding. Counter: $($hash[$key])"
            }
        }
        
        # Copy the hash table keys so that the collection can be modified
        $keys = @($hash.Keys).Clone()

        # Emit all processes hanging for longer than $timeout seconds
        $keys |
        # Take the ones not responding for the time specified in $timeout
        Where-Object { $hash[$_] -gt $timeout } |
        ForEach-Object {
            # Reset the counter (in case you choose not to kill them)
            $hash[$_] = 0
            # Emit the process for the process ID on record
            Get-Process -Id $_
        } |
        # Exclude those that already exited
        Where-Object { $_.HasExited -eq $false } |
        # Show properties
        Select-Object -Property Id, Name, StartTime, HasExited |
        # Show hanging processes. The process(es) selected by the user will be killed
        Out-GridView -Title "Select apps to kill that are hanging for more than $timeout seconds" -PassThru |
        # Kill selected processes
        Stop-Process -Force

        # Sleep for a second
        Start-Sleep -Seconds 1
    
    } while ($true)

    # Verbose output indicating the end of the function
    Write-Verbose "Stop-NonRespondingProcesses function completed."
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Stop-NonRespondingProcesses.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-NonRespondingProcesses.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

