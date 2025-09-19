function New-PSDriveRootFolder {
	<#
    .SYNOPSIS
    Creates PowerShell drives for all folders in a given path.

    .DESCRIPTION
    The `New-PSDriveRootFolder` function creates PowerShell drives for all folders in a specified root folder. 
    It iterates through each folder in the root path, creating a PSDrive for each one. The function validates 
    the specified path and handles errors gracefully.

    .PARAMETER FolderPath
    The root folder for which to create PS Drives.

    .EXAMPLE
    New-PSDriveRootFolder -FolderPath "C:\Users\username\Documents\WindowsPowerShell\Modules"
    Creates PS Drives for all subfolders in the specified path.

    .NOTES
    Ensure you have the necessary permissions to create PS Drives for the specified folders.

    .LINK
    # Add relevant links if necessary
    #>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateScript({
				if (Test-Path $_ -PathType Container) {
					$true
				}
				else {
					throw "Path `$_` is not a valid directory."
				}
			})]
		[string]$FolderPath
	)

	# Get all directories in the specified path
	$PSDrivePaths = Get-ChildItem -Path "$FolderPath" -Directory

	# Initialize progress tracking variables
	$totalItems = $PSDrivePaths.Count
	$currentItem = 0

	foreach ($item in $PSDrivePaths) {
		$currentItem++
		Write-Progress -Activity "Creating PS Drives" -Status "Processing Item $currentItem of $totalItems" -PercentComplete (($currentItem / $totalItems) * 100)

		try {
			# Ensure the path exists
			if (Test-Path -Path $item.FullName) {
				# Generate a valid drive name by removing invalid characters
				$driveName = $item.Name -replace '[;~\/\.:]', ''

				# Check if the PSDrive already exists and handle naming conflicts
				$originalDriveName = $driveName
				$index = 1
				while (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue) {
					$driveName = "$originalDriveName$index"
					$index++
				}

				# Create the new PSDrive
				New-PSDrive -Name $driveName -PSProvider "FileSystem" -Root $item.FullName -Scope Global
				Write-Verbose "Drive $driveName created successfully."
			}
		}
		catch {
			Write-Warning "Error creating drive {$driveName}: $_"
		}
	}
}
