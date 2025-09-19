function New-FakeADUser {

    <#
    .SYNOPSIS
        Creates a new fake Active Directory user.
    
    .DESCRIPTION
        This function creates a new fake Active Directory user with the specified parameters.
    
    .EXAMPLE
        PS C:\> New-FakeADUser -Name "John Doe" -Title "Manager" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@contoso.com" -StreetAddress "123 Main St" -State "CA" -City "Los Angeles" -Country "USA" -PostalCode "90001" -AccountPassword "P@ssw0rd" -Path "OU=Users,DC=contoso,DC=com"
    
        This example creates a new fake Active Directory user with the specified parameters.
    
    .INPUTS
        None.
    
    .OUTPUTS
        None.
    
    .NOTES
        General notes about the function.
    #>
        
    [CmdletBinding(
        SupportsShouldProcess = $true,
        DefaultParameterSetName = "Default")]
    param (
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the name of the user."
        )]
        [string]
        $Name,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the title of the user."
        )]
        [string]
        $Title,
    
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the given name of the user."
        )]
        [string]
        $GivenName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the surname of the user."
        )]
        [string]
        $Surname,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the display name of the user."
        )]
        [string]
        $DisplayName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the SamAccountName of the user."
        )]
        [string]
        $SamAccountName,

        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the street address of the user."
        )]
        [string]
        $StreetAddress,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the state of the user."
        )]
        [string]
        $State,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the city of the user."
        )]
        [string]
        $City,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the country of the user."
        )]
        [string]
        $Country,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the postal code of the user."
        )]
        [string]
        $PostalCode,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the user principal name of the user."
        )]
        [string]
        $UserPrincipalName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the path of the user."
        )]
        [string]
        $Path,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the account password of the user."
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
