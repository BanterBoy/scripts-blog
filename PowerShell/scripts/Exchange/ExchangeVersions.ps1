#############################################################################
# Name        : ExchangeVersions.ps1
# Author      : Michel de Rooij (michel@eightwone.com)
# Version     : 1.0
#
# Description:
# -------------
# Retrieves the highest Exchange version using registry for rollup info
#############################################################################

# Scripts only works for these Exchange versions
$ValidVersions = (8, 14)

# Scripts doesn't works for these Exchange roles
$NonValidRoles = ("ProvisionedServer", "Edge")

$output = @()

Function getExchVersion( $Server) {
	$maxMajor = [regex]::match( $Server.AdminDisplayVersion, "^\d{1,3}\.\d{1,3}").value
	$maxMinor = [regex]::match( $Server.AdminDisplayVersion, "\d{1,3}\.\d{1,3}$").value
	switch ( $Server.AdminDisplayVersion.Major) {
		8 {
			$prodguid = "461C2B4266EDEF444B864AD6D9E5B613"
			break
		}
		14 {
			$prodguid = "AE1D439464EB1B8488741FFA028E291C"
			break
		}
		default {
			write-error "Invalid major version passed to getExchVersion()"
			exit
		}
	}
	$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server)
	$updateskey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\$prodguid\Patches\"
	$updates = $reg.OpenSubKey( $updateskey).GetSubKeyNames()
	ForEach ($updatekey in $updates) {
		$update = $reg.OpenSubKey("$updateskey\$updatekey").GetValue( "DisplayName")
		$fullversion = [regex]::match( $update, "[0-9\.]*$").value
		$major = [regex]::match( $fullversion, "^\d{1,3}\.\d{1,3}").value
		$minor = [regex]::match( $fullversion, "\d{1,3}\.\d{1,3}$").value
		If ($major -gt $maxMajor -or $major -ge $maxMajor -and $minor -gt $maxMinor) {
			$maxMajor = $major
			$maxMinor = $minor
		}
	}
	return "$maxMajor.$maxMinor"
}

Get-ExchangeServer | foreach ($Server) {
	$bValid = $False
	If ($ValidVersions -contains $_.AdminDisplayVersion.Major) {
		$_.ServerRole | foreach {
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

	If ($bValid) {
		$outObj = New-Object Object
		$outObj | Add-Member -MemberType NoteProperty Server $_.Name
		$outObj | Add-Member -MemberType NoteProperty AdminVersion $_.AdminDisplayVersion
		$exVer = getExchVersion( $_ )
		$outObj | Add-Member -MemberType NoteProperty ExchangeVersion $exVer
		$output += $outObj
	}
}

$output

# For output to CSV, uncomment to following line:
# $output | Export-CSV output.csv
