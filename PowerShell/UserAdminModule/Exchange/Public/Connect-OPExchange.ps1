Function Connect-OPExchange {

    <#

    .SYNOPSIS
    Connect-OPExchange - A function to connect to Exchange Server on premise.
	
	.DESCRIPTION
    Connect-OPExchange - A function to connect to Exchange Server on premise. This function will connect to a random server in the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site.
	
	.PARAMETER UserName
    [string]UserName - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.

    .PARAMETER ComputerName
    [string]ComputerName - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.
	
	.EXAMPLE
    Connect-OPExchange -UserName "username.admin" -ComputerName "exch01.domain.local"

    Connects using the account named in UserName and connects to the server named in ComputerName
	
	.EXAMPLE
    Connect-OPExchange -ComputerName "exch01.domain.local"

    Connects using the environment variable $Env:USERNAME and connects to the server named in ComputerName
    
	.EXAMPLE
    ex365 -UserName "lukeleigh" -ComputerName "exch01.domain.local"

    Using the command alias, this command connects using the account named in UserName and connects to the server named in ComputerName
	
	.OUTPUTS
    No output returned.
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
    You can pipe objects to these perameters.
    
    - UserName [string] - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.
    - ComputerName [string] - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.
	
	.LINK
    https://scripts.lukeleigh.com
    Import-Module
    Connect-ExchangeOnline

#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [string]$UserName = $env:USERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.')]
        [ArgumentCompleter( {
                $Exchange = Get-ExchangeServerInSite
                $Servers = Get-Random -InputObject $Exchange -Shuffle:$true
                foreach ($Server in $Servers) {
                    $Server.FQDN
                }
            }) ]
        [Alias('cn')]
        [string]$ComputerName
        
    )
    
    begin {

    }

    process {

        if ($PSCmdlet.ShouldProcess($ComputerName, "Creating Session for Exchange access")) {

            if ( (Test-OpenPorts -ComputerName $ComputerName -RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).Status -eq 'Open' ) {
                Import-Module -Name ConnectExchangeOnPrem
                Connect-ExchangeOnPrem -ComputerName $ComputerName -Credential $creds -Authentication Kerberos
                Write-Verbose "Exchange Session connected to : $ComputerName."
            }
            else {
                Write-Warning "Unable to connect to $ComputerName."
            }

        }

    }
    
    end {

    }

}
