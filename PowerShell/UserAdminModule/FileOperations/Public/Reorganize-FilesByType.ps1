function Reorganize-FilesByType {

    <#
    .SYNOPSIS
        Reorganizes files in a directory into subfolders based on file types.

    .DESCRIPTION
        This function reorganizes all files in the specified base directory (and its subdirectories) into subfolders based on their file extensions. 
        It also cleans up any empty folders after moving the files.

    .PARAMETER baseDirectory
        The root directory containing the files to be reorganized.

    .EXAMPLE
        Reorganize-FilesByType -baseDirectory "C:\Path\To\Your\Files"
        This example reorganizes all files in "C:\Path\To\Your\Files" into subfolders based on their file types.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

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

    Write-Verbose "Scanning for all files in the directory and subdirectories."
    # Get all files in the directory and subdirectories
    $files = Get-ChildItem -Path $baseDirectory -File -Recurse

    Write-Verbose "Found $($files.Count) files. Starting reorganization process."

    # Loop through each file
    foreach ($file in $files) {
        # Extract the file extension and prepare the target subfolder path
        $fileExtension = $file.Extension.TrimStart('.')
        if ($fileExtension -eq '') {
            $fileExtension = 'NoExtension'
        }
        $targetFolder = Join-Path -Path $baseDirectory -ChildPath $fileExtension

        # Create the subfolder if it doesn't exist
        if (-Not (Test-Path -Path $targetFolder)) {
            Write-Verbose "Creating folder: $targetFolder"
            New-Item -Path $targetFolder -ItemType Directory | Out-Null
        }

        # Move the file to the target subfolder if it's not already there
        $targetFilePath = Join-Path -Path $targetFolder -ChildPath $file.Name
        if ($file.FullName -ne $targetFilePath) {
            Write-Verbose "Moving file: $($file.FullName) to $targetFilePath"
            Move-Item -Path $file.FullName -Destination $targetFilePath
        }
    }

    Write-Verbose "Reorganization complete. Starting cleanup of empty folders."

    # Clean up empty folders
    $allFolders = Get-ChildItem -Path $baseDirectory -Directory -Recurse
    foreach ($folder in $allFolders) {
        if ((Get-ChildItem -Path $folder.FullName).Count -eq 0) {
            Write-Verbose "Removing empty folder: $($folder.FullName)"
            Remove-Item -Path $folder.FullName
        }
    }

    Write-Verbose "Cleanup complete."
}

# Example Usage:
# Reorganize-FilesByType -baseDirectory "C:\Path\To\Your\Files" -Verbose
