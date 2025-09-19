<#
.SYNOPSIS
Disables Remote Desktop Protocol (RDP) on remote computers.

.DESCRIPTION
The Disable-RDPRemotely function disables Remote Desktop Protocol (RDP) on one or more remote computers. It uses either CIM or WMI to perform the operation, depending on the version of PowerShell.

.PARAMETER ComputerName
Specifies the name of the computer(s) on which to disable RDP. This parameter accepts an array of strings, allowing you to specify multiple computer names.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.String. The function returns a string indicating the success or failure of the operation.

.NOTES
- This function requires administrative privileges on the remote computers.
- If the computer is running PowerShell version 6 or later, CIM is used to disable RDP. Otherwise, WMI is used.
- For more information, visit the help URI: http://scripts.lukeleigh.com/

.EXAMPLE
Disable-RDPRemotely -ComputerName 'Server01', 'Server02'
Disables RDP on the computers 'Server01' and 'Server02'.

.EXAMPLE
'Desktop01', 'Desktop02' | Disable-RDPRemotely
Disables RDP on the computers 'Desktop01' and 'Desktop02' using pipeline input.

#>
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
