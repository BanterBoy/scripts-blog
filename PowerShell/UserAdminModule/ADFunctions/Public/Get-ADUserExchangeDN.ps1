<#
.SYNOPSIS
Retrieves the Exchange DN (Distinguished Name) and other details of an Active Directory user.

.DESCRIPTION
The Get-ADUserExchangeDN function retrieves the Exchange DN, legacyExchangeDN, mail, EmailAddress, and other details of an Active Directory user. It uses the Get-ADUser cmdlet to retrieve the user details from Active Directory.

.PARAMETER Identity
Specifies the identity of the user. This can be the user's SamAccountName, UserPrincipalName, DistinguishedName, or any other attribute that uniquely identifies the user.

.EXAMPLE
Get-ADUserExchangeDN -Identity "john.doe"
Retrieves the Exchange DN and other details of the user with the SamAccountName "john.doe".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns a custom object that contains the user details, including the Exchange DN, legacyExchangeDN, mail, EmailAddress, and proxy addresses.

.NOTES
This function requires the Active Directory module to be installed. Make sure you have the necessary permissions to retrieve user details from Active Directory.

.LINK
Get-ADUser
#>

function Get-ADUserExchangeDN {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Identity
    )
    
    # Function code goes here...
}
function Get-ADUserExchangeDN {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Identity
    )
    
    # Retrieve the user details
    try {
        $user = Get-ADUser -Identity $Identity -Properties proxyAddresses, legacyExchangeDN, mail, EmailAddress -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to retrieve user $Identity from Active Directory. $_"
        return
    }

    # Initialize an ordered dictionary to store user details and proxy addresses
    $summary = [ordered]@{
        Name              = $user.Name
        SamAccountName    = $user.SamAccountName
        UserPrincipalName = $user.UserPrincipalName
        Mail              = $user.Mail
        EmailAddress      = $user.EmailAddress
        LegacyExchangeDN  = $user.legacyExchangeDN
    }

    # Extract and process proxy addresses
    $x500Addresses = $user.proxyAddresses | Where-Object { $_ -like "x500:/o=ExchangeLabs*" }
    $legacyDN = $user.legacyExchangeDN
    $count = 1

    # Add non-x500 addresses to the summary
    foreach ($address in $user.proxyAddresses | Where-Object { $_ -notlike "x500:/o=ExchangeLabs*" }) {
        $summary.Add("proxyAddress$count", $address)
        $count++
    }

    # Identify the true duplicate x500 addresses
    $x500Bases = $x500Addresses | ForEach-Object { $_.Split('/')[-1] }
    $duplicates = @()

    foreach ($address in $x500Addresses) {
        $addressBase = $address.Split('/')[-1]
        if ($legacyDN -like "*$addressBase*") {
            $duplicates += $address
        }
        else {
            $summary.Add("proxyAddress$count", $address)
            $count++
        }
    }

    # Mark only the true duplicates for removal
    foreach ($address in $duplicates) {
        $summary.Add("proxyAddress$count", "REMOVE: $address")
        $count++
    }

    # Output the summary object
    return [PSCustomObject]$summary
}
