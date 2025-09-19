function Find-Movies {
	<#
	.SYNOPSIS
		A function to search for files
	
	.DESCRIPTION
		A function to search for files.
		
		Searches are performed by passing the parameters to Get-Childitem which will then
		recursively search through your specified file path and then perform a sort to output
		the most recently amended files at the top of the list.
		
		Outputs inlcude the Name,DirectoryName and FullName
		
		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
		
		If the extension is not provided it defaults to searching for PS1 files (PowerShell Scripts).
		
		Using the switch you can choose to search the start or end of the file or selecting wild,
		will perform a wildcard search using your searchterm.
	
	.PARAMETER Path
		Species the search path. The search will perform a recursive search on the specified folder path.
	
	.PARAMETER SearchTerm
		Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.
	
	.PARAMETER SearchType
		Specifies the type of search perfomed. Options are Start, End or Wild. This will search either the beginning, end or somewhere inbetween. If no option is selected, it will default to performing a wildcard search.
	
	.PARAMETER Extension
		Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg"
	
	.EXAMPLE
		Search-Scripts -Path .\scripts-blog\PowerShell\ -SearchTerm dns -SearchType Wild -Extension .ps1
		
		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
		
		Recursively scans the folder path looking for all files containing the searchterm and lists the files located in the output
	
	.OUTPUTS
		System.String. Search-Scripts returns a string with the extension or file name.
		
		Name                        DirectoryName                                       FullName
		----                        -------------                                       --------
		Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- Path [string]
		- SearchTerm [string]
		- Extension [string]
		- SearchType [string]
	
	.LINK
		https://github.com/BanterBoy/scripts-blog
		Get-Childitem
		Select-Object
	#>
	[CmdletBinding(DefaultParameterSetName = 'Default',
		PositionalBinding = $true,
		SupportsShouldProcess = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 0,
			HelpMessage = 'Enter the base path you would like to search.')]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path $_ })]
		[string]$Path,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 1,
			HelpMessage = 'Enter the text you would like to search for.')]
		[ValidateNotNullOrEmpty()]
		[string]$SearchTerm = '*', # Default to wildcard search
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			Position = 2,
			HelpMessage = 'Select the type of search. You can select Start/End/Wild to perform search for a file.')]
		[ValidateSet('Start', 'End', 'Wild')]
		[string]$SearchType = 'Wild' # Default to wildcard search
	)
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$($Path)", "Searching for files")) {
			try {
				switch ($SearchType) {
					Start {
						Get-ChildItem -Path $Path -Filter "$SearchTerm*" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
					End {
						Get-ChildItem -Path $Path -Filter "*$SearchTerm" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
					Wild {
						Get-ChildItem -Path $Path -Filter "*$SearchTerm*" -Include '*.mp4', '*.avi', '*.mkv' -Recurse |
						Select-Object -Property Name, DirectoryName, FullName
					}
				}
			}
			catch {
				Write-Error "An error occurred while trying to locate files on path $Path. Please ensure the path exists and you have the necessary permissions to access it."
			}
		}
	}
}
