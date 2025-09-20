---
layout: post
title: Set-RemoteComputerTime.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-RemoteComputerTime/
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

Function to correct wrong time and date on remote machines

#### Detailed Description

Set-RemoteComputerTime -ComputerName <Hostname> -Domain <domain> (default = )

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-RemoteComputerTime Computer01
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Additional information about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Set-RemoteComputerTime {
	<#
		.SYNOPSIS
			Function to correct wrong time and date on remote machines

		.DESCRIPTION
			Set-RemoteComputerTime -ComputerName <Hostname> -Domain <domain> (default = )

		.EXAMPLE
			Set-RemoteComputerTime Computer01
		
		.OUTPUTS
			System.String
		
		.NOTES
			Additional information about the function.
	#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		HelpUri = 'https://github.com/BanterBoy')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input')]
		[Alias('cn')]
		[string[]]$ComputerName,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$Domain
	)
	try {
		$Computer = (Get-ADComputer $ComputerName -properties DNSHostname, description, OperatingSystem -server $Domain -ErrorAction stop)
		$AdCheck = $true
	}
	Catch {
		Write-Host -ForegroundColor Red "Machine $($ComputerName) not found in AD"
		$Computer = $_.Exception.Message
		$AdCheck = $false
	}
	# Check machine is online
	if ($True -eq $AdCheck) {
		$PathTest = Test-Connection -Computername $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
	}
	if ($True -eq $PathTest) {
		Write-host -ForegroundColor Green "$($ComputerName) is online"
		$RemoteTimeAndDate = Invoke-Command -ComputerName $Computer.DNSHostname -ScriptBlock { return Get-Date -Format "dddd MM/dd/yyyy HH:mm" }
		$TimeAndDate = Get-date -Format "dddd MM/dd/yyyy HH:mm"
		if ($RemoteTimeAndDate -ne $TimeAndDate) {
			Write-Host -ForegroundColor RED "$($ComputerName) time is out"
			Write-Host -ForegroundColor RED "Remote Time - $($RemoteTimeAndDate)"
			Write-Host -ForegroundColor RED "Local Time - $($TimeAndDate)"
			$Continue = Read-Host -Prompt 'Do you wish to correct? -  Press Y to continue'
			if ("Y" -eq $Continue.ToUpper()) {
				Write-Warning -Message "Correcting time on $($ComputerName)"
				$TimeAndDate = Get-date
				$RemoteTimeAndDate = Invoke-Command -ComputerName $Computer.DNSHostname -ScriptBlock { Set-Date -Date $using:TimeAndDate
					return Get-Date -Format "dddd MM/dd/yyyy HH:mm" }
				if ($RemoteTimeAndDate -eq $TimeAndDate) {
					Write-Host -ForegroundColor Green "$($ComputerName) time was successfully corrected"
				}
				else {
					Write-Host -ForegroundColor RED "$($ComputerName) issue correcting time"
					Write-Host -ForegroundColor RED "Remote Time - $($RemoteTimeAndDate)"
					Write-Host -ForegroundColor RED "Remote Time - $($TimeAndDate)"
				}
			}
	
		}
		else {
			Write-Host -ForegroundColor Green "$($ComputerName) time is correct"
		}
	}
	else {
		Write-host -ForegroundColor Red "$($ComputerName) is offline"
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Set-RemoteComputerTime.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-RemoteComputerTime.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

