function Set-RDPRemotely {
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
        $ComputerName,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            HelpMessage = 'Specify whether to enable or disable RDP.')]
        [ValidateSet('Enable', 'Disable')]
        [string]
        $State
    )

    begin {}

    process {
        foreach ($Computer in $ComputerName) {

            if ($PSCmdlet.ShouldProcess("$Computer", "Setting RDP to $State")) {
            
                # Get the remote computer's operating system version
                $OSVersion = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Computer).Version
            
                # Determine the appropriate method to use based on the operating system version
                if ([version]$OSVersion -ge [version]'6.0') {
                    # Enable or disable RDP using CIM
                    $Win32TerminalServiceSettings = Get-CimInstance -Namespace root/cimv2/TerminalServices -ClassName Win32_TerminalServiceSetting -ComputerName $Computer
                    $Win32TerminalServiceSettings | Invoke-CimMethod -MethodName SetAllowTSConnections -Arguments @{AllowTSConnections = ($State -eq 'Enable'); ModifyFirewallException = ($State -eq 'Enable') } -ComputerName $Computer
                }
                else {
                    # Enable or disable RDP using WMI
                    $tsobj = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace Root\CimV2\TerminalServices -ComputerName $Computer
                    $tsobj.SetAllowTSConnections(($State -eq 'Enable'), ($State -eq 'Enable'))
                }
                
                # Output the computer name and current state
                $RDPStatus = if ($State -eq 'Enable') { 'Enabled' } else { 'Disabled' }
                $OutputObject = [PSCustomObject]@{
                    ComputerName = $Computer
                    RDPStatus    = $RDPStatus
                }
                Write-Output $OutputObject
            }
        }
    }
    end {}
}