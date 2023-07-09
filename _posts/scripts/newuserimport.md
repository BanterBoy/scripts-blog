---
layout: post
title: newuserimport.ps1
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
$csvcontent = Import-CSV -Path C:\Users\Administrator\Downloads\NewDCusers.csv
foreach ($user in $csvcontent) {
    $userInfo = @{
        AccountPassword       = (ConvertTo-SecureString "PoPeYeDaSail0rM@@n!" -AsPlainText -Force)
        ChangePasswordAtLogon = $true
        Company               = ($user.Company)
        DisplayName           = "$($user.Firstname) $($user.Lastname)"
        Enabled               = $true
        MobilePhone           = ($user.MobilePhone)
        OfficePhone           = ($user.PhoneNumber)
        Name                  = "$($user.Firstname) $($user.Lastname)"
        SamAccountName        = ($user.SamAccountName)
        Title                 = ($user.Title)
        Path                  = "OU=Users,OU=UNIFY,DC=unify,DC=org,DC=au"
        State                 = ($user.StateOrProvince)
        GivenName             = ($user.FirstName)
        SurName               = ($user.LastName)
        UserPrincipalName     = "$($user.Lastname)$($user.Firstname.Substring(0,1))@UNIFY.org.au"
        Department            = ($user.Department)
        Description           = ($user.Description)
        Office                = ($user.Office)
        City                  = ($user.City)
        Fax                   = ($user.Fax)
        Initials              = ($user.Initials)
        LogonName             = ($user.LogonName)
        PostalCode            = ($user.PostalCode)
        StreetAddress         = ($user.StreetAddress)
        HomeDirectory         = ($user.HomeDirectory)
        HomeDrive             = ($user.HomeDrive)
    }
    New-ADUser @userInfo
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/newuserimport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=newuserimport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
