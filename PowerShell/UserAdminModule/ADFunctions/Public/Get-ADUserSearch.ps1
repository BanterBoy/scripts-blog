<#
.SYNOPSIS
    Searches Active Directory for a user by LoginName, DisplayName, EmailAddress, or proxyAddress and returns user properties, group membership, direct reports, and manager.

.DESCRIPTION
    The Get-ADUserSearch function searches Active Directory for a user based on the provided parameters: SamAccountName, DisplayName, UserPrincipalName, proxyAddress, or EmailAddress. It retrieves the user's properties and group membership as a PSObject.

.PARAMETER SamAccountName
    Specifies the SamAccountName of the user to search for. This parameter supports wildcards and can accept multiple values.

.PARAMETER DisplayName
    Specifies the DisplayName of the user to search for. This parameter supports wildcards and can accept multiple values.

.PARAMETER UserPrincipalName
    Specifies the UserPrincipalName of the user to search for. This parameter supports wildcards and can accept multiple values.

.PARAMETER proxyAddress
    Specifies the proxyAddress of the user to search for. This parameter supports wildcards and can accept multiple values.

.PARAMETER EmailAddress
    Specifies the email address of the user to search for. This parameter supports wildcards and can accept multiple values.

.PARAMETER PasswordDetailsOnly
    Specifies whether to retrieve only password-related details for the user accounts. If this switch is used, the function 
    will only return the SamAccountName, PasswordAgeDays, PasswordLastSet, PasswordExpired, PasswordNeverExpires, PasswordNotRequired, and AccountExpirationDate properties.

.EXAMPLE
    Get-ADUserSearch -SamAccountName "john.doe"
    Searches for the AD object with the SamAccountName "john.doe" and returns the object properties if found.

.EXAMPLE
    Get-ADUserSearch -DisplayName "John Doe"
    Searches for the AD object with the DisplayName "John Doe" and returns the object properties if found.

.EXAMPLE
    Get-ADUserSearch -UserPrincipalName "john.doe@example.com"
    Searches for the AD object with the UserPrincipalName "john.doe@example.com" and returns the object properties if found.

.EXAMPLE
    Get-ADUserSearch -proxyAddress "john.doe@example.com"
    Searches for the AD object with the proxyAddress "john.doe@example.com" and returns the object properties if found.

.EXAMPLE
    Get-ADUserSearch -EmailAddress "*@example.com"
    Searches for the AD objects with email addresses ending with "@example.com" and returns the object properties if found.

.EXAMPLE
    Get-ADUserSearch -SamAccountName "john.doe" -PasswordDetailsOnly
    Searches for the AD object with the SamAccountName "john.doe" and returns only password-related details if found.

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSCustomObject

.NOTES
    Author: Your Name
    Date: Today's Date
    Version: 1.0

.LINK
    https://link-to-your-documentation

#>

function Get-ADUserSearch {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object SamAccountName. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$SamAccountName,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object DisplayName. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$DisplayName,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object UserPrincipalName. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserPrincipalName,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object proxyAddress. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$proxyAddress,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object EmailAddress. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$EmailAddress,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specify this switch to output only password-related details.')]
        [switch]$PasswordDetailsOnly
    )

    BEGIN {
        Write-Verbose "Starting Get-ADUserSearch function"
        $filter = @()
    }

    PROCESS {
        if ($SamAccountName) {
            $filter += "SamAccountName -like '$SamAccountName'"
            Write-Verbose "Filtering by SamAccountName: $SamAccountName"
        }
        if ($DisplayName) {
            $filter += "DisplayName -like '$DisplayName'"
            Write-Verbose "Filtering by DisplayName: $DisplayName"
        }
        if ($UserPrincipalName) {
            $filter += "UserPrincipalName -like '$UserPrincipalName'"
            Write-Verbose "Filtering by UserPrincipalName: $UserPrincipalName"
        }
        if ($proxyAddress) {
            $filter += "proxyAddresses -like '*$proxyAddress*'"
            Write-Verbose "Filtering by proxyAddress: $proxyAddress"
        }
        if ($EmailAddress) {
            $filter += "EmailAddress -like '$EmailAddress'"
            Write-Verbose "Filtering by EmailAddress: $EmailAddress"
        }

        $filterString = $filter -join ' -or '
        Write-Verbose "Constructed filter: $filterString"

        try {
            Write-Verbose "Retrieving users from Active Directory with filter: $filterString"
            $users = Get-ADUser -Filter $filterString -Properties * -ErrorAction Stop
            Write-Verbose "Retrieved $($users.Count) users"
        }
        catch {
            Write-Error -Message $_.Exception.Message
            return
        }

        foreach ($user in $users) {
            try {
                if ($PasswordDetailsOnly) {
                    $output = [PSCustomObject]@{
                        SamAccountName        = $user.SamAccountName
                        PasswordAgeDays       = if ($user.PasswordLastSet) { [math]::Round((New-TimeSpan -Start $user.PasswordLastSet -End (Get-Date)).TotalDays, 2) } else { $null }
                        PasswordLastSet       = $user.PasswordLastSet
                        PasswordExpired       = $user.PasswordExpired
                        PasswordNeverExpires  = $user.PasswordNeverExpires
                        PasswordNotRequired   = $user.PasswordNotRequired
                        AccountExpirationDate = $user.AccountExpirationDate
                        Enabled               = [bool]$user.Enabled
                    }
                    $output.PSObject.TypeNames.Insert(0, 'Custom.ADUserPasswordDetails')
                }
                else {
                    $managerDisplayNames = if ($user.Manager) {
                        $user.Manager | Where-Object { $_ } | ForEach-Object {
                            (Get-ADUser -Identity $_ -Properties DisplayName).DisplayName
                        }
                    }
                    $directReportsDisplayNames = if ($user.directReports) {
                        $user.directReports | ForEach-Object {
                            (Get-ADUser -Identity $_ -Properties DisplayName).DisplayName
                        }
                    }
                    $memberOfGroupNames = if ($user.MemberOf) {
                        $user.MemberOf | ForEach-Object {
                            (Get-ADGroup -Identity $_).Name
                        }
                    }

                    $passwordStatus = @{
                        PasswordAgeDays      = if ($user.PasswordLastSet) { [math]::Round((New-TimeSpan -Start $user.PasswordLastSet -End (Get-Date)).TotalDays, 2) } else { $null }
                        PasswordExpired      = $user.PasswordExpired
                        PasswordNeverExpires = $user.PasswordNeverExpires
                        PasswordNotRequired  = $user.PasswordNotRequired
                    }

                    $output = [PSCustomObject]@{
                        SamAccountName             = $user.SamAccountName
                        GivenName                  = $user.GivenName
                        Surname                    = $user.Surname
                        DisplayName                = $user.DisplayName
                        EmployeeID                 = $user.EmployeeID
                        Description                = $user.Description
                        Title                      = $user.Title
                        Company                    = $user.Company
                        Department                 = $user.Department
                        departmentNumber           = $user.departmentNumber
                        Office                     = $user.Office
                        physicalDeliveryOfficeName = $user.physicalDeliveryOfficeName
                        StreetAddress              = $user.StreetAddress
                        City                       = $user.City
                        State                      = $user.State
                        Country                    = $user.Country
                        PostalCode                 = $user.PostalCode
                        extensionAttribute         = $user.extensionAttribute
                        Manager                    = $managerDisplayNames
                        distinguishedName          = $user.distinguishedName
                        HomePhone                  = $user.HomePhone
                        OfficePhone                = $user.OfficePhone
                        MobilePhone                = $user.MobilePhone
                        Fax                        = $user.Fax
                        mail                       = $user.mail
                        mailNickname               = $user.mailNickname
                        EmailAddress               = $user.EmailAddress
                        UserPrincipalName          = $user.UserPrincipalName
                        proxyAddresses             = $user.proxyAddresses
                        HomePage                   = $user.HomePage
                        ProfilePath                = $user.ProfilePath
                        HomeDirectory              = $user.HomeDirectory
                        HomeDrive                  = $user.HomeDrive
                        ScriptPath                 = $user.ScriptPath
                        AccountExpirationDate      = $user.AccountExpirationDate
                        PasswordLastSet            = $user.PasswordLastSet
                        LockedOut                  = $user.LockedOut
                        Enabled                    = [bool]$user.Enabled
                        directReports              = $directReportsDisplayNames
                        MemberOf                   = $memberOfGroupNames
                        PasswordStatus             = $passwordStatus
                    }
                    $output.PSObject.TypeNames.Insert(0, 'Custom.ADUserDetails')
                }

                Write-Output $output
            }
            catch {
                Write-Error -Message "Failed to process user '$($user.SamAccountName)'. Error: $_"
            }
        }
    }

    END {
        Write-Verbose "Completed Get-ADUserSearch function"
    }
}

# Update-FormatData -PrependPath "$PSScriptRoot\Get-ADUserSearch.UserDetails.Format.ps1xml"
# Update-FormatData -PrependPath "$PSScriptRoot\Get-ADUserSearch.PasswordDetails.Format.ps1xml"
