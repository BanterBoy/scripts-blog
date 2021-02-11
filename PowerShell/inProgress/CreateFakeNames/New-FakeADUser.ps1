function New-FakeADUser {

    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
        .INPUTS
        Inputs (if any)
        .OUTPUTS
        Output (if any)
        .NOTES
        General notes
        #>
        
    [CmdletBinding(
        SupportsShouldProcess = $true,
        DefaultParameterSetName = "Default")]
    param (
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $Name,
            
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $Title,
    
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $GivenName,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $Surname,
        
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $DisplayName,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $SamAccountName,

        
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $StreetAddress,
        
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $State,
            
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $City,
            
        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $Country,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $PostalCode,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $UserPrincipalName,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $Path,

        # Parameter help description
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter your"
        )]
        [string]
        $AccountPassword
            
    )
            
    begin {
                
    }
    
    process {

        $userUserSettings = @{
            Name                  = $_.Name
            Title                 = $_.Title
            GivenName             = $_.GivenName
            Surname               = $_.Surname
            DisplayName           = $_.DisplayName
            SamAccountName        = $_.SamAccountName
            UserPrincipalName     = $_.UserPrincipalName
            StreetAddress         = $_.StreetAddress
            State                 = $_.State
            City                  = $_.City
            Country               = $_.Country
            PostalCode            = $_.PostalCode
            AccountPassword       = (ConvertTo-SecureString -String $AccountPassword -AsPlainText -Force)
            Enabled               = $true
            ChangePasswordAtLogon = $true
            Path                  = $_.Path
        }
        
        New-ADUser @userUserSettings -verbose
        
    }
        
    end {
        
    }
}
