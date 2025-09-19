---
layout: post
title: Stop-ProcessOnComputer.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Stop-ProcessOnComputer/
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

Stops a specified process on one or more computers.

#### Detailed Description

The Stop-ProcessOnComputer function stops a specified process on one or more computers. It uses the CIM_Process class to find and stop the process.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$cred = Get-Credential
```

"Server1", "Server2" | Stop-ProcessOnComputer -Name "Notepad" -Credential $cred This example stops the Notepad process on Server1 and Server2 using the provided credentials.

**Example 2**

```powershell
Stop-ProcessOnComputer -ComputerName "Server1" -Name "Notepad" -Force
```

This example forcefully stops the Notepad process on Server1.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Stops a specified process on one or more computers.

.DESCRIPTION
The Stop-ProcessOnComputer function stops a specified process on one or more computers. 
It uses the CIM_Process class to find and stop the process.

.PARAMETER ComputerName
The names of the computers where the process should be stopped. 
This parameter accepts pipeline input and can be used in a pipeline command.

.PARAMETER Name
The name of the process to stop. 
This parameter accepts pipeline input and can be used in a pipeline command.

.PARAMETER Force
If this switch is provided, the function will forcefully terminate the process.

.PARAMETER Credential
The credentials to use when connecting to the computers. 
If not provided, the function will use the current user's credentials.

.EXAMPLE
$cred = Get-Credential
"Server1", "Server2" | Stop-ProcessOnComputer -Name "Notepad" -Credential $cred

This example stops the Notepad process on Server1 and Server2 using the provided credentials.

.EXAMPLE
Stop-ProcessOnComputer -ComputerName "Server1" -Name "Notepad" -Force

This example forcefully stops the Notepad process on Server1.
#>
function Stop-ProcessOnComputer {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Default')]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The names of the computers where the process should be stopped.")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The name of the process to stop.", ParameterSetName = 'Default')]
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "The name of the process to stop.", ParameterSetName = 'Force')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(HelpMessage = "If this switch is provided, the function will forcefully terminate the process.", ParameterSetName = 'Force')]
        [switch]
        $Force,

        [Parameter(HelpMessage = "The credentials to use when connecting to the computers. If not provided, the function will use the current user's credentials.")]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Stop process $Name")) {
                try {
                    $cimParams = @{
                        ClassName    = "Win32_Process"
                        Namespace    = "root/CIMV2"
                        ComputerName = "$Computer"
                    }
                    if ($null -ne $Credential) {
                        $cimParams.Credential = $Credential
                    }
                    $Process = Get-CimInstance @cimParams | Where-Object -Property Name -Like ($Name + ".exe")

                    if ($Process) {
                        $Process | ForEach-Object {
                            $result = Invoke-CimMethod -InputObject $_ -MethodName "Terminate"
                            [PSCustomObject]@{
                                ComputerName    = $Computer
                                ProcessName     = $_.Name
                                ProcessId       = $_.ProcessId
                                TerminateResult = $result.ReturnValue
                            }
                        }
                    }
                }
                catch {
                    Write-Error -Message "Failed to get process information from Server ${Computer}: $_"
                }
            }
        }
    }    
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ProcessServiceSchedules/Public/Stop-ProcessOnComputer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Stop-ProcessOnComputer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

