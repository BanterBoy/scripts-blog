---
layout: post
title: Audit-ADTrusts.ps1
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
<#
.SYNOPSIS
	The script collect and verify Active Directory trusts of the current forest or a specified domain.

.NOTES
	Author		: Alexandre Augagneur (www.alexwinner.com)
	File Name	: Audit-ADTrusts.ps1
	Date		: 06/28/2013
	Version		: 1.0

.EXAMPLE
	.\Audit-ADTrusts.ps1 -FilePath C:\Temp\ADTrusts.csv

.EXAMPLE
	.\Audit-ADTrusts.ps1 -DomainName "corpnet.net" -FilePath C:\Temp\ADTrusts.csv

.PARAMETER FilePath
	File Path for the csv export of the trusts.

.PARAMETER DomainName
	Grab trusts of a specific domain. By default the script is connecting to the current forest.
#>

param (
	[Parameter(Mandatory = $true)]
	[ValidateScript( { Test-Path (Split-Path $_ -Parent) -PathType Container })]
	[String] $FilePath,

	[Parameter(Mandatory = $false)]
	[String] $DomainName
)

#Region Variables
####################################################
# Variables
####################################################

# List of properties of a trust relationship
$ObjTrustProps = @("Source Name", "Target Name", "Trust Direction", "Trust Type", "Selective Authentication", "SID Filtering",
	"SID History", "Inbound Status", "Outbound Status", "WMIPartnerDCName", "WMITrustIsOk", "WMITrustStatus")

#EndRegion

#Region Functions
####################################################
# Functions
####################################################

#---------------------------------------------------
# Verify the trust relationship using method
# System.DirectoryServices.ActiveDirectory.Domain.VerifyTrustRelationship)(
#---------------------------------------------------
function Check-TrustRelationship ( $objDomain, $TargetName, $Direction, $Type ) {
	Write-Host "`t=> Verifying the trust relationship between '$($objDomain.Name)' and '$($TargetName)'..."

	$ObjStatus = New-Object PsObject `
		-Property @{
		InBound          = "N/A"
		OutBound         = "N/A"
		WMIPartnerDCName = "N/A"
		WMITrustIsOk     = "N/A"
		WMITrustStatus   = "N/A"
	}

	try {
		try {
			# WMI Request using the trustmon WMI provider
			$WMIStatus = Get-WmiObject -Namespace root\MicrosoftActiveDirectory -Class Microsoft_DomainTrustStatus `
				-ComputerName $objDomain.PdcRoleOwner -Filter "TrustedDomain='$TargetName'" -ErrorAction SilentlyContinue -ErrorVariable WMIError

			if ( -not($WMIError) ) {
				$ObjStatus.WMITrustIsOk = $WMIStatus.TrustIsOk
				$ObjStatus.WMITrustStatus = $WMIStatus.TrustStatusString
				$ObjStatus.WMIPartnerDCName = $WMIStatus.TrustedDCName
			}
		}
		catch {
			Write-Verbose "Error while verifying trust with domain '$targetName': $($_.Exception.Message)"
		}

		# Quit the function if the trust is external and
		# if the user domain context is not the same of the source domain
		if ( $Type -match "External" -and ( $script:CurrentDomain.Name -ne $objDomainDomain) ) {
			Return $ObjStatus
		}
		# Connect to target domain (Use ADSI forest or ADSI domain constructor)
		elseif ( $Type -match "Forest" ) {
			$Context = new-object System.directoryServices.ActiveDirectory.DirectoryContext('Forest', $TargetName)
			$TargetDomain = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($Context)
		}
		else {
			$Context = new-object System.directoryServices.ActiveDirectory.DirectoryContext('Domain', $TargetName)
			$TargetDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
		}

		# Test each direction of the trust using the metode VerifyTrustRelationship
		switch ($Direction) {
			# Inbound trust
			"Inbound" {
				try {
					$objDomain.VerifyTrustRelationship($TargetDomain, $Direction)
					$ObjStatus.InBound = "Ok"
				}
				catch {
					$ObjStatus.InBound = "$($_.Exception.GetBaseException().Message.Trim())"
				}
			}
			# Outbound trust
			"Outbound" {
				try {
					$objDomain.VerifyTrustRelationship($TargetDomain, $Direction)
					$ObjStatus.OutBound = "Ok"
				}
				catch {
					$ObjStatus.OutBound = "$($_.Exception.GetBaseException().Message.Trim())"
				}

			}
			# Inbound/Outbound trust
			"Bidirectional" {
				try {
					$objDomain.VerifyTrustRelationship($TargetDomain, "Inbound")
					$ObjStatus.InBound = "Ok"
				}
				catch {
					$ObjStatus.InBound = "$($_.Exception.GetBaseException().Message.Trim())"
				}

				try {
					$objDomain.VerifyTrustRelationship($TargetDomain, "Outbound")
					$ObjStatus.OutBound = "Ok"
				}
				catch {
					$ObjStatus.OutBound = "$($_.Exception.GetBaseException().Message.Trim())"
				}

			}
		}
	}
	catch {
		$ObjStatus.InBound = "$($_.Exception.GetBaseException().Message.Trim())"
		$ObjStatus.OutBound = $ObjStatus.InBound
	}

	Return $ObjStatus
}

#---------------------------------------------------
# Construct the trust customized object
#---------------------------------------------------
Function Create-objTrust ( $objDomain, $trust ) {
	$ObjTrust = New-Object PsObject `
		-Property @{
		"Source Name"              = $trust.SourceName
		"Target Name"              = $trust.TargetName
		"Trust Direction"          = $trust.TrustDirection
		"Trust Type"               = $trust.TrustType
		"Selective Authentication" = "No"
		"SID Filtering"            = "No"
		"SID History"              = "No"
		"AD whenChanged"           = $null
	}

	# Check the selective authentication status
	if ( $objDomain.GetSelectiveAuthenticationStatus($ObjTrust."Target Name") ) {
		$ObjTrust."Selective Authentication" = "Yes"
	}

	# Check the sid filtering status
	if ( $objDomain.GetSidFilteringStatus($ObjTrust."Target Name") ) {
		$ObjTrust."SID Filtering" = "Yes"
	}

	# Retrieve the trust object from AD
	$objRootDSE = [System.DirectoryServices.DirectoryEntry] "LDAP://$($trust.SourceName)/rootDSE"
	$ADObj = [ADSI] "LDAP://CN=$($trust.TargetName),CN=system,$($objRootDSE.defaultNamingContext)"

	# Check if sid history is enabled
	if ( $ADObj.trustattributes.ToString() -band 64 ) {
		$ObjTrust."SID History" = "Yes"
	}

	# Retrieve whenChanged attribute of the trust object
	$ObjTrust."AD whenChanged" = $ADObj.whenchanged.ToString()

	# Call the function Check-TrustRelationship
	$ObjStatus = Check-TrustRelationship $ObjDomain $ObjTrust."Target Name"  $ObjTrust."Trust Direction" $ObjTrust."Trust Type"

	$ObjTrust | Add-Member -type NoteProperty -name "Inbound Status" -value $ObjStatus.Inbound
	$ObjTrust | Add-Member -type NoteProperty -name "Outbound Status" -value $ObjStatus.Outbound
	$ObjTrust | Add-Member -type NoteProperty -name "WMIPartnerDCName" -value $ObjStatus.WMIPartnerDCName
	$ObjTrust | Add-Member -type NoteProperty -name "WMITrustIsOk" -value $ObjStatus.WMITrustIsOk
	$ObjTrust | Add-Member -type NoteProperty -name "WMITrustStatus" -value $ObjStatus.WMITrustStatus

	Return $ObjTrust
}

#---------------------------------------------------
# Return the NETBIOSName of the specified domain distinguishedName
#---------------------------------------------------
Function Get-NETBiosName ( $dn, $ConfigurationNC ) {
	$Searcher = New-Object System.DirectoryServices.DirectorySearcher
	$Searcher.SearchScope = "subtree"
	$Searcher.PropertiesToLoad.Add("nETBIOSName") | Out-Null
	$Searcher.SearchRoot = "LDAP://cn=Partitions,$ConfigurationNC"
	$Searcher.Filter = "(nCName=$dn)"
	$NetBIOSName = ($Searcher.FindOne()).Properties.Item("nETBIOSName")
	Return $NetBIOSName
}

#---------------------------------------------------
# Warn the user if the script is not executed with enterprise admin account
#---------------------------------------------------
Function Is-MemberOf ( $Name ) {
	$Groups = @()

	([System.Security.Principal.WindowsIdentity]::GetCurrent()).Groups | `
		Foreach-Object { $Groups += $_.Translate([System.Security.Principal.NTAccount]) }

	if ( $Groups -notcontains "$Name\Enterprise Admins" ) {
		Write-Warning "The script is not running under an Enterprise Admins context."
	}
}

#---------------------------------------------------
# Main function listing trusts from AD and calling the function
# Create-objTrust for all trust relationships found
#---------------------------------------------------
function Get-ADTrusts ($Name, $Type) {
	# Specific treatment for forest or domain
	switch ($Type) {
		"Forest" {
			# Retrieve trusts from the current forest
			Write-Host "`n* Establishing connection to the current forest: " -NoNewline

			try {
				# Connecting to the forest
				$Forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
				Write-Host "SUCCESSFUL" -ForegroundColor Green

				# Check if the user account is enterprise admins
				$ForestPath = "DC=$($Forest.Name.Replace('.',',DC='))"
				$RootDomainNETBIOSName = Get-NETBiosName $ForestPath ([System.DirectoryServices.DirectoryEntry] "LDAP://rootDSE").configurationNamingContext

				Is-MemberOf $RootDomainNETBIOSName
			}
			catch {
				Write-Host "FAILED ($($_.Exception.GetBaseException().Message.Trim()))" -ForegroundColor RED
				Exit
			}

			try {
				Write-Host "`n`tRetrieving list of trusts from the forest '$($Forest.Name)'"

				# Retrieve list of forest trusts
				$ForestTrusts = $Forest.GetAllTrustRelationships()

				Write-Host "`tNumber of trusts found: " -NoNewline

				if ( $ForestTrusts.Count -gt 0 ) {
					Write-Host "$($ForestTrusts.Count)`n" -ForegroundColor Green
				}
				else {
					Write-Host "$($ForestTrusts.Count)`n" -ForegroundColor Red
				}

				for ( $i = 0; $i -lt $ForestTrusts.Count; $i++ ) {
					# Construct the list of object trusts to export
					$objTrust = Create-objTrust $Forest $ForestTrusts[$i]
					$script:Trusts.Add($ObjTrust) | Out-Null
				}
			}
			catch {
				$ObjTrust = New-Object -TypeName PsObject | Select-Object $ObjTrustProps
				$ObjTrust."Source Name" = $Forest.Name
				$ObjTrust."Target Name" = "$($_.Exception.GetBaseException().Message.Trim())"
				$script:Trusts.Add($ObjTrust) | Out-Null
			}

			# Recursive call of function Get-ADTrusts for each child domain
			foreach ( $Domain in $Forest.Domains) {
				Get-ADTrusts $Domain.Name "Domain"
			}
		}
		"Domain" {
			$DomainContext = new-object System.directoryServices.ActiveDirectory.DirectoryContext('Domain', $Name)
			Write-Host "`n* Establishing connection to domain '$Name': " -NoNewline

			try {
				# Connecting to the specified domain
				$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($DomainContext)
				Write-Host "SUCCESSFUL" -ForegroundColor Green

				# Retrieve list of trusts
				Write-Host "`n`tRetrieving list of trusts from '$($Domain.Name)'"
				$DomainTrusts = $Domain.GetAllTrustRelationships()

				try {
					Write-Host "`tNumber of trusts found: " -NoNewline

					if ( $DomainTrusts.Count -gt 0 ) {
						Write-Host "$($DomainTrusts.Count)`n" -ForegroundColor Green
					}
					else {
						Write-Host "$($DomainTrusts.Count)`n" -ForegroundColor Red
					}

					for ( $i = 0; $i -lt $DomainTrusts.Count; $i++ ) {
						$objTrust = Create-objTrust $Domain $DomainTrusts[$i]
						$script:Trusts.Add($ObjTrust) | Out-Null
					}
				}
				catch {
					$ObjTrust = New-Object -TypeName PsObject | Select-Object $ObjTrustProps
					$ObjTrust."Source Name" = $Domain.Name
					$ObjTrust."Target Name" = "$($_.Exception.GetBaseException().Message.Trim())"
					$script:Trusts.Add($ObjTrust) | Out-Null
				}
			}
			catch {
				Write-Host "FAILED ($($_.Exception.GetBaseException().Message.Trim()))" -ForegroundColor RED
				#Exit
			}
		}
	}
}

#EndRegion

#Region Main

####################################################
# Main
####################################################

$script:Trusts = new-object System.Collections.ArrayList
$script:CurrentDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

# Connect to the specified domain or the current forest and list trusts
if ( $DomainName ) {
	# Retrieve list of trusts of the specified domain
	Get-ADTrusts $DomainName "Domain"
}
else {
	# Retrieve list of trust of the specified forest and child domains
	Get-ADTrusts $null "Forest"
}

# Export results to csv file
if ($script:Trusts) {
	$script:Trusts | Export-Csv -Path $FilePath -Delimiter ";" -NoTypeInformation -Force
	Write-Host "`nActive Directory trusts inventory exported to " -NoNewline
	Write-Host $FilePath -ForegroundColor Green
}
else {
	Write-Host "`nNo trust found." -ForegroundColor Yellow
}
#EndRegion
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Audit-ADTrusts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Audit-ADTrusts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
