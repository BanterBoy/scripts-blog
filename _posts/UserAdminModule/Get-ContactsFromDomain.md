---
layout: post
title: Get-ContactsFromDomain.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/get-contactsfromdomain/
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

Retrieves MailContacts filtered by a specified domain.

#### Detailed Description

Get-ContactsFromDomain fetches MailContacts whose ExternalEmailAddress matches the provided domain. It constructs a search pattern based on the supplied domain and uses the Get-MailContact cmdlet to retrieve contacts. Selected properties are then output for review or further processing. This function supports ShouldProcess, allowing you to preview the operation with -WhatIf.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ContactsFromDomain -DomainName "gmail.com"
```

Retrieves all MailContacts with an ExternalEmailAddress that includes "@gmail.com".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2025-05-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves MailContacts filtered by a specified domain.

.DESCRIPTION
    Get-ContactsFromDomain fetches MailContacts whose ExternalEmailAddress matches the provided domain.
    It constructs a search pattern based on the supplied domain and uses the Get-MailContact cmdlet to retrieve
    contacts. Selected properties are then output for review or further processing. This function supports 
    ShouldProcess, allowing you to preview the operation with -WhatIf.

.PARAMETER DomainName
    Specifies the domain used to filter MailContacts. For example, "gmail.com" will retrieve contacts 
    whose ExternalEmailAddress contains "@gmail.com".

.EXAMPLE
    Get-ContactsFromDomain -DomainName "gmail.com"
    Retrieves all MailContacts with an ExternalEmailAddress that includes "@gmail.com".

.NOTES
    Author: Your Name
    Date: 2025-05-30
#>
function Get-ContactsFromDomain {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Domain to filter MailContacts (e.g. gmail.com).")]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName
    )

    begin {
        # Build the search pattern using the specified domain.
        $SearchPattern = "*@$DomainName*"
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess("MailContacts", "Retrieve contacts with ExternalEmailAddress matching '$SearchPattern'")) {
                $contacts = Get-MailContact -Filter "ExternalEmailAddress -like '$SearchPattern'" -ErrorAction Stop
                $contacts | Select-Object -Property Name, DisplayName, Alias, PrimarySMTPAddress, DistinguishedName
            }
        }
        catch {
            Write-Error "Failed to retrieve MailContacts: $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-ContactsFromDomain.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ContactsFromDomain.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

