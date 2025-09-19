<#
.SYNOPSIS
    Retrieves the names of all functions defined in a PowerShell script.

.DESCRIPTION
    The Get-ScriptFunctionNames function reads a PowerShell script, identifies all function definitions,
    and returns the names of these functions. It uses a regex pattern to match function definitions in the script.

.PARAMETER Path
    The path to the PowerShell script file that contains the functions.

.EXAMPLE
    Get-ScriptFunctionNames -Path "C:\Scripts\MyScript.ps1"

    This example retrieves the names of all functions defined in MyScript.ps1.

.EXAMPLE
    "C:\Scripts\MyScript.ps1" | Get-ScriptFunctionNames

    This example retrieves the names of all functions defined in MyScript.ps1 using pipeline input.

.NOTES
    Author: Your Name
    Date: June 30, 2024
#>
function Get-ScriptFunctionNames {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Path
    )

    process {
        # Initialize a list to store function names
        [System.Collections.Generic.List[String]]$funcNames = New-Object System.Collections.Generic.List[String]

        # Return the empty list if the path is null or empty
        if ([System.String]::IsNullOrWhiteSpace($Path)) {
            return $funcNames
        }
        
        # Search for function definitions in the script using Select-String
        Select-String -Path "$Path" -Pattern "^[Ff]unction.*[A-Za-z0-9+]-[A-Za-z0-9+]" |
        ForEach-Object {
            # Define the regex pattern to match function definitions
            [System.Text.RegularExpressions.Regex] $regexp = New-Object Regex("(function)( +)([\w-]+)")
            # Match the current line against the regex pattern
            [System.Text.RegularExpressions.Match] $match = $regexp.Match("$_")

            # If a match is found, add the function name to the list
            if ($match.Success) {
                $funcNames.Add($match.Groups[3].Value)
            }   
        }
        
        # Return the list of function names as an array
        return , $funcNames.ToArray()
    }
}
