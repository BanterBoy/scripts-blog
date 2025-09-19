<#
.SYNOPSIS
    Creates a new mail contact object.

.DESCRIPTION
    The New-MailContactObject function creates a new PSCustomObject representing a mail contact with various attributes such as name, email address, and additional details like phone numbers, address, and more.

.PARAMETER Name
    The display name of the mail contact. This parameter is mandatory.

.PARAMETER EmailAddress
    The email address of the mail contact. This parameter is mandatory.

.PARAMETER Alias
    The alias of the mail contact.

.PARAMETER FirstName
    The first name of the mail contact.

.PARAMETER LastName
    The last name of the mail contact.

.PARAMETER ExternalEmailAddress
    The external email address of the mail contact.

.PARAMETER Title
    The title of the mail contact.

.PARAMETER Department
    The department of the mail contact.

.PARAMETER Company
    The company of the mail contact.

.PARAMETER StreetAddress
    The street address of the mail contact.

.PARAMETER City
    The city of the mail contact.

.PARAMETER StateOrProvince
    The state or province of the mail contact.

.PARAMETER PostalCode
    The postal code of the mail contact.

.PARAMETER CountryOrRegion
    The country or region of the mail contact.

.PARAMETER Phone
    The phone number of the mail contact.

.PARAMETER Fax
    The fax number of the mail contact.

.PARAMETER HomePhone
    The home phone number of the mail contact.

.PARAMETER MobilePhone
    The mobile phone number of the mail contact.

.PARAMETER Pager
    The pager number of the mail contact.

.PARAMETER Notes
    Additional notes about the mail contact.

.PARAMETER Groups
    The groups to which the mail contact belongs. Multiple groups can be specified as an array.

.EXAMPLE
    $contact = New-MailContactObject -Name "John Doe" -EmailAddress "john.doe@example.com" -Alias "jdoe" -FirstName "John" -LastName "Doe" -Title "Manager" -Department "Sales" -Company "Example Corp" -StreetAddress "123 Main St" -City "Anytown" -StateOrProvince "CA" -PostalCode "12345" -CountryOrRegion "USA" -Phone "555-555-5555" -MobilePhone "555-555-5556" -Notes "This is a sample contact."

    Creates a new mail contact object with the specified details and stores it in the $contact variable.

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function New-MailContactObject {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$EmailAddress,

        [Parameter(Mandatory = $false)]
        [string]$Alias,

        [Parameter(Mandatory = $false)]
        [string]$FirstName,

        [Parameter(Mandatory = $false)]
        [string]$LastName,

        [Parameter(Mandatory = $false)]
        [string]$ExternalEmailAddress,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        [string]$Department,

        [Parameter(Mandatory = $false)]
        [string]$Company,

        [Parameter(Mandatory = $false)]
        [string]$StreetAddress,

        [Parameter(Mandatory = $false)]
        [string]$City,

        [Parameter(Mandatory = $false)]
        [string]$StateOrProvince,

        [Parameter(Mandatory = $false)]
        [string]$PostalCode,

        [Parameter(Mandatory = $false)]
        [string]$CountryOrRegion,

        [Parameter(Mandatory = $false)]
        [string]$Phone,

        [Parameter(Mandatory = $false)]
        [string]$Fax,

        [Parameter(Mandatory = $false)]
        [string]$HomePhone,

        [Parameter(Mandatory = $false)]
        [string]$MobilePhone,

        [Parameter(Mandatory = $false)]
        [string]$Pager,

        [Parameter(Mandatory = $false)]
        [string]$Notes,

        [Parameter(Mandatory = $false)]
        [string[]]$Groups
    )

    # Create a PSCustomObject to hold the contact details
    $contactDetails = [PSCustomObject]@{
        DisplayName          = $Name
        EmailAddress         = $EmailAddress
        Alias                = $Alias
        FirstName            = $FirstName
        LastName             = $LastName
        ExternalEmailAddress = $ExternalEmailAddress
        Title                = $Title
        Department           = $Department
        Company              = $Company
        StreetAddress        = $StreetAddress
        City                 = $City
        StateOrProvince      = $StateOrProvince
        PostalCode           = $PostalCode
        CountryOrRegion      = $CountryOrRegion
        Phone                = $Phone
        Fax                  = $Fax
        HomePhone            = $HomePhone
        MobilePhone          = $MobilePhone
        Pager                = $Pager
        Notes                = $Notes
        Groups               = $Groups -join ";"
    }

    # Return the created contact details object
    return $contactDetails
}
