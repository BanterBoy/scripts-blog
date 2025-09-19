function Wait-RemoteComputerShutdown {
    <#
    .SYNOPSIS
    Monitors remote computers and reports when each has shut down (stops responding to ping).

    .DESCRIPTION
    Accepts computer names via pipeline or array. Pings each computer until it stops responding, then reports shutdown.

    .PARAMETER Name
    The name(s) of the remote computer(s) to monitor. Accepts pipeline input.

    .EXAMPLE
    'PC1','PC2','PC3' | Wait-RemoteComputerShutdown
    Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Wait-RemoteComputerShutdown

    .NOTES
    Requires network connectivity and appropriate permissions.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory, Position=0)]
        [Alias('ComputerName')]
        [string[]]$Name
    )

    process {
        foreach ($computer in $Name) {
            Write-Host "Monitoring $computer for shutdown..."
            while (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
                Write-Host "$computer is still online..."
                Start-Sleep -Seconds 2
            }
            Write-Host "$computer has shut down (no longer responding to ping)."
        }
    }
}
