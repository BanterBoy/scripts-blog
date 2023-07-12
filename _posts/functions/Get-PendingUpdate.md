---
layout: post
title: Get-PendingUpdate.ps1
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

       Description
       -----------
       Retrieves the updates that are available to install on the local system
      .NOTES
      Author: Boe Prox

    #>

	#Requires -version 3.0
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/windowsUpdates/Get-PendingUpdate.ps1')">
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
