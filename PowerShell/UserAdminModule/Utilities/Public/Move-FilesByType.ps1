<#
.SYNOPSIS
Moves files to subfolders based on their file extensions.

.DESCRIPTION
The Move-FilesByType function moves files to subfolders based on their file extensions. It takes a base directory as input and searches for all files in that directory. For each file, it extracts the file extension and creates a subfolder with the same name as the file extension. It then moves the file to the corresponding subfolder.

.PARAMETER baseDirectory
The base directory where the files are located.

.EXAMPLE
Move-FilesByType -baseDirectory "C:\Path\To\Your\Files"
Moves all files in the "C:\Path\To\Your\Files" directory to subfolders based on their file extensions.

.NOTES
Author: Your Name
Date:   Current Date
#>

function Move-FilesByType {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory
    )

    # Check if the directory exists
    if (-Not (Test-Path -Path $baseDirectory)) {
        Write-Error "The directory '$baseDirectory' does not exist."
        return
    }

    # Get all files in the directory
    $files = Get-ChildItem -Path $baseDirectory -File

    # Loop through each file
    foreach ($file in $files) {
        # Extract the file extension and prepare the target subfolder path
        $fileExtension = $file.Extension.TrimStart('.')
        $targetFolder = Join-Path -Path $baseDirectory -ChildPath $fileExtension

        # Create the subfolder if it doesn't exist
        if (-Not (Test-Path -Path $targetFolder)) {
            New-Item -Path $targetFolder -ItemType Directory | Out-Null
        }

        # Move the file to the target subfolder
        $targetFilePath = Join-Path -Path $targetFolder -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $targetFilePath
    }
}

# Example Usage:
# Move-FilesByType -baseDirectory "C:\Path\To\Your\Files"
