---
layout: post
title: Get-DistributionListMembers.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-DistributionListMembers/
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

Retrieves the members of a distribution list.

#### Detailed Description

The Get-DistributionListMembers function retrieves the members of a distribution list based on the provided distribution list name. It uses the Get-DistributionGroup and Get-DistributionGroupMember cmdlets to fetch the distribution groups and their members.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DistributionListMembers -DistributionListName "Sales"
```

This example retrieves the members of the distribution list with the name "Sales".

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the members of a distribution list.

.DESCRIPTION
The Get-DistributionListMembers function retrieves the members of a distribution list based on the provided distribution list name. It uses the Get-DistributionGroup and Get-DistributionGroupMember cmdlets to fetch the distribution groups and their members.

.PARAMETER DistributionListName
The name of the distribution list for which to retrieve the members.

.EXAMPLE
Get-DistributionListMembers -DistributionListName "Sales"

This example retrieves the members of the distribution list with the name "Sales".

.INPUTS
System.String

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
Author: Your Name
Date: Today's Date
#>

function Get-DistributionListMembers {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$DistributionListName
    )

    process {
        if ($PSCmdlet.ShouldProcess($DistributionListName, 'Get-DistributionListMembers')) {
            try {
                $distributionGroups = Get-DistributionGroup | Where-Object { $_.Name -like "$DistributionListName" }

                if ($null -eq $distributionGroups) {
                    Write-Error "No distribution group found with the name: $DistributionListName"
                    return
                }

                $distributionGroups | ForEach-Object {
                    $groupName = $_.Name
                    $members = Get-DistributionGroupMember -Identity $groupName
                    $members | ForEach-Object {
                        $member = $_
                        $member | Select-Object DisplayName, PrimarySMTPAddress, SamAccountName, Alias, RecipientType, EmailAddresses, @{Name = 'DistributionGroupName'; Expression = { $groupName } }
                    }
                }
            }
            catch {
                Write-Error $_.Exception.Message
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Get-DistributionListMembers.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DistributionListMembers.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

