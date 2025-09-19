function Save-PasswordFile {
	<#
    .SYNOPSIS
        Saves a secure password to a file.

    .DESCRIPTION
        This function saves a secure password to a file with the specified label. The user can choose to save the password 
        in a predefined profile path or select a custom path.

    .PARAMETER Label
        The label for the password file.

    .PARAMETER Path
        The path where the password file will be saved. Options are 'Profile' or 'Select'. If not specified, the default is 'Profile'.

    .EXAMPLE
        Save-PasswordFile -Label UserName
        Prompts for a password and saves it to a file named 'UserName.txt' in the profile path.

    .EXAMPLE
        Save-PasswordFile -Label Password -Path Select
        Prompts for a password and allows the user to select a folder to save the password file named 'Password.txt'.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true,
			HelpMessage = "Enter password label")]
		[string]$Label,

		[Parameter(Mandatory = $false,
			HelpMessage = "Enter file path.")]
		[ValidateSet('Profile', 'Select')]
		[string]$Path = 'Profile'
	)

	begin {
		Write-Verbose -Message "Starting Save-PasswordFile function"
	}

	process {
		$securePassword = Read-Host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString

		switch ($Path) {
			'Profile' {
				Write-Verbose -Message "Using profile path for password storage"
				$ProfilePath = Split-Path -Path $PROFILE
				$filePath = Join-Path -Path $ProfilePath -ChildPath "$Label.txt"
			}
			'Select' {
				Write-Verbose -Message "Allowing user to select a folder for password storage"
				$directoryPath = Select-FolderLocation
				if ([string]::IsNullOrEmpty($directoryPath)) {
					Write-Error "No directory selected. Exiting function."
					return
				}
				$filePath = Join-Path -Path $directoryPath -ChildPath "$Label.txt"
			}
		}

		Write-Verbose -Message "Saving password to $filePath"
		try {
			$securePassword | Out-File -FilePath $filePath
			Write-Verbose -Message "Password saved successfully to $filePath"
		}
		catch {
			Write-Error "Failed to save password: $_"
		}
	}

	end {
		Write-Verbose -Message "Completed Save-PasswordFile function"
	}
}

# Example Usage:
# Save-PasswordFile -Label UserName -Verbose
# Save-PasswordFile -Label Password -Path Select -Verbose
