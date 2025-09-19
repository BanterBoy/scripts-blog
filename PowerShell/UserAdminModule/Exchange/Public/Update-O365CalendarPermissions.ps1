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
