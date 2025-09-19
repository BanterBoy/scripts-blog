<#
.SYNOPSIS
Retrieves logon history events from the Security event log on one or more computers.

.DESCRIPTION
The Get-LogonHistory function retrieves logon history events from the Security event log on one or more computers. It filters the events based on the event IDs 4624 (successful logon), 4625 (failed logon), and 4647 (user initiated logoff).

.PARAMETER ComputerName
Specifies the name of the computer(s) from which to retrieve logon history events. The default value is the local computer. This parameter supports pipeline input.

.PARAMETER Credential
Specifies the credentials to use when connecting to remote computers. This parameter supports pipeline input.

.EXAMPLE
Get-LogonHistory -ComputerName 'Server01', 'Server02' -Credential $cred

This example retrieves logon history events from 'Server01' and 'Server02' using the specified credentials.

.INPUTS
System.String, System.Management.Automation.PSCredential

.OUTPUTS
System.Management.Automation.PSObject

.NOTES
Author: Your Name
Date:   Current Date
#>

function Get-LogonHistory {
    Param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            $eventLogs = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "Security"; Id = '4624', '4625', '4647' } -ErrorAction SilentlyContinue
            foreach ($eventLog in $eventLogs) {
                try {
                    $properties = @{
                        Message      = [string]$eventLog.Message
                        Id           = [int]$eventLog.Id
                        LogName      = [string]$eventLog.LogName
                        MachineName  = [string]$eventLog.MachineName
                        ProviderName = [string]$eventLog.ProviderName
                        TimeCreated  = [datetime]$eventLog.TimeCreated
                    }
                    $obj = New-Object -TypeName PSObject -Property $Properties
                    Write-Output $obj
                }
                catch {
                    Write-Error "Failed with error: $_.Message"
                }
            }
        }
    }
    END {
    }
}
