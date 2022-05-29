function Enable-RDPRemotelyWMI {
    # You can enable RDP on a remote host by simply running the below two lines.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
        $tsobj.SetAllowTSConnections(1, 1)
    }
}
