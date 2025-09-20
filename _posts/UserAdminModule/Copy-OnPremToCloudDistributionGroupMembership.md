---
layout: post
title: Copy-OnPremToCloudDistributionGroupMembership.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Copy-OnPremToCloudDistributionGroupMembership/
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

Copies the distribution group membership from an on-premise distribution group to a cloud distribution group.

#### Detailed Description

This function copies the distribution group membership from an on-premise distribution group to a cloud distribution group.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Copy-OnPremToCloudDistributionGroupMembership -OnPremGroup "OnPremGroup1" -CloudGroup "CloudGroup1"
```

Copies the distribution group membership from OnPremGroup1 to CloudGroup1.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Date: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Copy-OnPremToCloudDistributionGroupMembership {
    <#
    .SYNOPSIS
    Copies the distribution group membership from an on-premise distribution group to a cloud distribution group.
    
    .DESCRIPTION
    This function copies the distribution group membership from an on-premise distribution group to a cloud distribution group.
    
    .PARAMETER OnPremGroup
    The name of the on-premise distribution group.
    
    .PARAMETER CloudGroup
    The name of the cloud distribution group.
    
    .EXAMPLE
    Copy-OnPremToCloudDistributionGroupMembership -OnPremGroup "OnPremGroup1" -CloudGroup "CloudGroup1"
    Copies the distribution group membership from OnPremGroup1 to CloudGroup1.
    
    .NOTES
    Author: Unknown
    Date: Unknown
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter( Mandatory = $true,
            HelpMessage = "Enter the name of the on-premise distribution group."
        )]
        [string]
        $OnPremGroup,

        [Parameter( Mandatory = $true,
            HelpMessage = "Enter the name of the cloud distribution group."
        )]
        [string]
        $CloudGroup
    )

    process {
        if ($PSCmdlet.ShouldProcess("$CloudGroup", "Copy On-Premise Group $OnPremGroup Memberships")) {
            # Get members of the on-premise distribution group
            $OnPremGroupMembers = Get-DistributionGroupMember -Identity $OnPremGroup -ResultSize Unlimited

            # Get members of the cloud distribution group
            $CloudGroupMembers = Get-DistributionGroupMember -Identity $CloudGroup -ResultSize Unlimited

            # Add members to the cloud distribution group
            foreach ($Member in $OnPremGroupMembers) {
                if ($CloudGroupMembers -notcontains $Member) {
                    Add-DistributionGroupMember -Identity $CloudGroup -Member $Member.PrimarySmtpAddress -ErrorAction SilentlyContinue
                }
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Copy-OnPremToCloudDistributionGroupMembership.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-OnPremToCloudDistributionGroupMembership.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

