<#
.SYNOPSIS
    Checks if PowerShell profile paths exist.

.DESCRIPTION
    This function checks if the standard PowerShell profile paths exist and provides detailed information about each profile.

.EXAMPLE
    PS C:\> Test-ProfileExists -Verbose
    Checks if the PowerShell profile paths exist and provides detailed information about each profile.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-ProfileExists {
    [CmdletBinding()]
    param ()

    BEGIN {
        Write-Verbose "Starting the Test-ProfileExists function."
    }

    PROCESS {
        $profile.PSObject.Properties.Name |
        Where-Object { $_ -ne 'Length' } |
        ForEach-Object {
            $profileName = $_
            $profilePath = $profile.$profileName
            $profileExists = Test-Path $profilePath

            Write-Verbose "Checking profile: $profileName"
            Write-Verbose "Profile path: $profilePath"
            Write-Verbose "Profile exists: $profileExists"

            [PSCustomObject]@{
                Profile = $profileName
                Present = $profileExists
                Path    = $profilePath
            }
        }
    }

    END {
        Write-Verbose "Test-ProfileExists function completed."
    }
}

# Example call to the function with verbose output
# Test-ProfileExists -Verbose | Format-Table -AutoSize
