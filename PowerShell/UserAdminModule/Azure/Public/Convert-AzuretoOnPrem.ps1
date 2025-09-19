<#
.SYNOPSIS
Converts Azure AD users to on-premises AD users.

.DESCRIPTION
This script converts Azure AD users to on-premises AD users by performing the following steps:
1. Retrieves the Azure AD user based on the provided UserPrincipalName.
2. Converts the Azure AD user to an on-premises AD user.
3. Creates the on-premises AD user.
4. Exports the on-premises AD user details.
5. Sets the ImmutableId of the Azure AD user to match the ObjectGuid of the on-premises AD user.

.PARAMETER AzureADUser
Specifies the UserPrincipalName for the Azure AD account to be converted. This parameter is mandatory.

.PARAMETER AccountPassword
Specifies the password for the converted Azure AD account. This parameter is optional and defaults to 'ThisIsMyPassword.1234'.

.EXAMPLE
Convert-AzuretoOnPrem -AzureADUser "john.doe@contoso.com" -AccountPassword (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)

This example converts the Azure AD user with the UserPrincipalName "john.doe@contoso.com" to an on-premises AD user with the specified account password.

.NOTES
This script requires the AzureAD module to be imported.

.LINK
https://docs.microsoft.com/en-us/powershell/module/azuread/
#>
function Convert-AzuretoOnPrem {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the Azure Account to be converted.'
        )]
        [string[]]$AzureADUser,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a password for the converted Azure Account or pipe input. This is not a mandatory field and defaults to ThisIsMyPassword.1234'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $AccountPassword = (New-Object System.Management.Automation.PSCredential 'dummy', (ConvertTo-SecureString -String 'ThisIsMyPassword.1234' -AsPlainText -Force))
    )

    begin {
        Import-Module AzureAD
    }

    process {
        
        $users = Get-AzureADUser -ObjectId $AzureADUser
        foreach ($user in $users) {
            if ($PSCmdlet.ShouldProcess("$User", "Convertion of Azure AD user to on-premises AD user")) {
                $adUser = ConvertTo-ADUser -AzureADUser $user -AccountPassword $AccountPassword
                New-OnPremADUser -ADUser $adUser
                Export-ADUser -ADUser $adUser
                Set-AzureADUserImmutableId -AzureADUser $user -ADUser $adUser
            }
        }
    }

    end {
        Write-Output "Script completed."
    }
}

<#
.SYNOPSIS
Converts an Azure AD user to an on-premises AD user.

.DESCRIPTION
This function takes an Azure AD user object and converts it to an on-premises AD user object by mapping the properties.

.PARAMETER AzureADUser
Specifies the Azure AD user object to be converted. This parameter is mandatory.

.PARAMETER AccountPassword
Specifies the password for the on-premises AD user. This parameter is mandatory.

.OUTPUTS
Returns a hashtable containing the mapped properties of the on-premises AD user.

.EXAMPLE
$azureADUser = Get-AzureADUser -ObjectId "john.doe@contoso.com"
$accountPassword = ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force
$adUser = ConvertTo-ADUser -AzureADUser $azureADUser -AccountPassword $accountPassword

This example converts the specified Azure AD user to an on-premises AD user and assigns the result to the $adUser variable.
#>
function ConvertTo-ADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Open.AzureAD.Model.User]$AzureADUser,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$AccountPassword
    )

    $samAccountName = $AzureADUser.GivenName + "." + $AzureADUser.Surname

    $params = @{
        Name                 = $samAccountName
        SamAccountName       = $samAccountName
        GivenName            = $AzureADUser.GivenName
        Surname              = $AzureADUser.Surname
        City                 = $AzureADUser.City
        Department           = $AzureADUser.Department
        DisplayName          = $AzureADUser.DisplayName
        Fax                  = $AzureADUser.Fax
        MobilePhone          = $AzureADUser.Mobile
        Office               = $AzureADUser.OfficeLocation
        PasswordNeverExpires = [bool]$AzureADUser.PasswordNeverExpires
        OfficePhone          = $AzureADUser.PhoneNumber
        PostalCode           = $AzureADUser.PostalCode
        EmailAddress         = $AzureADUser.UserPrincipalName
        State                = $AzureADUser.State
        StreetAddress        = $AzureADUser.StreetAddress
        Title                = $AzureADUser.JobTitle
        UserPrincipalName    = $AzureADUser.UserPrincipalName
        AccountPassword      = $AccountPassword
        Enabled              = $true
    }

    return $params
}

<#
.SYNOPSIS
Creates an on-premises AD user.

.DESCRIPTION
This function creates an on-premises AD user based on the provided hashtable of user properties.

.PARAMETER ADUser
Specifies the hashtable containing the properties of the on-premises AD user. This parameter is mandatory.

.EXAMPLE
$adUser = @{
    Name            = "John Doe"
    SamAccountName  = "johndoe"
    GivenName       = "John"
    Surname         = "Doe"
    City            = "New York"
    Department      = "IT"
    DisplayName     = "John Doe"
    Fax             = "123456789"
    MobilePhone     = "987654321"
    Office          = "Building A"
    PasswordNeverExpires = $true
    OfficePhone     = "555-1234"
    PostalCode      = "12345"
    EmailAddress    = "john.doe@contoso.com"
    State           = "NY"
    StreetAddress   = "123 Main St"
    Title           = "Engineer"
    UserPrincipalName = "johndoe@contoso.com"
    AccountPassword = (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)
    Enabled         = $true
}
New-OnPremADUser -ADUser $adUser

This example creates an on-premises AD user with the specified properties.
#>
function New-OnPremADUser {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [Hashtable]$ADUser
    )

    if ($PSCmdlet.ShouldProcess($ADUser.UserPrincipalName, "Create on-premises AD user")) {
        Write-Verbose "Creating on-premises AD user: $($ADUser.SamAccountName)"
        New-ADUser @ADUser
    }
}

<#
.SYNOPSIS
Exports the on-premises AD user details.

.DESCRIPTION
This function exports the details of the on-premises AD user to a file using the ldifde.exe command.

.PARAMETER ADUser
Specifies the hashtable containing the properties of the on-premises AD user. This parameter is mandatory.

.EXAMPLE
$adUser = @{
    Name            = "John Doe"
    SamAccountName  = "johndoe"
    GivenName       = "John"
    Surname         = "Doe"
    City            = "New York"
    Department      = "IT"
    DisplayName     = "John Doe"
    Fax             = "123456789"
    MobilePhone     = "987654321"
    Office          = "Building A"
    PasswordNeverExpires = $true
    OfficePhone     = "555-1234"
    PostalCode      = "12345"
    EmailAddress    = "john.doe@contoso.com"
    State           = "NY"
    StreetAddress   = "123 Main St"
    Title           = "Engineer"
    UserPrincipalName = "johndoe@contoso.com"
    AccountPassword = (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)
    Enabled         = $true
}
Export-ADUser -ADUser $adUser

This example exports the details of the specified on-premises AD user.
#>
function Export-ADUser {
    param (
        [Parameter(Mandatory = $true)]
        [Hashtable]$ADUser
    )

    $ldifdeCommand = "ldifde.exe -f $($Env:TEMP)\ExportAllUser.txt -r ""(UserPrincipalname=$($ADUser.UserPrincipalName))"" -l ""ObjectGuid,UserPrincipalName"""
    Start-Process -FilePath $ldifdeCommand -Wait -NoNewWindow
}

<#
.SYNOPSIS
Sets the ImmutableId of an Azure AD user.

.DESCRIPTION
This function sets the ImmutableId of an Azure AD user to match the ObjectGuid of the on-premises AD user.

.PARAMETER AzureADUser
Specifies the Azure AD user object. This parameter is mandatory.

.PARAMETER ADUser
Specifies the hashtable containing the properties of the on-premises AD user. This parameter is mandatory.

.EXAMPLE
$azureADUser = Get-AzureADUser -ObjectId "john.doe@contoso.com"
$adUser = @{
    Name            = "John Doe"
    SamAccountName  = "johndoe"
    GivenName       = "John"
    Surname         = "Doe"
    City            = "New York"
    Department      = "IT"
    DisplayName     = "John Doe"
    Fax             = "123456789"
    MobilePhone     = "987654321"
    Office          = "Building A"
    PasswordNeverExpires = $true
    OfficePhone     = "555-1234"
    PostalCode      = "12345"
    EmailAddress    = "john.doe@contoso.com"
    State           = "NY"
    StreetAddress   = "123 Main St"
    Title           = "Engineer"
    UserPrincipalName = "johndoe@contoso.com"
    AccountPassword = (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)
    Enabled         = $true
}
Set-AzureADUserImmutableId -AzureADUser $azureADUser -ADUser $adUser

This example sets the ImmutableId of the specified Azure AD user to match the ObjectGuid of the on-premises AD user.
#>
function Set-AzureADUserImmutableId {
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Open.AzureAD.Model.User]$AzureADUser,

        [Parameter(Mandatory = $true)]
        [Hashtable]$ADUser
    )

    Set-AzureADUser -ObjectId $AzureADUser.ObjectId -ImmutableId $ADUser.ObjectGuid
}
