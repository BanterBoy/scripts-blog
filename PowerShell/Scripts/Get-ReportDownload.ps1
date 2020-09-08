Connect-Office365Services.ps1
Connect-ExchangeOnline -Credential (Get-Credential)
Connect-MsolService -Credential (Get-Credential)

$reports = Get-HistoricalSearch | Where-Object { ( $_.Status -eq 'Done' ) -and ( $_.Rows -gt '0' ) -and ( $_.SubmitDate -ge '05/23/2019 06:00:00') }
foreach ($report in $reports) {
    $path = "C:\AllDomainEmailReports"
	$filename = ($report.ReportTitle).Replace('/','-') + ".csv"
    $url = $report.FileUrl
    $output = Join-Path -Path $path -ChildPath $filename
    Start-Process $url
}
