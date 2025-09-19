function Get-VpnFailoverEventLogs {
    <#
    .SYNOPSIS
    Retrieves the event logs created by the Switch-VpnFailover function.

    .DESCRIPTION
    The Get-VpnFailoverEventLogs function retrieves event log entries from the "Application" log where the source is "Switch-VpnFailover".

    .PARAMETER StartTime
    The start time for filtering event logs. Only events after this time will be retrieved. Default is 7 days ago.

    .PARAMETER EndTime
    The end time for filtering event logs. Only events before this time will be retrieved. Default is the current time.

    .INPUTS
    None. This function does not accept pipeline input.

    .OUTPUTS
    System.Diagnostics.EventLogEntry. This function outputs event log entries.

    .EXAMPLE
    Get-VpnFailoverEventLogs
    Retrieves all event logs created by the Switch-VpnFailover function in the past 7 days.

    .EXAMPLE
    Get-VpnFailoverEventLogs -StartTime (Get-Date).AddDays(-1)
    Retrieves event logs created by the Switch-VpnFailover function in the past day.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Specify the start time for filtering event logs.")]
        [DateTime]$StartTime = (Get-Date).AddDays(-7),

        [Parameter(Mandatory = $false, HelpMessage = "Specify the end time for filtering event logs.")]
        [DateTime]$EndTime = (Get-Date)
    )

    process {
        try {
            # Get event logs from the Application log with the source "Switch-VpnFailover"
            Get-EventLog -LogName Application -Source "Switch-VpnFailover" |
            Where-Object { $_.TimeGenerated -ge $StartTime -and $_.TimeGenerated -le $EndTime }
        }
        catch {
            Write-Error "Failed to retrieve event logs: $_"
        }
    }
}

# Example usage:
# Get-VpnFailoverEventLogs
# Get-VpnFailoverEventLogs -StartTime (Get-Date).AddDays(-1)
