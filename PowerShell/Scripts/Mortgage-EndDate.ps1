$MortgagePaid = New-TimeSpan -Start (Get-Date) -End "28/07/2019 00:00:00"
$MortgageYears = (($MortgagePaid.Days)*0.0027).ToString("F")
$MortgageMonths = (($MortgagePaid.Days)*0.0328).ToString("F")
$MortgageDays = (($MortgagePaid.Days)*24).ToString("F")

Clear-Host

Write-Host "-------------------------------"
Write-Host "     Time left on Mortgage"
Write-Host "-------------------------------"
Write-Host " Total | " $MortgageYears "Years"
Write-Host " Total | " $MortgageMonths "Months"
Write-Host " Total | " $MortgageDays "Days"
Write-Host "-------------------------------"
Write-Host ""
Write-Host "Countdown"
Write-Host "---------"
Write-Host "Total = " $MortgagePaid.Days "Days,", $MortgagePaid.Hours "Hours,", $MortgagePaid.Minutes "Minutes,", $MortgagePaid.Seconds "Seconds"
Write-Host ""
