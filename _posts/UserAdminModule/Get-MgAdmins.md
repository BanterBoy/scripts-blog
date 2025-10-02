---
layout: post
title: Get-MgAdmins.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/azure/get-mgadmins/
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

Get all users with an Admin role.

#### Detailed Description

This function retrieves all users who have an Admin role. It uses the Microsoft Graph API to get the directory roles and their members. It then filters the members to only include users and returns the user details such as display name, user principal name, email, and ID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-MgAdmins
```

Retrieves all users with an Admin role.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- This function requires the Microsoft Graph PowerShell module.

- You need to have the necessary permissions to access the directory roles and their members.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
Function Get-MgAdmins {
  <#
  .SYNOPSIS
  Get all users with an Admin role.

  .DESCRIPTION
  This function retrieves all users who have an Admin role. It uses the Microsoft Graph API to get the directory roles and their members. It then filters the members to only include users and returns the user details such as display name, user principal name, email, and ID.

  .NOTES
  - This function requires the Microsoft Graph PowerShell module.
  - You need to have the necessary permissions to access the directory roles and their members.

  .EXAMPLE
  Get-MgAdmins
  Retrieves all users with an Admin role.

  .OUTPUTS
  System.Management.Automation.PSCustomObject
  The function returns a custom object with the following properties:
  - Role: The name of the directory role.
  - DisplayName: The display name of the user.
  - UserPrincipalName: The user principal name (UPN) of the user.
  - Mail: The email address of the user.
  - Id: The ID of the user.

  .LINK
  Microsoft Graph PowerShell module: https://docs.microsoft.com/powershell/module/graph/?view=graph-powershell-1.0

  #>
  process {
    $admins = Get-MgDirectoryRole | Select-Object DisplayName, Id | 
    ForEach-Object -Process { $role = $_.DisplayName; Get-MgDirectoryRoleMember -DirectoryRoleId $_.id | 
      Where-Object -FilterScript { $_.AdditionalProperties."@odata.type" -eq "#microsoft.graph.user" } | 
      ForEach-Object -Process { Get-MgUser -userid $_.id }
    } | 
    Select-Object -Property @{Name = "Role"; Expression = { $role } }, DisplayName, UserPrincipalName, Mail, Id | Sort-Object -Property Mail -Unique
  
    return $admins
  }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Get-MgAdmins.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-MgAdmins.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

