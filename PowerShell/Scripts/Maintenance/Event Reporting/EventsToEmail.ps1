#Event Logs Send to Email Script
#Version:1.0, June 2018, James Pearman

#Parameters
$ServerName = "$env:computername"
$EmailTo = "<INSERT EMAIL ADDRESS>"
$EmailFrom = "<INSERT EMAIL ADDRESS>"
$EmailSubject = "Server Events for " + $ServerName
$SMTPServer = "<INSERT SMTP>"
$ReportFileName = "C:\Support\LogAppView.html"
$yesterday = (Get-Date).AddHours(-24)
$Date = Get-Date

#Create HTML Table
$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Application and System event logs with either warning or error status for $ServerName within last 24 hours"

#Get event logs and convert to HTML file
$Events = Get-WinEvent -FilterHashTable @{LogName='Application','System'; Level=2,3; StartTime=$Yesterday} -ErrorAction SilentlyContinue | Select-Object TimeCreated,LogName,ProviderName,Id,LevelDisplayName,Message

$Events | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Send Email
$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
