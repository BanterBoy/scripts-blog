---
layout: post
title: Get-LastBootTime.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

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
		[Alias('dp')]
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-LastBootTime.ps1')">
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
