<#
.SYNOPSIS
Searches Active Directory for user or contact objects based on email address.

.DESCRIPTION
The Get-ADObjectAddress function searches Active Directory for user or contact objects that match the specified email address. It supports wildcards in the email address and returns the object properties if a match is found.

.PARAMETER EmailAddress
Specifies the email address to search for. Wildcards are supported. If not specified, all user or contact objects will be returned.

.EXAMPLE
Get-ADObjectAddress -EmailAddress "john.doe@example.com"
Searches Active Directory for user or contact objects with the email address "john.doe@example.com" and returns their properties.

.EXAMPLE
Get-ADObjectAddress -EmailAddress "*@example.com"
Searches Active Directory for user or contact objects with email addresses ending with "@example.com" and returns their properties.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns a custom object with the following properties:
- Name: The name of the user or contact object.
- mail: The primary email address of the user or contact object.
- proxyAddresses: The proxy email addresses associated with the user or contact object.
- DistinguishedName: The distinguished name (DN) of the user or contact object.
- ObjectClass: The object class of the user or contact object.
- whenCreated: The date and time when the user or contact object was created.
- whenChanged: The date and time when the user or contact object was last modified.

.NOTES
This function requires the Active Directory module to be installed. If the module is not available, the function will fail.

.LINK
https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adobject

#>

function Get-ADObjectAddress {
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
                foreach ($Address in $EmailAddress) {
                    Get-ADObject -Properties * -Filter "mail -like '*$address*' -or proxyAddresses -like '*$address*'" | Select-Object -Property Name, mail, proxyAddresses, DistinguishedName, ObjectClass, whenCreated, whenChanged
                }
            }
            catch {
                Write-Error -Message "$_"
            }
        }
    }
}

# function to search all attributes of an AD User or Contact object for an email address and return the object properties if found
