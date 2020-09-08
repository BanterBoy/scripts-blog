<#
    .SYNOPSIS
    Resource CmdLet used to create a config file to be used with the Send-EventsToEmail CmdLet (Incomplete)
    - Code forked from James Pearman's EventsToEmail Script (https://github.com/jimmyp85/Maintenance)

    .DESCRIPTION
    Resource CmdLet used to create a config file to be used with the Send-EventsToEmail CmdLet (Incomplete)
    This function is not completed and is still being written.
    Currently adapting James script to make a cmdlet

    Code forked from James Pearman's EventsToEmail Script.

    .EXAMPLE
    .\New-ReportConfig.ps1 -ComputerName "servername.domain" -EmailTo "recipient@address.com" -EmailFrom "sender@address.com" -EmailSubject "This is a test Email Config File" -SMTPServer "email.server.com" -ReportFileName "Report.html" -Date -ConfigFileName "serverConfig.json"

    This command will test for a subfolder called resources, if this does not exist, a warning message will be displayed.
    If the folder exists, a new JSON file is then created within this resource folder.
    This JSON file can then be imported to create a report using the Send-EventsToEmail CmdLet

    .EXAMPLE
    .\New-ReportConfig.ps1 -ComputerName $env:COMPUTERNAME -EmailTo 'recipient@address.com' -EmailFrom 'sender@address.com' -EmailSubject "EventLog Report from $env:COMPUTERNAME" -SMTPServer 'smtpserver.address.com' -ReportFileName "$env:COMPUTERNAME-Report.html" -ConfigFileName "$env:COMPUTERNAME-reportconfig.json" -Date

    This command will test for a subfolder called resources, if this does not exist, a warning message will be displayed.
    If the folder exists, a new JSON file is then created within this resource folder.
    This JSON file can then be imported to create a report using the Send-EventsToEmail CmdLet

    .INPUTS
    None

    .OUTPUTS
    JSON file created containing the following details

    $ConfigFileName = serverConfig.json

    {
        "Recipient":  [
                        "recipient@address.com"
                    ],
        "SMTPServer":  [
                        "email.server.com"
                    ],
        "Subject":  [
                        "This is a test Email Config File"
                    ],
        "Today-Yesterday":  {
                                "IsPresent":  true
                            },
        "ReportFilename":  [
                            "Report.html"
                        ],
        "Sender":  [
                    "sender@address.com"
                ],
        "ServerName":  [
                        "servername.domain"
                    ]
    }

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


[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "Please enter the ComputerName or Pipe in from another command.")]
    [Alias('Hostname', 'cn')]
    [string[]]$ComputerName,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter the Recipient's Email Address or Pipe in from another command.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('et', 'Eto')]
    [string[]]$EmailTo,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter the Sender's Email Address or Pipe in from another command.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('ef', 'Efr')]
    [String[]]$EmailFrom,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email subject or Pipe in from another command.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('es', 'EmSub')]
    [string[]]$EmailSubject,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter SMTP Server address FQDN or Pipe in from another command.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('ss', 'SMTP')]
    [string[]]$SMTPServer,

    [Parameter(Mandatory = $True,
        HelpMessage = "Enter Filename (e.g. LogAppView.html)",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('rfn')]
    [string[]]$ReportFileName,

    [Parameter(Mandatory = $True,
        HelpMessage = "Enter Filename (e.g. serverConfig.json)",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('cfn')]
    [string[]]$ConfigFileName,

    [Parameter(Mandatory = $false,
        HelpMessage = "Please enter an Email subject or Pipe in from another command.",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('yd')]
    [switch]$Date
)

BEGIN {}

PROCESS {
    if ((Test-Path -Path ".\resources").Equals($false)) {
        Write-Host "WARNING! Resource folder does not exist. Please create subfolder called resources"
    }
    else {
        try {
            $properties = @{
                "ServerName"      = $ComputerName
                "Recipient"       = $EmailTo
                "Sender"          = $EmailFrom
                "Subject"         = $EmailSubject
                "SMTPServer"      = $SMTPServer
                "ReportFilename"  = $ReportFileName
                "Today-Yesterday" = $Date
            }
        }
        catch {
            $properties = @{
                "ServerName"      = $ComputerName
                "Recipient"       = $EmailTo
                "Sender"          = $EmailFrom
                "Subject"         = $EmailSubject
                "SMTPServer"      = $SMTPServer
                "ReportFilename"  = $ReportFileName
                "Today-Yesterday" = $Date
            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            $obj | ConvertTo-Json | Out-File -FilePath ".\resources\$ConfigFileName"
            Get-Content -Path ".\resources\$ConfigFileName" | ConvertFrom-Json -OutVariable serverConfig
        }
    }
}
