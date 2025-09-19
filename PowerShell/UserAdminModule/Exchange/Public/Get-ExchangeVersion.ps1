function Get-ExchangeVersion {
	<#
	.SYNOPSIS
	Retrieves Exchange server version information using registry for rollup info
	Outputs objects which can be post-processed or filtered.
       
   	Michel de Rooij
	michel@eightwone.com
	http://eightwone.com
	
	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
	Version 1.4, March 8th, 2021
	
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
    1.40 Added ComputerName parameter
         Default operation mode is against local host
         Made pipeline friendly
         Small optimizations

	.EXAMPLE
	Get-ExchangeVersion.ps1

    .EXAMPLE
    Get-ExchangeServer | .\Get-ExchangeVersion.ps1
#>
	Param(
		[parameter( Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)] 
		[alias('cn')]
		[string[]]$ComputerName
	)

	Begin {
		# Scripts doesn't works for these roles and only for indicated versions
		$NonValidRoles = ( 'ProvisionedServer', 'Edge')
		$ValidVersions = 8, 14, 15

		Function getExchVersion {
			Param(
				$Server
			)
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
							Write-Error ('Unknown minor version: {0}' -f $Server.AdminDisplayVersion)
							return $null
						}
					}
				}
				default {
					Write-Error ('Unknown major version: {0}' -f $Server.AdminDisplayVersion)
					return $null
				}
			}
			$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey( 'LocalMachine', $Server)
			$MainKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\{0}\' -f $prodguid

			$displayVersion = $reg.OpenSubKey( ('{0}\InstallProperties' -f $MainKey)).GetValue( 'DisplayVersion')
			$exchVersionRegex = [regex]::match( $displayVersion, '^(?:(\d+)\.)?(?:(\d+)\.)?(?:(\d+)\.)?(\d+)$')
			$maxMajor = $exchVersionRegex.captures.groups[1].value
			$maxMinor = $exchVersionRegex.captures.groups[2].value
			$maxBuild = $exchVersionRegex.captures.groups[3].value
			$maxRevision = $exchVersionRegex.captures.groups[4].value
			$updates = $reg.OpenSubKey( ('{0}\Patches' -f $MainKey)).GetSubKeyNames()
			If ( $Updates) {
				ForEach ($updatekey in $updates) {
					$update = $reg.OpenSubKey( ('{0}\Patches\{1}' -f $MainKey, $updatekey)).GetValue( 'DisplayName')
					$fullversion = [regex]::match( $update, '[0-9\.]*$').value
					$exchPatchVersionRegex = [regex]::match( $fullversion, '^(?:(\d+)\.)?(?:(\d+)\.)?(?:(\d+)\.)?(\d+)$')
					[Uint32]$build = $exchPatchVersionRegex.captures.groups[3].value
					[Uint32]$revision = $exchPatchVersionRegex.captures.groups[4].value
					If ($build -gt $maxBuild -or $build -ge $maxBuild -and $revision -gt $maxRevision) {
						$maxBuild = $build
						$maxRevision = $revision
					}
				}
			}
			return ('{0}.{1}.{2}.{3}' -f $maxMajor, $maxMinor, $maxBuild, $maxRevision)
		}

		If (-not( Get-Command Get-ExchangeServer -ErrorAction SilentlyContinue)) {
			Throw 'Exchange Management Shell not loaded.'
		}
	}
	Process {
		If ($null -eq $ComputerName) {
			$ComputerName = Get-ExchangeServer -Identity $ENV:COMPUTERNAME
		}
		$ComputerName | ForEach-Object {
			If ( $_.getType().FullName -eq 'Microsoft.Exchange.Data.Directory.Management.ExchangeServer') {
				$ThisServer = $_
			}
			Else {
				$ThisServer = Get-ExchangeServer -Identity $_
			}

			$bValid = $False
			If ($ValidVersions -contains $ThisServer.AdminDisplayVersion.Major) {
				If ( $NonValidRoles.Contains( $ThisServer.ServerRole)) {
					Write-Warning ('Script does not work on Exchange server {0} with roles {1}' -f $ThisServer.Name, ($NonValidRoles -join ','))
				}
				Else {
					$bValid = $True
				}
			}
			Else {
				Write-Warning ('Script does not work on Exchange server {0} with version {1}' -f $ThisServer.Name, $ThisServer.AdminDisplayVersion.Major)
			}

			$bOnline = Test-Connection $ThisServer.Name -Count 1 -ErrorAction SilentlyContinue

			$outObj = New-Object Object
			$outObj | Add-Member -MemberType NoteProperty Server $ThisServer.Name
			If ( $bValid -and $bOnline) {
				$outObj | Add-Member -MemberType NoteProperty Accessible $true
				$outObj | Add-Member -MemberType NoteProperty AdminVersion $ThisServer.AdminDisplayVersion
				$exVer = getExchVersion -Server $ThisServer
				$outObj | Add-Member -MemberType NoteProperty ExchangeVersion $exVer
			}
			Else {
				$outObj | Add-Member -MemberType NoteProperty Accessible $false
				$outObj | Add-Member -MemberType NoteProperty AdminVersion "N/A"
				$outObj | Add-Member -MemberType NoteProperty ExchangeVersion "N/A"
			}
			$outObj
		}
	}
	End {

	}

}