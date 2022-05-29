function Enable-RDPRemotelyCIM {
    # You can enable RDP on a remote host by simply running the below two lines.
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($Computer in $ComputerName) {
        $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
        $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections=1;ModifyFirewallException=1} -ComputerName $Computer
    }

}