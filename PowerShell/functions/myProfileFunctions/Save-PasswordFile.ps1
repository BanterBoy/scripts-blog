function Save-PasswordFile {
	<# Example

	.EXAMPLE
	Save-Password -Label UserName

	.EXAMPLE
	Save-Password -Label Password

	#>
	param(
		[Parameter(Mandatory = $true,
			HelpMessage = "Enter password label")]
		[string]$Label,

		[Parameter(Mandatory = $false,
			HelpMessage = "Enter file path.")]
		[ValidateSet('Profile', 'Select') ]
		[string]$Path
	)

	switch ($Path) {
		Profile {
			$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
			$filePath = "$ProfilePath" + "\$Label.txt"
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$filePath"
		}
		Select {
			$directoryPath = Select-FolderLocation
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$directoryPath\$Label.txt"
		
		}
		Default {
			$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
			$filePath = "$ProfilePath" + "\$Label.txt"
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$filePath"
		}
	}
}