function Restart-ProjectComputer {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('rpc')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string]
        $ComputerName,

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
    
    begin {

    }

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Process restart request")) {

            if ($Credential) {
                Restart-Computer -ComputerName $ComputerName -Credential $Credential -Force
                do {
                    Test-Connection -ComputerName $ComputerName Continuous -TimeoutSeconds 5 | Select-Object -Property Ping, Source, Destination, Address, Status
                } while (
                    $_.Status -ne "Success"
                )
            }
            else {
                Restart-Computer -ComputerName $ComputerName -Force
                do {
                    Test-Connection -ComputerName $ComputerName Continuous -TimeoutSeconds 5 | Select-Object -Property Ping, Source, Destination, Address, Status
                } while (
                    $_.Status -ne "Success"
                )
            }
        }
    }

    end {

    }

}
