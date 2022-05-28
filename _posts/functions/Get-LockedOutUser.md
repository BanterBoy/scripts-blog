---
layout: post
title: Get-LockedOutUser.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
.SYNOPSIS
    Get-LockedOutUser.ps1 returns a list of users who were locked out in Active Directory.

.DESCRIPTION
    Get-LockedOutUser.ps1 is an advanced script that returns a list of users who were locked out in Active Directory
by querying the event logs on the PDC emulation in the domain.

.PARAMETER UserName
    The userid of the specific user you are looking for lockouts for. The default is all locked out users.

.PARAMETER StartTime
    The datetime to start searching from. The default is all datetimes that exist in the event logs.

.EXAMPLE
    Get-LockedOutUser.ps1

.EXAMPLE
    Get-LockedOutUser.ps1 -UserName 'mike'

.EXAMPLE
    Get-LockedOutUser.ps1 -StartTime (Get-Date).AddDays(-1)

.EXAMPLE
    Get-LockedOutUser.ps1 -UserName 'miker' -StartTime (Get-Date).AddDays(-1)
#>

[CmdletBinding()]
param (
    [ValidateNotNullOrEmpty()]
    [string]
    $DomainName = $env:DOMAIN,

    [ValidateNotNullOrEmpty()]
    [string]
    $UserName = "*",

    [ValidateNotNullOrEmpty()]
    [datetime]
    $StartTime = (Get-Date).AddDays(-3)
)

Invoke-Command -ComputerName (

    [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain((
            New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $DomainName))
    ).PdcRoleOwner.name

) {
    Get-WinEvent -FilterHashtable @{LogName = 'Security'; Id = 4740; StartTime = $Using:StartTime } |
    Where-Object { $_.Properties[0].Value -like "$Using:UserName" } |
    Select-Object -Property TimeCreated,
    @{Label = 'UserName'; Expression = { $_.Properties[0].Value } },
    @{Label = 'ClientName'; Expression = { $_.Properties[1].Value } }
} -Credential (Get-Credential) | Select-Object -Property TimeCreated, 'UserName', 'ClientName'
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-LockedOutUser.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-LockedOutUser.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
