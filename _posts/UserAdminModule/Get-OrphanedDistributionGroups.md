---
layout: post
title: Get-OrphanedDistributionGroups.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/get-orphaneddistributiongroups/
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

Retrieves distribution groups that have no valid owners.

#### Detailed Description

This function scans all on-premises Exchange distribution groups and identifies groups where:

- The `ManagedBy` property is empty, or

- All owners in the `ManagedBy` list are either disabled or cannot be resolved.

It returns a PSObject with the group name, display name, primary SMTP address, and current owners (if any). Use the -Detailed switch to include all owner names (resolved where possible).

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-OrphanedDistributionGroups
```

Returns all distribution groups with missing or invalid owners, with basic details.

**Example 2**

```powershell
Get-OrphanedDistributionGroups -Detailed
```

Returns all orphaned distribution groups with current owners (if any) resolved.

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
    Retrieves distribution groups that have no valid owners.

.DESCRIPTION
    This function scans all on-premises Exchange distribution groups and identifies groups where:
        - The `ManagedBy` property is empty, or
        - All owners in the `ManagedBy` list are either disabled or cannot be resolved.

    It returns a PSObject with the group name, display name, primary SMTP address, and current owners (if any).
    Use the -Detailed switch to include all owner names (resolved where possible).

.PARAMETER ResultSize
    The number of distribution groups to retrieve. Default is 'Unlimited'.

.PARAMETER Detailed
    Includes a resolved list of current owners for each group (even if they're invalid).

.EXAMPLE
    Get-OrphanedDistributionGroups

    Returns all distribution groups with missing or invalid owners, with basic details.

.EXAMPLE
    Get-OrphanedDistributionGroups -Detailed

    Returns all orphaned distribution groups with current owners (if any) resolved.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Get-OrphanedDistributionGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ResultSize = "Unlimited",

        [switch]$Detailed
    )

    if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
        Throw "Exchange Management Shell cmdlets not found. Please run this on an Exchange Management Shell."
    }

    $orphanedGroups = @()
    $groups = Get-DistributionGroup -ResultSize $ResultSize

    foreach ($group in $groups) {
        $validOwners = @()
        $resolvedOwners = @()

        if ($group.ManagedBy) {
            foreach ($ownerDN in $group.ManagedBy) {
                try {
                    $owner = Get-Recipient $ownerDN -ErrorAction Stop
                    $resolvedOwners += $owner.Name

                    if ($owner.RecipientType -match 'UserMailbox|MailUser' -and -not $owner.AccountDisabled) {
                        $validOwners += $owner.Name
                    }
                    elseif ($owner.RecipientType -notmatch 'UserMailbox|MailUser') {
                        # Service accounts, groups, etc. are considered valid
                        $validOwners += $owner.Name
                    }
                }
                catch {
                    # Owner can't be resolved
                }
            }
        }

        if (-not $group.ManagedBy -or $validOwners.Count -eq 0) {
            $orphanedGroups += [PSCustomObject]@{
                GroupName          = $group.Name
                DisplayName        = $group.DisplayName
                PrimarySmtpAddress = $group.PrimarySmtpAddress
                CurrentOwners      = if ($Detailed) { $resolvedOwners -join ', ' } else { $null }
            }
        }
    }

    return $orphanedGroups
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-OrphanedDistributionGroups.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-OrphanedDistributionGroups.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

