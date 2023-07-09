---
layout: post
title: Unlock-UserAccount.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
function Unlock-UserAccount {
    <#
    .SYNOPSIS
    Unlock AD User Accounts for user who are currently locked out.

    .DESCRIPTION
    This function will gather user account information from Active Directory compiling a list of user accounts
    for all Active Directory accounts that are currently locked due to incorrect passwords being entered.
    When running the function, it searches all AD User accounts from AD looking for those that are locked out.
    It then produces an alphabetical list output in Grid-View with the user details "Name,SamAccountName,LastLogonDate,UserPrincipalName,LockedOut"
    You can then select the User/s accounts and click OK to unlock them.

    .EXAMPLE
    Unlock-UserAccount

    .NOTES
    The user account running this function, needs to have 'Domain Admin Privileges' in order to unlock the account.

    #>

    Search-ADAccount -LockedOut |
    Select-Object Name, SamAccountName, LastLogonDate, UserPrincipalName, LockedOut |
    Sort-Object Name |
    Out-GridView -PassThru |
    Foreach-Object { Unlock-ADAccount -Identity $_.DistinguishedName }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Unlock-UserAccount.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Unlock-UserAccount.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
