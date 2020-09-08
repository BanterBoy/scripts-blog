$MortgagePaid = New-TimeSpan -Start (Get-Date) -End "28/07/2019 00:00:00"
Write-Host -NoNewline $MortgagePaid.Days "Days,", $MortgagePaid.Hours "Hours,", $MortgagePaid.Minutes "Minutes,", $MortgagePaid.Seconds "Seconds"

