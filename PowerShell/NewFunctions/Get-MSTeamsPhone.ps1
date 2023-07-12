function Get-MSTeamsPhone {

    <#
    .SYNOPSIS
        Get-MSTeamsPhone
    .DESCRIPTION
        Get-MSTeamsPhone - 
    .EXAMPLE
        PS C:\> Get-MSTeamsPhone
        
    .INPUTS
        None.
    .OUTPUTS
        [String] 
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
    [Alias('gtp')]
    Param
    (

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [Alias('upn')]
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
