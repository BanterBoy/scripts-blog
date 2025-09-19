<#
.SYNOPSIS
    Retrieves detailed information and distribution group memberships for a specified mail contact.

.DESCRIPTION
    The Get-MailContactDetails function takes a specific email address as input and retrieves
    detailed information about the corresponding mail contact, including their distribution group memberships.
    It validates the email format, fetches the mail contact and underlying contact object, and lists all
    distribution groups the contact is a member of.

.PARAMETER ContactEmail
    The email address of the mail contact to retrieve details for. This parameter is mandatory.

.EXAMPLE
    Get-MailContactDetails -ContactEmail "jeff.jefferty@example.com"
    Retrieves detailed information for the mail contact with the specified email address.

.EXAMPLE
    Get-MailContactDetails -ContactEmail "unknown@example.com"
    Returns an error if the specified email address is not found or is invalid.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Get-MailContactDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ContactEmail
    )

    # Validate the email address format
    if ($ContactEmail -notmatch '^[\w\.-]+@[\w\.-]+\.\w{2,}$') {
        Write-Error "Invalid email address format: $ContactEmail"
        return
    }

    # Get the mail contact
    $mailContact = Get-MailContact -Identity $ContactEmail -ErrorAction SilentlyContinue

    if ($null -eq $mailContact) {
        Write-Error "Mail contact with email address $ContactEmail not found."
        return
    }

    # Get the underlying contact object
    $contact = Get-Contact -Identity $ContactEmail | Select-Object -Property *

    # Get the distribution groups the contact is a member of
    $groups = Get-DistributionGroup -ResultSize Unlimited | Where-Object {
        (Get-DistributionGroupMember -Identity $_.Identity | Where-Object { $_.PrimarySmtpAddress -eq $ContactEmail })
    }

    $groupNames = $groups | Select-Object -ExpandProperty Name -Unique

    # Create a custom object with the contact's detailed information and group memberships
    $contactDetails = [PSCustomObject]@{
        DisplayName          = $mailContact.DisplayName
        EmailAddress         = $mailContact.PrimarySmtpAddress
        Alias                = $mailContact.Alias
        FirstName            = $contact.FirstName
        LastName             = $contact.LastName
        ExternalEmailAddress = $mailContact.ExternalEmailAddress
        OrganizationalUnit   = $mailContact.OrganizationalUnit
        DistinguishedName    = $mailContact.DistinguishedName
        Title                = $contact.Title
        Department           = $contact.Department
        Company              = $contact.Company
        StreetAddress        = $contact.StreetAddress
        City                 = $contact.City
        StateOrProvince      = $contact.StateOrProvince
        PostalCode           = $contact.PostalCode
        CountryOrRegion      = $contact.CountryOrRegion
        Phone                = $contact.Phone
        Fax                  = $contact.Fax
        HomePhone            = $contact.HomePhone
        MobilePhone          = $contact.MobilePhone
        Pager                = $contact.Pager
        Notes                = $contact.Notes
        Groups               = $groupNames -join ";"
    }

    return $contactDetails
}
