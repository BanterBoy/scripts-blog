$DisabledUsers = Get-ADUser -Filter { Name -like '*' } -SearchBase "OU=Users,OU=Disabled Accounts,DC=domain,DC=local" |
Where-Object { $_.Enabled -eq $false }
foreach ($User in $DisabledUsers) {
    try {
        Get-Mailbox -Identity $User.UserPrincipalName -ErrorAction Stop |
        Set-Mailbox -HiddenFromAddressListsEnabled $true -ErrorAction Stop -Whatif
    }
    catch {
        Write-Verbose -Message $_.Exception.Message -Verbose
    }
}
