---
layout: post
title: Repair-MissingOnPremMailbox.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/repair-missingonpremmailbox/
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

Repairs a missing on-premises mailbox by adding a proxy address and enabling a remote mailbox.

#### Detailed Description

This function takes a SamAccountName as input and checks if the user exists in Active Directory. If the user exists, it adds a proxy address and enables a remote mailbox.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Repair-MissingOnPremMailbox -SamAccountName "JohnDoe"
```

This example repairs the missing on-premises mailbox for the user with SamAccountName "JohnDoe".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: 2023-10-29 Version: 1.0.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
# function Repair-MissingOnPremMailbox {
#     param (
#         [String]
#         $SamAccountName
#     )
#     $ADUserInfo = Get-ADUser -Identity $SamAccountName -Properties *
#     $Name = $AdUserInfo.GivenName + "." + $AdUserInfo.Surname
#     Set-ADUser -Identity $ADUserInfo.SamAccountName -add @{ProxyAddresses = "SMTP:$($Name)@raildeliverygroup.com,smtp:$($Name)@atoc.mail.onmicrosoft.com" -split "," }
#     Enable-RemoteMailbox -Identity $ADUserInfo.SamAccountName-RemoteRoutingAddress "$($Name)@atoc.mail.onmicrosoft.com"
# }


function Repair-MissingOnPremMailbox {
    <#
    .SYNOPSIS
    Repairs a missing on-premises mailbox by adding a proxy address and enabling a remote mailbox.
    
    .DESCRIPTION
    This function takes a SamAccountName as input and checks if the user exists in Active Directory. If the user exists, it adds a proxy address and enables a remote mailbox.
    
    .PARAMETER SamAccountName
    The SamAccountName of the user whose mailbox needs to be repaired.
    
    .PARAMETER PrimaryDomain
    The primary domain name for the user's email address. Default value is "raildeliverygroup.com".
    
    .PARAMETER Office365Domain
    The Office 365 domain name for the user's email address. Default value is "atoc.mail.onmicrosoft.com".
    
    .EXAMPLE
    Repair-MissingOnPremMailbox -SamAccountName "JohnDoe"
    
    This example repairs the missing on-premises mailbox for the user with SamAccountName "JohnDoe".
    
    .NOTES
    Author: Luke Leigh
    Date: 2023-10-29
    Version: 1.0.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $SamAccountName,
        [Parameter(Mandatory = $false)]
        [String]
        $PrimaryDomain = "raildeliverygroup.com",
        [Parameter(Mandatory = $false)]
        [String]
        $Office365Domain = "atoc.mail.onmicrosoft.com"
    )
    try {
        $ADUserInfo = Get-ADUser -Identity $SamAccountName -Properties *
        if ($null -eq $ADUserInfo) {
            Write-Error "User $SamAccountName not found in Active Directory"
            return
        }
        $Name = $AdUserInfo.GivenName + "." + $AdUserInfo.Surname
        Set-ADUser -Identity $ADUserInfo.SamAccountName -add @{ProxyAddresses = "SMTP:$($Name)@$($PrimaryDomain),smtp:$($Name)@$($Office365Domain)" -split "," }
        Enable-RemoteMailbox -Identity $ADUserInfo.SamAccountName -RemoteRoutingAddress "$($Name)@$($Office365Domain)"
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Repair-MissingOnPremMailbox.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Repair-MissingOnPremMailbox.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

