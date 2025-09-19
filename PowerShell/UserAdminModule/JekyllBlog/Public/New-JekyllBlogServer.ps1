<#
.SYNOPSIS
	Starts a Jekyll blog server using Docker Compose.

.DESCRIPTION
	The New-JekyllBlogServer function starts a Jekyll blog server using Docker Compose. It provides two parameter sets: 'Select' and 'Blog'.
	- 'Select' parameter set prompts the user to select a folder location and then starts the blog server in that location.
	- 'Blog' parameter set starts the blog server in the specified path.
	- If no parameter set is specified, it prompts the user to select a folder location and starts the blog server in that location.

.PARAMETER BlogPath
	Specifies the parameter set to use. Valid values are 'Select' and 'Blog'.
	- 'Select': Prompts the user to select a folder location and starts the blog server in that location.
	- 'Blog': Starts the blog server in the specified path.

.PARAMETER Path
	Specifies the path where the blog server should be started. Only used when 'Blog' parameter set is selected.

.EXAMPLE
	New-JekyllBlogServer -BlogPath 'Select'
	Starts the Jekyll blog server by prompting the user to select a folder location.

.EXAMPLE
	New-JekyllBlogServer -BlogPath 'Blog' -Path 'C:\MyBlog'
	Starts the Jekyll blog server in the 'C:\MyBlog' path.

#>
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
