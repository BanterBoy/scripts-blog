---
layout: post
title: Get-MailContactDetails.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/get-mailcontactdetails/
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Retrieves detailed information and distribution group memberships for a specified mail contact.

#### Detailed Description

The Get-MailContactDetails function takes a specific email address as input and retrieves detailed information about the corresponding mail contact, including their distribution group memberships. It validates the email format, fetches the mail contact and underlying contact object, and lists all distribution groups the contact is a member of.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-MailContactDetails -ContactEmail "jeff.jefferty@example.com"
```

Retrieves detailed information for the mail contact with the specified email address.

**Example 2**

```powershell
Get-MailContactDetails -ContactEmail "unknown@example.com"
```

Returns an error if the specified email address is not found or is invalid.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-MailContactDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MailContactDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

