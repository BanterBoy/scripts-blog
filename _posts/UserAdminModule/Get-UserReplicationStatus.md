---
layout: post
title: Get-UserReplicationStatus.ps1
date: 2025-09-19
permalink: /useradminmodule/replication/get-userreplicationstatus/
categories:
  - UserAdminModule
  - Replication
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-UserReplicationStatus {
    param (
        [string]$UserName,
        [switch]$ShowPasswordDetails,
        [string[]]$ExcludeDomainControllers
    )

    # Ensure the ActiveDirectory module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "The ActiveDirectory module is not available. Please install it to use this function."
        return
    }

    # Get all domain controllers
    $domainControllers = Get-AllDomainControllers

    # Filter out excluded domain controllers if specified
    if ($ExcludeDomainControllers) {
        $domainControllers = $domainControllers | Where-Object {
            $exclude = $false
            foreach ($pattern in $ExcludeDomainControllers) {
                if ($_.Hostname -like "*$pattern*") {
                    $exclude = $true
                    break
                }
            }
            -not $exclude
        }
    }

    # Initialize an array to hold the results
    $results = @()

    # Iterate over each domain controller and get the user account details
    foreach ($dc in $domainControllers) {
        try {
            $user = Get-ADUser -Identity $UserName -Properties * -Server $dc.Hostname
            $result = [PSCustomObject]@{
                Server                = $dc.Hostname
                SamAccountName        = $user.SamAccountName
                LockedOut             = $user.LockedOut
                LastLogonDate         = $user.LastLogonDate
                PasswordLastSet       = $user.PasswordLastSet
                DisplayName           = $user.DisplayName
                EmailAddress          = $user.EmailAddress
                Title                 = $user.Title
                Department            = $user.Department
                GivenName             = $user.GivenName
                Surname               = $user.Surname
                StreetAddress         = $user.StreetAddress
                City                  = $user.City
                State                 = $user.State
                PostalCode            = $user.PostalCode
                Country               = $user.Country
                TelephoneNumber       = $user.TelephoneNumber
                MobilePhone           = $user.MobilePhone
                Company               = $user.Company
                Manager               = $user.Manager
                EmployeeID            = $user.EmployeeID
                Description           = $user.Description
                Office                = $user.PhysicalDeliveryOfficeName
                Division              = $user.Division
                Fax                   = $user.Fax
                Pager                 = $user.Pager
                HomePhone             = $user.HomePhone
                POBox                 = $user.PostOfficeBox
                LogonWorkstations     = $user.LogonWorkstations
                ScriptPath            = $user.ScriptPath
                ProfilePath           = $user.ProfilePath
                HomeDirectory         = $user.HomeDirectory
                HomeDrive             = $user.HomeDrive
                AccountExpirationDate = $user.AccountExpirationDate
                Enabled               = $user.Enabled
            }

            if ($ShowPasswordDetails) {
                $result | Add-Member -MemberType NoteProperty -Name 'PasswordNeverExpires' -Value $user.PasswordNeverExpires -Force
                $result | Add-Member -MemberType NoteProperty -Name 'PasswordExpired' -Value $user.PasswordExpired -Force
            }

            $result.PSObject.TypeNames.Insert(0, 'Custom.UserReplicationStatus')
            $results += $result
        }
        catch {
            Write-Warning "Failed to get user information from server $($dc.Hostname): $_"
        }
    }

    # Return the results
    return $results
}

# Example usage:
# Exclude domain controllers with "NYC" in their name:
# $userStatus = Get-UserReplicationStatus -UserName "lucy.barrick" -ExcludeDomainControllers "NYC"
# $userStatus | Format-Table -AutoSize

# Usage with password details and exclusions:
# $userStatus = Get-UserReplicationStatus -UserName "lucy.barrick" -ShowPasswordDetails -ExcludeDomainControllers "NYC", "LON"
# $userStatus | Format-Table -AutoSize
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Replication/Public/Get-UserReplicationStatus.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserReplicationStatus.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

