function Unblock-AndUnzipFiles {
    <#
    .SYNOPSIS
    Unblocks and unzips all zip files in a specified folder or a single zip file.
    
    .DESCRIPTION
    This function unblocks all zip files in the specified folder or a single zip file and then unzips each file into a folder with the same name as the zip file. It also provides a list of zip files that have been unzipped upon completion.
    
    .PARAMETER FolderPath
    The path to the folder containing the zip files.
    
    .PARAMETER FilePath
    The path to a single zip file.
    
    .EXAMPLE
    Unblock-AndUnzipFiles -FolderPath "C:\Temp\WindowsSecurityBaseline"
    
    This example unblocks and unzips all zip files in the C:\Temp\WindowsSecurityBaseline folder.
    
    .EXAMPLE
    Unblock-AndUnzipFiles -FilePath "C:\Temp\WindowsSecurityBaseline\example.zip"
    
    This example unblocks and unzips the example.zip file.
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Folder')]
        [string]$FolderPath,

        [Parameter(Mandatory = $false, ParameterSetName = 'File')]
        [string]$FilePath
    )

    if ($PSCmdlet.ParameterSetName -eq 'Folder') {
        # Get all zip files in the folder
        $zipFiles = Get-ChildItem -Path $FolderPath -Filter *.zip
    } elseif ($PSCmdlet.ParameterSetName -eq 'File') {
        # Get the single zip file
        if (Test-Path -Path $FilePath) {
            $zipFiles = @(Get-Item -Path $FilePath)
        } else {
            Write-Error "The specified file does not exist."
            return
        }
    } else {
        Write-Error "You must specify either a FolderPath or a FilePath."
        return
    }

    # Total number of files to process
    $totalFiles = $zipFiles.Count
    $currentFile = 0

    # List to store the names of unzipped files
    $unzippedFiles = @()

    # Iterate through each zip file
    foreach ($zipFile in $zipFiles) {
        # Update progress bar
        $currentFile++
        $progressPercent = ($currentFile / $totalFiles) * 100
        Write-Progress -Activity "Unblocking and Unzipping Files" -Status "Processing $($zipFile.Name)" -PercentComplete $progressPercent

        # Unblock the zip file
        Unblock-File -Path $zipFile.FullName

        # Define the output folder path (same name as the zip file without extension)
        $outputFolderPath = Join-Path -Path $zipFile.DirectoryName -ChildPath ($zipFile.BaseName)

        # Create the output folder if it doesn't exist
        if (-not (Test-Path -Path $outputFolderPath)) {
            New-Item -Path $outputFolderPath -ItemType Directory | Out-Null
        }

        # Unzip the file into the output folder
        Expand-Archive -Path $zipFile.FullName -DestinationPath $outputFolderPath -Force

        # Add the zip file name to the list
        $unzippedFiles += $zipFile.Name
    }

    Write-Output "All zip files have been unblocked and unzipped successfully."
    Write-Output "List of unzipped files:"
    $unzippedFiles
}

# Example usage
# Unblock-AndUnzipFiles -FolderPath "C:\Temp\WindowsSecurityBaseline"
# Unblock-AndUnzipFiles -FilePath "C:\Temp\WindowsSecurityBaseline\example.zip"
