<#
.SYNOPSIS
Creates a new blog session by setting up a new PowerShell drive and opening the code editor.

.DESCRIPTION
The New-BlogSession function creates a new blog session by prompting the user to select a root folder for the blog. It then creates a new PowerShell drive using the selected folder as the root. Finally, it opens the code editor with the selected folder as the workspace.

.PARAMETER None

.EXAMPLE
New-BlogSession
#>

function New-BlogSession {
	$PSRootFolder = Select-FolderLocation
	New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
	code ($PSRootFolder) -n
}