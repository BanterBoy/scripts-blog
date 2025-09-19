<#
.SYNOPSIS
Retrieves user details from the Microsoft Graph API.

.DESCRIPTION
The Get-MgUserDetails function retrieves user details from the Microsoft Graph API based on the specified parameters. It can retrieve users by name, get admins only, or get all users (enabled, disabled, or both) based on the provided filters.

.PARAMETER UserPrincipalName
Specifies the user principal name(s) of the user(s) to retrieve. This parameter accepts a single user principal name or an array of user principal names.

.PARAMETER enabled
Specifies whether to retrieve enabled users, disabled users, or both. Valid values are "true" (enabled users), "false" (disabled users), or "both" (both enabled and disabled users).

.PARAMETER adminsOnly
Specifies whether to retrieve only admin users. If this parameter is set to $true, only admin users will be retrieved.

.PARAMETER IsLicensed
Specifies whether to retrieve only licensed users. If this parameter is set to $true, only licensed users will be retrieved.

.EXAMPLE
Get-MgUserDetails -UserPrincipalName "john.doe@example.com"
Retrieves the user details for the user with the specified user principal name.

.EXAMPLE
Get-MgUserDetails -enabled "true"
Retrieves the details of all enabled users.

.EXAMPLE
Get-MgUserDetails -enabled "false"
Retrieves the details of all disabled users.

.EXAMPLE
Get-MgUserDetails -enabled "both"
Retrieves the details of all users, regardless of their enabled status.

.EXAMPLE
Get-MgUserDetails -adminsOnly $true
Retrieves the details of all admin users.

.EXAMPLE
Get-MgUserDetails -IsLicensed $true
Retrieves the details of all licensed users.

.OUTPUTS
System.Management.Automation.PSCustomObject[]
The function returns an array of custom objects representing the user details. Each object contains the following properties:
- id: The unique identifier of the user.
- DisplayName: The display name of the user.
- userprincipalname: The user principal name of the user.
- mail: The email address of the user.
- AssignedLicenses: An array of assigned licenses for the user.

.NOTES
This function requires the Microsoft Graph PowerShell module to be installed. You can install it by running the following command:
Install-Module -Name Microsoft.Graph

.LINK
https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0&tabs=http
#>
Function Get-MgUserDetails {
    param (
        [string]$UserPrincipalName,
        [string]$enabled,
        [bool]$adminsOnly,
        [bool]$IsLicensed
    )

    process {
        # Set the properties to retrieve
        $select = @(
            'id',
            'DisplayName',
            'userprincipalname',
            'mail'
        )

        $properties = $select + "AssignedLicenses"

        # Get enabled, disabled or both users
        switch ($enabled) {
            "true" { $filter = "AccountEnabled eq true and UserType eq 'member'" }
            "false" { $filter = "AccountEnabled eq false and UserType eq 'member'" }
            "both" { $filter = "UserType eq 'member'" }
        }
    
        # Check if UserPrincipalName(s) are given
        if ($UserPrincipalName) {
            Write-Output "Get users by name"

            $users = @()
            foreach ($user in $UserPrincipalName) {
                try {
                    $users += Get-MgUser -UserId $user -Property $properties | Select-Object -Property $select -ErrorAction Stop
                }
                catch {
                    [PSCustomObject]@{
                        DisplayName       = " - Not found"
                        UserPrincipalName = $User
                        isAdmin           = $null
                        MFAEnabled        = $null
                    }
                }
            }
        }
        elseif ($adminsOnly) {
            Write-Output "Get admins only"

            $users = @()
            foreach ($admin in $admins) {
                $users += Get-MgUser -UserId $admin.UserPrincipalName -Property $properties | Select-Object $select
            }
        }
        else {
            if ($IsLicensed) {
                # Get only licensed users
                $users = Get-MgUser -Filter $filter -Property $properties -all | Where-Object { ($_.AssignedLicenses).count -gt 0 } | Select-Object $select
            }
            else {
                $users = Get-MgUser -Filter $filter -Property $properties -all | Select-Object $select
            }
        }
        return $users
    }
}