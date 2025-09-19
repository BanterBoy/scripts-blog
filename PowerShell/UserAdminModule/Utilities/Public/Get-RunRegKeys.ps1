<#
.SYNOPSIS
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path.

.DESCRIPTION
The Get-RunRegKeys function retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified computer(s). It can be used to check the programs that are set to run automatically when the computer starts up.

.PARAMETER ComputerName
Specifies the name(s) of the computer(s) to retrieve the registry keys from. If not specified, the function will use the local computer.

.PARAMETER Credential
Specifies the credentials to use when connecting to remote computers. This parameter is optional.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.String
The function outputs the registry keys as strings.

.EXAMPLE
Get-RunRegKeys
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the local computer.

.EXAMPLE
Get-RunRegKeys -ComputerName 'Server01', 'Server02' -Credential $cred
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified remote computers using the specified credentials.

.LINK
https://github.com/BanterBoy

#>
function Get-RunRegKeys {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy'
    )]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $scriptBlock = {
        $path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        Get-ItemProperty -Path $path
    }

    foreach ($Computer in $ComputerName) {
        if ($Credential) {
            Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $scriptBlock
        }
        else {
            Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock
        }
    }
}
