$after = (get-date).AddDays(-2)
$before = (get-date).AddDays(-3)
Get-EventLog -LogName Application -EntryType Error -Newest 50 -After $after -Before $before | Format-List EntryType,TimeGenerated,Message,InstanceId


Get-EventLog -LogName System -EntryType Error -Newest 50 | Where-Object { $_.Message -like "The previous system shutdown*" }

