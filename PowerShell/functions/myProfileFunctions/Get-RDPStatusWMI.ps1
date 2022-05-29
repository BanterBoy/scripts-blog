function Get-RDPStatusWMI {
    # Do you care to check if it is currently enabled or disabled before acting? Use the below code.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        if ($tsobj.AllowTSConnections -eq '1') {
            Write-Output "RDP Enabled"
        }
        if ($tsobj.AllowTSConnections -eq '0') {
            Write-Output "RDP Disabled"
        }
    } 
}
