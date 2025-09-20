---
layout: post
title: Get-ADObjectAddress.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ADObjectAddress/
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

Searches Active Directory for user or contact objects based on email address.

#### Detailed Description

The Get-ADObjectAddress function searches Active Directory for user or contact objects that match the specified email address. It supports wildcards in the email address and returns the object properties if a match is found.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADObjectAddress -EmailAddress "john.doe@example.com"
```

Searches Active Directory for user or contact objects with the email address "john.doe@example.com" and returns their properties.

**Example 2**

```powershell
Get-ADObjectAddress -EmailAddress "*@example.com"
```

Searches Active Directory for user or contact objects with email addresses ending with "@example.com" and returns their properties.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Active Directory module to be installed. If the module is not available, the function will fail.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Searches Active Directory for user or contact objects based on email address.

.DESCRIPTION
The Get-ADObjectAddress function searches Active Directory for user or contact objects that match the specified email address. It supports wildcards in the email address and returns the object properties if a match is found.

.PARAMETER EmailAddress
Specifies the email address to search for. Wildcards are supported. If not specified, all user or contact objects will be returned.

.EXAMPLE
Get-ADObjectAddress -EmailAddress "john.doe@example.com"
Searches Active Directory for user or contact objects with the email address "john.doe@example.com" and returns their properties.

.EXAMPLE
Get-ADObjectAddress -EmailAddress "*@example.com"
Searches Active Directory for user or contact objects with email addresses ending with "@example.com" and returns their properties.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns a custom object with the following properties:
- Name: The name of the user or contact object.
- mail: The primary email address of the user or contact object.
- proxyAddresses: The proxy email addresses associated with the user or contact object.
- DistinguishedName: The distinguished name (DN) of the user or contact object.
- ObjectClass: The object class of the user or contact object.
- whenCreated: The date and time when the user or contact object was created.
- whenChanged: The date and time when the user or contact object was last modified.

.NOTES
This function requires the Active Directory module to be installed. If the module is not available, the function will fail.

.LINK
https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adobject

#>

function Get-ADObjectAddress {
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
                foreach ($Address in $EmailAddress) {
                    Get-ADObject -Properties * -Filter "mail -like '*$address*' -or proxyAddresses -like '*$address*'" | Select-Object -Property Name, mail, proxyAddresses, DistinguishedName, ObjectClass, whenCreated, whenChanged
                }
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

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADObjectAddress.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADObjectAddress.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

