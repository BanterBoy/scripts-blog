function Invoke-RemoteComputerShutdown {
<#
    .SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation on a remote computer.

    .DESCRIPTION
    Wraps the native Windows shutdown.exe command to remotely schedule shutdown, restart, or hibernate actions.
    Supports force and abort options. Uses Invoke-Command for remote execution.

    .PARAMETER ComputerName
    The name of the remote computer to target.

    .PARAMETER Action
    The action to perform: Shutdown, Restart, or Hibernate.

    .PARAMETER Timeout
    The delay in seconds before the action is executed (0-315360000).

    .PARAMETER Comment
    A comment describing the reason for the action.

    .PARAMETER Force
    Forces running applications to close.

    .PARAMETER Abort
    Cancels a scheduled shutdown/restart/hibernate.

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Shutdown" -Timeout 60 -Comment "Maintenance window" -Force

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Action "Restart" -Timeout 120

    .EXAMPLE
    Invoke-RemoteComputerShutdown -ComputerName "SRV01" -Abort

    .NOTES
    Requires administrative privileges and remote access permissions.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action,

        [Parameter(Position = 2)]
        [ValidateRange(0, 315360000)]
        [int]$Timeout = 30,

        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Comment = "Scheduled by PowerShell",

        [switch]$Force,

        [switch]$Abort
    )

    switch ($Action) {
        "Shutdown" { $actionParam = "/s" }
        "Restart" { $actionParam = "/r" }
        "Hibernate" { $actionParam = "/h" }
    }

    $forceParam = if ($Force) { "/f" } else { "" }

    $cmd = "shutdown.exe /m \\$ComputerName $actionParam /t $Timeout /c `"$Comment`" $forceParam"

    if ($Abort) {
        $cmd = "shutdown.exe /m \\$ComputerName /a"
    }

    if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Action: $Action", "Command: $cmd")) {
        try {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock { param($command) & cmd /c $command } -ArgumentList $cmd -ErrorAction Stop
            Write-Output "Action '$Action' scheduled on $ComputerName successfully."
        }
        catch {
            Write-Error "Failed to schedule action '$Action' on $ComputerName. Error: $($_.Exception.Message)"
            if ($_.Exception.InnerException) {
                Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
            }
        }
    }
}
