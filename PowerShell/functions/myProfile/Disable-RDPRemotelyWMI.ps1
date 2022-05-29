function Disable-RDPRemotelyWMI {
    # You can also disable it using the below method.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        $tsobj.SetAllowTSConnections(0, 0)
    }
}
