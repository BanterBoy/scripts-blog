---
layout: post
title: Test-ContactEmail.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-ContactEmail/
categories:
  - UserAdminModule
  - Testing
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

Checks for the existence of a mail contact in both on-premises Exchange and Exchange Online.

#### Detailed Description

This function takes an email address as input and searches for a corresponding mail contact in both on-premises Exchange and Exchange Online. If a contact is found, it returns detailed information about the contact.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Test-ContactEmail -EmailAddress "user@example.com" -Verbose
```

Checks for the existence of a mail contact with the specified email address.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30 HelpUri: http://scripts.lukeleigh.com/

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Checks for the existence of a mail contact in both on-premises Exchange and Exchange Online.

.DESCRIPTION
    This function takes an email address as input and searches for a corresponding mail contact in both on-premises Exchange and Exchange Online. If a contact is found, it returns detailed information about the contact.

.PARAMETER EmailAddress
    The email address to check.

.EXAMPLE
    PS C:\> Test-ContactEmail -EmailAddress "user@example.com" -Verbose
    Checks for the existence of a mail contact with the specified email address.

.NOTES
    Author: Your Name
    Date: 2024-06-30
    HelpUri: http://scripts.lukeleigh.com/
#>

function Test-ContactEmail {
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')
    ]
    [OutputType([psobject])]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the email address to check.'
        )]
        [string]$EmailAddress
    )

    begin {
        Write-Verbose "Initializing the Test-ContactEmail function."
    }

    process {
        if ($PSCmdlet.ShouldProcess("Check email address '$EmailAddress'", "Search for mail contact")) {
            $results = @()
            Write-Verbose "Searching for mail contact with email address '$EmailAddress'."

            # Search for on-premises mail contact
            try {
                Write-Verbose "Attempting to retrieve on-premises mail contact."
                $Contact = Get-MailContact -Anr $EmailAddress -ErrorAction Stop
                if ($Contact) {
                    Write-Verbose "On-premises mail contact found."
                    $properties = [ordered]@{
                        Name                          = $Contact.Name
                        DisplayName                   = $Contact.DisplayName
                        Alias                         = $Contact.Alias
                        Email                         = $Contact.PrimarySmtpAddress
                        Type                          = $Contact.RecipientType
                        AddressListMembership         = $Contact.AddressListMembership
                        EmailAddresses                = $Contact.EmailAddresses
                        ExternalEmailAddress          = $Contact.ExternalEmailAddress
                        HiddenFromAddressListsEnabled = $Contact.HiddenFromAddressListsEnabled
                        PrimarySmtpAddress            = $Contact.PrimarySmtpAddress
                        WindowsEmailAddress           = $Contact.WindowsEmailAddress
                    }
                    $obj = New-Object PSObject -Property $properties
                    $results += $obj
                }
            }
            catch {
                Write-Error "Failed to retrieve on-premises mail contact: $_"
            }

            # Search for Exchange Online mail contact
            try {
                Write-Verbose "Attempting to retrieve Exchange Online mail contact."
                $EXOContact = Get-EXORecipient -Identity $EmailAddress -ErrorAction Stop
                if ($EXOContact) {
                    Write-Verbose "Exchange Online mail contact found."
                    $properties = [ordered]@{
                        Name           = $EXOContact.Name
                        DisplayName    = $EXOContact.DisplayName
                        Alias          = $EXOContact.Alias
                        Email          = $EXOContact.PrimarySmtpAddress
                        Type           = $EXOContact.RecipientType
                        EmailAddresses = $EXOContact.EmailAddresses
                        TypeDetails    = $EXOContact.RecipientTypeDetails
                    }
                    $obj = New-Object PSObject -Property $properties
                    $results += $obj
                }
            }
            catch {
                Write-Error "Failed to retrieve Exchange Online mail contact: $($_.Error.Message)"
            }

            if ($results.Count -eq 0) {
                Write-Warning "No mail contact found for email address '$EmailAddress'"
            }
            else {
                Write-Output $results
            }
        }
    }

    end {
        Write-Verbose "Test-ContactEmail function completed."
    }
}

# Example call to the function with verbose output
# Test-ContactEmail -EmailAddress "user@example.com" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-ContactEmail.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ContactEmail.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

