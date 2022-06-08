function New-JekyllBlogServer {
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param(
		[Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter path or Browse to select dockerfile")]
		[ValidateSet('Select', 'Blog')]
		[string]$BlogPath,
		[string]$Path
	)
	switch ($BlogPath) {
		Select {
			try {
				$PSRootFolder = Select-FolderLocation
				Set-Location -Path $PSRootFolder
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Blog {
			try {
				Set-Location -Path $Path
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Default {
			try {
				Set-Location -Path $PSRootFolder
				$PSRootFolder = Select-FolderLocation
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
	}
}
