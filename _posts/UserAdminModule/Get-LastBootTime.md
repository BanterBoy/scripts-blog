---
layout: post
title: Get-LastBootTime.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-LastBootTime/
categories:
  - UserAdminModule
  - Shell
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

A brief description of the Get-LastBootTime function.

#### Detailed Description

A detailed description of the Get-LastBootTime function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-LastBootTime -ComputerName 'value1'
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-LastBootTime {
	<#
	.SYNOPSIS
		A brief description of the Get-LastBootTime function.
	
	.DESCRIPTION
		A detailed description of the Get-LastBootTime function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER DaysPast
		A description of the DaysPast parameter.
	
	.EXAMPLE
		PS C:\> Get-LastBootTime -ComputerName 'value1'
	
	.OUTPUTS
		System.String
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cn')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cred')]
		[ValidateNotNull()]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter the number of days past or pipe input')]
		[int]$DaysPast = 1
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$($Computer)", "Find last Boot Time")) {
				$Test = (Test-Connection -ComputerName $Computer -Ping -Count 1).Status
				if ($Test -eq "Success") {
					if ($Credential) {
						try {
							$StartTime = (Get-Date).AddDays(-$DaysPast)
							Get-WinEvent -ComputerName $Computer -FilterHashtable @{
								logname = 'System';
								id      = '1074'
							} | Where-Object -Property TimeCreated -GT $StartTime
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
					else {
						try {
							$StartTime = (Get-Date).AddDays(-$DaysPast)
							Get-WinEvent -ComputerName $Computer -FilterHashtable @{
								logname = 'System';
								id      = '1074'
							} | Where-Object -Property TimeCreated -GT $StartTime
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
				}
				else {
					Write-Output "Computer $Computer is not reachable."
				}
			}
		}
	}
	END {
	}
}

# Get-LastBootTime -ComputerName KAMINO, DANTOOINE, HOTH -DaysPast 100 | Format-Table -AutoSize -Wrap
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-LastBootTime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastBootTime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

