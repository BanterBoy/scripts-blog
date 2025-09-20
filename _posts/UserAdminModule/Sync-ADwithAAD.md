---
layout: post
title: Sync-ADwithAAD.ps1
date: 2025-09-19
permalink: /useradminmodule/replication/sync-adwithaad/
categories:
  - UserAdminModule
  - Replication
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

Synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers.

#### Detailed Description

The Sync-ADwithAAD function synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers. It imports the AADConnector.psm1 module, checks the AD Sync Scheduler status, and starts a sync cycle if one is not already in progress. It then waits for the sync cycle to complete before proceeding.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Sync-ADwithAAD -ComputerName 'Server01'
```

This example synchronizes AD with AAD on a single computer named 'Server01'.

**Example 2**

```powershell
'Server01', 'Server02' | Sync-ADwithAAD
```

This example synchronizes AD with AAD on multiple computers named 'Server01' and 'Server02' using pipeline input.

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
    Synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers.

.DESCRIPTION
    The Sync-ADwithAAD function synchronizes Active Directory (AD) with Azure Active Directory (AAD) on one or more computers. 
    It imports the AADConnector.psm1 module, checks the AD Sync Scheduler status, and starts a sync cycle if one is not already in progress. 
    It then waits for the sync cycle to complete before proceeding.

.PARAMETER ComputerName
    Specifies the name of the computer(s) on which to synchronize AD with AAD. This parameter is mandatory and accepts pipeline input.

.PARAMETER Credential
    Specifies the credentials to use when creating a new session with the computer(s). If not provided, a session will be created without credentials.

.INPUTS
    System.String

.OUTPUTS
    System.String

.EXAMPLE
    Sync-ADwithAAD -ComputerName 'Server01'

    This example synchronizes AD with AAD on a single computer named 'Server01'.

.EXAMPLE
    'Server01', 'Server02' | Sync-ADwithAAD

    This example synchronizes AD with AAD on multiple computers named 'Server01' and 'Server02' using pipeline input.

.LINK
    http://scripts.lukeleigh.com/
#>
function Sync-ADwithAAD {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'Enter credentials for the remote session')]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    begin {
        Write-Verbose -Message "Starting Sync-ADwithAAD" -Verbose

        $scriptBlock = {
            try {
                $modulePath = "C:\Program Files\Microsoft Azure AD Sync\Extensions\AADConnector.psm1"
                if (Test-Path -Path $modulePath) {
                    Write-Verbose -Message "Importing AADConnector.psm1 module" -Verbose
                    Import-Module -Name $modulePath -ErrorAction Stop
                }
                else {
                    throw "Module $modulePath not found."
                }
                
                $ADSyncStatus = Get-ADSyncScheduler
                if (-Not $ADSyncStatus.SyncCycleInProgress) {
                    Write-Verbose -Message "Starting ADSyncSyncCycle" -Verbose
                    Start-ADSyncSyncCycle -PolicyType Delta
                }
                else {
                    Write-Verbose -Message "Sync cycle already in progress" -Verbose
                }

                # Wait for the sync cycle to complete
                do {
                    Start-Sleep -Seconds 20
                    $ADSyncStatus = Get-ADSyncScheduler
                } while ($ADSyncStatus.SyncCycleInProgress)

                Write-Output "Sync cycle completed on $env:COMPUTERNAME"
            }
            catch {
                # Handle the specific management agent error
                if ($_.Exception.Message -match "0x80230613") {
                    Write-Output "An error occurred on $env:COMPUTERNAME: Operation failed because the specified management agent could not be found."
                }
                else {
                    Write-Output "An error occurred on $env:COMPUTERNAME: $_"
                }
            }
        }
    }
    process {
        $total = $ComputerName.Count
        $count = 0
        foreach ($Computer in $ComputerName) {
            $count++
            $percentComplete = ($count / $total) * 100
            Write-Progress -Activity "Syncing AD with AAD" -Status "Processing $Computer ($count of $total)" -PercentComplete $percentComplete
            try {
                if ($Credential) {
                    $session = New-PSSession -ComputerName $Computer -Credential $Credential
                }
                else {
                    $session = New-PSSession -ComputerName $Computer
                }

                Invoke-Command -Session $session -ScriptBlock $scriptBlock
                Remove-PSSession -Session $session
                Write-Output "Synchronized $Computer successfully."
            }
            catch {
                Write-Output "An error occurred while processing $($Computer): $_"
            }
        }
    }
    end {
        Write-Progress -Activity "Syncing AD with AAD" -Completed
        Write-Verbose -Message "Ending Sync-ADwithAAD" -Verbose
    }
}

# Example of how to call the function with enhanced logging
# $creds = Get-Credential
# Sync-ADwithAAD -ComputerName "TATOOINE" -Credential $creds -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Replication/Public/Sync-ADwithAAD.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Sync-ADwithAAD.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

