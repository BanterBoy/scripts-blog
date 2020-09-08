Get-Mailbox |
Get-MailboxStatistics |
Sort-Object TotalItemSize -Descending |
Select-Object -Property DisplayName,DeletedItemCount,TotalItemSize,LastLogonTime |
ConvertTo-Csv |
Out-File C:\Temp\Mailboxes.csv


<#
Get-Mailbox | Get-MailboxStatistics | Get-Member

AssociatedItemCount
Database
DatabaseName
DeletedItemCount
DisconnectDate
DisconnectReason
DisplayName
Identity
IsArchiveMailbox
IsQuarantined
IsValid
ItemCount
LastLoggedOnUserAccount
LastLogoffTime
LastLogonTime
LegacyDN
MailboxGuid
MailboxTableIdentifier
MapiIdentity
MoveHistory
ObjectClass
OriginatingServer
ServerName
StorageLimitStatus
TotalDeletedItemSize
TotalItemSize


Get-Mailbox | Get-MailboxStatistics | Sort-Object TotalItemSize | Format-Table -Property DisplayName,DeletedItemCount,TotalItemSize,LastLogonTime -AutoSize

#>
