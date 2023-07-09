---
layout: post
title: CreateUser.ps1
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
Import-Module ActiveDirectory

$creds = Get-Credential
$currentEmployees = Import-Csv .\currentEmployees.csv

$currentEmployees |
ForEach-Object $name=$_.name {
    if ( Get-ADUser -Filter { Name -eq $name } ) {
        Write-Host "User exists"
    }
    else {
        New-ADUser -Credential $creds
        -SamAccountName $_.sAMAccountName
        -UserPrincipalName $_.userPrincipalName
        -DisplayName $_.displayName
        -AccountPassword (ConvertTo-SecureString $_.password -AsPlainText -Force)
        -Enabled $true
        -GivenName $_.givenName
        -Surname $_.sn
        -Name $_.name
        -Title $_.title
        -EmployeeID $_.employeeID
        -EmployeeNumber $_.employeeNumber
        -Department $_.department
        -Path $_.path
        -OtherAttributes @{
            businessCategory = $_.businessCategory;
            proxyAddresses   = $_.proxyAddresses
        } -whatif
    }
}

Import-Module ActiveDirectory
$OUList = Get-ChildItem -Path "AD:\OU=Folder,OU=Containing,DC=Users" | Where-Object { $PSItem.ObjectClass -eq 'organizationalUnit' } | Out-GridView -PassThru
$OUList


# $creds = get-credential
# $currentEmployees = import-csv .\currentEmployees.csv
# $currentEmployees |
# ForEach-Object $name=$_.name {
#     if ( Get-ADUser -Filter { Name -eq $name} ) {
#         write-host "User exists"
#     }
#     else {
#         New-ADUser -Credential $creds
#         -SamAccountName $_.sAMAccountName
#         -UserPrincipalName $_.userPrincipalName
#         -DisplayName $_.displayName
#         -AccountPassword (ConvertTo-SecureString $_.password -AsPlainText -force)
#         -Enabled $true
#         -GivenName $_.givenName
#         -Surname $_.sn
#         -Name $_.name
#         -Title $_.title
#         -EmployeeID $_.employeeID
#         -EmployeeNumber $_.employeeNumber
#         -Department $_.department
#         -Path $_.path
#         -OtherAttributes @{
#             businessCategory=$_.businessCategory;
#             proxyAddresses=$_.proxyAddresses} -whatif
#     }
# }
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/CreateUser.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CreateUser.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
