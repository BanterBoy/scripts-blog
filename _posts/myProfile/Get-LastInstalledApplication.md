---
layout: post
title: Get-LastInstalledApplication.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Get-LastInstalledApplication {
	<#
	.SYNOPSIS
		A brief description of the Get-LastInstalledApplication function.

	.DESCRIPTION
		A detailed description of the Get-LastInstalledApplication function.

	.PARAMETER ComputerName
		A description of the ComputerName parameter.

	.PARAMETER Last
		A description of the Last parameter.

	.EXAMPLE
		PS C:\> Get-LastInstalledApplication -ComputerName 'value1'

	.OUTPUTS
		System.String

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy'
	)]
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
			HelpMessage = 'Enter computer name or pipe input')]
		[Alias('l')]
		[int]$Last = '5'
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$($Computer)", "Find last installed application")) {
				$Test = (Test-Connection -ComputerName $Computer -Ping -Count 1).Status
				if ($Test -eq "Success") {
					if ($Credential) {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential -FilterHashtable @{ LogName = "Application"; ID = 11707; ProviderName = 'MsiInstaller' } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -Last $Last
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}

					}
					else {
						try {
							$Results = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Application"; ID = 11707; ProviderName = 'MsiInstaller' } -ErrorAction SilentlyContinue |
							Select-Object TimeCreated, Message, MachineName -Last $Last
							if ($null -eq $Results) {
								Write-Output "No Matching Events Found on $Computer"
							}
							else {
								Write-Output $Results
							}
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

# "HOTH", "KAMINO", "DANTOOINE" | ForEach-Object -Process { Get-LastInstalledApplication -ComputerName $_ -Last 1 }
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Get-LastInstalledApplication.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LastInstalledApplication.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
