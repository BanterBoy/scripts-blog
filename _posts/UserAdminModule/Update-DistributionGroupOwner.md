---
layout: post
title: Update-DistributionGroupOwner.ps1
date: 2025-09-19
permalink: /useradminmodule/exchange/update-distributiongroupowner/
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

Updates the owners (ManagedBy property) of distribution groups in on-premises Exchange.

#### Detailed Description

This function allows you to:

- Replace an old owner with a new one.

- Add a new owner while retaining existing ones.

- Target specific distribution groups via -Identity or pipeline input.

It returns a PSObject for each updated group, showing the old owners and new owners.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Update-DistributionGroupOwner -Identity "Finance Team" -NewOwner "Jane.Smith"
```

Sets Jane.Smith as the owner of the Finance Team group, replacing all owners.

**Example 2**

```powershell
Get-DistributionGroup "HR*" | Update-DistributionGroupOwner -NewOwner "DL_Owner_Service" -Add
```

Adds DL_Owner_Service as an additional owner to all HR-related groups.

**Example 3**

```powershell
Update-DistributionGroupOwner -OldOwner "John.Doe" -NewOwner "Jane.Smith"
```

Replaces John.Doe with Jane.Smith in all distribution groups owned by John.Doe.

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
    Updates the owners (ManagedBy property) of distribution groups in on-premises Exchange.

.DESCRIPTION
    This function allows you to:
        - Replace an old owner with a new one.
        - Add a new owner while retaining existing ones.
        - Target specific distribution groups via -Identity or pipeline input.

    It returns a PSObject for each updated group, showing the old owners and new owners.

.PARAMETER Identity
    One or more distribution groups to update. Can be piped from Get-DistributionGroup or Get-OrphanedDistributionGroups.

.PARAMETER OldOwner
    The current owner to replace (sAMAccountName, alias, or email).

.PARAMETER NewOwner
    The new owner to set or add to the distribution groups.

.PARAMETER Add
    If specified, the NewOwner will be added to the existing list of owners, instead of replacing them.

.EXAMPLE
    Update-DistributionGroupOwner -Identity "Finance Team" -NewOwner "Jane.Smith"

    Sets Jane.Smith as the owner of the Finance Team group, replacing all owners.

.EXAMPLE
    Get-DistributionGroup "HR*" | Update-DistributionGroupOwner -NewOwner "DL_Owner_Service" -Add

    Adds DL_Owner_Service as an additional owner to all HR-related groups.

.EXAMPLE
    Update-DistributionGroupOwner -OldOwner "John.Doe" -NewOwner "Jane.Smith"

    Replaces John.Doe with Jane.Smith in all distribution groups owned by John.Doe.

.NOTES
    Author: Luke's Automation Helper (ChatGPT)
    Requires: Exchange Management Shell
#>
function Update-DistributionGroupOwner {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Identity,

        [Parameter(Mandatory = $false)]
        [string]$OldOwner,

        [Parameter(Mandatory = $true)]
        [string]$NewOwner,

        [switch]$Add
    )

    begin {
        if (-not (Get-Command Get-DistributionGroup -ErrorAction SilentlyContinue)) {
            Throw "Exchange Management Shell cmdlets not found. Please run this on an Exchange Management Shell."
        }

        try {
            $newOwnerDN = (Get-Recipient $NewOwner -ErrorAction Stop).DistinguishedName
        }
        catch {
            Throw "Unable to resolve NewOwner '$NewOwner'. Ensure the account exists."
        }

        if ($OldOwner) {
            try {
                $oldOwnerDN = (Get-Recipient $OldOwner -ErrorAction Stop).DistinguishedName
            }
            catch {
                Throw "Unable to resolve OldOwner '$OldOwner'. Ensure the account exists."
            }
        }
    }

    process {
        $groups = @()

        if ($Identity) {
            foreach ($id in $Identity) {
                try {
                    $groups += Get-DistributionGroup -Identity $id -ErrorAction Stop
                }
                catch {
                    Write-Warning "Could not find group '$id': $_"
                }
            }
        }
        else {
            $groups = Get-DistributionGroup -ResultSize Unlimited
        }

        foreach ($group in $groups) {
            $oldManagers = $group.ManagedBy
            $updatedManagers = @()

            if ($OldOwner) {
                if ($oldManagers -notcontains $oldOwnerDN) {
                    Write-Verbose "Skipping '$($group.Name)' - OldOwner not found among current managers."
                    continue
                }

                if ($Add) {
                    $updatedManagers = $oldManagers + $newOwnerDN
                } else {
                    $updatedManagers = ($oldManagers | Where-Object { $_ -ne $oldOwnerDN }) + $newOwnerDN
                }
            } else {
                if ($Add) {
                    $updatedManagers = $oldManagers + $newOwnerDN
                } else {
                    $updatedManagers = @($newOwnerDN)
                }
            }

            $updatedManagers = $updatedManagers | Sort-Object -Unique

            if ($PSCmdlet.ShouldProcess($group.Name, "Update owner(s)")) {
                Set-DistributionGroup -Identity $group.Name -ManagedBy $updatedManagers
            }

            [PSCustomObject]@{
                GroupName = $group.Name
                OldOwners = ($oldManagers | ForEach-Object { (Get-Recipient $_).Name })
                NewOwners = ($updatedManagers | ForEach-Object { (Get-Recipient $_).Name })
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Update-DistributionGroupOwner.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-DistributionGroupOwner.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

