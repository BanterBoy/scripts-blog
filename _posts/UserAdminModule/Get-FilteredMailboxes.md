---
layout: post
title: Get-FilteredMailboxes.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-FilteredMailboxes/
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

This function retrieves mailboxes based on provided search and email address filter.

#### Detailed Description

The Get-FilteredMailboxes function retrieves mailboxes from the Exchange server. If a search parameter is provided, it retrieves only those mailboxes whose display name matches the search parameter. Otherwise, it retrieves all mailboxes. It then filters the email addresses of these mailboxes based on the provided email address filter. The function returns a custom PowerShell object with mailbox details and filtered email addresses.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-FilteredMailboxes -Search "John Doe" -EmailAddressFilter "@company.com"
```

This example retrieves all mailboxes whose display name includes "John Doe" and filters their email addresses to include only those that contain "@company.com".

**Example 2**

```powershell
Get-FilteredMailboxes -Search "John*" -EmailAddressFilter "*@company.com"
```

This example retrieves all mailboxes whose display name starts with "John" and filters their email addresses to include only those that end with "@company.com".

**Example 3**

```powershell
Get-FilteredMailboxes -EmailAddressFilter "*@company.com"
```

This example retrieves all mailboxes and filters their email addresses to include only those that end with "@company.com".

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
This function retrieves mailboxes based on provided search and email address filter.

.DESCRIPTION
The Get-FilteredMailboxes function retrieves mailboxes from the Exchange server. 
If a search parameter is provided, it retrieves only those mailboxes whose display name matches the search parameter.
Otherwise, it retrieves all mailboxes. 
It then filters the email addresses of these mailboxes based on the provided email address filter.
The function returns a custom PowerShell object with mailbox details and filtered email addresses.

.PARAMETER Search
The search parameter used to filter mailboxes by display name. If not provided, all mailboxes are retrieved.
This parameter supports wildcard search, for example, you can use "John*" to search for all mailboxes whose names start with "John".

.PARAMETER EmailAddressFilter
The filter used to filter the email addresses of the retrieved mailboxes. 
This parameter supports wildcard search, for example, you can use "*@company.com" to filter for all email addresses from the domain "company.com".

.EXAMPLE
Get-FilteredMailboxes -Search "John Doe" -EmailAddressFilter "@company.com"
This example retrieves all mailboxes whose display name includes "John Doe" and filters their email addresses to include only those that contain "@company.com".

.EXAMPLE
Get-FilteredMailboxes -Search "John*" -EmailAddressFilter "*@company.com"
This example retrieves all mailboxes whose display name starts with "John" and filters their email addresses to include only those that end with "@company.com".

.EXAMPLE
Get-FilteredMailboxes -EmailAddressFilter "*@company.com"
This example retrieves all mailboxes and filters their email addresses to include only those that end with "@company.com".
#>
function Get-FilteredMailboxes {
    Param(
        [string]$Search,  # Search parameter for filtering mailboxes by display name
        [string]$EmailAddressFilter  # Filter for filtering email addresses of mailboxes
    )
    # If no search parameter is provided, retrieve all mailboxes
    if ([string]::IsNullOrEmpty($Search)) {
        $mailboxes = Get-Mailbox -ResultSize Unlimited
    } else {
        # If a search parameter is provided, retrieve only those mailboxes whose display name matches the search parameter
        $mailboxes = Get-Mailbox -Filter "DisplayName -like '*$Search*'" -ResultSize Unlimited
    }
    # For each mailbox, filter the email addresses based on the provided email address filter
    $mailboxes | ForEach-Object {
        $mailbox = $_
        $emailAddresses = [ordered]@{}
        $index = 1
        $mailbox.EmailAddresses | Where-Object { $_ -like "*$EmailAddressFilter*" } | ForEach-Object {
            $emailAddresses["EmailAddress$index"] = $_
            $index++
        }
        # If there are any filtered email addresses, create a custom PowerShell object with mailbox details and filtered email addresses
        if ($emailAddresses.Count -gt 0) {
            $output = [ordered]@{
                Name = $contact.Name
                FirstName = $contact.FirstName
                LastName = $contact.LastName
                DisplayName = $contact.DisplayName
                Alias = $contact.Alias
                RecipientType = $contact.RecipientType
                PrimarySmtpAddress = $contact.PrimarySmtpAddress
                ExternalEmailAddress = $mailbox.ExternalEmailAddress
                WindowsEmailAddress = $mailbox.PrimarySmtpAddress
            } + $emailAddresses
            [PSCustomObject]$output
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-FilteredMailboxes.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FilteredMailboxes.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

