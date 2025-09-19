<#
.SYNOPSIS
Enables Remote Desktop Protocol (RDP) on one or more remote computers.

.DESCRIPTION
The Enable-RDPRemotely function enables Remote Desktop Protocol (RDP) on one or more remote computers. It uses CIM (Common Information Model) to enable RDP on computers running PowerShell version 6 or later, and WMI (Windows Management Instrumentation) for older versions of PowerShell.

.PARAMETER ComputerName
Specifies the name of the computer(s) on which to enable RDP. This parameter accepts an array of strings, allowing you to specify multiple computer names.

.EXAMPLE
Enable-RDPRemotely -ComputerName 'Computer01', 'Computer02'
Enables RDP on the computers named 'Computer01' and 'Computer02'.

.EXAMPLE
'Computer01', 'Computer02' | Enable-RDPRemotely
Enables RDP on the computers named 'Computer01' and 'Computer02' using pipeline input.

.INPUTS
System.String

.OUTPUTS
System.String

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0
#>
function Enable-RDPRemotely {
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
        # Enable RDP using CIM
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
            $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = 1; ModifyFirewallException = 1 } -ComputerName $Computer
        }
        # Enable RDP using CIM
        else {
            $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
            $tsobj.SetAllowTSConnections(1, 1)
        }
    }
}
