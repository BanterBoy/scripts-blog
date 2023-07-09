function Disable-RDPRemotely {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName
    )
    foreach ($Computer in $ComputerName) {
        # Disable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 0; ModifyFirewallException = 0 } -ComputerName $Computer
        }
        # Disable RDP using WMI
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(0, 0)
        }
    }
}
