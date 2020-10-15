<#
	.SYNOPSIS
	Retrieves Exchange server version information using registry for rollup info
	Outputs objects which can be post-processed or filtered.
       
   	Michel de Rooij
	michel@eightwone.com
	http://eightwone.com
	
	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
	Version 1.33, October 22nd, 2018
	
	.DESCRIPTION
	Retrieves Exchange server version information using registry for rollup info
	Outputs objects which can be post-processed or filtered.

	.LINK
	http://eightwone.com

	Revision History
	---------------------------------------------------------------------
	1.0  Initial release
	1.1  Added support for Exchange Server 2013
             Renamed script to Get-ExchangeVersions.p1
        1.2  Added connectivity test
             Fixed patchless Exchange 2010 output issue
	1.3  Added Exchange 2016 support
        1.31 Fixed layout bug for 4-digit build no.
        1.32 Added EMS check
             Renamed to Get-ExchangeVersion
        1.33 Added Exchange Server 2019 support

	.EXAMPLE
	Get-ExchangeVersion.ps1
#>

#Requires -Version 1.0

# Scripts only works for these Exchange versions
$ValidVersions = (8, 14, 15)

# Scripts doesn't works for these Exchange roles
$NonValidRoles = ("ProvisionedServer", "Edge")

$output = @()

Function getExchVersion( $Server) {
	switch ( $Server.AdminDisplayVersion.Major) {
		8 {
			$prodguid = "461C2B4266EDEF444B864AD6D9E5B613"
			break
		}
		14 {
			$prodguid = "AE1D439464EB1B8488741FFA028E291C"
			break
		}
		15 {
			switch ( $Server.AdminDisplayVersion.Minor) {
				0 {
					$prodguid = "AE1D439464EB1B8488741FFA028E291C"
					break
				}
				1 {
					$prodguid = "442189DC8B9EA5040962A6BED9EC1F1F"
					break
				}
				2 {
					$prodguid = "442189DC8B9EA5040962A6BED9EC1F1F"
					break
				}
				default {
					Write-Error "Unknown major version $($Server.AdminDisplayVersion)"
					return 0
				}
			}
		}
		default {
			Write-Error "Unknown major version $($Server.AdminDisplayVersion)"
			return 0
		}
	}
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server)
	$MainKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$prodguid\"

	$displayVersion = $reg.OpenSubKey("$MainKey\InstallProperties").GetValue( "DisplayVersion")
	$maxMajor = [regex]::match( $displayVersion, "^\d{1,4}\.\d{1,4}").value
	$maxMinor = [regex]::match( $displayVersion, "\d{1,4}\.\d{1,4}$").value
	$updates = $reg.OpenSubKey( "$MainKey\Patches\").GetSubKeyNames()
	If ( $Updates) {
		ForEach ($updatekey in $updates) {
			$update = $reg.OpenSubKey("$MainKey\Patches\$updatekey").GetValue( "DisplayName")
			$fullversion = [regex]::match( $update, "[0-9\.]*$").value
			$major = [regex]::match( $fullversion, "^\d{1,3}\.\d{1,3}").value
			$minor = [regex]::match( $fullversion, "\d{1,3}\.\d{1,3}$").value
			If ($major -gt $maxMajor -or $major -ge $maxMajor -and $minor -gt $maxMinor) {
				$maxMajor = $major
				$maxMinor = $minor
			}
		}
	}
	return "$maxMajor.$maxMinor"
}

If (-not( Get-Command Get-ExchangeServer -ErrorAction SilentlyContinue)) {
	Write-Error 'Exchange Management Shell not loaded.'
	Exit 1
}

$ExSrv = Get-ExchangeServer
$ExSrv | ForEach-Object {
	$bValid = $False
	If ($ValidVersions -contains $_.AdminDisplayVersion.Major) {
		$_.ServerRole | ForEach-Object {
			If ( $NonValidRoles -match $_.ServerRole) {
				$bValid = $True
			}
			else {
				Write-Warning "Script doesn't work on Exchange server" $_.Name "with role" $NonValidRoles
			}
		}
	}
	else {
		Write-Warning "Script doesn't work on Exchange server" $_.Name "with version" $_.AdminDisplayVersion.Major
	}

	$bOnline = Test-Connection $_.Name -Count 1 -ErrorAction SilentlyContinue

	$outObj = New-Object Object
	$outObj | Add-Member -MemberType NoteProperty Server $_.Name
	If ( $bValid -and $bOnline) {
		$outObj | Add-Member -MemberType NoteProperty AdminVersion $_.AdminDisplayVersion
		$exVer = getExchVersion( $_ )
		$outObj | Add-Member -MemberType NoteProperty ExchangeVersion $exVer
	}
	Else {
		$outObj | Add-Member -MemberType NoteProperty AdminVersion "N/A"
		$outObj | Add-Member -MemberType NoteProperty ExchangeVersion "N/A"
	}
	$output += $outObj
}

$output

# For output to CSV, uncomment to following line:
# $output | Export-CSV output.csv.
