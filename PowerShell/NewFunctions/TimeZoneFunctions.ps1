function Set-ServerTimeZone {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            Invoke-Command -ComputerName $Computer -ScriptBlock { 
                Set-TimeZone -Id "GMT Standard Time"
            }
        }
    }
}


function Get-ServerTimeZone {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            Invoke-Command -ComputerName $Computer -ScriptBlock { 
                Get-TimeZone
            }
        }
    }
}
