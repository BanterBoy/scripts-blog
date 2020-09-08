# Exchange Server 2010: Agent Log Reports
# This script has been written to run as a scheduled task and email the last 48 hours Agent Logs.
# Version 1.0 - James Pearman, July 2019


#Parameters

$Date = (Get-Date).AddHours(-48)
$EmailTo = "recip@domain.com"
$EmailFrom = "from@domain.com"
$EmailSubject = "Exchange Agent Logs" + $Date 
$SMTPServer = "123.456.7.89"
$ReportFileName = "C:\TaskScripts\TaskOut\Exch\ExchAgentLogs.html"

# Load the Microsoft Exchange Server 2010 PowerShell Snapin
If ((Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue) -eq $Null) {
    Add-PsSnapin Microsoft.Exchange.Management.PowerShell.E2010
}

# Map Agent Log Location
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\exchange\c$\Program Files\Microsoft\Exchange Server\V14\TransportRoles\Logs\AgentLog" -Persist

#Create HTML Table

$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Exchange Server Admin Log"

#Get Agent Logs

$Logs = Get-AgentLog -Location "Z:\" -StartDate $Date | select-object @{n='recipients';e={$_.recipients}},timestamp,P1fromaddress,@{n='p2fromaddresses';e={$_.p2fromaddresses}},reasondata

$Logs | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Send Email

$Body = [System.IO.File]::ReadAllText('C:\TaskScripts\TaskOut\Exch\ExchAgentLogs.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer

#Remove Mapped Drive
Remove-PSDrive -Name Z
