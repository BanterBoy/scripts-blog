function Unlock-UserAccount {
    <#
    .SYNOPSIS
    Unlock AD User Accounts for user who are currently locked out.
    
    .DESCRIPTION
    This function will gather user account information from Active Directory compiling a list of user accounts
    for all Active Directory accounts that are currently locked due to incorrect passwords being entered.
    When running the function, it searches all AD User accounts from AD looking for those that are locked out.
    It then produces an alphabetical list output in Grid-View with the user details "Name,SamAccountName,LastLogonDate,UserPrincipalName,LockedOut"
    You can then select the User/s accounts and click OK to unlock them.
    
    .EXAMPLE
    Unlock-UserAccount
    
    .NOTES
    The user account running this function, needs to have 'Domain Admin Privileges' in order to unlock the account.
    
    #>
    
    Search-ADAccount -LockedOut |
    Select-Object Name, SamAccountName, LastLogonDate, UserPrincipalName, LockedOut |
    Sort-Object Name |
    Out-GridView -PassThru |
    Foreach-Object { Unlock-ADAccount -Identity $_.DistinguishedName }
}
