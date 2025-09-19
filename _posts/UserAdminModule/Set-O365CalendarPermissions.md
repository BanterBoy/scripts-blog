---
layout: post
title: Set-O365CalendarPermissions.ps1
description: "Applies or removes Microsoft 365 calendar permissions for specified users."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-O365CalendarPermissions/
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

Sets, updates, or removes permissions for a user on an Office 365 calendar (Exchange Online).

#### Detailed Description

This function allows you to set, update, or remove permissions for a user on a calendar using Exchange Online cmdlets. It supports all standard Outlook calendar roles.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-O365CalendarPermissions -OwnerUPN "user@example.com" -UserUPN "otheruser@example.com" -AccessLevel "Editor"
```

Sets the permissions for the calendar of the user named in OwnerUPN to the access level named in AccessLevel for the user named in UserUPN.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Last Edit: 2025-09-04

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-O365CalendarPermissions {

    <#
    .SYNOPSIS
        Sets, updates, or removes permissions for a user on an Office 365 calendar (Exchange Online).

    .DESCRIPTION
        This function allows you to set, update, or remove permissions for a user on a calendar using Exchange Online cmdlets. It supports all standard Outlook calendar roles.

    .PARAMETER OwnerUPN
        The UserPrincipalName for the calendar owner whose calendar you want to modify. This parameter can be piped.

    .PARAMETER UserUPN
        The UserPrincipalName for the user who will be granted access to the calendar. This parameter can be piped.

    .PARAMETER AccessLevel
        The access level to grant to the user. Valid values are None, Owner, PublishingEditor, Editor, PublishingAuthor, Author, NoneditingAuthor, Reviewer, Contributor, AvailabilityOnly, LimitedDetails. This parameter can be piped.

    .PARAMETER Update
        Update the permissions for the user named in UserUPN. If this parameter is not used, the permissions for the user named in UserUPN will be added.

    .EXAMPLE
        Set-O365CalendarPermissions -OwnerUPN "user@example.com" -UserUPN "otheruser@example.com" -AccessLevel "Editor"
        Sets the permissions for the calendar of the user named in OwnerUPN to the access level named in AccessLevel for the user named in UserUPN.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2025-09-04

    .LINK
        https://scripts.lukeleigh.com
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string]$OwnerUPN,

        [Parameter(
            ParameterSetName = 'Default',    
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the user who will be granted access to the calendar. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string]$UserUPN,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the access level to grant to the user. The access level can be None, Owner, PublishingEditor, Editor, Reviewer, Author, NoneditingAuthor, PublishingAuthor, AvailabilityOnly or LimitedDetails. This parameter can be piped.')]
        [ValidateSet('None', 'Owner', 'PublishingEditor', 'Editor', 'PublishingAuthor', 'Author', 'NoneditingAuthor', 'Reviewer', 'Contributor', 'AvailabilityOnly', 'LimitedDetails')]
        [string]$AccessLevel,

        [Parameter(
            ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Update the permissions for the user named in User. This parameter can be piped. If this parameter is not used, the permissions for the user named in User will be added.')]
        [bool]$Update = $false

    )

    begin {
    
    }

    process {
        if ($PSCmdlet.ShouldProcess("$($OwnerUPN):\Calendar", "Set permissions for $UserUPN to $AccessLevel")) {
            try {
                $userDisplay = $UserUPN
                if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                    $userDisplay = $UserUPN
                }
                if ($AccessLevel -eq 'None') {
                    Remove-MailboxFolderPermission -Identity "$($OwnerUPN):\Calendar" -User $UserUPN -Confirm:$false -ErrorAction Stop
                    [PSCustomObject]@{
                        CalendarOwner = $OwnerUPN
                        User         = $userDisplay
                        AccessLevel  = $AccessLevel
                        Action       = 'Removed'
                        Success      = $true
                    }
                    return
                }
                if ($Update -eq $true) {
                    Set-MailboxFolderPermission -Identity "$($OwnerUPN):\Calendar" -User $UserUPN -AccessRights $AccessLevel -ErrorAction Stop
                    [PSCustomObject]@{
                        CalendarOwner = $OwnerUPN
                        User         = $userDisplay
                        AccessLevel  = $AccessLevel
                        Action       = 'Updated'
                        Success      = $true
                    }
                    return
                }
                Add-MailboxFolderPermission -Identity "$($OwnerUPN):\Calendar" -User $UserUPN -AccessRights $AccessLevel -ErrorAction Stop
                [PSCustomObject]@{
                    CalendarOwner = $OwnerUPN
                    User         = $userDisplay
                    AccessLevel  = $AccessLevel
                    Action       = 'Added'
                    Success      = $true
                }
            } catch {
                Write-Warning "Failed to set $AccessLevel permissions for $UserUPN on $OwnerUPN's calendar. $_"
                [PSCustomObject]@{
                    CalendarOwner = $OwnerUPN
                    User         = $UserUPN
                    AccessLevel  = $AccessLevel
                    Action       = if ($AccessLevel -eq 'None') { 'Remove' } elseif ($Update) { 'Update' } else { 'Add' }
                    Success      = $false
                    Error        = $_
                }
            }
        }
    }

    end {

    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Set-O365CalendarPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-O365CalendarPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

