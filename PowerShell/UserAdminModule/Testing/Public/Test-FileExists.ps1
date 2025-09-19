<#
.SYNOPSIS
Tests whether a file exists at the specified path.

.DESCRIPTION
The Test-FileExists function tests whether a file exists at the specified path. If the file exists, the function returns $true. If the file does not exist, the function returns $false, unless the -Create switch is specified, in which case the function creates a new file at the specified path and returns $true.

.PARAMETER Path
The path to the file to test.

.PARAMETER Create
If specified, creates a new file at the specified path if the file does not already exist.

.EXAMPLE
Test-FileExists -Path "C:\Temp\test.txt"
Returns $true if a file named "test.txt" exists in the C:\Temp directory.

.EXAMPLE
Test-FileExists -Path "C:\Temp\test.txt" -Create
Creates a new file named "test.txt" in the C:\Temp directory and returns $true.

.INPUTS
None.

.OUTPUTS
System.Boolean

.NOTES
Author: Unknown
Date: Unknown
#>
function Test-FileExists {
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
            HelpMessage = 'Enter the file path to test.'
        )]
        [string]
        $Path,

        [Parameter(
            ParameterSetName = 'Default'
        )]
        [switch]
        $Create
    )
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Testing this path...")) {
            $fileExists = Test-Path $Path -PathType Leaf
            if ($fileExists) {
                Write-Verbose -Message "File Exists."
            }
            else {
                Write-Verbose -Message "File does not exist."
                if ($Create) {
                    New-Item -ItemType File -Path $Path | Out-Null
                    Write-Verbose -Message "File created."
                    $fileExists = $true
                }
            }
            return $fileExists
        }
    }
}