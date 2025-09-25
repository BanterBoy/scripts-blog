<#
.SYNOPSIS
Retrieves LAPS (Local Administrator Password Solution) and BitLocker recovery information for specified computers or all computers in the domain.

.DESCRIPTION
The `Get-LapsAndBitLocker` function queries Active Directory to retrieve the following information:
- LAPS password (`ms-Mcs-AdmPwd`) for the specified computer(s).
- BitLocker recovery password (`msFVE-RecoveryPassword`) for the specified computer(s).
- Additional properties such as the computer's Distinguished Name, Enabled status, and the date/time of the recovery information.

If no `ComputerName` is provided, the function retrieves all BitLocker recovery information in the domain.

.PARAMETER ComputerName
Specifies one or more computer names to query in Active Directory. If this parameter is omitted, the function queries all BitLocker recovery information in the domain.

.EXAMPLE
Get-LapsAndBitLocker -ComputerName "Computer1"

Retrieves LAPS and BitLocker recovery information for the computer named "Computer1".

.EXAMPLE
Get-LapsAndBitLocker -ComputerName "Computer1", "Computer2" -Verbose

Retrieves LAPS and BitLocker recovery information for the computers "Computer1" and "Computer2", with verbose output enabled.

.EXAMPLE
Get-LapsAndBitLocker

Retrieves all BitLocker recovery information in the domain.

.NOTES
- This function requires appropriate permissions to access LAPS and BitLocker recovery information in Active Directory.
- If run without sufficient permissions, the function may return no results or warnings about access issues.
- Ensure the Active Directory module is installed and imported before running this function.

.INPUTS
[string[]]
Accepts an array of computer names as input.

.OUTPUTS
[PSCustomObject]
Returns a custom object with the following properties:
- ComputerName: The name of the computer.
- LapsPassword: The LAPS password for the computer.
- DateTime: The date/time of the recovery information.
- BitLocker: The BitLocker recovery password.
- Enabled: The enabled status of the computer.
- DistinguishedName: The Distinguished Name of the computer in Active Directory.

.LINK
https://learn.microsoft.com/en-us/powershell/module/activedirectory/
#>
#requires -PSEdition Desktop

function Get-LapsAndBitLocker {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$ComputerName
    )
    # Version 1.0.3
    begin {
        $results = @()
        Write-Verbose "Starting Get-LapsAndBitLocker function"
    }
    process {
        if ($ComputerName) {
            foreach ($name in $ComputerName) {
                Write-Verbose "Processing computer: $name"
                try {
                    # Retrieve the computer object with all required properties in one query
                    $comp = Get-ADComputer -Identity $name -Properties ms-Mcs-AdmPwd, Enabled, DistinguishedName -ErrorAction Stop
                    if ($comp) {
                        Write-Verbose "Found AD computer object for $name"
                        $searchBase = $comp.DistinguishedName
                        try {
                            # Retrieve BitLocker recovery information for the computer
                            $bitLockerData = Get-ADObject -Filter 'objectclass -eq "msFVE-RecoveryInformation"' -SearchBase $searchBase -Properties msFVE-RecoveryPassword, WhenCreated -ErrorAction Stop
                            foreach ($bitLocker in $bitLockerData) {
                                # Add the result to the results array
                                $results += [PSCustomObject]@{
                                    ComputerName      = $name
                                    LapsPassword      = $comp.'ms-Mcs-AdmPwd'
                                    DateTime          = $bitLocker.WhenCreated
                                    BitLocker         = $bitLocker.'msFVE-RecoveryPassword'
                                    Enabled           = $comp.Enabled
                                    DistinguishedName = $comp.DistinguishedName
                                }
                            }
                        }
                        catch {
                            Write-Warning "Failed to retrieve BitLocker information for computer '$name': $_"
                        }
                    }
                    else {
                        Write-Warning "No AD computer object found for computer '$name'"
                    }
                }
                catch {
                    Write-Warning "Failed to retrieve AD computer object for computer '$name': $_"
                }
            }
        }
        else {
            Write-Verbose "No ComputerName provided, querying all BitLocker recovery information"
            $filter = "(objectclass=msFVE-RecoveryInformation)"
            try {
                # Retrieve all BitLocker recovery information in the domain
                $bitLockerObjects = Get-ADObject -LDAPFilter $filter -SearchBase 'DC=rdg,DC=co,DC=uk' -Properties msFVE-RecoveryPassword, WhenCreated -ErrorAction Stop
                foreach ($bitLocker in $bitLockerObjects) {
                    $computerName = $bitLocker.DistinguishedName.Split(',')[1].Split('=')[1]
                    try {
                        # Retrieve the computer object with all required properties
                        $comp = Get-ADComputer -Identity $computerName -Properties ms-Mcs-AdmPwd, Enabled, DistinguishedName -ErrorAction Stop
                        $results += [PSCustomObject]@{
                            ComputerName      = $computerName
                            LapsPassword      = $comp.'ms-Mcs-AdmPwd'
                            DateTime          = $bitLocker.WhenCreated
                            BitLocker         = $bitLocker.'msFVE-RecoveryPassword'
                            Enabled           = $comp.Enabled
                            DistinguishedName = $comp.DistinguishedName
                        }
                    }
                    catch {
                        Write-Warning "Failed to retrieve AD computer object for computer '$computerName': $_"
                    }
                }
            }
            catch {
                Write-Warning "Failed to retrieve BitLocker recovery information for the domain: $_"
            }
        }
    }
    end {
        if ($results.Count -eq 0) {
            Write-Warning "No results were retrieved. Ensure you have sufficient permissions and valid input."
        }
        else {
            Write-Verbose "Returning results"
            $results | Sort-Object -Property ComputerName | Write-Output
        }
    }
}
