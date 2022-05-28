---
layout: post
title: Update-CalendarPermissions.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Update-CalendarPermission {

	<#
	Update-CalendarPermission -Identify <mailbox> -User <xxx> -Permission <permission>
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

	#Add Exchange 2010 Management Shell if needed
	if (! (Get-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:SilentlyContinue)) {
		Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:Stop
	}

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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Update-CalendarPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-CalendarPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
