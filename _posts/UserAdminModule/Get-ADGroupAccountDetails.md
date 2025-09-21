---
layout: post
title: Get-ADGroupAccountDetails.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-adgroupaccountdetails/
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

Retrieves account details for members of an Active Directory group.

#### Detailed Description

The Get-ADGroupAccountDetails function retrieves account details for members of an Active Directory group. It returns a list of objects containing information such as name, display name, account status, password details, and group membership.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADGroupAccountDetails -GroupName 'Domain Admins'
```

This example retrieves account details for members of the 'Domain Admins' group.

**Example 2**

```powershell
Get-ADGroupAccountDetails -GroupName 'Help Desk' -PassDetails
```

This example retrieves account details for members of the 'Help Desk' group and includes password details in the output.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Active Directory module to be installed. Make sure you have the necessary permissions to retrieve account details.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves account details for members of an Active Directory group.

.DESCRIPTION
The Get-ADGroupAccountDetails function retrieves account details for members of an Active Directory group. It returns a list of objects containing information such as name, display name, account status, password details, and group membership.

.PARAMETER GroupName
Specifies the name of the Active Directory group. The default value is 'Domain Admins'.

.PARAMETER PassDetails
Indicates whether to include password details in the output. By default, password details are not included.

.EXAMPLE
Get-ADGroupAccountDetails -GroupName 'Domain Admins'

This example retrieves account details for members of the 'Domain Admins' group.

.EXAMPLE
Get-ADGroupAccountDetails -GroupName 'Help Desk' -PassDetails

This example retrieves account details for members of the 'Help Desk' group and includes password details in the output.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject[]
The function returns an array of PSCustomObject objects, each representing an account and its details.

.NOTES
This function requires the Active Directory module to be installed. Make sure you have the necessary permissions to retrieve account details.

.LINK
https://docs.microsoft.com/en-us/powershell/module/activedirectory

#>

function Get-ADGroupAccountDetails {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Mandatory = $false)]
        [String]
        $GroupName = 'Domain Admins',
        [Parameter(Mandatory = $false)]
        [Switch]
        $PassDetails
    )
    BEGIN { }
    PROCESS {
        $adminAccounts = Get-ADGroupMember -Identity $GroupName -Recursive | Get-ADUser -Properties *
        $adminAccountsData = $adminAccounts | ForEach-Object {
            $passwordAge = if ($_.PasswordLastSet) {
                ((Get-Date) - $_.PasswordLastSet).Days
            }
            $accountExpirationDate = if ($_.AccountExpirationDate) {
                $_.AccountExpirationDate
            }
            $lastLogonDate = if ($_.LastLogonDate) {
                $_.LastLogonDate
            }
            $groups = if ($_.MemberOf) { $_.MemberOf | ForEach-Object { (Get-ADGroup $_).Name } }
            $adminAccount = [PSCustomObject]@{
                Name                  = $_.Name
                DisplayName           = $_.DisplayName
                SamAccountName        = $_.SamAccountName
                Description           = $_.Description
                Enabled               = [bool]$_.Enabled
                PasswordNeverExpires  = $_.PasswordNeverExpires
                PasswordLastSet       = $_.PasswordLastSet
                PasswordAge           = $passwordAge
                AccountExpirationDate = $accountExpirationDate
                LastLogonDate         = $lastLogonDate
                Groups                = $groups -join ', '
            }
            $adminAccount  # output the object to be collected in $adminAccountsData
        }
        if ($PassDetails) {
            $adminAccountsData | Select-Object -Property Name, SamAccountName, Enabled, PasswordNeverExpires, PasswordLastSet, PasswordAge
        }
        else {
            $adminAccountsData
        }
    }
        
    END { }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADGroupAccountDetails.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADGroupAccountDetails.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

