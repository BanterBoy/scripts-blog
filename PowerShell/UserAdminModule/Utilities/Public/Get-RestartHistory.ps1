<#
.SYNOPSIS
    Retrieves the restart history of one or more computers.

.DESCRIPTION
    The Get-RestartHistory function retrieves the restart history of one or more computers by querying the System event log for specific event IDs related to system restarts. It returns a collection of objects representing each restart event, including information such as the event message, ID, log name, machine name, provider name, and time created.

.PARAMETER ComputerName
    Specifies the name of the computer(s) to retrieve the restart history from. If not specified, the local computer name is used by default. This parameter supports pipeline input.

.PARAMETER Credential
    Specifies the credentials to use when connecting to remote computers. If not specified, the current user's credentials are used by default. This parameter supports pipeline input.

.EXAMPLE
    Get-RestartHistory -ComputerName KAMINO | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(-7) | Where-Object -FilterScript { ($_.ID -EQ 6005) -or ($_.ID -EQ 6006) } | Format-Table -AutoSize
    Retrieves the restart history from the computer named "KAMINO" for the past 7 days and filters the results to include only events with ID 6005 or 6006. The results are then formatted as a table.

#>

function Get-RestartHistory {
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
            $eventLogs = Get-WinEvent -ComputerName $Computer -FilterHashtable @{ LogName = "System"; Id = '6005', '6006', '6008', '6009', '6013', '1074', '1076' } -ErrorAction SilentlyContinue
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
