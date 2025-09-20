---
layout: post
title: Compare-GroupMembership.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Compare-GroupMembership/
categories:
  - UserAdminModule
  - ADFunctions
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

Compares the group membership of two Active Directory users.

#### Detailed Description

The Compare-GroupMembership function compares the group membership of two Active Directory users and returns a list of all the groups that either user is a member of, along with a Boolean value indicating whether each user is a member of each group.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Compare-GroupMembership -SourceUser "jdoe" -DestinationUser "asmith"
```

This example compares the group membership of the "jdoe" and "asmith" users.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
        Compares the group membership of two Active Directory users.
    
    .DESCRIPTION
        The Compare-GroupMembership function compares the group membership of two Active Directory users and returns a list of all the groups that either user is a member of, along with a Boolean value indicating whether each user is a member of each group.
    
    .PARAMETER SourceUser
        The username of the source user to compare. Supports pipeline input.
    
    .PARAMETER DestinationUser
        The username of the destination user to compare. Supports pipeline input.
    
    .EXAMPLE
        Compare-GroupMembership -SourceUser "jdoe" -DestinationUser "asmith"
    
        This example compares the group membership of the "jdoe" and "asmith" users.
    
    .NOTES
        Author: Your Name
        Date:   Today's Date
#>

function Compare-GroupMembership {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $SourceUser,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $DestinationUser
    )

    begin {
        Write-Verbose "Starting group membership comparison..."
    }

    process {
        try {
            # Retrieve source user groups
            Write-Verbose "Retrieving groups for SourceUser: $SourceUser"
            $SourceUserObject = Get-ADUser -Identity $SourceUser -Properties MemberOf, PrimaryGroup
            $SourceUserGroups = @($SourceUserObject.MemberOf)
            $SourceUserPrimaryGroup = (Get-ADGroup -Identity $SourceUserObject.PrimaryGroup).DistinguishedName
            $SourceUserGroups += $SourceUserPrimaryGroup
        }
        catch {
            Write-Error "Failed to retrieve groups for SourceUser: $SourceUser. $_"
            return
        }

        try {
            # Retrieve destination user groups
            Write-Verbose "Retrieving groups for DestinationUser: $DestinationUser"
            $DestinationUserObject = Get-ADUser -Identity $DestinationUser -Properties MemberOf, PrimaryGroup
            $DestinationUserGroups = @($DestinationUserObject.MemberOf)
            $DestinationUserPrimaryGroup = (Get-ADGroup -Identity $DestinationUserObject.PrimaryGroup).DistinguishedName
            $DestinationUserGroups += $DestinationUserPrimaryGroup
        }
        catch {
            Write-Error "Failed to retrieve groups for DestinationUser: $DestinationUser. $_"
            return
        }

        # Combine and deduplicate all groups
        Write-Verbose "Combining and deduplicating group memberships..."
        $AllGroups = ($SourceUserGroups + $DestinationUserGroups) | Sort-Object -Unique

        # Retrieve group names
        Write-Verbose "Retrieving group names..."
        $GroupNames = @{}
        foreach ($Group in $AllGroups) {
            try {
                $GroupObject = Get-ADGroup -Identity $Group -ErrorAction Stop
                $GroupNames[$Group] = $GroupObject.Name
            }
            catch {
                Write-Verbose "Failed to retrieve group name for $Group. $_"
            }
        }

        # Generate output
        Write-Verbose "Generating output..."
        foreach ($Group in $AllGroups) {
            $GroupName = $GroupNames[$Group]
            $SourceUserMember = $SourceUserGroups -contains $Group
            $DestinationUserMember = $DestinationUserGroups -contains $Group

            [PSCustomObject]@{
                GroupName         = $GroupName
                DistinguishedName = $Group
                $SourceUser       = $SourceUserMember
                $DestinationUser  = $DestinationUserMember
            }
        }
    }

    end {
        Write-Verbose "Group membership comparison completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Compare-GroupMembership.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Compare-GroupMembership.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

