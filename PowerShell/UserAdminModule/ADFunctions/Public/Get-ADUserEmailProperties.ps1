<#
.SYNOPSIS
Retrieves email properties of an Active Directory user.

.DESCRIPTION
The Get-ADUserEmailProperties function retrieves the email properties of an Active Directory user, including proxy addresses, legacyExchangeDN, mail, mailNickName, targetAddress, and enabled status. It also retrieves mailbox details from both on-premises Exchange and Exchange Online.

.PARAMETER Identity
Specifies the user identity. This can be a distinguished name, GUID, security identifier (SID), or SAM account name.

.EXAMPLE
$userDetails = Get-ADUserEmailProperties -Identity "becky.galea"
$userDetails | Format-Table -AutoSize

This example retrieves the email properties of the user with the SAM account name "becky.galea" and displays the details in a formatted table.

.INPUTS
[string]
The Identity parameter accepts a string value representing the user identity.

.OUTPUTS
[PSCustomObject]
The function returns a custom object containing the user's email properties.

.NOTES
This function requires the Active Directory module and Exchange module to be installed.

.LINK
https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-aduser
https://docs.microsoft.com/en-us/powershell/module/exchange/get-mailbox

#>

function Get-ADUserEmailProperties {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Specifies the user identity. This can be a distinguished name, GUID, security identifier (SID), or SAM account name.")]
        [string]$Identity
    )

    # Rest of the code...
}
function Get-ADUserEmailProperties {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Specifies the user identity. This can be a distinguished name, GUID, security identifier (SID), or SAM account name.")]
        [string]$Identity
    )

    # Retrieve the user details
    try {
        $user = Get-ADUser -Identity $Identity -Properties proxyAddresses, legacyExchangeDN, mail, mailNickName, targetAddress, enabled -ErrorAction Stop
    } catch {
        Write-Error "Failed to retrieve user $Identity from Active Directory. $_"
        return
    }

    # Initialize an ordered dictionary to store user details and proxy addresses
    $summary = [ordered]@{
        Name                = $user.Name
        SamAccountName      = $user.SamAccountName
        UserPrincipalName   = $user.UserPrincipalName
        LegacyExchangeDN    = $user.legacyExchangeDN
        Mail                = $user.Mail
        MailNickName        = $user.MailNickName
        TargetAddress       = $user.TargetAddress
        Enabled             = $user.Enabled
    }

    # Extract and process proxy addresses
    $proxyAddresses = $user.proxyAddresses
    $count = 1
    $x500Addresses = @{}
    $duplicates = @{}

    foreach ($address in $proxyAddresses) {
        if ($address -like "x500:*") {
            if ($x500Addresses.ContainsKey($address)) {
                $highlight = "REMOVE: "
                $duplicates[$address] = $true
            } else {
                $highlight = ""
                $x500Addresses[$address] = $true
            }
        } else {
            $highlight = ""
        }
        $summary.Add("ProxyAddress$count", $highlight + $address)
        $count++
    }

    # Retrieve mailbox details from on-premises Exchange
    try {
        $mailbox = Get-Mailbox -Identity $Identity -ErrorAction Stop
        $summary["PrimarySMTPAddress_OnPrem"] = $mailbox.PrimarySmtpAddress.ToString()
    } catch {
        Write-Warning "Failed to retrieve Exchange mailbox details for $Identity from on-premises Exchange. $_"
        $summary["PrimarySMTPAddress_OnPrem"] = ""
    }

    # Retrieve mailbox details from Exchange Online
    try {
        $mailbox = Get-Mailbox -Identity $Identity -ErrorAction Stop -ConnectionUri https://outlook.office365.com/powershell-liveid/
        $summary["PrimarySMTPAddress_Online"] = $mailbox.PrimarySmtpAddress.ToString()
    } catch {
        Write-Warning "Failed to retrieve Exchange mailbox details for $Identity from Exchange Online. $_"
        $summary["PrimarySMTPAddress_Online"] = ""
    }

    # Output the summary object
    return [PSCustomObject]$summary
}

# Usage example:
# $userDetails = Get-ADUserEmailProperties -Identity "becky.galea"
# $userDetails | Format-Table -AutoSize
