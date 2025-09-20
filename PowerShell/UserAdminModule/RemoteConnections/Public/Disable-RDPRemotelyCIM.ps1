function Disable-RDPRemotelyCIM {
    # You can also disable it using the below method.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
        $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections=0;ModifyFirewallException=0} -ComputerName $Computer
    }
}
