---
layout: post
title: Get-LockoutHistory.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-LockoutHistory/
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

Displays list of accounts that have been locked out in AD since the last time each DC's Event Log has rolled over.

#### Detailed Description

By default, this script displays list of accounts that have been locked out on the current domain since the last time the Event Log rolled over. Results can be filtered by using parameters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author  : Chrissy LeMaire Requires:     PowerShell Version 3.0 DateUpdated: 2015-Feb-5 Version: 1.1

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-LockoutHistory {

	<#  
	.SYNOPSIS  
	Displays list of accounts that have been locked out in AD since the last time each DC's Event Log has rolled over.

	.DESCRIPTION
	By default, this script displays list of accounts that have been locked out on the current domain since the last time the Event Log rolled over. Results can be filtered by using parameters.

	.PARAMETER forest
	Queries all DCs in the current forest

	.PARAMETER Domain
	Queries only DCs within the specified domain. If no domain is listed, it will default to the current domain.
	
	.PARAMETER DCs
	Queries only specified DCs
	
	.PARAMETER Start
	Filter by start time in 'MM/dd/yyyy HH:mm:ss' format.
	
	.PARAMETER End
	Filter by end time in 'MM/dd/yyyy HH:mm:ss' format.
	
	.NOTES  
	Author  : Chrissy LeMaire 
	Requires:     PowerShell Version 3.0
	DateUpdated: 2015-Feb-5
	Version: 1.1
	 
	.LINK
	
	 
	.EXAMPLE
	.\Get-LockoutHistory.ps1
	Gets all locked out accounts in the current domain.
	
	.EXAMPLE
	.\Get-LockoutHistory.ps1 -forest
	Gets all locked out accounts in the current forest
	
	.EXAMPLE
	.\Get-LockoutHistory.ps1 -domain ad.local -start '1/28/2015' -end '1/29/2015'
	Gets all locked out accounts in the ad.local domain, starting at 01/28/2015 00:00:00 and ending at 01/29/2015 00:00:00
#> 
	[CmdletBinding(DefaultParameterSetName = "Default")]

	Param(
		[switch]$forest,
		[string]$domain,
		[string[]]$dcs,
		[datetime]$start,
		[datetime]$end
	)

	if ($domain.length -ne 0) { $domain = $domain.toLower() }

	if (($forest -eq $true -or $null -ne $domain) -and $dcs.length -eq 0) {
		$currentforest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
		$currentdomains = $currentforest.Domains
	
		if ($domain.length -ne 0) {
			$singledomain = ($currentdomains | Where-Object { $_.Name -eq $domain })
			if ($null -eq $singledomain) { throw "$domain could not be found in the forest." }
			$dcs = $singledomain.DomainControllers.name 
		}
		else { $dcs = $domains.DomainControllers.name }
	} 

	if ($null -eq $dcs) {
		$currentdomain = [directoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
		$dcs = $currentdomain.FindAllDomainControllers()
	}

	$filter = @{LogName = 'Security'; Id = 4740; }

	if ($start -ne $null) {
		$start = (Get-Date $start -Format 'MM/dd/yyyy HH:mm:ss')
		$filter += @{StartTime = $start; }
		Write-Warning "Filter Start: $start"
	}

	if ($end -ne $null) {
		$end = (Get-Date $end -Format 'MM/dd/yyyy HH:mm:ss')
		$filter += @{EndTime = $end; }
		Write-Warning "Filter End: $end"
	}

	$allevents = $null; $lockedout = @()

	foreach ($dc in $dcs) {
		Write-Output "Contacting $dc"
		try {
			$allevents = (Get-WinEvent -ComputerName $dc -FilterHashtable $filter -ErrorAction Stop).ToXml()
			$allevents = "<root>$allevents</root>"

			foreach ($event in ([xml]$allevents).root.Event) {
				$user = ($event.EventData.data |  Where-Object { $_.Name -eq "TargetUserName" }).'#text'
				$from = ($event.EventData.data | Where-Object { $_.Name -eq "TargetDomainName" }).'#text'
				$dc = (($event.EventData.data | Where-Object { $_.Name -eq "SubjectUserName" }).'#text').TrimEnd("$")
				$domain = ($event.EventData.data | Where-Object { $_.Name -eq "SubjectDomainName" }).'#text'
				$entrytime = [datetime]$event.System.TimeCreated.SystemTime
				$status = (Get-ADUser -Identity $user  -Server $DC -Properties LockedOut).LockedOut
		
				$lockedout += [pscustomobject]@{User = $user; From = $from; DC = $dc; Domain = $domain; Timestamp = $entrytime; "Currently Locked Out" = $status }
			}
		}
		catch {
			$msg = $_.Exception.Message
			if (!$msg.StartsWith("No events were found")) {
				Write-Warning "$dc was unreachable or otherwise unparsable."
				Write-Warning "Ensure your account has Read access to the DC's Security log and the appropriate firewall ports are open."
			}
		}
	}

	if ($lockedout.count -eq 0) {
		Write-Warning "No locked out events could be found."
	}
	else {
		$lockedout | Out-Gridview
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-LockoutHistory.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LockoutHistory.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

