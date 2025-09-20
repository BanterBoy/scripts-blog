---
layout: post
title: Get-FeaturesInventory.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/get-featuresinventory/
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

Get-FeaturesInventory - This is a function to query AD for servers and then inventory the roles and features on each server.

#### Detailed Description

This is a function to query AD for servers and then inventory the roles and features on each server.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Get-FeaturesInventory
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Get-FeaturesInventory {
	<#
		.SYNOPSIS
			Get-FeaturesInventory - This is a function to query AD for servers and then inventory the roles and features on each server.
		
		.DESCRIPTION
			This is a function to query AD for servers and then inventory the roles and features on each server.
		
		.PARAMETER SearchBase
			Distinguished name of Active Directory container where search for computer accounts for servers should begin.  Defaults to the entire domain of which the local computer is a member.
		
		.EXAMPLE
			PS C:\> Get-FeaturesInventory
		
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		- SearchBase [string]
		Distinguished name of Active Directory container where search for computer accounts for servers should begin.  Defaults to the entire domain of which the local computer is a member.
	
	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Get-AdDomain
		Get-WindowsFeature
		Write-Error
		Write-Output
	#>
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $true,
			Position = 0,
			HelpMessage = 'Enter the Name of the computer you would like to test.')]
		[Alias('cn')]
		[string[]]$ComputerName
	)
	Begin {
	}
	Process {
		ForEach ($Computer In $ComputerName) {
			$AdComputer = Get-ADComputer -Filter { Name -like $Computer } -Properties *
			$features = Get-WindowsFeature -ComputerName $AdComputer.DnsHostName | Where-Object -Property Installed -EQ $true
			ForEach ($feature In $features) {
				Try {
					$properties = [ordered]@{
						ComputerName    = $AdComputer.Name
						OperatingSystem = $AdComputer.OperatingSystem
						DnsHostName     = $AdComputer.DnsHostName
						IPv4Address     = $AdComputer.IPv4Address
						Date            = Get-Date
						FeatureName     = $feature.Name
						DisplayName     = $feature.DisplayName
						Description     = $feature.Description
						Installed       = $feature.Installed
						InstallDate     = $feature.InstallDate
						ADComputer      = $AdComputer.Name
					}
				}
				Catch {
					Write-Error "Error getting feature properties"
				}
				Finally {
					$obj = New-Object -TypeName PSObject -Property $properties
					Write-Output $obj
				}
			}
		}
	}
	End {
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-FeaturesInventory.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FeaturesInventory.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

