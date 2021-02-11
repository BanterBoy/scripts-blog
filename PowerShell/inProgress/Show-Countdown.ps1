$MortgagePaid = New-TimeSpan -Start (Get-Date) -End "01/02/2030 00:00:00"
$MortgageYears = (($MortgagePaid.Days)*0.0027).ToString("F")
$MortgageMonths = (($MortgagePaid.Days)*0.0328).ToString("F")
$MortgageDays = ($MortgagePaid.Days)
$MortgageHours = ($MortgagePaid.TotalHours).ToString("F")
Write-Host ""
Write-Host "-------------------------------"
Write-Host "     Time left on Mortgage"
Write-Host "-------------------------------"
Write-Host " Total | " $MortgageYears "Years"
Write-Host " Total | " $MortgageMonths "Months"
Write-Host " Total | " $MortgageDays "Days"
Write-Host " Total | " $MortgageHours "Hours"
Write-Host "-------------------------------"
Write-Host ""
Write-Host "Countdown"
Write-Host "---------"
Write-Host "Total = " $MortgagePaid.Days "Days,", $MortgagePaid.Hours "Hours,", $MortgagePaid.Minutes "Minutes,", $MortgagePaid.Seconds "Seconds"
Write-Host ""

<#
$ppi = New-TimeSpan -Start (Get-Date) -End "29/11/2018 00:00:00"
Write-Host "Check PPI Emails"
Write-Host "----------------"
Write-Host "In " $ppi.Days "Days"
Write-Host ""

// 29/07/2019
var futureDate = new Date(2030, 2, 1);
#>