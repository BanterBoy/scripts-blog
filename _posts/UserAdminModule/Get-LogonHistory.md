---
layout: post
title: Get-LogonHistory.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-LogonHistory/
categories:
  - UserAdminModule
  - ADFunctions
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

Retrieves logon history events from the Security event log on one or more computers.

#### Detailed Description

The Get-LogonHistory function retrieves logon history events from the Security event log on one or more computers. It filters the events based on the event IDs 4624 (successful logon), 4625 (failed logon), and 4647 (user initiated logoff).

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-LogonHistory -ComputerName 'Server01', 'Server02' -Credential $cred
```

This example retrieves logon history events from 'Server01' and 'Server02' using the specified credentials.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves logon history events from the Security event log on one or more computers.

.DESCRIPTION
The Get-LogonHistory function retrieves logon history events from the Security event log on one or more computers. It filters the events based on the event IDs 4624 (successful logon), 4625 (failed logon), and 4647 (user initiated logoff).

.PARAMETER ComputerName
Specifies the name of the computer(s) from which to retrieve logon history events. The default value is the local computer. This parameter supports pipeline input.

.PARAMETER Credential
Specifies the credentials to use when connecting to remote computers. This parameter supports pipeline input.

.EXAMPLE
Get-LogonHistory -ComputerName 'Server01', 'Server02' -Credential $cred

This example retrieves logon history events from 'Server01' and 'Server02' using the specified credentials.

.INPUTS
System.String, System.Management.Automation.PSCredential

.OUTPUTS
System.Management.Automation.PSObject

.NOTES
Author: Your Name
Date:   Current Date
#>

function Get-LogonHistory {
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
            $eventLogs = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Security"; Id = '4624', '4625', '4647' } -ErrorAction SilentlyContinue
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-LogonHistory.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LogonHistory.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

