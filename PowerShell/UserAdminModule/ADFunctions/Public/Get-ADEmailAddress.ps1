<#
.SYNOPSIS
Searches Active Directory for user accounts based on email address.

.DESCRIPTION
The Get-ADEmailAddress function searches Active Directory for user accounts based on the provided email address. It supports wildcard matching and returns the object properties of matching accounts.

.PARAMETER EmailAddress
Specifies the email address to search for. Wildcards are supported.

.EXAMPLE
Get-ADEmailAddress -EmailAddress john.doe@example.com
Searches Active Directory for user accounts with the email address "john.doe@example.com" and returns their object properties.

.EXAMPLE
Get-ADEmailAddress -EmailAddress *@example.com
Searches Active Directory for user accounts with email addresses ending with "@example.com" and returns their object properties.

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0

.LINK
https://link-to-documentation

#>
function Get-ADEmailAddress {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the AD object EmailAddress. This will return all accounts that match the entered value. Wildcards are supported.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$EmailAddress
    )
    BEGIN { }

    PROCESS {
        if ($PSCmdlet.ShouldProcess("$($EmailAddress)", "searching AD for user details.")) {
            try {
                Get-ADObject -Filter ' mail -like "$($EmailAddress)" ' -Properties * | Select-Object -Property DistinguishedName, ObjectClass, Name, mail
            }
            catch {
                Write-Error -Message "$_"
            }
        }
    }
}

# function to search all attributes of an AD User or Contact object for an email address and return the object properties if found
