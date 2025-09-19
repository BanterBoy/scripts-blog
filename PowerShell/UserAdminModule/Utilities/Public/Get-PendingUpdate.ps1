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
