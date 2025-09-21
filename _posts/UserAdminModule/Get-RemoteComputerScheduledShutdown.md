---
layout: post
title: Get-RemoteComputerScheduledShutdown.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shutdowncommands/get-remotecomputerscheduledshutdown/
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

Retrieves scheduled or recent shutdown/restart/hibernate events (Event ID 1074) for one or more remote computers.

#### Detailed Description

Queries the System event log on the target computer(s) for Event ID 1074 and returns a collection of objects describing the action, time, and raw message. The function supports pipeline input and multiple computer names, optional credentials, and a configurable maximum events per computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
'SRV01','SRV02' | Get-RemoteComputerScheduledShutdown -MaxEvents 10
```

**Example 2**

```powershell
Get-RemoteComputerScheduledShutdown -ComputerName RDGDC01 -Credential (Get-Credential)
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-RemoteComputerScheduledShutdown {
    <#
    .SYNOPSIS
    Retrieves scheduled or recent shutdown/restart/hibernate events (Event ID 1074) for one or more remote computers.

    .DESCRIPTION
    Queries the System event log on the target computer(s) for Event ID 1074 and returns a collection of objects describing the action, time, and raw message.
    The function supports pipeline input and multiple computer names, optional credentials, and a configurable maximum events per computer.

    .PARAMETER ComputerName
    One or more remote computer names to query. Accepts pipeline input by value or property name.

    .PARAMETER MaxEvents
    The maximum number of recent events to retrieve per computer. Default is 5.

    .PARAMETER Credential
    Optional PSCredential to use for the remote connection.

    .EXAMPLE
    'SRV01','SRV02' | Get-RemoteComputerScheduledShutdown -MaxEvents 10

    .EXAMPLE
    Get-RemoteComputerScheduledShutdown -ComputerName RDGDC01 -Credential (Get-Credential)
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]
        $MaxEvents = 5,

        [Parameter(Mandatory = $false)]
        [PSCredential]
        $Credential
    )

    begin {
        $allResults = @()
    }

    process {
        foreach ($target in $ComputerName) {
            try {
                Write-Verbose "Querying event log on $target for up to $MaxEvents events."

                $invokeParams = @{ 
                    ComputerName = $target
                    ScriptBlock  = {
                        param ($maxEvents)
                        Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 1074 } -MaxEvents $maxEvents -ErrorAction Stop
                    }
                    ArgumentList = $MaxEvents
                    ErrorAction  = 'Stop'
                }

                if ($Credential) { $invokeParams.Credential = $Credential }

                $events = Invoke-Command @invokeParams

                if ($events -and $events.Count -gt 0) {
                    Write-Verbose "Found $($events.Count) event(s) on $target."
                    foreach ($evt in $events) {
                        $msg = $evt.Message
                        $time = $evt.TimeCreated
                        $action = switch -Regex ($msg) {
                            'shutdown'   { 'Shutdown'; break }
                            'restart|reboot' { 'Restart'; break }
                            'hibernate|sleep' { 'Hibernate'; break }
                            default { 'Unknown' }
                        }

                        $allResults += [PSCustomObject]@{
                            ComputerName    = $target
                            EventRecordId    = $evt.RecordId
                            TimeCreated      = $time
                            Action           = $action
                            ScheduledTime    = $time
                            Message          = $msg
                        }
                    }
                }
                else {
                    Write-Verbose "No scheduled shutdown/restart/hibernate events found on $target."
                    $allResults += [PSCustomObject]@{
                        ComputerName    = $target
                        EventRecordId    = $null
                        TimeCreated      = $null
                        Action           = 'None'
                        ScheduledTime    = $null
                        Message          = 'No scheduled events found.'
                    }
                }
            }
            catch [System.Management.Automation.RemotingException] {
                Write-Error "Remote access failed for $target. Ensure WinRM/remote management is enabled and you have permissions. Error: $($_.Exception.Message)"
                $allResults += [PSCustomObject]@{
                    ComputerName    = $target
                    EventRecordId    = $null
                    TimeCreated      = $null
                    Action           = 'Error'
                    ScheduledTime    = $null
                    Message          = "Remote access failed: $($_.Exception.Message)"
                }
            }
            catch {
                Write-Error "Failed to retrieve scheduled shutdown event from $target. Error: $($_.Exception.Message)"
                if ($_.Exception.InnerException) {
                    Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
                }
                $allResults += [PSCustomObject]@{
                    ComputerName    = $target
                    EventRecordId    = $null
                    TimeCreated      = $null
                    Action           = 'Error'
                    ScheduledTime    = $null
                    Message          = "General failure: $($_.Exception.Message)"
                }
            }
        }
    }

    end {
        return ,$allResults
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Get-RemoteComputerScheduledShutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RemoteComputerScheduledShutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

