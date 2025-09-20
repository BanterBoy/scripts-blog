---
layout: post
title: Get-DistributionGroupsWithOwners.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-DistributionGroupsWithOwners/
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

Retrieves distribution groups and their owners using Exchange Management Shell.

#### Detailed Description

Retrieves all distribution groups and their owners, returning a flattened list of group-owner relationships. If a group has multiple owners, each owner is shown on its own row.

For owners that aren't mail-enabled, the CN (name) from the DN is extracted and displayed directly, avoiding unnecessary AD lookups.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DistributionGroupsWithOwners
```

Returns a simple list of all distribution groups and their owners.

**Example 2**

```powershell
Get-DistributionGroupsWithOwners -Detailed
```

Returns all distribution groups and detailed information about each owner.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke's Automation Helper (ChatGPT) Requires: Exchange Management Shell

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves distribution groups and their owners using Exchange Management Shell.

.DESCRIPTION
    Retrieves all distribution groups and their owners, returning a flattened list of
    group-owner relationships. If a group has multiple owners, each owner is shown
    on its own row.

    For owners that aren't mail-enabled, the CN (name) from the DN is extracted and
    displayed directly, avoiding unnecessary AD lookups.

.PARAMETER ResultSize
    Number of distribution groups to retrieve. Default is Unlimited.

.PARAMETER Detailed
    Returns additional properties for each owner (OwnerPrimarySmtpAddress and
    OwnerIsMailEnabled). For non-mail-enabled owners, OwnerPrimarySmtpAddress is blank.

.EXAMPLE
    Get-DistributionGroupsWithOwners
    Returns a simple list of all distribution groups and their owners.

.EXAMPLE
    Get-DistributionGroupsWithOwners -Detailed
    Returns all distribution groups and detailed information about each owner.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Get-DistributionGroupsWithOwners {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ResultSize = "Unlimited",

        [switch]$Detailed
    )

    if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
        Write-Warning "Exchange Management Shell cmdlets not found. 
Run this function in an Exchange Management Shell session or load the Exchange module."
        return
    }

    try {
        $Groups = Get-DistributionGroup -ResultSize $ResultSize

        foreach ($group in $Groups) {
            if ($group.ManagedBy) {
                foreach ($ownerDN in $group.ManagedBy) {
                    $ownerName = $null
                    $ownerPrimarySmtp = $null
                    $ownerIsMailEnabled = $false

                    try {
                        $owner = Get-Recipient $ownerDN -ErrorAction Stop
                        $ownerName = $owner.Name
                        $ownerPrimarySmtp = $owner.PrimarySmtpAddress
                        $ownerIsMailEnabled = $true
                    }
                    catch {
                        # If not mail-enabled, extract the CN from the DN
                        if ($ownerDN -match '([^/]+)$') {
                            $ownerName = $Matches[1]
                        }
                        else {
                            $ownerName = $ownerDN
                        }
                    }

                    if ($Detailed) {
                        [PSCustomObject]@{
                            GroupName             = $group.Name
                            GroupDisplayName      = $group.DisplayName
                            GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                            OwnerName             = $ownerName
                            OwnerPrimarySmtpAddress = $ownerPrimarySmtp
                            OwnerIsMailEnabled    = $ownerIsMailEnabled
                        }
                    }
                    else {
                        [PSCustomObject]@{
                            GroupName             = $group.Name
                            GroupDisplayName      = $group.DisplayName
                            GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                            OwnerName             = $ownerName
                        }
                    }
                }
            }
            else {
                [PSCustomObject]@{
                    GroupName             = $group.Name
                    GroupDisplayName      = $group.DisplayName
                    GroupPrimarySmtpAddress = $group.PrimarySmtpAddress
                    OwnerName             = "None"
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred while retrieving distribution groups: $($_.Exception.Message)"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-DistributionGroupsWithOwners.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DistributionGroupsWithOwners.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

