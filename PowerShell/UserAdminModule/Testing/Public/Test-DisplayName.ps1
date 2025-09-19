<#
.SYNOPSIS
    Checks if a given DisplayName exists in Active Directory.

.DESCRIPTION
    This function searches Active Directory for a given DisplayName and returns whether the DisplayName exists.

.PARAMETER DisplayName
    The DisplayName to search for in Active Directory.

.EXAMPLE
    PS C:\> Test-DisplayName -DisplayName "John Doe" -Verbose
    Checks if the DisplayName "John Doe" exists in Active Directory.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-DisplayName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String] $DisplayName
    )

    BEGIN {
        Write-Verbose "Starting the Test-DisplayName function."
        Write-Verbose "DisplayName parameter value: $DisplayName"
    }

    PROCESS {
        Write-Verbose "Creating an ADSI searcher for DisplayName: $DisplayName"
        $searcher = [ADSISearcher] "(DisplayName=$DisplayName)"
        
        Write-Verbose "Executing the search."
        $result = $searcher.FindOne()

        if ($null -ne $result) {
            Write-Verbose "DisplayName '$DisplayName' found in Active Directory."
            $true
        }
        else {
            Write-Verbose "DisplayName '$DisplayName' not found in Active Directory."
            $false
        }
    }

    END {
        Write-Verbose "Test-DisplayName function completed."
    }
}

# Example call to the function with verbose output
# Test-DisplayName -DisplayName "John Doe" -Verbose
