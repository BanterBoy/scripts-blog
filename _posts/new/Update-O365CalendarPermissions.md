---
layout: post
title: Update-O365CalendarPermissions.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script is designed to update permissions for a specified user on a specified calendar in Office 365. The script takes in three parameters: the mailbox alias, the name of the calendar, and the permission level to be set. The script first constructs the folder ID for the specified calendar by concatenating the mailbox alias and the calendar name.

If the permission level is set to 'remove', the script removes the specified user's permission from the calendar using the Remove-MailboxFolderPermission cmdlet. If the permission level is not 'remove', the script checks if the specified user is already in the Access Control List (ACL) for the calendar. If the user is not in the ACL, the script adds the specified user to the ACL with the specified permission level using the Add-MailboxFolderPermission cmdlet. If the user is already in the ACL, the script changes the user's permission level to the specified level using the Set-MailboxFolderPermission cmdlet.

Finally, the script displays the new permission level for the specified user on the specified calendar using the Get-MailboxFolderPermission cmdlet. The cursor is on line 90, which is the end of the if-else block that sets or changes the user's permission level.

To improve the readability of this code, the script could benefit from more descriptive variable names. Additionally, the script could be refactored to use functions to break up the code into smaller, more manageable pieces. In terms of performance, the script could be optimized to reduce the number of cmdlets called, such as by checking if the user is in the ACL before calling Get-MailboxFolderPermission.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are some examples of how you could use this script:

1. To add 'JohnDoe' with 'Editor' permission to the 'Marketing' calendar for the 'jane.doe@contoso.com' mailbox:

```
.\Update-O365CalendarPermissions.ps1 -MailboxAlias 'jane.doe' -CalendarName 'Marketing' -User 'JohnDoe' -Permission 'Editor'
```

2. To remove 'JaneDoe' from the 'Sales' calendar for the 'john.doe@contoso.com' mailbox:

```
.\Update-O365CalendarPermissions.ps1 -MailboxAlias 'john.doe' -CalendarName 'Sales' -User 'JaneDoe' -Permission 'remove'
```

3. To change 'JohnDoe' from 'Editor' to 'Reviewer' permission on the 'Engineering' calendar for the 'jane.doe@contoso.com' mailbox:

```
.\Update-O365CalendarPermissions.ps1 -MailboxAlias 'jane.doe' -CalendarName 'Engineering' -User 'JohnDoe' -Permission 'Reviewer'
```

Note that you will need to have the necessary permissions to modify the calendar in order for this script to work.

---

#### Script

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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Update-O365CalendarPermissions.ps1')">
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
