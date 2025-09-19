function Remove-Files {
    <#
    .SYNOPSIS
        Removes an array of files.

    .DESCRIPTION
        The Remove-Files function takes an array of file paths and removes each file. It supports verbose output and handles errors gracefully. This function also supports the `ShouldProcess` method for safety.

    .PARAMETER Files
        An array of file paths to be removed.

    .EXAMPLE
        Remove-Files -Files "C:\temp\file1.txt", "C:\temp\file2.txt"
        This example removes the files "file1.txt" and "file2.txt" from the "C:\temp" directory.

    .NOTES
        Author: [Author Name]
        Date: [Date]
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Files
    )

    begin {
        Write-Verbose -Message "Starting file removal process for $($Files.Count) files"
    }

    process {
        $Files | ForEach-Object -Process {
            # Check if the file exists before attempting to remove it
            if (Test-Path -Path $_ -PathType Leaf) {
                if ($PSCmdlet.ShouldProcess("$($_)", "Deleting file...")) {
                    Write-Verbose -Message "Removing file $($_)"
                    try {
                        Remove-Item -Path $_ -Force
                        Write-Verbose -Message "Successfully removed file $($_)"
                    }
                    catch {
                        Write-Error -Message "Failed to remove file $($_) - $_"
                    }
                }
            }
            else {
                Write-Warning -Message "File $($_) does not exist."
            }
        }
    }

    end {
        Write-Verbose -Message "File removal process completed."
    }
}

# Example Usage:
# Remove-Files -Files "C:\temp\file1.txt", "C:\temp\file2.txt" -Verbose
