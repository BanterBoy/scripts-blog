# Exchange Server Admin Audit Report
# This script has been written to report on events in the Exchange server admin audit log over the last 48 hours.
# This has been written for Exchange 2010 SP3 and to be compatible with PowerShell 2.0
# Version 1.0 -  James Pearman, November 2018


#Parameters

$Date = Get-Date
$yesterday = (Get-Date).AddHours(-48)
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exch@domain.com"
$EmailSubject = "Exchange Server Audit Report" + $Date 
$SMTPServer = "smtp.domain.com"
$ReportFileName = "C:\Support\ExchAdminLog.html"


#Create HTML Table

$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Exchange Server Admin Log"

#Get Admin Logs

$logs = Search-AdminAuditLog -StartDate $yesterday | Select ObjectModified,CmdletName,@{Expression={$_.CmdletParameters};Label="CmdletParameters";},@{Expression={$_.ModifiedProperties};Label="ModifiedProperties";},Caller,Succeeded,Error,RunDate

$Logs | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Send Email

$Body = [System.IO.File]::ReadAllText('C:\Support\ExchAdminLog.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
