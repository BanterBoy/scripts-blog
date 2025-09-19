function Start-RemoteComputerShutdownSchedule {
    <#
    .SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation on a remote computer at a specific time.

    .DESCRIPTION
    Calculates the timeout required for shutdown.exe based on the desired shutdown time, then calls Invoke-RemoteComputerShutdown.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .PARAMETER ShutdownTime
    The date and time when the action should occur.

    .PARAMETER Action
    The action to perform: Shutdown, Restart, or Hibernate.

    .PARAMETER Comment
    A comment describing the reason for the action.

    .PARAMETER Force
    Forces running applications to close.

    .EXAMPLE
    Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime (Get-Date).AddMinutes(30) -Action "Shutdown" -Comment "End of day shutdown" -Force

    .EXAMPLE
    Start-RemoteComputerShutdownSchedule -ComputerName "SRV01" -ShutdownTime "2025-09-01 23:00" -Action "Restart"

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [datetime]$ShutdownTime,

        [Parameter()]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action = "Shutdown",

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Comment = "Scheduled by PowerShell",

        [switch]$Force
    )

    $currentDateTime = Get-Date
    $timeDifference = [int]($ShutdownTime - $currentDateTime).TotalSeconds

    if ($timeDifference -le 0) {
        Write-Error "The specified time has already passed. Please specify a future time."
        return
    }
    if ($timeDifference -gt 315360000) {
        Write-Error "Timeout exceeds maximum allowed by shutdown.exe (315360000 seconds)."
        return
    }

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: $Action at $ShutdownTime")) {
        try {
            Invoke-RemoteComputerShutdown -ComputerName $ComputerName -Action $Action -Timeout $timeDifference -Comment $Comment -Force:$Force
        }
        catch {
            Write-Error "Failed to schedule shutdown on $ComputerName. Error: $($_.Exception.Message)"
        }
    }
}
