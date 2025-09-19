<#
.SYNOPSIS
    Checks if a user with the given SAMAccountName exists in Active Directory.

.DESCRIPTION
    This function searches Active Directory for a user with the specified SAMAccountName and returns whether the user exists.

.PARAMETER SAMAccountName
    The SAMAccountName to search for in Active Directory.

.EXAMPLE
    PS C:\> Test-UserExists -SAMAccountName "jdoe" -Verbose
    Checks if the user with the SAMAccountName "jdoe" exists in Active Directory.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-UserExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $SAMAccountName
    )

    BEGIN {
        Write-Verbose "Starting the Test-UserExists function."
        Write-Verbose "SAMAccountName parameter value: $SAMAccountName"
    }

    PROCESS {
        Write-Verbose "Searching for user with SAMAccountName: $SAMAccountName"
        
        try {
            $userCount = @(Get-ADUser -LDAPFilter "(samaccountname=$SAMAccountName)").Count

            if ($userCount -ne 0) {
                Write-Verbose "User with SAMAccountName '$SAMAccountName' found in Active Directory."
                $true
            }
            else {
                Write-Verbose "User with SAMAccountName '$SAMAccountName' not found in Active Directory."
                $false
            }
        }
        catch {
            Write-Error "Failed to search for user with SAMAccountName '$SAMAccountName': $_"
            $false
        }
    }

    END {
        Write-Verbose "Test-UserExists function completed."
    }
}

# Example call to the function with verbose output
# Test-UserExists -SAMAccountName "jdoe" -Verbose
