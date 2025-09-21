---
layout: post
title: Lock-UserAccount.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/lock-useraccount/
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

Lock AD User Account.

#### Detailed Description

This function will lock a user account in Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Lock-UserAccount -SamAccountName "jdoe"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

The user account running this function, needs to have 'Domain Admin Privileges' in order to lock the account.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Lock-UserAccount {

    <#
    .SYNOPSIS
    Lock AD User Account.
    
    .DESCRIPTION
    This function will lock a user account in Active Directory.
    
    .PARAMETER SamAccountName
    The SamAccountName of the user account to be locked.
    
    .NOTES
    The user account running this function, needs to have 'Domain Admin Privileges' in order to lock the account.
    
    .EXAMPLE
    Lock-UserAccount -SamAccountName "jdoe"
    
    #>
    
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SamAccountName
    )
    begin {
        Write-Verbose "Locking user account '$SamAccountName'..."
    }
    process {
        if ($PSCmdlet.ShouldProcess("$SamAccountName", "Locking user account")) {
            $user = Get-ADUser -Identity $SamAccountName
            if ($user) {
                Set-ADAccountLockout -Identity $user.DistinguishedName -LockoutTime ([timespan]::MaxValue).Days -Confirm:$false
                Write-Output "User account '$SamAccountName' has been locked."
            }
            else {
                Write-Error "User account '$SamAccountName' not found."
            }
        }
    }
    end {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Lock-UserAccount.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Lock-UserAccount.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

