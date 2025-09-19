<#
.SYNOPSIS
    Retrieves users with duplicate Exchange distinguished names (DNs) and provides the option to remove the duplicates.

.DESCRIPTION
    The Get-DuplicateExchangeDN function searches for users in Active Directory who have multiple x500 addresses in the proxyAddresses attribute. It then determines the x500 address to remove based on a mismatch with the legacyExchangeDN attribute. The function creates a custom PSObject for each x500 address, indicating whether it should be removed or kept. The function also provides the option to remove the duplicate x500 addresses if the -RemoveDuplicate switch is specified.

.PARAMETER RemoveDuplicate
    Specifies whether to remove the duplicate x500 addresses. If this switch is specified, the function will remove the duplicate x500 addresses based on the mismatch with the legacyExchangeDN attribute.

.EXAMPLE
    Get-DuplicateExchangeDN -RemoveDuplicate
    Retrieves users with duplicate Exchange distinguished names (DNs) and removes the duplicate x500 addresses.

.EXAMPLE
    Get-DuplicateExchangeDN
    Retrieves users with duplicate Exchange distinguished names (DNs) without removing the duplicate x500 addresses.

.INPUTS
    None. You cannot pipe input to this function.

.OUTPUTS
    System.Management.Automation.PSCustomObject
    The function outputs a custom PSObject for each user with multiple x500 addresses. The PSObject contains the following properties:
    - Name: The name of the user.
    - SamAccountName: The SamAccountName of the user.
    - UserPrincipalName: The UserPrincipalName of the user.
    - LegacyExchangeDN: The legacyExchangeDN attribute of the user.
    - ProxyAddresses: An ordered dictionary of the user's proxy addresses, with the address to be removed highlighted.
    - RemovedEntries: A list of entries that were removed, each with the following properties:
        - Name: The name of the user.
        - SamAccountName: The SamAccountName of the user.
        - UserPrincipalName: The UserPrincipalName of the user.
        - RemovedAddress: The x500 address that was removed.
        - NewProxyAddresses: The new list of proxy addresses after removal.

.NOTES
    - This function requires the ActiveDirectory module to be imported.
    - The function requires appropriate permissions to access Active Directory.

.LINK
    https://github.com/your-repo/Get-DuplicateExchangeDN.ps1
    The source code for this function can be found on GitHub.

#>
function Get-DuplicateExchangeDN {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Medium")]
    param (
        [switch]$RemoveDuplicate
    )
    
    <# Import the ActiveDirectory module
    try {
        Import-Module ActiveDirectory -ErrorAction Stop
    } catch {
        Write-Error "Failed to import ActiveDirectory module. Ensure it is installed and available."
        return
    }#>

    # Define the search filter to find users with multiple x500 addresses in proxyAddresses
    $searchFilter = { proxyAddresses -like "*x500:/o=ExchangeLabs*" }

    # Initialize arrays to store results
    $removedEntries = @()
    $customObjects = @()

    try {
        # Search for users and filter those with multiple x500 addresses
        $users = Get-ADUser -Filter $searchFilter -Properties proxyAddresses, legacyExchangeDN -ErrorAction Stop | Where-Object {
            ($_.proxyAddresses | Where-Object { $_ -like "x500:/o=ExchangeLabs*" }).Count -gt 1
        }
    } catch {
        Write-Error "Failed to retrieve users from Active Directory. $_"
        return
    }

    # Process each user
    foreach ($user in $users) {
        try {
            $x500Addresses = $user.proxyAddresses | Where-Object { $_ -like "x500:/o=ExchangeLabs*" }
            $legacyDN = $user.legacyExchangeDN
            $addressToRemove = $null
            $count = 1
            $proxyAddressesSummary = [ordered]@{}

            # Determine the address to remove based on mismatch with LegacyExchangeDN
            foreach ($x500Address in $x500Addresses) {
                if ($legacyDN -notlike "*$($x500Address.Split('/')[-1])*") {
                    $addressToRemove = $x500Address
                }
            }

            # Create a detailed list of proxy addresses
            foreach ($address in $user.proxyAddresses) {
                $highlight = if ($address -eq $addressToRemove) { "REMOVE: " } else { "" }
                $proxyAddressesSummary.Add("EmailAddress$count", $highlight + $address)
                $count++
            }

            # Remove the address if the switch is enabled and ShouldProcess confirms
            if ($RemoveDuplicate -and $addressToRemove) {
                if ($PSCmdlet.ShouldProcess("$($user.SamAccountName): $addressToRemove", "Remove x500 address")) {
                    $newProxyAddresses = $user.proxyAddresses | Where-Object { $_ -ne $addressToRemove }
                    try {
                        Set-ADUser -Identity $user -Replace @{ proxyAddresses = $newProxyAddresses } -ErrorAction Stop
                        $removedEntries += [PSCustomObject][ordered]@{
                            Name              = $user.Name
                            SamAccountName    = $user.SamAccountName
                            UserPrincipalName = $user.UserPrincipalName
                            RemovedAddress    = $addressToRemove
                            NewProxyAddresses = $newProxyAddresses -join ";"
                        }
                        Write-Verbose "Removed $addressToRemove from $($user.SamAccountName)"
                    } catch {
                        Write-Error "Failed to update user $($user.SamAccountName) with new proxy addresses. $_"
                    }
                }
            }

            # Create PSObjects for each user with detailed proxy addresses
            $customObjects += [PSCustomObject][ordered]@{
                Name              = $user.Name
                SamAccountName    = $user.SamAccountName
                UserPrincipalName = $user.UserPrincipalName
                LegacyExchangeDN  = $legacyDN
                ProxyAddresses    = $proxyAddressesSummary
            }
        } catch {
            Write-Error "Error processing user $($user.SamAccountName). $_"
        }
    }

    # Output the custom PSObjects and removed entries
    return [PSCustomObject][ordered]@{
        DetailedEntries = $customObjects
        RemovedEntries  = $removedEntries
    }
}

# Usage example:
# $result = Get-DuplicateExchangeDN
# $result.DetailedEntries | Format-List

# To remove duplicates and get details of removed entries
# $result = Get-DuplicateExchangeDN -RemoveDuplicate -Verbose
# $result.RemovedEntries | Format-Table -AutoSize
