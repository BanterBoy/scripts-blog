---
layout: post
title: Get-FeaturesInventory.ps1
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
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter the Distinguished name of the Active Directory container where search for server accounts should begin.')]
		[string]
		$SearchBase = (Get-AdDomain -Current LocalComputer).DistinguishedName
	)
	Begin {
	}
	Process {
		$AdComputer = Get-ADComputer -Filter { OperatingSystem -like '*Server*' } -SearchBase $SearchBase -Properties *
		ForEach ($Computer In $AdComputer) {
			$features = Get-WindowsFeature -ComputerName $Computer.DnsHostName | Where-Object -Property Installed -EQ $true
			ForEach ($feature In $features) {
				Try {
					$properties = [ordered]@{
						ComputerName    = $Computer.Name
						OperatingSystem = $Computer.OperatingSystem
						DnsHostName     = $Computer.DnsHostName
						IPv4Address     = $Computer.IPv4Address
						Date            = Get-Date
						FeatureName     = $feature.Name
						DisplayName     = $feature.DisplayName
						Description     = $feature.Description
						Installed       = $feature.Installed
						InstallDate     = $feature.InstallDate
						ADComputer      = $Computer.Name
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-FeaturesInventory.ps1')">
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
