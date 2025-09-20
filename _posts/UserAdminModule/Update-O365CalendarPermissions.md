---
layout: post
title: Update-O365CalendarPermissions.ps1
description: "Updates existing Microsoft 365 calendar permissions with new roles or removes access."
date: 2025-09-19
permalink: /_posts/UserAdminModule/Update-O365CalendarPermissions/
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

Update-O365CalendarPermissions - A function to update the permissions for a calendar.

#### Detailed Description

Update-O365CalendarPermissions - A function to update the permissions for a calendar. This function will apply the permission to the calendar with the permissions of the user specified. You can add permissions by specifying a specific permission or by specifying the role of the user. You can remove user permissions by specifying the permission 'remove'.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Update-O365CalendarPermissions -Identity <mailbox> -User <xxx> -Permission <permission>
```

Returns the permissions for the calendar of the user named in UserPrincipalName

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Luke Leigh Website:    https://scripts.lukeleigh.com/ LinkedIn:   https://www.linkedin.com/in/lukeleigh/ GitHub:     https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Update-O365CalendarPermissions {

	<#

    .SYNOPSIS
    Update-O365CalendarPermissions - A function to update the permissions for a calendar.
	
	.DESCRIPTION
    Update-O365CalendarPermissions - A function to update the permissions for a calendar. This function will apply the permission to the calendar with the permissions of the user specified. You can add permissions by specifying a specific permission or by specifying the role of the user. You can remove user permissions by specifying the permission 'remove'.
	
	.PARAMETER Identity
	[string]Identity - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.

	.PARAMETER User
	[string]User - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.

	.PARAMETER Permission
	[string]Permission - Select a permission to apply to the calendar. You can also select a role to apply to the calendar. The following roles are available: Reviewer, Contributor, Editor, Author, PublishingAuthor, PublishingEditor, Owner, None, FolderVisible, FolderContact, FolderOwner, CreateSubfolders, DeleteAllItems, EditAllItems, DeleteOwnedItems, EditOwnedItems, CreateItems, ReadItems, AvailabilityOnly, LimitedDetails, Remove. The role 'Remove' will remove the permission from the user.
	
	.EXAMPLE
    Update-O365CalendarPermissions -Identity <mailbox> -User <xxx> -Permission <permission>

	Returns the permissions for the calendar of the user named in UserPrincipalName

	.INPUTS
    You can pipe objects to these perameters.
    
    - Identity [string] - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.
	- User [string] - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.
	- Permission [string] - Select a permission to apply to the calendar. You can also select a role to apply to the calendar. The following roles are available: Reviewer, Contributor, Editor, Author, PublishingAuthor, PublishingEditor, Owner, None, FolderVisible, FolderContact, FolderOwner, CreateSubfolders, DeleteAllItems, EditAllItems, DeleteOwnedItems, EditOwnedItems, CreateItems, ReadItems, AvailabilityOnly, LimitedDetails, Remove. The role 'Remove' will remove the permission from the user.
	
	.OUTPUTS
    [string] - Returns the permissions for the calendar of the user named in UserPrincipalName
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.LINK
    https://scripts.lukeleigh.com
    Get-MailboxFolderPermission
    Get-Mailbox
    New-Object
    Write-Output

    #>

	param
	(
		[Parameter(Mandatory = $true,
			HelpMessage = "Enter a mailbox where you apply permission to")]
		[ValidateNotNullOrEmpty()]
		[string]$Identity,

		[Parameter(Mandatory = $true, HelpMessage = "Enter a user/group who will be granted the permission  syntax domain\xxx might be needed")]
		[ValidateNotNullOrEmpty()]
		[string]$User,

		[parameter(Mandatory = $true, HelpMessage = "Enter a valid permission set")]
		[ValidateSet("ReadItems", "CreateItems", "EditOwnedItems", "DeleteOwnedItems", "EditAllItems", "DeleteAllItems", "CreateSubfolders", "FolderOwner", "FolderContact", "FolderVisible", "None", "Owner", "PublishingEditor", "Editor", "PublishingAuthor", "Author", "NonEditingAuthor", "Reviewer", "Contributor", "AvailabilityOnly", "LimitedDetails", "Remove")]
		[string]$Permission
	)

	$MBX = Get-Mailbox $identity

	$CalendarName = (Get-MailboxFolderStatistics -Identity $MBX.alias -FolderScope Calendar | Select-Object -First 1).Name
	$folderID = $MBX.alias + ':\' + $CalendarName

	if ($Permission -eq 'remove') {
		# special case, remove permission from user
		Remove-MailboxFolderPermission -Identity $folderID -User $User -Confirm:$False
	}
	else {
		$i = @(Get-MailboxFolderPermission -Identity $folderID -User $User -ErrorAction SilentlyContinue).count
		if ($i -eq 0) {
			# not in ACL, add permission
			Add-MailboxFolderPermission -Identity $folderID -User $User -AccessRights $Permission > $Null
		}
		else {
			# user is already in ACL, change permission
			Set-MailboxFolderPermission -Identity $folderID -User $User -AccessRights $Permission
		}
	
		# display new permission for $user
		Get-MailboxFolderPermission -Identity $folderID -User $User
	}
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Update-O365CalendarPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-O365CalendarPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

