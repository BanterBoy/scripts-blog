<#
    .SYNOPSIS
    Finds unused accounts in Active Directory.

    .DESCRIPTION
    The Find-UnusedADAccounts function is used to find unused accounts in Active Directory. It retrieves accounts that meet certain conditions, such as disabled accounts, expired passwords, and accounts that have not been logged into for a specified period of time.

    .EXAMPLE
    $unused_accounts = Find-UnusedADAccounts -InactiveDays 90 -IncludeDisabled $true -IncludeExpiredPasswords $true -OrganizationalUnit "OU=Users,DC=example,DC=com" -AccountType User
    $unused_accounts | Where-Object { $_.Enabled -eq $false } | Select-Object Username, FirstName, LastName, DistinguishedName, PasswordLastSet, PasswordNeverExpires, PasswordExpired, PasswordAge, LastLogonDate, LastLogonAge, AccountExpirationDate, AccountCreated, AccountModified, EmailAddress, PhoneNumber

    .PARAMETER RemoveUsersFound
    Specifies whether to remove the found unused accounts. By default, it is set to $false.

    .PARAMETER InactiveDays
    Specifies the number of days of inactivity to consider an account as unused. By default, it is set to 60 days.

    .PARAMETER IncludeDisabled
    Specifies whether to include disabled accounts in the search. By default, it is set to $true.

    .PARAMETER IncludeExpiredPasswords
    Specifies whether to include accounts with expired passwords in the search. By default, it is set to $true.

    .PARAMETER OrganizationalUnit
    Specifies an Organizational Unit to limit the search scope. By default, it searches the entire directory.

    .PARAMETER OnlyDisabled
    Specifies whether to only find disabled unused accounts. By default, it is set to $false.

    .PARAMETER AccountType
    Specifies the type of accounts to search for. Valid values are 'User', 'Computer', 'ServiceAccount'. By default, it is set to 'User'.

    .PARAMETER AccountStatus
    Specifies the status of accounts to search for. Valid values are 'Inactive', 'Disabled', 'Expired', 'Expiring', 'LockedOut', 'PasswordExpired', 'PasswordNeverExpires'. By default, it is set to 'Inactive'.

    .NOTES
    This function requires the Active Directory module to be installed.

#>

function Find-UnusedADAccounts {
    
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [bool]$RemoveUsersFound = $false,

        [Parameter(Mandatory = $false)]
        [int]$InactiveDays = 60,

        [Parameter(Mandatory = $false)]
        [bool]$IncludeDisabled = $true,

        [Parameter(Mandatory = $false)]
        [bool]$IncludeExpiredPasswords = $true,

        [Parameter(Mandatory = $false)]
        [string]$OrganizationalUnit,

        [Parameter(Mandatory = $false)]
        [bool]$OnlyDisabled = $false,

        [Parameter(Mandatory = $false)]
        [ValidateSet("User", "Computer", "ServiceAccount")]
        [string]$AccountType = "User",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Inactive", "Disabled", "Expired", "Expiring", "LockedOut", "PasswordExpired", "PasswordNeverExpires")]
        [string]$AccountStatus = "Inactive"
    )

    $today_object = Get-Date
    $time_span = New-TimeSpan -Days $InactiveDays

    try {
        $search_params = @{ }

        if ($OrganizationalUnit) {
            $search_params['SearchBase'] = $OrganizationalUnit
        }

        switch ($AccountType) {
            "User" {
                $search_params['UsersOnly'] = $true
            }
            "Computer" {
                $search_params['ComputersOnly'] = $true
            }
            "ServiceAccount" {
                $search_params['ServiceLogon'] = $true
            }
        }

        switch ($AccountStatus) {
            "Inactive" {
                $search_params['AccountInactive'] = $true
                $search_params['TimeSpan'] = $time_span
            }
            "Disabled" {
                $search_params['AccountDisabled'] = $true
            }
            "Expired" {
                $search_params['AccountExpired'] = $true
            }
            "Expiring" {
                $search_params['AccountExpiring'] = $true
                $search_params['TimeSpan'] = $time_span
            }
            "LockedOut" {
                $search_params['LockedOut'] = $true
            }
            "PasswordExpired" {
                $search_params['PasswordExpired'] = $true
            }
            "PasswordNeverExpires" {
                $search_params['PasswordNeverExpires'] = $true
            }
        }

        $unused_accounts = Search-ADAccount @search_params |
        Get-ADUser -Properties samAccountName, givenName, surName, Enabled, PasswordExpired, LastLogonDate, PasswordLastSet, PasswordNeverExpires, AccountExpirationDate, Created, Modified, EmailAddress, telephoneNumber, MobilePhone, UserPrincipalName, proxyAddresses |
        Where-Object {
            ($OnlyDisabled -and -not $_.Enabled) -or
            (($IncludeDisabled -or $_.Enabled) -and ($IncludeExpiredPasswords -or -not $_.PasswordExpired))
        } |
        Select-Object @{
            Name = 'Username'; Expression = { $_.samAccountName }
        }, @{
            Name = 'FirstName'; Expression = { $_.givenName }
        }, @{
            Name = 'LastName'; Expression = { $_.surName }
        }, @{
            Name = 'DistinguishedName'; Expression = { $_.DistinguishedName }
        }, @{
            Name = 'Enabled'; Expression = { $_.Enabled }
        }, @{
            Name = 'PasswordExpired'; Expression = { $_.PasswordExpired }
        }, @{
            Name = 'PasswordAge'; Expression = { if (!$_.PasswordLastSet) { 'Never' } else { ($today_object - $_.PasswordLastSet).Days } }
        }, @{
            Name = 'PasswordLastSet'; Expression = { $_.PasswordLastSet }
        }, @{
            Name = 'PasswordNeverExpires'; Expression = { $_.PasswordNeverExpires }
        }, @{
            Name = 'LastLogonAge'; Expression = { if (!$_.LastLogonDate) { 'Never' } else { ($today_object - $_.LastLogonDate).Days } }
        }, @{
            Name = 'LastLogonDate'; Expression = { $_.LastLogonDate }
        }, @{
            Name = 'AccountExpirationDate'; Expression = { $_.AccountExpirationDate }
        }, @{
            Name = 'AccountCreated'; Expression = { $_.Created }
        }, @{
            Name = 'AccountModified'; Expression = { $_.Modified }
        }, @{
            Name = 'EmailAddress'; Expression = { $_.EmailAddress }
        }, @{
            Name = 'UserPrincipalName'; Expression = { $_.UserPrincipalName }
        }, @{
            Name = 'PhoneNumber'; Expression = { $_.telephoneNumber }
        }, @{
            Name = 'Mobile'; Expression = { $_.MobilePhone }
        }, @{
            Name = 'proxyAddresses'; Expression = { $_.proxyAddresses }
        }, @{
            Name = 'AccountType'; Expression = { $AccountType }
        }, @{
            Name = 'AccountStatus'; Expression = { $AccountStatus }
        }
    }
    catch {
        Write-Error "Failed to retrieve accounts: $_"
        return
    }

    if ($RemoveUsersFound) {
        $unused_accounts | ForEach-Object {
            try {
                if ($PSCmdlet.ShouldProcess("Removing account $($_.Username)")) {
                    Remove-ADUser $_.Username -Confirm:$false
                    Write-Output "Removed account: $($_.Username)"
                }
            }
            catch {
                Write-Error "Failed to remove account $($_.Username): $_"
            }
        }
    }

    return $unused_accounts
}
