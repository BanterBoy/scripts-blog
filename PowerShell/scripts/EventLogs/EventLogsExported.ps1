$after = (Get-Date).AddDays(-2)
$before = (Get-Date).AddDays(-3)

Get-EventLog -LogName Application -EntryType Error -Newest 50 -After $after -Before $before | Format-List EntryType, TimeGenerated, Message, InstanceId

Get-EventLog -LogName System -EntryType Error -Newest 50 | Where-Object { $_.Message -like "The previous system shutdown*" }

