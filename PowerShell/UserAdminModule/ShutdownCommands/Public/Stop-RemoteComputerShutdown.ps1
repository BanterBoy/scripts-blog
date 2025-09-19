function Stop-RemoteComputerShutdown {
    <#
    .SYNOPSIS
    Cancels a scheduled shutdown, restart, or hibernate operation on a remote computer.

    .DESCRIPTION
    Wraps shutdown.exe /a to abort any pending shutdown, restart, or hibernate action on the target computer.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .EXAMPLE
    Stop-RemoteComputerShutdown -ComputerName "SRV01"

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName
    )

    $cmd = "shutdown.exe /m \\$ComputerName /a"

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: Cancel Scheduled Shutdown/Restart/Hibernate")) {
        try {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock { param($command) & cmd /c $command } -ArgumentList $cmd -ErrorAction Stop
            Write-Output "Scheduled shutdown/restart/hibernate on $ComputerName has been canceled successfully."
        }
        catch {
            Write-Error "Failed to cancel the scheduled action on $ComputerName. Error: $($_.Exception.Message)"
            if ($_.Exception.InnerException) {
                Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
            }
        }
    }
}
