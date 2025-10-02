---
layout: post
title: Copy-DistributionGroupMembership.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/copy-distributiongroupmembership/
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

Copies the distribution group membership of one user to another user.

#### Detailed Description

This function copies the distribution group membership of one user to another user. It can also align the destination user's distribution group membership with the source user's.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Copy-DistributionGroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
```

Copies the distribution group membership of User1 to User2 and aligns User2's distribution group membership with User1's.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Unknown Date: Unknown

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
Function Copy-DistributionGroupMembership {
    <#
    .SYNOPSIS
    Copies the distribution group membership of one user to another user.
    
    .DESCRIPTION
    This function copies the distribution group membership of one user to another user. It can also align the destination user's distribution group membership with the source user's.
    
    .PARAMETER SourceUser
    The SamAccountName of the user you are copying from.
    
    .PARAMETER DestinationUser
    The SamAccountName of the user you are copying to.
    
    .PARAMETER AlignMembership
    If specified, aligns the destination user's distribution group membership with the source user's.
    
    .EXAMPLE
    Copy-DistributionGroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
    Copies the distribution group membership of User1 to User2 and aligns User2's distribution group membership with User1's.
    
    .NOTES
    Author: Unknown
    Date: Unknown
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName for the user you are copying from."
        )]
        [string]
        $SourceUser,

        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName of the user you are copying to."
        )]
        [string]
        $DestinationUser,

        [Parameter(
            HelpMessage = "Align the destination user's distribution group membership with the source user's."
        )]
        [switch]
        $AlignMembership
    )

    process {
        if ($PSCmdlet.ShouldProcess("$DestinationUser", "Copy User $SourceUser Distribution Group Memberships")) {
            $SourceUserGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember -Identity $_.Identity -ResultSize Unlimited).PrimarySmtpAddress -contains $SourceUser }

            if ($AlignMembership) {
                $DestinationUserGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember -Identity $_.Identity -ResultSize Unlimited).PrimarySmtpAddress -contains $DestinationUser }
                foreach ($Group in $DestinationUserGroups) {
                    if ($SourceUserGroups -notcontains $Group) {
                        Remove-DistributionGroupMember -Identity $Group.Identity -Member $DestinationUser -Confirm:$false
                    }
                }
            }

            foreach ($Group in $SourceUserGroups) {
                Add-DistributionGroupMember -Identity $Group.Identity -Member $DestinationUser -ErrorAction SilentlyContinue
            }
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Copy-DistributionGroupMembership.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-DistributionGroupMembership.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

