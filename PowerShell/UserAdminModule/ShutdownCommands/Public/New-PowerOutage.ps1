function New-PowerOutage {

    <#
    .SYNOPSIS
    Shuts down a computer or a list of computers and optionally monitors virtual machines until they are stopped.

    .DESCRIPTION
    The New-PowerOutage function shuts down a computer or a list of computers and optionally monitors virtual machines until all are stopped. 
    If the -Report switch is specified, the function will monitor virtual machines until they are stopped before shutting down the computer. 
    The function checks if the computer is online before shutting it down and waits for the computer to shut down before completing.

    .PARAMETER ComputerName
    Enter the Name/IP/FQDN of the computer you would like to shut down, or pipe in a list of computers.

    .PARAMETER Report
    If specified, the function will monitor virtual machines until all are stopped before shutting down the computer.

    .EXAMPLE
    New-PowerOutage -ComputerName "Computer01" -Report
    Shuts down "Computer01" and monitors virtual machines until all are stopped.

    .EXAMPLE
    "Computer01", "Computer02" | New-PowerOutage
    Shuts down "Computer01" and "Computer02".

    .NOTES
    Author: Luke Leigh/Github Copilot
    Date: 2023-09-20
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to shut down, or pipe in a list of computers.'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(
            HelpMessage = 'Monitor virtual machines until all are stopped before shutting down the computer.'
        )]
        [switch]$Report
    )

    begin {
        Write-Verbose "Starting power outage..."
    }

    process {
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess($Computer, "Shut down")) {
                try {
                    # Check if the computer is online
                    Write-Verbose "Checking if $Computer is online..."
                    $ComputerState = Test-Connection -ComputerName $Computer -Count 1 -Quiet
                    if (-not $ComputerState) {
                        Write-Error "$Computer is offline."
                        continue
                    }

                    if ($Report) {
                        Write-Verbose "Monitoring virtual machines on $Computer..."
                        # Monitor virtual machines until all are stopped
                        do {
                            $VirtualMachineState = Get-VM -ComputerName $Computer | Select-Object Name, State
                            $RunningVMs = $VirtualMachineState | Where-Object { $_.State -eq "Running" }
                            if ($RunningVMs) {
                                Get-VM -ComputerName $Computer | Stop-VM -Force
                                Write-Verbose "Running VMs on {$Computer}:"
                                $RunningVMs | Format-Table -AutoSize
                                Start-Sleep -Seconds 5
                            }
                        } until (-not $RunningVMs)
                    }

                    # Shut down the computer
                    Write-Verbose "Shutting down $Computer..."
                    Stop-Computer -ComputerName $Computer -Force

                    # Wait for the computer to shut down
                    Write-Verbose "Waiting for $Computer to shut down..."
                    do {
                        $ComputerState = Test-Connection -ComputerName $Computer -Count 1 -Quiet
                        Start-Sleep -Seconds 5
                    } until (-not $ComputerState)
                }
                catch {
                    Write-Error "Failed to shut down $Computer. Error: $_"
                }
                finally {
                    Write-Verbose "Power outage process for $Computer complete."
                }
            }
        }
    }

    end {
        Write-Verbose "Power outage operation complete."
    }
}
