function Randomize-FilesIntoSubfolders {
    <#
    .SYNOPSIS
    Distributes files from a base directory into a specified number of randomly named subfolders.

    .DESCRIPTION
    The Randomize-FilesIntoSubfolders function takes all files from a specified base directory and distributes them into a specified number of subfolders with random names. If the base directory does not exist or contains no files, appropriate warnings or errors are displayed.

    .PARAMETER baseDirectory
    The path of the base directory containing the files to be moved.

    .PARAMETER numFolders
    The number of subfolders to create in the base directory.

    .EXAMPLE
    Randomize-FilesIntoSubfolders -baseDirectory "C:\Path\To\Your\Files" -numFolders 5
    Distributes all files from "C:\Path\To\Your\Files" into 5 randomly named subfolders within the same directory.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None. This function does not produce any output.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory,

        [Parameter(Mandatory = $true)]
        [int]$numFolders
    )

    # Check if the directory exists
    if (-Not (Test-Path -Path $baseDirectory)) {
        Write-Error "The directory '$baseDirectory' does not exist."
        return
    }
    else {
        Write-Verbose "The directory '$baseDirectory' exists."
    }

    # Check if the directory is not empty
    $files = Get-ChildItem -Path $baseDirectory -File
    if ($files.Count -eq 0) {
        Write-Warning "There are no files in the base directory '$baseDirectory' to move."
        return
    }
    else {
        Write-Verbose "Found $($files.Count) files in the base directory '$baseDirectory'."
    }

    # Generate random folder names and create them
    $randomFolderNames = 1..$numFolders | ForEach-Object {
        $randomFolderName = [System.IO.Path]::GetRandomFileName().Replace(".", "")
        $folderPath = Join-Path -Path $baseDirectory -ChildPath $randomFolderName
        New-Item -Path $folderPath -ItemType Directory | Out-Null
        Write-Verbose "Created folder '$folderPath'."
        $folderPath
    }

    # Move files to random folders
    foreach ($file in $files) {
        $randomFolderPath = Get-Random -InputObject $randomFolderNames
        $destinationPath = Join-Path -Path $randomFolderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
        Write-Verbose "Moved file '$($file.Name)' to folder '$randomFolderPath'."
    }
}

# Example Usage:
# Randomize-FilesIntoSubfolders -baseDirectory "C:\Path\To\Your\Files" -numFolders 5 -Verbose
