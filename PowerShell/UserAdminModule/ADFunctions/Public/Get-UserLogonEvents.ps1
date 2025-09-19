<#
.SYNOPSIS
Retrieves user logon events from the specified event log on one or more computers.

.DESCRIPTION
The Get-UserLogonEvents function retrieves user logon events from the specified event log on one or more computers. It filters the events based on various criteria such as the event log name, start time, end time, event ID, event level, provider name, and message content.

.PARAMETER ComputerName
Specifies the name of the computer(s) from which to retrieve the logon events. The default value is the local computer.

.PARAMETER LogName
Specifies the name of the event log from which to retrieve the logon events (e.g., "Security", "Application").

.PARAMETER StartTime
Specifies the start time for filtering the logon events. The default value is the beginning of the current day.

.PARAMETER EndTime
Specifies the end time for filtering the logon events. The default value is the end of the current day.

.PARAMETER ID
Specifies the event ID to filter the logon events by.

.PARAMETER Level
Specifies the event level to filter the logon events by. Valid values are "Critical", "Error", "Warning", "Information", and "Verbose".

.PARAMETER ProviderName
Specifies the provider name to filter the logon events by.

.PARAMETER MessageFilter
Specifies a keyword or phrase to filter the logon events by message content. The default value is "An account was successfully logged on".

.OUTPUTS
System.Management.Automation.PSCustomObject[]
An array of custom objects representing the logon events that match the specified selection criteria. Each object contains properties such as TimeCreated, ID, ProviderName, Level, Message, SecurityID, AccountName, AccountDomain, LogonID, LogonType, SourceNetworkAddress, SubjectSecurityID, SubjectAccountName, and SubjectAccountDomain.

.EXAMPLE
Get-UserLogonEvents -ComputerName "RDGLONALDSAP001" -LogName "Security" -StartTime (Get-Date).AddDays(-1) -EndTime (Get-Date) -MessageFilter "An account was successfully logged on" | ft -AutoSize -Property SecurityID, AccountName, AccountDomain, LogonID, LogonType, SourceNetworkAddress, SubjectSecurityID, SubjectAccountName, SubjectAccountDomain
Retrieves the logon events from the "Security" event log on the "RDGLONALDSAP001" computer that occurred within the last 24 hours and have the message "An account was successfully logged on". The results are displayed in a formatted table with selected properties.

.LINK
http://scripts.lukeleigh.com/
The help URI for more information about the Get-UserLogonEvents function.

#>
function Get-UserLogonEvents {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(ParameterSetName = 'Default',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter the name of the computer you would like to test.')]
        [string[]]$ComputerName = @($env:COMPUTERNAME),

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'Specify the name of the event log (e.g., Security, Application).')]
        [string]$LogName,

        [Parameter(ParameterSetName = 'Default',
            Position = 2,
            HelpMessage = 'Specify the start time for filtering events. Default is the beginning of the current day.')]
        [datetime]$StartTime = (Get-Date -Hour 0 -Minute 0 -Second 0),

        [Parameter(ParameterSetName = 'Default',
            Position = 3,
            HelpMessage = 'Specify the end time for filtering events. Default is the end of the current day.')]
        [datetime]$EndTime = (Get-Date -Hour 23 -Minute 59 -Second 59),

        [Parameter(ParameterSetName = 'Default',
            Position = 4,
            HelpMessage = 'Specify the event ID to filter events by.')]
        [int]$ID = 4624,

        [Parameter(ParameterSetName = 'Default',
            Position = 5,
            HelpMessage = 'Specify the event level to filter events by. Valid values are "Critical", "Error", "Warning", "Information", and "Verbose".')]
        [ValidateSet("Critical", "Error", "Warning", "Information", "Verbose")]
        [string]$Level,

        [Parameter(ParameterSetName = 'Default',
            Position = 6,
            HelpMessage = 'Specify the provider name to filter events by.')]
        [string]$ProviderName,

        [Parameter(ParameterSetName = 'Default',
            Position = 7,
            HelpMessage = 'Specify a keyword or phrase to filter events by message content.')]
        [string]$MessageFilter = "An account was successfully logged on."
    )

    # Mapping for event levels
    $LevelMapping = @{
        "Critical"    = 1
        "Error"       = 2
        "Warning"     = 3
        "Information" = 4
        "Verbose"     = 5
    }

    $allEvents = @()
    foreach ($Computer in $ComputerName) {
        try {
            # Retrieve the events
            $events = Get-WinEvent -ComputerName $Computer -LogName $LogName -ErrorAction Stop |
                      Where-Object {
                          ($_.TimeCreated -ge $StartTime) -and
                          ($_.TimeCreated -le $EndTime) -and
                          ($_.Id -eq $ID) -and
                          ($Level -eq $null -or $_.LevelDisplayName -eq $Level) -and
                          ($ProviderName -eq $null -or $_.ProviderName -eq $ProviderName) -and
                          ($MessageFilter -eq $null -or $_.Message -like "*$MessageFilter*")
                      }

            # Process events into custom objects
            $customEvents = $events | ForEach-Object {
                $msg = $_.Message -replace "`r`n", "`n"

                # Extract relevant fields from the message
                $SecurityID           = if ($msg -match 'New Logon:\s*Security ID:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $AccountName          = if ($msg -match 'New Logon:\s*Account Name:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $AccountDomain        = if ($msg -match 'New Logon:\s*Account Domain:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $LogonID              = if ($msg -match 'New Logon:\s*Logon ID:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $LogonType            = if ($msg -match 'Logon Information:\s*Logon Type:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $SourceNetworkAddress = if ($msg -match 'Network Information:\s*Source Network Address:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $SubjectSecurityID    = if ($msg -match 'Subject:\s*Security ID:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $SubjectAccountName   = if ($msg -match 'Subject:\s*Account Name:\s*([^\n]*)') { $matches[1].Trim() } else { $null }
                $SubjectAccountDomain = if ($msg -match 'Subject:\s*Account Domain:\s*([^\n]*)') { $matches[1].Trim() } else { $null }

                [PSCustomObject]@{
                    TimeCreated          = $_.TimeCreated
                    ID                   = $_.Id
                    ProviderName         = $_.ProviderName
                    Level                = $_.LevelDisplayName
                    Message              = $_.Message
                    SecurityID           = $SecurityID
                    AccountName          = $AccountName
                    AccountDomain        = $AccountDomain
                    LogonID              = $LogonID
                    LogonType            = $LogonType
                    SourceNetworkAddress = $SourceNetworkAddress
                    SubjectSecurityID    = $SubjectSecurityID
                    SubjectAccountName   = $SubjectAccountName
                    SubjectAccountDomain = $SubjectAccountDomain
                }
            }

            if ($customEvents) {
                $allEvents += $customEvents
            }
        }
        catch {
            Write-Warning "Failed to retrieve events from {$Computer}: $_"
        }
    }

    if ($allEvents.Count -eq 0) {
        Write-Warning "No events were found that match the specified selection criteria."
    }

    return $allEvents
}

# Usage Example
# Get-UserLogonEvents -ComputerName "RDGLONALDSAP001" -LogName "Security" -StartTime (Get-Date).AddDays(-1) -EndTime (Get-Date) -MessageFilter "An account was successfully logged on" | ft -AutoSize -Property SecurityID, AccountName, AccountDomain, LogonID, LogonType, SourceNetworkAddress, SubjectSecurityID, SubjectAccountName, SubjectAccountDomain
