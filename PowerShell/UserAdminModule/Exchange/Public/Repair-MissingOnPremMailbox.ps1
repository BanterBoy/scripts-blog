# function Repair-MissingOnPremMailbox {
#     param (
#         [String]
#         $SamAccountName
#     )
#     $ADUserInfo = Get-ADUser -Identity $SamAccountName -Properties *
#     $Name = $AdUserInfo.GivenName + "." + $AdUserInfo.Surname
#     Set-ADUser -Identity $ADUserInfo.SamAccountName -add @{ProxyAddresses = "SMTP:$($Name)@raildeliverygroup.com,smtp:$($Name)@atoc.mail.onmicrosoft.com" -split "," }
#     Enable-RemoteMailbox -Identity $ADUserInfo.SamAccountName-RemoteRoutingAddress "$($Name)@atoc.mail.onmicrosoft.com"
# }


function Repair-MissingOnPremMailbox {
    <#
    .SYNOPSIS
    Repairs a missing on-premises mailbox by adding a proxy address and enabling a remote mailbox.
    
    .DESCRIPTION
    This function takes a SamAccountName as input and checks if the user exists in Active Directory. If the user exists, it adds a proxy address and enables a remote mailbox.
    
    .PARAMETER SamAccountName
    The SamAccountName of the user whose mailbox needs to be repaired.
    
    .PARAMETER PrimaryDomain
    The primary domain name for the user's email address. Default value is "raildeliverygroup.com".
    
    .PARAMETER Office365Domain
    The Office 365 domain name for the user's email address. Default value is "atoc.mail.onmicrosoft.com".
    
    .EXAMPLE
    Repair-MissingOnPremMailbox -SamAccountName "JohnDoe"
    
    This example repairs the missing on-premises mailbox for the user with SamAccountName "JohnDoe".
    
    .NOTES
    Author: Luke Leigh
    Date: 2023-10-29
    Version: 1.0.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $SamAccountName,
        [Parameter(Mandatory = $false)]
        [String]
        $PrimaryDomain = "raildeliverygroup.com",
        [Parameter(Mandatory = $false)]
        [String]
        $Office365Domain = "atoc.mail.onmicrosoft.com"
    )
    try {
        $ADUserInfo = Get-ADUser -Identity $SamAccountName -Properties *
        if ($null -eq $ADUserInfo) {
            Write-Error "User $SamAccountName not found in Active Directory"
            return
        }
        $Name = $AdUserInfo.GivenName + "." + $AdUserInfo.Surname
        Set-ADUser -Identity $ADUserInfo.SamAccountName -add @{ProxyAddresses = "SMTP:$($Name)@$($PrimaryDomain),smtp:$($Name)@$($Office365Domain)" -split "," }
        Enable-RemoteMailbox -Identity $ADUserInfo.SamAccountName -RemoteRoutingAddress "$($Name)@$($Office365Domain)"
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
