function Restart-ExchangeServices {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
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
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Restarting Exchange Services")) {

                $Session = New-PsSession -ComputerName $Computer -Credential $Credential
                $Command = {
                    $Services = Get-Service | Where-Object -FilterScript { $_.Name -like "MSExchange*" -and $_.Status -eq "Running" }
                    foreach ($Service in $Services) {
                        Restart-Service $Service.name -Force
                    }
                }
                Invoke-Command -Session $Session -ScriptBlock $Command
            }
        }
    }

    end {
    }

}
