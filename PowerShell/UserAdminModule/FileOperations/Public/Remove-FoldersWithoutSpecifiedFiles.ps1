function Remove-FoldersWithoutSpecifiedFiles {
    <#
    .SYNOPSIS
        Removes folders that do not contain specified file types.

    .DESCRIPTION
        This function recursively scans directories within the specified path and removes any folder that does not contain files of the specified types. 
        It can also generate a validation report listing the folders that would be deleted, without actually deleting them.

    .PARAMETER Path
        The root path to begin scanning for folders.

    .PARAMETER FileTypes
        An array of file extensions to check for within each folder.

    .PARAMETER Validation
        If specified, the function will generate a validation report without deleting any folders.

    .PARAMETER ReportPath
        The file path to save the validation report to. Defaults to "DeletionReport.csv".

    .EXAMPLE
        Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Validation -ReportPath "C:\Temp\NonMP3Folders.csv"
        This example validates folders in the specified path and generates a report of folders without .mp3 files.

    .EXAMPLE
        Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3"
        This example removes folders in the specified path that do not contain .mp3 files.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$FileTypes,

        [Parameter(Mandatory = $false)]
        [switch]$Validation,

        [Parameter(Mandatory = $false)]
        [string]$ReportPath = "DeletionReport.csv"
    )

    # Helper function to determine if a folder or any of its subfolders contain specified file types
    function Test-SpecifiedFilesExist {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath,
    
            [Parameter(Mandatory = $true)]
            [string[]]$FileTypes
        )
    
        foreach ($fileType in $FileTypes) {
            if ((Get-ChildItem -Path $FolderPath -Filter "*.$fileType" -File -Recurse).Count -gt 0) {
                return $true
            }
        }
        return $false
    }

    # Helper function to get list of files in the folder
    function Get-FilesInFolder {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath
        )

        return Get-ChildItem -Path $FolderPath -File -Recurse | Select-Object -ExpandProperty FullName
    }

    $deletionReport = @()

    # Get all directories recursively, sorted in descending order
    $directories = Get-ChildItem -Path $Path -Directory -Recurse | Sort-Object -Property FullName -Descending

    foreach ($dir in $directories) {
        Write-Verbose -Message "Checking folder: $($dir.FullName)"
        if (-not (Test-SpecifiedFilesExist -FolderPath $dir.FullName -FileTypes $FileTypes)) {
            $filesInFolder = (Get-FilesInFolder -FolderPath $dir.FullName) -join "; "
            if ($Validation) {
                Write-Verbose -Message "Adding $($dir.FullName) to validation report"
                $deletionReport += [pscustomobject]@{
                    Path          = $dir.FullName
                    Type          = "Folder"
                    ContainsFiles = $filesInFolder
                }
            }
            else {
                Write-Verbose -Message "Attempting to remove folder: $($dir.FullName)"
                try {
                    Remove-Item -Path $dir.FullName -Force -Recurse
                    Write-Output "Removed folder without specified files: $($dir.FullName)"
                }
                catch {
                    Write-Output "Failed to remove folder: $($dir.FullName) - $_"
                }
            }
        }
    }

    # Check if the root folder itself should be removed
    Write-Verbose -Message "Checking root folder: $Path"
    if (-not (Test-SpecifiedFilesExist -FolderPath $Path -FileTypes $FileTypes)) {
        $filesInFolder = (Get-FilesInFolder -FolderPath $Path) -join "; "
        if ($Validation) {
            Write-Verbose -Message "Adding $Path to validation report"
            $deletionReport += [pscustomobject]@{
                Path          = $Path
                Type          = "Folder"
                ContainsFiles = $filesInFolder
            }
        }
        else {
            Write-Verbose -Message "Attempting to remove root folder: $Path"
            try {
                Remove-Item -Path $Path -Force -Recurse
                Write-Output "Removed root folder without specified files: $Path"
            }
            catch {
                Write-Output "Failed to remove root folder: $Path - $_"
            }
        }
    }

    if ($Validation -and $deletionReport.Count -gt 0) {
        Write-Verbose -Message "Saving validation report to $ReportPath"
        $deletionReport | Export-Csv -Path $ReportPath -NoTypeInformation
        Write-Output "Validation report saved to $ReportPath"
    }
    elseif ($Validation) {
        Write-Output "No folders or files to delete."
    }
}

# Example usage with validation:
# Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Validation -ReportPath "C:\Temp\NonMP3Folders.csv" -Verbose

# Example usage without validation:
# Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Verbose
