---
layout: post
title: Copy-GroupMembership.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Copy-GroupMembership/
categories:
- UserAdminModule
- ADFunctions
tags:
- PowerShell
- User Admin Module
- Group Membership
description: Copies the group membership of one user to another user.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Copies the group membership of one user to another user.

#### Detailed Description

This function copies the group membership of one user to another user. It can also align the destination user's group membership with the source user's by removing groups that the destination user is a member of but the source user is not.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2"
```

Copies the group membership of User1 to User2.

**Example 2**

```powershell
Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
```

Copies the group membership of User1 to User2 and aligns User2's group membership with User1's.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Copies the group membership of one user to another user.

.DESCRIPTION
    This function copies the group membership of one user to another user. It can also align the destination user's group membership with the source user's by removing groups that the destination user is a member of but the source user is not.

.PARAMETER SourceUser
    The SamAccountName of the user you are copying from.

.PARAMETER DestinationUser
    The SamAccountName of the user you are copying to.

.PARAMETER AlignMembership
    If specified, aligns the destination user's group membership with the source user's by removing groups that the destination user is a member of but the source user is not.

.EXAMPLE
    Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2"
    Copies the group membership of User1 to User2.

.EXAMPLE
    Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
    Copies the group membership of User1 to User2 and aligns User2's group membership with User1's.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Copy-GroupMembership {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceUser,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationUser,

        [Parameter()]
        [switch]$AlignMembership
    )

    process {
        if ($PSCmdlet.ShouldProcess("$DestinationUser", "Copy group memberships from $SourceUser")) {
            try {
                # Retrieve source user groups
                Write-Verbose "Retrieving groups for SourceUser: $SourceUser"
                $SourceUserObject = Get-ADUser -Identity $SourceUser -Properties MemberOf
                $SourceUserGroups = @($SourceUserObject.MemberOf)

                # Align membership if the switch is specified
                if ($AlignMembership) {
                    Write-Verbose "Aligning group memberships for DestinationUser: $DestinationUser"
                    $DestinationUserObject = Get-ADUser -Identity $DestinationUser -Properties MemberOf
                    $DestinationUserGroups = @($DestinationUserObject.MemberOf)

                    foreach ($Group in $DestinationUserGroups) {
                        if ($SourceUserGroups -notcontains $Group) {
                            try {
                                Write-Verbose "Removing $DestinationUser from group: $Group"
                                Remove-ADGroupMember -Identity $Group -Members $DestinationUser -Confirm:$false -ErrorAction Stop
                            }
                            catch {
                                Write-Error "Failed to remove $DestinationUser from group $Group. $_"
                            }
                        }
                    }
                }

                # Add destination user to source user's groups
                foreach ($Group in $SourceUserGroups) {
                    try {
                        Write-Verbose "Adding $DestinationUser to group: $Group"
                        Add-ADGroupMember -Identity $Group -Members $DestinationUser -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Error "Failed to add $DestinationUser to group $Group. $_"
                    }
                }
            }
            catch {
                Write-Error "An error occurred while processing group memberships: $_"
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Copy-GroupMembership.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-GroupMembership.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

