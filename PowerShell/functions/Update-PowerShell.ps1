Function Update-PowerShell {
<#
	.SYNOPSIS
		Update-PowerShell can be used to update PowerShell to the latest available version.
	
	.DESCRIPTION
		Update-PowerShell can be used to update PowerShell to the latest available version.
	
	.PARAMETER Check
		Tests if PowerShellForGitHub module is installed and if not, installs module.
		Checks current version installed.
	
	.PARAMETER Update
		Updates the current version installed to the latest release.
	
	.EXAMPLE
		PS C:\> Update-PowerShell
	
	.EXAMPLE
		PS C:\> Update-PowerShell -Update
	
	.EXAMPLE
		PS C:\> Update-PowerShell -Check
	
	.OUTPUTS
		string
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	[OutputType([string], ParameterSetName = 'Default')]
	[OutputType([string])]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $false)]
		[Alias('chk')]
		[switch]$Check,
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $false)]
		[Alias('up')]
		[switch]$Update
	)
	
	If ($Update) {
		Try {
			$Protocols = [System.Net.SecurityProtocolType]'Tls12'
			[System.Net.ServicePointManager]::SecurityProtocol = $Protocols
			Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
		}
		Catch {
			Write-Error -Message $_
		}
	}
	If ($Check) {
		Try {
			# Test if PowerShellForGitHub module is installed and if not, install module.
			$Module = "PowerShellForGitHub"
			Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			If (Get-Module -Name $Module) {
				Import-Module -Name $Module
				Write-Verbose "Module Import - Imported $Module"
			}
			Else {
				Write-Verbose "Installing $Module"
				$execpol = Get-ExecutionPolicy -Scope Process
				If ($execpol -ne 'Unrestricted') {
					Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
				}
				Install-Module -Name $Module -Scope CurrentUser
			}
			# Test current version installed and update if not latest release
			Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
			$GitRelease = (Get-GitHubRelease -OwnerName PowerShell -RepositoryName PowerShell -Latest -ErrorAction Continue).tag_name
			$LocalVersion = $PSVersionTable.GitCommitId
			If ($GitRelease -like "*" + $LocalVersion) {
				Write-Output "Up-to-date!"
			}
		}
		Catch {
			Write-Error -Message $_
		}
	}
	Else {
		Try {
			# Test if PowerShellForGitHub module is installed and if not, install module.
			$Module = "PowerShellForGitHub"
			Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			If (Get-Module -Name $Module) {
				Import-Module -Name $Module
				Write-Verbose "Module Import - Imported $Module"
			}
			Else {
				Write-Verbose "Installing $Module"
				$execpol = Get-ExecutionPolicy -Scope Process
				If ($execpol -ne 'Unrestricted') {
					Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
				}
				Install-Module -Name $Module -Scope CurrentUser
			}
			
			# Test current version installed and update if not latest release
			Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
			$GitRelease = (Get-GitHubRelease -OwnerName PowerShell -RepositoryName PowerShell -Latest -ErrorAction Continue).tag_name
			$LocalVersion = $PSVersionTable.GitCommitId
			If ($GitRelease -like "*" + $LocalVersion) {
				Write-Output "Up-to-date!"
			}
			Else {
				$Protocols = [System.Net.SecurityProtocolType]'Tls12'
				[System.Net.ServicePointManager]::SecurityProtocol = $Protocols
				Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
			}
		}
		Catch {
			Write-Error -Message $_
		}
	}
}

# Update-PowerShell