---
layout: post
title: New-O365Contact.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-O365Contact/
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

Creates new contacts in Office 365 or Exchange On-Premises from email addresses.

#### Detailed Description

The `New-O365Contact` function creates new mail contacts in Office 365 or Exchange On-Premises using the provided email addresses. It parses the email address to create values for Name, DisplayName, and Alias, and uses the New-MailContact cmdlet to create the contact. The function accepts piped input and handles errors gracefully, returning custom error messages.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Example 1: Create a new contact from an email address
```

PS C:\> New-O365Contact -EmailAddress "john.doe@example.com"

**Example 2**

```powershell
# Example 2: Create multiple contacts from a CSV file
```

PS C:\> Import-Csv -Path "C:\Contacts.csv" | New-O365Contact

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

The function works with both Office 365 and Exchange On-Premises.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates new contacts in Office 365 or Exchange On-Premises from email addresses.

.DESCRIPTION
The `New-O365Contact` function creates new mail contacts in Office 365 or Exchange On-Premises using the provided email addresses. It parses the email address to create values for Name, DisplayName, and Alias, and uses the New-MailContact cmdlet to create the contact. The function accepts piped input and handles errors gracefully, returning custom error messages.

.PARAMETER EmailAddress
The email address for the new contact. This parameter is mandatory and accepts input from the pipeline.

.EXAMPLE
# Example 1: Create a new contact from an email address
PS C:\> New-O365Contact -EmailAddress "john.doe@example.com"

.EXAMPLE
# Example 2: Create multiple contacts from a CSV file
PS C:\> Import-Csv -Path "C:\Contacts.csv" | New-O365Contact

.NOTES
Author: Your Name
Date: Today's Date

The function works with both Office 365 and Exchange On-Premises.
#>

function New-O365Contact {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern('^[\w\.\-]+@[\w\.\-]+\.[a-zA-Z]{2,}$', ErrorMessage = "Invalid email address format.")]
        [string]$EmailAddress
    )

    process {
        try {
            # Parse the email address
            $Name = $EmailAddress.Split('@')[0]
            $DisplayName = $Name
            $Alias = $Name

            # Create the new mail contact
            $Contact = New-MailContact -Name $Name -DisplayName $DisplayName -Alias $Alias -ExternalEmailAddress $EmailAddress -ErrorAction Stop
            
            # Return the new contact object
            $Contact
        }
        catch {
            # Return custom error message
            $errorMsg = "Failed to create contact for $EmailAddress. Error: $_"
            Write-Error -Message $errorMsg
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/New-O365Contact.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-O365Contact.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

