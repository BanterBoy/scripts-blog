---
layout: post
title: Set-MailContactDetails.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-MailContactDetails/
categories:
  - UserAdminModule
  - Exchange
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-MailContactDetails {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ContactDetails,
        [switch]$UpdateExisting
    )

    # Get the existing contact
    $existingContact = Get-MailContact -Identity $ContactDetails.EmailAddress -ErrorAction SilentlyContinue

    if ($null -ne $existingContact) {
        if ($UpdateExisting) {
            Write-Output "Updating existing contact: $($ContactDetails.DisplayName)"

            # Helper function to update properties
            function Update-Property {
                param (
                    [string]$PropertyName,
                    [string]$NewValue,
                    [string]$CmdletName
                )

                $currentValue = $existingContact.$PropertyName
                if ($currentValue -ne $NewValue) {
                    $params = @{
                        Identity      = $ContactDetails.EmailAddress
                        $PropertyName = $NewValue
                    }
                    Write-Verbose "Updating $PropertyName to $NewValue using $CmdletName"
                    & $CmdletName @params
                    Write-Output "Updated $PropertyName to $NewValue"
                }
                else {
                    Write-Output "$PropertyName is already set to $NewValue. No update needed."
                }
            }

            # Update MailContact properties
            $mailContactProperties = @(
                "Alias", "ExternalEmailAddress", "DisplayName", "CustomAttribute1", "CustomAttribute2", "CustomAttribute3", 
                "CustomAttribute4", "CustomAttribute5", "CustomAttribute6", "CustomAttribute7", "CustomAttribute8", 
                "CustomAttribute9", "CustomAttribute10", "ExtensionCustomAttribute1", "ExtensionCustomAttribute2", 
                "ExtensionCustomAttribute3", "ExtensionCustomAttribute4", "ExtensionCustomAttribute5"
            )
            foreach ($prop in $mailContactProperties) {
                $newValue = $ContactDetails.$prop
                if (-not [string]::IsNullOrEmpty($newValue)) {
                    Update-Property -PropertyName $prop -NewValue $newValue -CmdletName "Set-MailContact"
                }
                else {
                    Write-Verbose "$prop is empty. No update needed."
                }
            }

            # Update Contact properties
            $contactProperties = @(
                "FirstName", "LastName", "Title", "Department", "Company", "StreetAddress", "City", "StateOrProvince", 
                "PostalCode", "CountryOrRegion", "Phone", "Fax", "HomePhone", "MobilePhone", "Pager", "Notes", 
                "AssistantName", "Initials", "Office", "TelephoneAssistant", "WebPage"
            )
            foreach ($prop in $contactProperties) {
                $newValue = $ContactDetails.$prop
                if (-not [string]::IsNullOrEmpty($newValue)) {
                    Update-Property -PropertyName $prop -NewValue $newValue -CmdletName "Set-Contact"
                }
                else {
                    Write-Verbose "$prop is empty. No update needed."
                }
            }

        }
        else {
            Write-Output "Mail contact with email address $($ContactDetails.EmailAddress) already exists in Exchange Online. No changes will be made."
            return
        }
    }
    else {
        # Create the mail contact in Exchange Online
        Write-Output "Creating new contact: $($ContactDetails.DisplayName)"
        New-MailContact -Name $ContactDetails.DisplayName -ExternalEmailAddress $ContactDetails.EmailAddress -DisplayName $ContactDetails.DisplayName

        # Set the mail contact details using Set-MailContact
        Set-MailContact -Identity $ContactDetails.EmailAddress `
            -DisplayName $ContactDetails.DisplayName `
            -Alias $ContactDetails.Alias `
            -ExternalEmailAddress $ContactDetails.ExternalEmailAddress

        # Set additional user/contact details using Set-Contact
        Set-Contact -Identity $ContactDetails.EmailAddress `
            -FirstName $ContactDetails.FirstName `
            -LastName $ContactDetails.LastName `
            -Title $ContactDetails.Title `
            -Department $ContactDetails.Department `
            -Company $ContactDetails.Company `
            -StreetAddress $ContactDetails.StreetAddress `
            -City $ContactDetails.City `
            -StateOrProvince $ContactDetails.StateOrProvince `
            -PostalCode $ContactDetails.PostalCode `
            -CountryOrRegion $ContactDetails.CountryOrRegion `
            -Phone $ContactDetails.Phone `
            -Fax $ContactDetails.Fax `
            -HomePhone $ContactDetails.HomePhone `
            -MobilePhone $ContactDetails.MobilePhone `
            -Pager $ContactDetails.Pager `
            -Notes $ContactDetails.Notes `
            -AssistantName $ContactDetails.AssistantName `
            -Initials $ContactDetails.Initials `
            -Office $ContactDetails.Office `
            -TelephoneAssistant $ContactDetails.TelephoneAssistant `
            -WebPage $ContactDetails.WebPage
    }

    Write-Output "Mail contact details created/updated successfully for $($ContactDetails.EmailAddress)."
}

# # Example usage
# $mailContactObject = New-Object -TypeName PSObject -Property @{
#     Identity = "jeff.jefferty@example.com"
#     Name = "Jeff Jefferty"
#     Alias = "JeffJefferty"
#     FirstName = "Jeff"
#     LastName = "Jefferty"
#     Title = "Chief Clown"
#     Department = "Clowns"
#     Company = "Clown Enterprises"
#     StreetAddress = "1 Jefferty Road"
#     City = "Jeff Ville"
#     StateOrProvince = "Jefferton"
#     PostalCode = "CL0 WN1"
#     CountryOrRegion = "GB"
#     Phone = "+44 12 1234 1234"
#     MobilePhone = "+44 1234 123456"
#     ExternalEmailAddress = "jeff.jefferty@example.com"
#     EmailAddress = "jeff.jefferty@example.com"
#     DisplayName = "Jeff Jefferty" # Ensure DisplayName is set
#     AssistantName = "Assistant Name"
#     Initials = "JJ"
#     Office = "Office 101"
#     TelephoneAssistant = "+44 12 3456 7890"
#     WebPage = "https://example.com"
#     Notes = "Notes about Jeff Jefferty"
# }

# Set-MailContactDetails -ContactDetails $mailContactObject -UpdateExisting -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Set-MailContactDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-MailContactDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

