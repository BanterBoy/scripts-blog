<#
.SYNOPSIS
Connects to the internal PRTG server.

.DESCRIPTION
The Connect-InternalPRTG function is used to establish a connection to the internal PRTG server. It takes the computer name(s) as input and connects to the server using the specified credentials.

.PARAMETER ComputerName
Specifies the name(s) of the computer(s) to connect to. This parameter supports pipeline input. If not specified, the function retrieves the computer names that match the filter '*PRTG*' from Active Directory.

.PARAMETER Credential
Specifies the credentials to use for the connection. This parameter is optional. If not specified, the function will use the current user's credentials.

.EXAMPLE
Connect-InternalPRTG -ComputerName 'PRTGServer01'

Connects to the PRTG server with the specified computer name 'PRTGServer01' using the current user's credentials.

.EXAMPLE
Get-ADComputer -Filter { Name -like '*PRTG*' } | Connect-InternalPRTG

Retrieves the computer names that match the filter '*PRTG*' from Active Directory and connects to each PRTG server using the current user's credentials.

#>
function Connect-InternalPRTG {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [ArgumentCompleter( {
                $Content = Get-ADComputer -Filter { Name -like '*PRTG*' }
                foreach ($Item in $Content) {
                    $Item.DNSHostName
                }
            }
        )]
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

        
    BEGIN {

    }
    PROCESS {
        foreach ($Computer in $ComputerName) {
            $Connection = "https://" + $Computer
            if (!(Get-PrtgClient)) {
                Connect-PrtgServer -Server $Connection -Credential $Credential -IgnoreSSL
            }
        }
        
    }
    END {

    }
}
