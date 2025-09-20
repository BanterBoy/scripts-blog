---
layout: post
title: Get-UsersCalendarAccess.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/get-userscalendaraccess/
categories:
  - UserAdminModule
  - Exchange
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

Retrieves calendar access permissions for a specified user from Active Directory and exports the results to a CSV file.

#### Detailed Description

The Get-UsersCalendarAccess function retrieves calendar access permissions for a specified user from Active Directory. It uses the Get-ADUser cmdlet to get a list of users from a specified search base. Then, it uses the Get-O365CalendarPermissions cmdlet to get the calendar permissions for each user. The function filters the results to only include the permissions for the specified user and exports them to a CSV file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-UsersCalendarAccess -UserName "Charmaine Kerr" -OutputPath "C:\Temp\CharmaineCalendarPerms.csv" -SearchBase "OU=Azure Sync Users,OU=Active,OU=RDG Users,DC=rdg,DC=co,DC=uk"
```

Retrieves the calendar access permissions for the user "Charmaine Kerr" from the specified search base and exports the results to the specified CSV file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves calendar access permissions for a specified user from Active Directory and exports the results to a CSV file.

.DESCRIPTION
    The Get-UsersCalendarAccess function retrieves calendar access permissions for a specified user from Active Directory. It uses the Get-ADUser cmdlet to get a list of users from a specified search base. Then, it uses the Get-O365CalendarPermissions cmdlet to get the calendar permissions for each user. The function filters the results to only include the permissions for the specified user and exports them to a CSV file.

.PARAMETER UserName
    Specifies the username for which to retrieve calendar access permissions.

.PARAMETER OutputPath
    Specifies the path where the CSV file containing the calendar access permissions will be saved.

.PARAMETER SearchBase
    Specifies the search base for the Get-ADUser cmdlet. This parameter is optional. If not specified, the function will use the default search base.

.EXAMPLE
    Get-UsersCalendarAccess -UserName "Charmaine Kerr" -OutputPath "C:\Temp\CharmaineCalendarPerms.csv" -SearchBase "OU=Azure Sync Users,OU=Active,OU=RDG Users,DC=rdg,DC=co,DC=uk"
    Retrieves the calendar access permissions for the user "Charmaine Kerr" from the specified search base and exports the results to the specified CSV file.

#>

function Get-UsersCalendarAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserName,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath, 

        [Parameter(Mandatory = $false)]
        [string]$SearchBase
    )

    try {
        $AZSyncUsers = Get-ADUser -filter " Name -like '*' " -SearchBase $SearchBase -ErrorAction Stop | Where-Object -FilterScript { $_.Enabled -eq $true }
    }
    catch {
        Write-Error "Failed to get AD users: $_"
        return
    }

    $CalendarPermissions = $AZSyncUsers | ForEach-Object -Process {
        try {
            Get-O365CalendarPermissions -UserPrincipalName $_.UserPrincipalName -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to get calendar permissions for $($_.UserPrincipalName): $_"
        }
    } | Where-Object -FilterScript { $_.User -eq $UserName }

    if ($CalendarPermissions) {
        $CalendarPermissions | Export-Csv -Path $OutputPath -Encoding utf8 -ErrorAction SilentlyContinue
        if (-not $?) {
            Write-Error "Failed to export calendar permissions to CSV at $OutputPath"
        }
    }
    else {
        Write-Warning "No calendar permissions found for $UserName"
    }

    return $CalendarPermissions
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-UsersCalendarAccess.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UsersCalendarAccess.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

