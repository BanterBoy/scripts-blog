function New-MSTeamsPhone {

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
            Position = 0,
            HelpMessage = 'Enter your credentials or pipe input.'
        )]
        [Alias('creds')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter a the UserPrincipalName for the account to be configured or pipe input.'
        )]
        [string]$UserPrincipalName,
        
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2,
            HelpMessage = 'Enter the full telephone number or pipe input. (e.g. +442048418255)'
        )]
        [string]$PhoneNumber
    )
    
    begin {
        Import-Module MicrosoftTeams
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Configuring MSTeams phone assignment")) {

            try {
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -EnterpriseVoiceEnabled:$true
                Set-CsPhoneNumberAssignment -Identity $UserPrincipalName -PhoneNumber $PhoneNumber -PhoneNumberType DirectRouting
                Grant-CsOnlineVoiceRoutingPolicy -Identity $UserPrincipalName -PolicyName "VRPolicy"
            }
            catch {
                Write-Error -Message $_
            }
            finally {
                Get-CsOnlineUser -Identity $UserPrincipalName | Select-Object -Property DisplayName, DialPlan, EnterpriseVoiceEnabled, FeatureTypes, LineUri, UserPrincipalName
            }
        }
    }

    end {}

}
