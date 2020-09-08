<#
    .SYNOPSIS
    Short function to send an export from the EventLog to Email (Incomplete)
    - Code forked from James Pearman's EventsToEmail Script (https://github.com/jimmyp85/Maintenance)

    .DESCRIPTION
    Short function to send an export from the EventLog to Email (Incomplete)
    This function is not completed and is still being written.
    Currently adapting script to make a cmdlet

    Code forked from James Pearman's EventsToEmail Script.

    .EXAMPLE
    This CmdLet is incomplete

    .INPUTS
    None

    .OUTPUTS
    None (at present)

    .NOTES
    Author:     Luke Leigh & James Pearman
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/ - https://github.com/jimmyp85/Maintenance
    GitHubGist: https://gist.github.com/BanterBoy
    Version:    1.1 (August  2018)

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

# $currentConfigs = Get-ChildItem -Path ".\resources\" -Include "*.json" | Select-Object -Property *

$currentConfigs = Get-ChildItem -Path ".\resources\*.json" | Select-Object -Property Fullname,Name -Unique
foreach ($currentConfig in $currentConfigs) {
    Get-Content $currentConfig.FullName | ConvertFrom-Json -OutVariable $currentConfig.Name
}


Get-Content -Path ".\resources\$ConfigFileName" | ConvertFrom-Json -OutVariable serverConfig
$FilePath = "C:\Support\"
$ReportFile = "$FilePath\ + $ReportFileName"

#Parameters
# $ComputerName = "$env:computername"
# $EmailTo = "<INSERT EMAIL ADDRESS>"
$EmailFrom = "<INSERT EMAIL ADDRESS>"
$EmailSubject = "Server Events for " + $ServerName
$SMTPServer = "<INSERT SMTP>"
$ReportFileName = "C:\Support\LogAppView.html"
$Yesterday = (Get-Date).AddHours(-24)

#Create HTML Table
$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Application and System event logs with either warning or error status for $ComputerName within last 24 hours"

#Get event logs and convert to HTML file
$Events = Get-WinEvent -FilterHashTable @{LogName = 'Application', 'System'; Level = 2, 3; StartTime = $Yesterday} -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, LogName, ProviderName, Id, LevelDisplayName, Message

$Events |
    ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFile"

#Send Email
$Body = Get-Content -Raw $ReportFile
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
#>
