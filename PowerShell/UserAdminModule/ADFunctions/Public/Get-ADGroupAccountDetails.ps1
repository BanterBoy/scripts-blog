<#
.SYNOPSIS
Retrieves account details for members of an Active Directory group.

.DESCRIPTION
The Get-ADGroupAccountDetails function retrieves account details for members of an Active Directory group. It returns a list of objects containing information such as name, display name, account status, password details, and group membership.

.PARAMETER GroupName
Specifies the name of the Active Directory group. The default value is 'Domain Admins'.

.PARAMETER PassDetails
Indicates whether to include password details in the output. By default, password details are not included.

.EXAMPLE
Get-ADGroupAccountDetails -GroupName 'Domain Admins'

This example retrieves account details for members of the 'Domain Admins' group.

.EXAMPLE
Get-ADGroupAccountDetails -GroupName 'Help Desk' -PassDetails

This example retrieves account details for members of the 'Help Desk' group and includes password details in the output.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject[]
The function returns an array of PSCustomObject objects, each representing an account and its details.

.NOTES
This function requires the Active Directory module to be installed. Make sure you have the necessary permissions to retrieve account details.

.LINK
https://docs.microsoft.com/en-us/powershell/module/activedirectory

#>
#requires -PSEdition Desktop

function Get-ADGroupAccountDetails {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Mandatory = $false)]
        [String]
        $GroupName = 'Domain Admins',
        [Parameter(Mandatory = $false)]
        [Switch]
        $PassDetails
    )
    BEGIN { }
    PROCESS {
        $adminAccounts = Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Properties *
        $adminAccountsData = $adminAccounts | ForEach-Object {
            $passwordAge = if ($_.PasswordLastSet) {
                ((Get-Date) - $_.PasswordLastSet).Days
            }
            $accountExpirationDate = if ($_.AccountExpirationDate) {
                $_.AccountExpirationDate
            }
            $lastLogonDate = if ($_.LastLogonDate) {
                $_.LastLogonDate
            }
            $groups = if ($_.MemberOf) { $_.MemberOf | ForEach-Object { (Get-ADGroup $_).Name } }
            $adminAccount = [PSCustomObject]@{
                Name                  = $_.Name
                DisplayName           = $_.DisplayName
                SamAccountName        = $_.SamAccountName
                Description           = $_.Description
                Enabled               = [bool]$_.Enabled
                PasswordNeverExpires  = $_.PasswordNeverExpires
                PasswordLastSet       = $_.PasswordLastSet
                PasswordAge           = $passwordAge
                AccountExpirationDate = $accountExpirationDate
                LastLogonDate         = $lastLogonDate
                Groups                = $groups -join ', '
            }
            $adminAccount  # output the object to be collected in $adminAccountsData
        }
        if ($PassDetails) {
            $adminAccountsData | Select-Object -Property Name, SamAccountName, Enabled, PasswordNeverExpires, PasswordLastSet, PasswordAge
        }
        else {
            $adminAccountsData
        }
    }
        
    END { }
}
