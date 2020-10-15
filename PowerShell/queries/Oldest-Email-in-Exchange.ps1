Get-mailboxdatabase | Get-Mailbox | Sort-Object -Property Name | ForEach-Object { $s = $_.SamAccountName; Get-MailboxFolderStatistics $s -IncludeOldestAndNewestItems | Sort-Object OldestItemReceivedDate | Where-Object { $_.OldestItemReceivedDate -ne $null } | Select-Object Identity, OldestItemReceivedDate -First 1 }

<#

There are requirements when you need to find oldest email in a mailbox so that you can take necessary decisions. I could remember these one scenario when this happens.

You have to deploy Exchange Retetnion POlicies on a Mailbox and want to know what type of emails will be deleted.

There is a simple one liner to extract stats against mailbox or set of mailboxes.

Launch On-Prem Exchange or Exchange Online Powershell.

Run this command against one mailbox, It will dump data to a CSV on your desktop.

#>

Get-MailboxFolderStatistics -ID <mailboxemailaddress> -IncludeOldestAndNewestItems | Select-Object Identity, Name, FolderPath, ItemsInFolder, FolderSize, OldestItemReceivedDate | Export-Csv $homedesktopMB.csv -NoTypeInformation

generic.JPG

Run against all mailboxes, but that will take so much time to export.

Get-Mailbox -resultsize unlimited | ForEach-Object { Get-MailboxFolderStatistics -id $_ -IncludeOldestAndNewestItems } | Select-Object Identity, Name, FolderPath, ItemsInFolder, FolderSize, OldestItemReceivedDate | Export-Csv $homedesktopAllMB.csv -NoTypeInformation

# Run against set of mailboxes, Copy list of email address in a .txt file and run below command.

Get-Content $homedesktopinput.txt | ForEach-Object { Get-MailboxFolderStatistics -id $_ -IncludeOldestAndNewestItems } | Select-Object Identity, Name, FolderPath, ItemsInFolder, FolderSize, OldestItemReceivedDate | Export-Csv $homedesktopFewMB.csv -NoTypeInformation

