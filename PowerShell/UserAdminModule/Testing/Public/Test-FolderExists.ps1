<#
.SYNOPSIS
    Tests if a specified folder exists and creates it if it does not.

.DESCRIPTION
    This function takes a file path as input, checks if the folder exists, and creates the folder if it does not exist. It provides verbose output for the operations performed.

.PARAMETER Path
    The file path to test. If the folder does not exist, it will be created.

.EXAMPLE
    PS C:\> Test-FolderExists -Path "C:\Temp\MyFolder" -Verbose
    Tests if the folder "C:\Temp\MyFolder" exists and creates it if it does not.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-FolderExists {
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true
    )]
    param
    (
        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'Enter the file path to test. If folder does not exist, it will be created.'
        )]
        [ValidateScript(
            {
                # Check if the specified path is a valid container path
                if (Test-Path $_ -PathType Container) {
                    Write-Verbose -Message "Folder exists: $_"
                    $true
                }
                else {
                    Write-Verbose -Message "Folder does not exist: $_"
                    $false
                }
            }
        )]
        [string]$Path
    )

    BEGIN {
        Write-Verbose "Starting the Test-FolderExists function."
    }

    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Testing if this path exists...")) {
            if (Test-Path $Path -PathType Container) {
                Write-Verbose -Message "$Path - Folder exists, yay!"
            }
            else {
                Write-Verbose -Message "$Path - Folder does not exist. Creating folder..."
                try {
                    New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
                    Write-Verbose -Message "$Path - Folder created successfully."
                }
                catch {
                    Write-Error -Message "Failed to create folder at {$Path}: $_"
                }
            }
        }
    }

    END {
        Write-Verbose "Test-FolderExists function completed."
    }
}

# Example call to the function with verbose output
# Test-FolderExists -Path "C:\Temp\MyFolder" -Verbose
