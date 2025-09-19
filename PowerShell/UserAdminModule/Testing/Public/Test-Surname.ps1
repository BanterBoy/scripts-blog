<#
.SYNOPSIS
    Checks if a given surname exists in Active Directory.

.DESCRIPTION
    This function searches Active Directory for a given surname (sn attribute) and returns whether the surname exists.

.PARAMETER Surname
    The surname to search for in Active Directory.

.EXAMPLE
    PS C:\> Test-Surname -Surname "Smith" -Verbose
    Checks if the surname "Smith" exists in Active Directory.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Test-Surname {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String] $Surname
    )

    BEGIN {
        Write-Verbose "Starting the Test-Surname function."
        Write-Verbose "Surname parameter value: $Surname"
    }

    PROCESS {
        Write-Verbose "Creating an ADSI searcher for surname: $Surname"
        $searcher = [ADSISearcher] "(sn=$Surname)"
        
        Write-Verbose "Executing the search."
        $result = $searcher.FindOne()

        if ($null -ne $result) {
            Write-Verbose "Surname '$Surname' found in Active Directory."
            $true
        }
        else {
            Write-Verbose "Surname '$Surname' not found in Active Directory."
            $false
        }
    }

    END {
        Write-Verbose "Test-Surname function completed."
    }
}

# Example call to the function with verbose output
# Test-Surname -Surname "Smith" -Verbose
