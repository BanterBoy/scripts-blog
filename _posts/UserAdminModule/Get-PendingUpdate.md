---
layout: post
title: Get-PendingUpdate.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/get-pendingupdate/
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

Retrieves the updates waiting to be installed from WSUS

#### Detailed Description

Retrieves the updates waiting to be installed from WSUS

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-PendingUpdates
```

Retrieves the updates that are available to install on the local system

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Boe Prox

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Get-PendingUpdate {

<#
	.SYNOPSIS
		Retrieves the updates waiting to be installed from WSUS
	
	.DESCRIPTION
		Retrieves the updates waiting to be installed from WSUS
	
	.PARAMETER Computername
		Computer or computers to find updates for.
	
	.EXAMPLE
		Get-PendingUpdates
		Retrieves the updates that are available to install on the local system
	
	.NOTES
		Author: Boe Prox
#>

	[CmdletBinding(
		DefaultParameterSetName = 'computer'
	)]
	param (
		[Parameter(ValueFromPipeline = $True)]
		[string[]]$Computername = $env:COMPUTERNAME
	)
	Process {
		ForEach ($computer in $Computername) {
			If (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
				Try {
					#Create Session COM object
					Write-Verbose "Creating COM object for WSUS Session"
					$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session", $computer))
				}
				Catch {
					Write-Warning "$($Error[0])"
					Break
				}

				#Configure Session COM Object
				Write-Verbose "Creating COM object for WSUS update Search"
				$updatesearcher = $updatesession.CreateUpdateSearcher()

				#Configure Searcher object to look for Updates awaiting installation
				Write-Verbose "Searching for WSUS updates on client"
				$searchresult = $updatesearcher.Search("IsInstalled=0")

				#Verify if Updates need installed
				Write-Verbose "Verifing that updates are available to install"
				If ($searchresult.Updates.Count -gt 0) {
					#Updates are waiting to be installed
					Write-Verbose "Found $($searchresult.Updates.Count) update\s!"
					#Cache the count to make the For loop run faster
					$count = $searchresult.Updates.Count

					#Begin iterating through Updates available for installation
					Write-Verbose "Iterating through list of updates"
					For ($i = 0; $i -lt $Count; $i++) {
						#Create object holding update
						$Update = $searchresult.Updates.Item($i)
						[pscustomobject]@{
							Computername     = $Computer
							Title            = $Update.Title
							KB               = $($Update.KBArticleIDs)
							SecurityBulletin = $($Update.SecurityBulletinIDs)
							MsrcSeverity     = $Update.MsrcSeverity
							IsDownloaded     = $Update.IsDownloaded
							Url              = $($Update.MoreInfoUrls)
							Categories       = ($Update.Categories | Select-Object -ExpandProperty Name)
							BundledUpdates   = @($Update.BundledUpdates) | ForEach-Object {
								[pscustomobject]@{
									Title       = $_.Title
									DownloadUrl = @($_.DownloadContents).DownloadUrl
								}
							}
						}
					}
				}
				Else {
					#Nothing to install at this time
					Write-Verbose "No updates to install."
				}
			}
			Else {
				#Nothing to install at this time
				Write-Warning "$($c): Offline"
			}
		}
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-PendingUpdate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PendingUpdate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

