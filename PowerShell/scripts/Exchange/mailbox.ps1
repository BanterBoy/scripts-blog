Get-Mailbox |
Get-MailboxPermission |
Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} |
Select-Object Identity,User,@{Name='Access Rights';Expression={[string]::join(', ', $_.AccessRights)}} |
Export-Csv -NoTypeInformation C:\temp\mailboxpermissions.csv
