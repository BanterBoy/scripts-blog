# Paul Flaherty
# http://blogs.flaphead.dns2go.com/archive/2008/11/14/get-mailboxstatistics-with-totalitemsize-in-mb-to-a-csv-file.aspx
# Create a csv file from Get-MailboxStatistics, but with the TotalItemSize in MB

"DisplayName,TotalItemSize(MB),ItemCount,StorageLimitSize,Database,LegacyDN" | out-file GMS.csv; get-mailbox -resultsize unlimited | Get-MailboxStatistics | foreach{$a = $_.DisplayName;$b=$_.TotalItemSize.Value.ToMB();$c=$_.itemcount;$d=$_.storagelimitstatus;$e=$_.database;$f=$_.legacydn;"$a,$b,$c,$d,$e,$f"} | out-file GMS.csv -Append