---
layout: post
title: Get-SystemEvent.ps1
date: 2025-09-19
permalink: /useradminmodule/logging/get-systemevent/
categories:
  - UserAdminModule
  - Logging
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

Retrieves system events from one or more computers.

#### Detailed Description

The Get-SystemEvent function retrieves system events from one or more computers. It filters the events based on the specified criteria, such as the computer name, credentials, and number of days of events to retrieve. The function uses the Get-WinEvent cmdlet to retrieve the events and outputs the selected properties of the events.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-SystemEvent -ComputerName 'Server01', 'Server02' -Days 7
```

Retrieves system events from Server01 and Server02 that occurred within the last 7 days.

**Example 2**

```powershell
Get-SystemEvent -ComputerName 'Server01' -Credential $cred -Days 30
```

Retrieves system events from Server01 that occurred within the last 30 days using the specified credentials.

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
Retrieves system events from one or more computers.

.DESCRIPTION
The Get-SystemEvent function retrieves system events from one or more computers. It filters the events based on the specified criteria, such as the computer name, credentials, and number of days of events to retrieve. The function uses the Get-WinEvent cmdlet to retrieve the events and outputs the selected properties of the events.

.PARAMETER ComputerName
Specifies the name of the computer from which to retrieve events. The default value is the local computer.

.PARAMETER Credential
Specifies the credentials to use when connecting to the computer. This parameter is optional.

.PARAMETER Days
Specifies the number of days of events to retrieve. The default value is 10.

.OUTPUTS
System.String
The function outputs a string that represents the selected properties of the retrieved events. The selected properties include TimeCreated, Message, and MachineName.

.EXAMPLE
Get-SystemEvent -ComputerName 'Server01', 'Server02' -Days 7
Retrieves system events from Server01 and Server02 that occurred within the last 7 days.

.EXAMPLE
Get-SystemEvent -ComputerName 'Server01' -Credential $cred -Days 30
Retrieves system events from Server01 that occurred within the last 30 days using the specified credentials.

.LINK
https://github.com/BanterBoy
The function's help URI.

#>
function Get-SystemEvent {
	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy'
	)]
	[OutputType([string])]
	param (
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter the name of the computer from which to retrieve events.'
		)]
		[Alias('cn')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter the credentials to use when connecting to the computer.'
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
			HelpMessage = 'Enter the number of days of events to retrieve.'
		)]
		[int[]]$Days = 10
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$Computer", "Extracting events")) {
				if ($Credential) {
					try {
						$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential | Where-Object -FilterScript { ($_.Level -eq 2) -or ($_.Level -eq 3) } | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(- "$Days") -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message, MachineName
						if ($null -eq $Results) {
							Write-Error "No events Found on $Computer"
						}
						else {
							Write-Output $Results
						}
					}
					catch {
						Write-Error "Failed to retrieve events from $Computer"
					}

				}
				else {
					try {
						$Results = Get-WinEvent -ComputerName $Computer | Where-Object -FilterScript { ($_.Level -eq 2) -or ($_.Level -eq 3) } | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(- "$Days") -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message, MachineName
						if ($null -eq $Results) {
							Write-Error "No events Found on $Computer"
						}
						else {
							Write-Output $Results
						}
					}
					catch {
						Write-Error "Failed to retrieve events from $Computer. Error: $_"
					}
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Logging/Public/Get-SystemEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-SystemEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

