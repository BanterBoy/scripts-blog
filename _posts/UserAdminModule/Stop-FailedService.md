---
layout: post
title: Stop-FailedService.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/processserviceschedules/stop-failedservice/
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

Stops a specified process on one or more remote computers.

#### Detailed Description

This function retrieves the specified process on the provided remote computers and attempts to terminate it. If the process is not running, it provides an appropriate error message.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Stop-FailedService -ComputerName "Server1", "Server2" -ProcessName "notepad"
```

Attempts to stop the notepad process on Server1 and Server2.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Stops a specified process on one or more remote computers.

.DESCRIPTION
    This function retrieves the specified process on the provided remote computers and attempts to terminate it.
    If the process is not running, it provides an appropriate error message.

.PARAMETER ComputerName
    The name(s) of the remote computer(s) on which to stop the process.

.PARAMETER ProcessName
    The name of the process to be stopped (without the ".exe" extension).

.EXAMPLE
    PS C:\> Stop-FailedService -ComputerName "Server1", "Server2" -ProcessName "notepad"
    Attempts to stop the notepad process on Server1 and Server2.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Stop-FailedService {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $true)]
        [string]
        $ProcessName
    )

    # Verbose output indicating the start of the function
    Write-Verbose "Starting Stop-FailedService function..."

    foreach ($Computer in $ComputerName) {
        Write-Verbose "Processing computer: $Computer"

        # Retrieve the process information from the remote computer
        $Process = Get-CimInstance -ClassName "CIM_Process" -Namespace "root/CIMV2" -ComputerName "$Computer" | Where-Object -Property Name -Like ($ProcessName + ".exe")
        
        if ($null -ne $Process) {
            Write-Verbose "Process $ProcessName found on $Computer. Attempting to terminate..."

            # Attempt to dispose of the process
            $returnval = $Process.Dispose()
            $processid = $Process.Handle
            
            if ($null -eq $returnval) {
                Write-Output "The process $ProcessName `($processid`) terminated successfully on Server $Computer"
            }
            else {
                Write-Error -Message "The process $ProcessName `($processid`) termination encountered problems on Server $Computer"
            }
        }
        else {
            Write-Error -Message "Process $ProcessName not running on Server $Computer"
        }
    }

    # Verbose output indicating the end of the function
    Write-Verbose "Stop-FailedService function completed."
}

# Example call to the function with verbose output
# Stop-FailedService -ComputerName "Server1", "Server2" -ProcessName "notepad" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Stop-FailedService.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-FailedService.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

