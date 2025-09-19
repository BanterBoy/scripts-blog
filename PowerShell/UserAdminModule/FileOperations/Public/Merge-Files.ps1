<#
.SYNOPSIS
    Merges multiple files of a specified type from a source folder into one or more output files.

.DESCRIPTION
    The Merge-FileContent function merges multiple files of a specified type from a source folder into one or more output files.
    It reads the content of each file and combines them into the specified number of output files.

.PARAMETER SourceFolder
    The path to the source folder containing the files to be merged.

.PARAMETER OutputFile
    The path to the output file or the base name of the output files if multiple files are generated.

.PARAMETER NumberOfFiles
    The number of output files to generate. Each output file will contain a portion of the merged content.
    The default value is 1, which means all the content will be merged into a single output file.

.PARAMETER FileType
    The file type of the files to be merged. Only files with this file type will be considered for merging.

.EXAMPLE
    Merge-FileContent -SourceFolder "C:\path\to\source\folder" -OutputFile "C:\path\to\output\file.txt" -NumberOfFiles 3 -FileType "txt"
    Merges all the text files in the specified source folder into three output files with the specified base name.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Merge-FileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$SourceFolder,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$OutputFile,

        [Parameter(Mandatory = $false)]
        [int]$NumberOfFiles = 1,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$FileType
    )

    process {
        # Check if the source folder exists
        if (-Not (Test-Path -Path $SourceFolder)) {
            Write-Error "The source folder '$SourceFolder' does not exist."
            return
        }

        # Get all files of the specified type in the source folder
        $searchPattern = "*.$FileType"
        $files = Get-ChildItem -Path $SourceFolder -Filter $searchPattern -File

        # Check if there are files of the specified type in the source folder
        if ($files.Count -eq 0) {
            Write-Error "No files of type '$FileType' found in the source folder '$SourceFolder'."
            return
        }

        # Initialize an array to hold the contents
        $allContents = @()

        # Loop through each file and get its content
        foreach ($file in $files) {
            try {
                $content = Get-Content -Path $file.FullName -ErrorAction Stop
                $allContents += $content
            }
            catch {
                Write-Warning "Failed to read file '$($file.FullName)': $_"
            }
        }

        # Determine the size of each output file
        $totalLines = $allContents.Count
        $linesPerFile = [math]::Ceiling($totalLines / $NumberOfFiles)

        # Write the combined content to the specified number of output files
        for ($i = 0; $i -lt $NumberOfFiles; $i++) {
            $startLine = $i * $linesPerFile
            $endLine = [math]::Min(($startLine + $linesPerFile), $totalLines) - 1
            $currentContent = $allContents[$startLine..$endLine]

            $currentOutputFile = if ($NumberOfFiles -gt 1) {
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($OutputFile)
                $extension = [System.IO.Path]::GetExtension($OutputFile)
                [System.IO.Path]::Combine((Get-Item -Path $OutputFile).DirectoryName, "$baseName`_$($i + 1)$extension")
            }
            else {
                $OutputFile
            }

            try {
                $currentContent | Out-File -FilePath $currentOutputFile -Encoding UTF8 -Force
                Write-Output "Content successfully written to '$currentOutputFile'."
            }
            catch {
                Write-Error "Failed to write to output file '$currentOutputFile': $_"
            }
        }
    }
}

# Example usage:
# Merge-FileContent -SourceFolder "C:\path\to\source\folder" -OutputFile "C:\path\to\output\file.txt" -NumberOfFiles 3 -FileType "txt"
