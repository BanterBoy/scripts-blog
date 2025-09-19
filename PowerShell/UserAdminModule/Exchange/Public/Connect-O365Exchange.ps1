Function Connect-O365Exchange {

    <#

    .SYNOPSIS
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication.
	
	.DESCRIPTION
    Connect-O365Exchange - A function to connect to Office 365 Exchange Online using Modern Authentication. This function will import the ExchangeOnlineManagement module and connect to Exchange Online using the credentials of the user named in UserName. If UserName is left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.PARAMETER UserName
    [string]UserName - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
	.EXAMPLE
    Connect-O365Exchange -UserName "lukeleigh.admin"

    Connects using the account named in UserName
	
	.EXAMPLE
    Connect-O365Exchange

    Connects using the environment variable $Env:USERNAME
    
	.EXAMPLE
    ex365 -UserName "lukeleigh"

    Using the command alias, this command connects using the account named in UserName
	
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
		
    - UserName [string] - Enter a username with permissions to Office 365. If left blank it will try to use the default account for the powershell session, using the '$env:USERNAME' environment variable.
	
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

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to Office 365 e.g. "lukeleigh.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [string]$UserName = $env:USERNAME
    )
    
    begin {

    }
    
    process {
        if ($PSCmdlet.ShouldProcess($UserName, "Connecting to Exchange Online as")) {

            Import-Module ExchangeOnlineManagement
            Connect-ExchangeOnline -UserPrincipalName (Get-ADUser -Identity $UserName).UserPrincipalName -ShowBanner:$false

        }
    }

    end {

    }
}
