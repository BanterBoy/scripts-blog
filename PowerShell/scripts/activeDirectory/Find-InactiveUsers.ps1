$inactiveUsers = Search-ADAccount -AccountInactive -UsersOnly -SearchBase "OU=Users,OU=example,DC=example,DC=local"  | Where-Object { $null -eq $_.LastLogonDate }

foreach ($inactiveUser in $inactiveUsers) {
    Get-ADUser -Filter { SamAccountName -eq $inactiveUser.SamAccountName } -Properties *
} Out-File C:\MoreInactiveUsers.txt
