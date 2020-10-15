.\PowerShellScripts\CapitalSupport\Functions\Connect-Office365Services.ps1
Connect-ExchangeOnline -Credential (Get-Credential)
Connect-MsolService -Credential (Get-Credential)
$emailDomains = Get-MsolDomain | Where-Object { $_.Status -eq 'Verified' }

foreach ($emailDomain in $emailDomains) {
    Start-HistoricalSearch -ReportTitle ($emailDomain.Name + ' - '  + (Get-Date).AddDays(-10).ToShortDateString()) -StartDate "5/13/2019 00:00:00" -EndDate "5/13/2019 23:30:00" -Direction Sent -ReportType MessageTraceDetail -SenderAddress ('*@' + $emailDomain.Name) -NotifyAddress 'csg-admin@ssy.co.uk'
    Start-HistoricalSearch -ReportTitle ($emailDomain.Name + ' - '  + (Get-Date).AddDays(-9).ToShortDateString()) -StartDate "5/14/2019 00:00:00" -EndDate "5/14/2019 23:30:00" -Direction Sent -ReportType MessageTraceDetail -SenderAddress ('*@' + $emailDomain.Name) -NotifyAddress 'csg-admin@ssy.co.uk'
    Start-HistoricalSearch -ReportTitle ($emailDomain.Name + ' - '  + (Get-Date).AddDays(-8).ToShortDateString()) -StartDate "5/15/2019 00:00:00" -EndDate "5/15/2019 23:30:00" -Direction Sent -ReportType MessageTraceDetail -SenderAddress ('*@' + $emailDomain.Name) -NotifyAddress 'csg-admin@ssy.co.uk'
    Start-HistoricalSearch -ReportTitle ($emailDomain.Name + ' - '  + (Get-Date).AddDays(-7).ToShortDateString()) -StartDate "5/16/2019 00:00:00" -EndDate "5/16/2019 23:30:00" -Direction Sent -ReportType MessageTraceDetail -SenderAddress ('*@' + $emailDomain.Name) -NotifyAddress 'csg-admin@ssy.co.uk'
    Start-HistoricalSearch -ReportTitle ($emailDomain.Name + ' - '  + (Get-Date).AddDays(-6).ToShortDateString()) -StartDate "5/17/2019 00:00:00" -EndDate "5/17/2019 23:30:00" -Direction Sent -ReportType MessageTraceDetail -SenderAddress ('*@' + $emailDomain.Name) -NotifyAddress 'csg-admin@ssy.co.uk'
}