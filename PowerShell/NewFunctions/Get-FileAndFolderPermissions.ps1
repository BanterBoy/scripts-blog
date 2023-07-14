function Get-FileAndFolderPermissions {

	<#
	.SYNOPSIS
	Retrieves the permissions for files or folders at a specified path.

	.DESCRIPTION
	The Get-FileAndFolderPermissions function retrieves the permissions for files or folders at a specified path. It can retrieve permissions for a single file or folder, or for all files or folders in a directory and its subdirectories.

	.PARAMETER SourcePath
	The path to the file or folder for which to retrieve permissions.

	.PARAMETER FileFolder
	Specifies whether to retrieve permissions for a file or a folder. Valid values are "File" and "Folder".

	.PARAMETER Extension
	Specifies a file extension to filter by when retrieving permissions for files.

	.PARAMETER Recurse
	Indicates whether to retrieve permissions for files or folders in subdirectories.

	.EXAMPLE
	Get-FileAndFolderPermissions -SourcePath "C:\Temp\MyFile.txt" -FileFolder "File"

	Retrieves the permissions for the file "MyFile.txt" located in the "C:\Temp" directory.

	.EXAMPLE
	Get-FileAndFolderPermissions -SourcePath "C:\Temp" -FileFolder "Folder" -Recurse

	Retrieves the permissions for all folders in the "C:\Temp" directory and its subdirectories.

	.NOTES
	Author: GitHub Copilot
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]$SourcePath,
		[Parameter(Mandatory = $true)]
		[ValidateSet("File", "Folder")]
		[string]$FileFolder,
		[string]$Extension,
		[switch]$Recurse
	)

	try {
		if ($FileFolder -eq "File") {
			if (-not (Test-Path $SourcePath)) {
				throw "File does not exist: $SourcePath"
			}
			if ($Extension) {
				$files = Get-ChildItem $SourcePath -Filter "*$Extension" -File -Recurse:$Recurse
			}
			else {
				$files = Get-ChildItem $SourcePath -File -Recurse:$Recurse
			}
			foreach ($file in $files) {
				$acl = Get-Acl $file.FullName
				foreach ($access in $acl.Access) {
					[PSCustomObject]@{
						Path              = $file.FullName
						IdentityReference = $access.IdentityReference
						FileSystemRights  = $access.FileSystemRights
					}
				}
			}
		}
		elseif ($FileFolder -eq "Folder") {
			if (-not (Test-Path $SourcePath)) {
				throw "Folder does not exist: $SourcePath"
			}
			$acl = Get-Acl $SourcePath
			foreach ($access in $acl.Access) {
				[PSCustomObject]@{
					Path              = $SourcePath
					IdentityReference = $access.IdentityReference
					FileSystemRights  = $access.FileSystemRights
				}
			}
			if ($Recurse) {
				$folders = Get-ChildItem $SourcePath -Directory -Recurse
				foreach ($folder in $folders) {
					$acl = Get-Acl $folder.FullName
					foreach ($access in $acl.Access) {
						[PSCustomObject]@{
							Path              = $folder.FullName
							IdentityReference = $access.IdentityReference
							FileSystemRights  = $access.FileSystemRights
						}
					}
				}
			}
		}
	}
 catch {
		Write-Error $_.Exception.Message
	}
}
