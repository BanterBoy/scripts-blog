---
layout: post
title: Connect-PSExecPowershell.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Connect-PSExecPowershell/
categories:
- UserAdminModule
- RemoteConnections
tags:
- PowerShell
- User Admin Module
- PowerShell Exec Powershell
description: Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell
  Console session to a remote computer.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer.

#### Detailed Description

Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Connect-PSExecPowershell -ComputerName COMPUTERNAME
```

Starts an RDP session to COMPUTERNAME

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Connect-PSExecPowershell {
    <#
	.SYNOPSIS
		Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer.
	
	.DESCRIPTION
		Connect-PSExecPowershell - Spawn PSEXEC and launches an PSEXEC PowerShell Console session to a remote computer. Sets remote computers ExecutionPolicy to Unrestricted.
	
	.PARAMETER ComputerName
		This parameter accepts the Name of the computer you would like to connect to.
		Supports IP/Name/FQDN
	
	.EXAMPLE
		Connect-PSExecPowershell -ComputerName COMPUTERNAME
		Starts an RDP session to COMPUTERNAME
	
	.OUTPUTS
		System.String. Connect-PSExecPowershell
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		ComputerName - You can pipe objects to this perameters.
	
	.LINK
		https://scripts.lukeleigh.com
		PsExec.exe
		powershell.exe
#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName
    )

    BEGIN {
        $psExecPath = Join-Path $PSScriptRoot 'resources/PsExec.exe'
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$($Computer)", "Establishing PSEXEC PowerShell Console session")) {
            foreach ($Computer in $ComputerName) {
                try {
                    if ($PSCmdlet.ShouldProcess("$($Computer)", "Establishing PSEXEC Session")) {
                        & $psExecPath \\$Computer powershell.exe -ExecutionPolicy Unrestricted
                    }
                }
                catch {
                    Write-Error "Unable to connect to $($Computer)"
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/RemoteConnections/Public/Connect-PSExecPowershell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-PSExecPowershell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

