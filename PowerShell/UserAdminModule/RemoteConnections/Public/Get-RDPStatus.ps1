# Function: Get-RDPStatus
Function Get-RDPStatus {
    <#
    .SYNOPSIS
    Checks the RDP status on specified computers.

    .DESCRIPTION
    Retrieves the RDP configuration status from specified computers.

    .PARAMETER ComputerName
    Name or IP address of the computer(s) to check.

    .EXAMPLE
    Get-RDPStatus -ComputerName "DANTOOINE"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )

    foreach ($Computer in $ComputerName) {
        try {
            $Settings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            [pscustomobject]@{
                ComputerName = $Computer
                RDPStatus    = if ($Settings.AllowTSConnections -eq 1) { 'Enabled' } else { 'Disabled' }
            }
        } catch {
            Write-Warning "Failed to get RDP status on $($Computer): $_"
        }
    }
}
