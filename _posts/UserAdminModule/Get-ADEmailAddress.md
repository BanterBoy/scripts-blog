---
layout: post
title: Get-ADEmailAddress.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ADEmailAddress/
categories:
  - UserAdminModule
  - ADFunctions
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

Searches Active Directory for user accounts based on email address.

#### Detailed Description

The Get-ADEmailAddress function searches Active Directory for user accounts based on the provided email address. It supports wildcard matching and returns the object properties of matching accounts.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADEmailAddress -EmailAddress john.doe@example.com
```

Searches Active Directory for user accounts with the email address "john.doe@example.com" and returns their object properties.

**Example 2**

```powershell
Get-ADEmailAddress -EmailAddress *@example.com
```

Searches Active Directory for user accounts with email addresses ending with "@example.com" and returns their object properties.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date Version: 1.0

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Searches Active Directory for user accounts based on email address.

.DESCRIPTION
The Get-ADEmailAddress function searches Active Directory for user accounts based on the provided email address. It supports wildcard matching and returns the object properties of matching accounts.

.PARAMETER EmailAddress
Specifies the email address to search for. Wildcards are supported.

.EXAMPLE
Get-ADEmailAddress -EmailAddress john.doe@example.com
Searches Active Directory for user accounts with the email address "john.doe@example.com" and returns their object properties.

.EXAMPLE
Get-ADEmailAddress -EmailAddress *@example.com
Searches Active Directory for user accounts with email addresses ending with "@example.com" and returns their object properties.

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author: Your Name
Date: Today's Date
Version: 1.0

.LINK
https://link-to-documentation

#>
function Get-ADEmailAddress {
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
                Get-ADObject -Filter ' mail -like "$($EmailAddress)" ' -Properties * | Select-Object -Property DistinguishedName, ObjectClass, Name, mail
            }
            catch {
                Write-Error -Message "$_"
            }
        }
    }
}

# function to search all attributes of an AD User or Contact object for an email address and return the object properties if found
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADEmailAddress.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADEmailAddress.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

