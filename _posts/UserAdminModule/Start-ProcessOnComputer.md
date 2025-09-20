---
layout: post
title: Start-ProcessOnComputer.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Start-ProcessOnComputer/
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

Starts a process on a remote computer.

#### Detailed Description

The Start-ProcessOnComputer function starts a process on a remote computer. It uses the Invoke-Command cmdlet to run a script block on the remote machine, and within that script block, it uses the Start-Process cmdlet to start the process.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Start-ProcessOnComputer -ComputerName "Server01" -Name "notepad.exe"
```

Starts the notepad.exe process on the computer named Server01.

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
Starts a process on a remote computer.

.DESCRIPTION
The Start-ProcessOnComputer function starts a process on a remote computer. 
It uses the Invoke-Command cmdlet to run a script block on the remote machine, 
and within that script block, it uses the Start-Process cmdlet to start the process.

.PARAMETER ComputerName
The name of the computer on which to start the process.

.PARAMETER Name
The name of the process to start.

.PARAMETER Credential
The credentials to use to start the process. If not provided, the current user's credentials are used.

.EXAMPLE
Start-ProcessOnComputer -ComputerName "Server01" -Name "notepad.exe"

Starts the notepad.exe process on the computer named Server01.
#>
function Start-ProcessOnComputer {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Enter the name of the computer.")]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the process to start.")]
        [string]$Name,

        [Parameter(HelpMessage = "Enter the credentials to use. If not provided, the current user's credentials are used.")]
        [System.Management.Automation.PSCredential]$Credential
    )

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Start process $Name")) {
            try {
                Write-Verbose "Attempting to start process $Name on $ComputerName..."
                $scriptBlock = {
                    param($Name)
                    $process = Start-Process -FilePath $Name -PassThru
                    $process | Format-List * | Out-String
                }

                $invokeParams = @{
                    ComputerName = $ComputerName
                    ScriptBlock  = $scriptBlock
                    ArgumentList = $Name
                }
                if ($null -ne $Credential) {
                    $invokeParams.Credential = $Credential
                }
                $processDetails = Invoke-Command @invokeParams
                Write-Verbose "Process $Name started on $ComputerName successfully. Details: `n$processDetails"
            }
            catch {
                Write-Error -Message "Failed to start process on Server ${ComputerName}: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Start-ProcessOnComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-ProcessOnComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

