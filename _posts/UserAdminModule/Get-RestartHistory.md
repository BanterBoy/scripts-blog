---
layout: post
title: Get-RestartHistory.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RestartHistory/
categories:
  - UserAdminModule
  - Utilities
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

Retrieves the restart history of one or more computers.

#### Detailed Description

The Get-RestartHistory function retrieves the restart history of one or more computers by querying the System event log for specific event IDs related to system restarts. It returns a collection of objects representing each restart event, including information such as the event message, ID, log name, machine name, provider name, and time created.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RestartHistory -ComputerName KAMINO | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(-7) | Where-Object -FilterScript { ($_.ID -EQ 6005) -or ($_.ID -EQ 6006) } | Format-Table -AutoSize
```

Retrieves the restart history from the computer named "KAMINO" for the past 7 days and filters the results to include only events with ID 6005 or 6006. The results are then formatted as a table.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves the restart history of one or more computers.

.DESCRIPTION
    The Get-RestartHistory function retrieves the restart history of one or more computers by querying the System event log for specific event IDs related to system restarts. It returns a collection of objects representing each restart event, including information such as the event message, ID, log name, machine name, provider name, and time created.

.PARAMETER ComputerName
    Specifies the name of the computer(s) to retrieve the restart history from. If not specified, the local computer name is used by default. This parameter supports pipeline input.

.PARAMETER Credential
    Specifies the credentials to use when connecting to remote computers. If not specified, the current user's credentials are used by default. This parameter supports pipeline input.

.EXAMPLE
    Get-RestartHistory -ComputerName KAMINO | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(-7) | Where-Object -FilterScript { ($_.ID -EQ 6005) -or ($_.ID -EQ 6006) } | Format-Table -AutoSize
    Retrieves the restart history from the computer named "KAMINO" for the past 7 days and filters the results to include only events with ID 6005 or 6006. The results are then formatted as a table.

#>

function Get-RestartHistory {
    Param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            $eventLogs = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "System"; Id = '6005', '6006', '6008', '6009', '6013', '1074', '1076' } -ErrorAction SilentlyContinue
            foreach ($eventLog in $eventLogs) {
                try {
                    $properties = @{
                        Message      = [string]$eventLog.Message
                        Id           = [int]$eventLog.Id
                        LogName      = [string]$eventLog.LogName
                        MachineName  = [string]$eventLog.MachineName
                        ProviderName = [string]$eventLog.ProviderName
                        TimeCreated  = [datetime]$eventLog.TimeCreated
                    }
                    $obj = New-Object -TypeName PSObject -Property $Properties
                    Write-Output $obj
                }
                catch {
                    Write-Error "Failed with error: $_.Message"
                }
            }
        }
    }
    END {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-RestartHistory.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RestartHistory.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

