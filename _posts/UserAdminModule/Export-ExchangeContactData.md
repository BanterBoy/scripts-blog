---
layout: post
title: Export-ExchangeContactData.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Export-ExchangeContactData/
categories:
- UserAdminModule
- Exchange
tags:
- PowerShell
- User Admin Module
- Exchange Contact Data
- Exchange
description: Exports Exchange contact data to CSV files.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Exports Exchange contact data to CSV files.

#### Detailed Description

The Export-ExchangeContactData function exports Exchange contact data to individual CSV files and a complete list. It also exports distribution lists and their members to CSV files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Export-ExchangeContactData -OutputDirectory "C:\Temp\ExchangeDataExport" -DistributionListOU "OU=DistributionGroups,DC=yourdomain,DC=com" -Verbose
```

This example exports Exchange contact data to CSV files in the "C:\Temp\ExchangeDataExport" directory. It also exports distribution lists and their members from the specified OU.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Exports Exchange contact data to CSV files.

.DESCRIPTION
The Export-ExchangeContactData function exports Exchange contact data to individual CSV files and a complete list. It also exports distribution lists and their members to CSV files.

.PARAMETER OutputDirectory
The path to the directory where the exported CSV files will be saved.

.PARAMETER DistributionListOU
The Organizational Unit (OU) where the distribution groups are located.

.EXAMPLE
Export-ExchangeContactData -OutputDirectory "C:\Temp\ExchangeDataExport" -DistributionListOU "OU=DistributionGroups,DC=yourdomain,DC=com" -Verbose

This example exports Exchange contact data to CSV files in the "C:\Temp\ExchangeDataExport" directory. It also exports distribution lists and their members from the specified OU.

#>
function Export-ExchangeContactData {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory,

        [Parameter(Mandatory = $true)]
        [string]$DistributionListOU
    )

    # Ensure the output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -Path $OutputDirectory -ItemType Directory -Force
        Write-Verbose "Created output directory: $OutputDirectory"
    }

    # Define subdirectories
    $contactsDir = Join-Path -Path $OutputDirectory -ChildPath "contacts"
    $distlistsDir = Join-Path -Path $OutputDirectory -ChildPath "distlists"

    # Ensure subdirectories exist
    if (-not (Test-Path -Path $contactsDir)) {
        New-Item -Path $contactsDir -ItemType Directory -Force
        Write-Verbose "Created contacts directory: $contactsDir"
    }

    if (-not (Test-Path -Path $distlistsDir)) {
        New-Item -Path $distlistsDir -ItemType Directory -Force
        Write-Verbose "Created distribution lists directory: $distlistsDir"
    }

    # Export contacts
    Write-Verbose "Retrieving mail contacts..."
    $contacts = Get-MailContact -ResultSize Unlimited | Select-Object DisplayName, PrimarySmtpAddress, ExternalEmailAddress, Name, Alias, Company, Department, Title, FirstName, LastName, OrganizationalUnit
    $totalContacts = $contacts.Count
    $contactCounter = 0

    Write-Verbose "Exporting mail contacts to individual CSV files and a complete list..."
    foreach ($contact in $contacts) {
        $contactCounter++
        Write-Progress -Activity "Exporting Contacts" -Status "Processing contact $contactCounter of $totalContacts" -PercentComplete (($contactCounter / $totalContacts) * 100)

        # Replace spaces in contact names with underscores for the file name
        $contactFileName = $contact.DisplayName -replace ' ', '_'
        $contactFilePath = "$contactsDir\$contactFileName.csv"

        # Export individual contact to CSV
        [PSCustomObject]@{
            DisplayName = $contact.DisplayName
            PrimarySmtpAddress = $contact.PrimarySmtpAddress
            ExternalEmailAddress = $contact.ExternalEmailAddress
            Name = $contact.Name
            Alias = $contact.Alias
            Company = $contact.Company
            Department = $contact.Department
            Title = $contact.Title
            FirstName = $contact.FirstName
            LastName = $contact.LastName
            OrganizationalUnit = $contact.OrganizationalUnit
        } | Export-Csv -Path $contactFilePath -NoTypeInformation

        Write-Verbose "Exported contact $($contact.DisplayName) to $contactFilePath"
    }

    # Export all contacts to a single CSV file
    $allContactsFilePath = "$OutputDirectory\AllContacts.csv"
    $contacts | Select-Object DisplayName, PrimarySmtpAddress, ExternalEmailAddress, Name, Alias, Company, Department, Title, FirstName, LastName, OrganizationalUnit | Export-Csv -Path $allContactsFilePath -NoTypeInformation
    Write-Verbose "Exported all contacts to $allContactsFilePath"

    # Export distribution lists
    Write-Verbose "Retrieving distribution groups from OU: $DistributionListOU..."
    $distributionLists = Get-ADGroup -Filter {GroupCategory -eq 'Distribution' -and GroupScope -eq 'Universal'} -SearchBase $DistributionListOU
    $totalDLs = $distributionLists.Count
    $dlCounter = 0

    foreach ($dl in $distributionLists) {
        $dlCounter++
        Write-Progress -Activity "Exporting Distribution Lists" -Status "Processing $dlCounter of $totalDLs" -PercentComplete (($dlCounter / $totalDLs) * 100)

        Write-Verbose "Retrieving members of distribution group: $($dl.Name)"
        $members = Get-ADGroupMember -Identity $dl.DistinguishedName

        # Replace spaces in distribution group names with underscores for the file name
        $fileName = $dl.Name -replace ' ', '_'

        # Ensure the directory exists
        $filePath = "$distlistsDir\$fileName`_Members.csv"

        $memberEmails = $members | Where-Object { $_.objectClass -eq 'user' } | ForEach-Object { $_.mail }
        [PSCustomObject]@{
            GroupName = $dl.Name
            Members = $memberEmails -join ","
        } | Export-Csv -Path $filePath -NoTypeInformation

        Write-Verbose "Exported members of $($dl.Name) to $filePath"
    }

    # Export all distribution lists to a single CSV file
    $allDistListsFilePath = "$OutputDirectory\AllDistributionLists.csv"
    $distributionLists | Select-Object Name | Export-Csv -Path $allDistListsFilePath -NoTypeInformation
    Write-Verbose "Exported all distribution lists to $allDistListsFilePath"

    Write-Verbose "Export of Exchange data completed."
}

# Example of running the function with verbose output and specifying the OU
# Export-ExchangeContactData -OutputDirectory "C:\Temp\ExchangeDataExport" -DistributionListOU "OU=DistributionGroups,DC=yourdomain,DC=com" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Export-ExchangeContactData.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-ExchangeContactData.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

