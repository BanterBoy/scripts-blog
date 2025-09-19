function Get-MSTeamsPhone {

    <#
    .SYNOPSIS
        Install-RequiredModules - Tests to see if scripts/function required modules are available.
    .DESCRIPTION
        Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .EXAMPLE
        PS C:\> Install-RequiredModules
        Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .INPUTS
        None.
    .OUTPUTS
        [String] Outputs details of installation, importing and failure.
    .NOTES
        Author	: Luke Leigh
        Website	: https://blog.lukeleigh.com
        Twitter	: https://twitter.com/luke_leighs
        GitHub  : https://github.com/BanterBoy

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    Param
    (

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [string]$UserPrincipalName

    )
    
    begin {
        Import-Module MicrosoftTeams
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Getting MSTeams phone assignment")) {

            try {
                $User = Get-CsOnlineUser -Identity $UserPrincipalName
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                Write-Output -InputObject $User | Select-Object -Property DisplayName, DialPlan, EnterpriseVoiceEnabled, FeatureTypes, LineUri, UserPrincipalName                
            }

        }

    }

    end {}

}
