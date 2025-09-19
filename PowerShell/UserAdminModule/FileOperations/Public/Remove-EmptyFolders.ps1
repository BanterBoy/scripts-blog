function Remove-EmptyFolders {
    <#
    .SYNOPSIS
    Removes empty folders from a specified path recursively.

    .DESCRIPTION
    The Remove-EmptyFolders function traverses a specified directory path recursively and removes any empty folders it finds. It also checks if the root folder itself is empty and removes it if necessary.

    .PARAMETER Path
    The path of the directory to check for empty folders.

    .EXAMPLE
    Remove-EmptyFolders -Path "C:\Temp"

    .EXAMPLE
    Remove-EmptyFolders "\\deathstar.domain.leigh-services.com\MyMusic\" -Verbose

    .INPUTS
    System.String. The path to the directory to check for empty folders.

    .OUTPUTS
    System.String. A message indicating which folders were removed.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    # Helper function to determine if a folder is empty
    function Is-EmptyFolder {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath
        )
        # Check if the folder contains any files or subfolders
        if ((Get-ChildItem -Path $FolderPath -File).Count -eq 0 -and
            (Get-ChildItem -Path $FolderPath -Directory).Count -eq 0) {
            return $true
        }
        return $false
    }

    # Check if the path exists
    if (-Not (Test-Path -Path $Path)) {
        Write-Error "The specified path '$Path' does not exist."
        return
    }

    # Get all directories recursively
    $directories = Get-ChildItem -Path $Path -Directory -Recurse | Sort-Object -Property FullName -Descending

    foreach ($dir in $directories) {
        if (Is-EmptyFolder -FolderPath $dir.FullName) {
            try {
                Remove-Item -Path $dir.FullName -Force -Recurse
                Write-Verbose "Removed empty folder: $($dir.FullName)"
            }
            catch {
                Write-Warning "Failed to remove folder: $($dir.FullName) - $_"
            }
        }
    }

    # Check if the root folder itself is empty and remove if necessary
    if (Is-EmptyFolder -FolderPath $Path) {
        try {
            Remove-Item -Path $Path -Force -Recurse
            Write-Verbose "Removed empty root folder: $Path"
        }
        catch {
            Write-Warning "Failed to remove root folder: $Path - $_"
        }
    }
}

# Example Usage:
# Remove-EmptyFolders -Path "\\deathstar.domain.leigh-services.com\MyMusic\" -Verbose
