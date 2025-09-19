# Function: Set-RDPStatus
Function Set-RDPStatus {
    <#
    .SYNOPSIS
    Enables or disables RDP on specified computers.

    .DESCRIPTION
    Configures the RDP settings on specified computers using CIM/WMI methods.

    .PARAMETER ComputerName
    Name or IP address of the computer(s) to configure.

    .PARAMETER Enable
    Switch to enable RDP. If not specified, RDP will be disabled.

    .EXAMPLE
    Set-RDPStatus -ComputerName "DANTOOINE" -Enable

    .EXAMPLE
    Set-RDPStatus -ComputerName "DANTOOINE"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $false)]
        [switch]$Enable
    )

    foreach ($Computer in $ComputerName) {
        try {
            $Settings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Settings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{ AllowTSConnections = [int]$Enable; ModifyFirewallException = [int]$Enable } -ComputerName $Computer
            Write-Output "$($Computer): RDP $($Enable ? 'enabled' : 'disabled')."
        } catch {
            Write-Warning "Failed to set RDP status on $($Computer): $_"
        }
    }
}

