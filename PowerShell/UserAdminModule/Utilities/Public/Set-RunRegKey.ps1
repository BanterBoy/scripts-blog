function Set-RunRegKey {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        supportsShouldProcess = $true,
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
        $Credential,
        [Parameter(Mandatory = $true)]
        [string]$KeyName,
        [Parameter(Mandatory = $true)]
        [string]$KeyValue
    )

    $scriptBlock = {
        param($KeyName, $KeyValue)
        $path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        Set-ItemProperty -Path $path -Name $KeyName -Value $KeyValue
    }

    foreach ($Computer in $ComputerName) {
        if ($Credential) {
            Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $scriptBlock -ArgumentList $KeyName, $KeyValue
        } else {
            Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock -ArgumentList $KeyName, $KeyValue
        }
    }
}
