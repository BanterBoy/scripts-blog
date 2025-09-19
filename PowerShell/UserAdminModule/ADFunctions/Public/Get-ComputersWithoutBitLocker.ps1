<#
.SYNOPSIS
    Retrieves a list of computers in Active Directory that do not have associated BitLocker recovery information.

.DESCRIPTION
    The `Get-ComputersWithoutBitLocker` function queries Active Directory for computer objects and checks if they have associated BitLocker recovery information. 
    It can optionally filter out disabled computers using the `-Enabled` switch. The function outputs a list of computers without BitLocker recovery information, 
    including their names, distinguished names, and enabled status.

.PARAMETER SearchBase
    Specifies the Active Directory search base for the query. By default, it uses the distinguished name of the current domain.

.PARAMETER Enabled
    Filters the results to include only enabled computers. Disabled computers are skipped when this switch is specified.

.EXAMPLE
    Get-ComputersWithoutBitLocker

    Retrieves all computers in the domain that do not have BitLocker recovery information.

.EXAMPLE
    Get-ComputersWithoutBitLocker -SearchBase "OU=Computers,DC=example,DC=com"

    Retrieves all computers in the specified organizational unit (OU) that do not have BitLocker recovery information.

.EXAMPLE
    Get-ComputersWithoutBitLocker -Enabled

    Retrieves only enabled computers in the domain that do not have BitLocker recovery information.

.NOTES
    Author: [Your Name]
    Date: April 17, 2025
    Version: 1.0

    This function requires the Active Directory module to be installed and imported. 
    It also requires appropriate permissions to query Active Directory and access BitLocker recovery information.

.OUTPUTS
    PSCustomObject
        A custom object with the following properties:
        - ComputerName: The name of the computer.
        - DistinguishedName: The distinguished name of the computer in Active Directory.
        - Enabled: Indicates whether the computer is enabled.
        - Notes: Additional information (e.g., "No BitLocker recovery information found").

#>

function Get-ComputersWithoutBitLocker {
    [CmdletBinding()]
    param(
        [string]$SearchBase = (Get-ADDomain).DistinguishedName,
        [switch]$Enabled
    )
    begin {
        Write-Verbose "Starting Get-ComputersWithoutBitLocker function"
        $results = @()
    }
    process {
        try {
            # Retrieve all computer objects in the domain
            Write-Verbose "Querying all computer objects in Active Directory"
            $computers = Get-ADComputer -Filter * -SearchBase $SearchBase -Properties DistinguishedName, Enabled -ErrorAction Stop

            foreach ($computer in $computers) {
                $computerName = $computer.Name
                $distinguishedName = $computer.DistinguishedName
                $isEnabled = $computer.Enabled

                # Skip disabled computers if the Enabled switch is specified
                if ($Enabled -and -not $isEnabled) {
                    Write-Verbose "Skipping disabled computer: $computerName"
                    continue
                }

                Write-Verbose "Checking BitLocker recovery information for computer: $computerName"

                try {
                    # Check if the computer has any associated BitLocker recovery information
                    $bitLockerData = Get-ADObject -Filter 'objectclass -eq "msFVE-RecoveryInformation"' -SearchBase $distinguishedName -ErrorAction Stop

                    if (-not $bitLockerData) {
                        # If no BitLocker recovery information is found, add the computer to the results
                        $results += [PSCustomObject]@{
                            ComputerName      = $computerName
                            DistinguishedName = $distinguishedName
                            Enabled           = $isEnabled
                            Notes             = "No BitLocker recovery information found"
                        }
                    }
                }
                catch {
                    Write-Warning "Failed to check BitLocker recovery information for computer '$computerName': $_"
                }
            }
        }
        catch {
            Write-Warning "Failed to retrieve computer objects from Active Directory: $_"
        }
    }
    end {
        if ($results.Count -eq 0) {
            Write-Warning "No computers without BitLocker recovery information were found."
        }
        else {
            Write-Verbose "Returning results"
            $results | Sort-Object -Property ComputerName | Write-Output
        }
    }
}