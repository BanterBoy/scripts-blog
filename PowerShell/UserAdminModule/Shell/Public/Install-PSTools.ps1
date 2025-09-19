<#
.SYNOPSIS
	Installs or uninstalls PSTools.

.DESCRIPTION
	This script contains two functions: Install-PSTools and Uninstall-PSTools.
	Install-PSTools downloads and installs PSTools if it is not already installed.
	Uninstall-PSTools removes PSTools from the system.

.PARAMETER Uninstall
	Specifies whether to uninstall PSTools. If this switch is provided, the script will call the Uninstall-PSTools function.

.INPUTS
	None.

.OUTPUTS
	None.

.EXAMPLE
	Install-PSTools
	Installs PSTools if it is not already installed.

.EXAMPLE
	Install-PSTools -Uninstall
	Uninstalls PSTools from the system.

.NOTES
	Author: Your Name
	Date:   Current Date
#>

function Uninstall-PSTools {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param()

	if ($PSCmdlet.ShouldProcess('PSTools', 'Uninstall')) {
		Write-Verbose "Checking if PSTools is installed..."
		if (!(Test-Path 'C:\Program Files\Sysinternals\PsExec.exe')) {
			Write-Verbose "PSTools is not installed."
			return
		}

		try {
			Write-Verbose "Removing PSTools from 'C:\Program Files\Sysinternals\'..."
			Remove-Item -Path 'C:\Program Files\Sysinternals\' -Recurse -Force -ErrorAction Stop

			Write-Verbose "Removing 'C:\Program Files\Sysinternals\' from system and user 'Path'..."
			Remove-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'Machine'
			Remove-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'User'
		}
		catch {
			Write-Error "An error occurred: $_"
		}
	}
}

function Install-PSTools {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param(
		[switch] $Uninstall
	)

	if ($Uninstall) {
		Uninstall-PSTools
	}
	else {
		if ($PSCmdlet.ShouldProcess('PSTools', 'Install')) {
			Write-Verbose "Checking if PSTools is already installed..."
			if (Test-Path 'C:\Program Files\Sysinternals\PsExec.exe') {
				Write-Verbose "PSTools is already installed."
				return
			}

			try {
				# Paths
				$Temp = "C:\Temp\"
				$ZipTemp = $Temp + "\pstools.zip"
				$ZipTempExtract = $Temp + "\pstools\"

				Write-Verbose "Downloading PSTools..."
				Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile $ZipTemp -ErrorAction Stop
				Write-Verbose "Extracting PSTools..."
				Expand-Archive -Path $ZipTemp -DestinationPath $ZipTempExtract -Force -ErrorAction Stop

				Write-Verbose "Checking if 'C:\Program Files\Sysinternals\' directory exists..."
				if (!(Test-Path 'C:\Program Files\Sysinternals\')) {
					Write-Verbose "Creating 'C:\Program Files\Sysinternals\' directory..."
					New-Item -Path 'C:\Program Files\Sysinternals\' -ItemType Directory -Force | Out-Null
				}

				Write-Verbose "Copying PSTools to 'C:\Program Files\Sysinternals\'..."
				$Tools = Get-ChildItem -Path $ZipTempExtract -File -Recurse -Force
				$Tools | ForEach-Object {
					Copy-Item -Path $_.FullName -Destination 'C:\Program Files\Sysinternals\' -Force -ErrorAction Stop
				}

				Write-Verbose "Cleaning up temporary files..."
				Remove-Item -Path $ZipTemp -Force
				Remove-Item -Path $ZipTempExtract -Recurse -Force

				Write-Verbose "Checking if user is an administrator..."
				$test = Test-IsAdmin
				if ($test -eq $true) {
					Write-Verbose "User is an administrator. Adding 'C:\Program Files\Sysinternals\' to system 'Path'..."
					Add-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'Machine'
				}
				else {
					Write-Verbose "User is not an administrator. Adding 'C:\Program Files\Sysinternals\' to user 'Path'..."
					Add-EnvPath -Path 'C:\Program Files\Sysinternals\' -Container 'User'
				}
			}
			catch {
				Write-Error "An error occurred: $_"
			}
		}
	}
}
