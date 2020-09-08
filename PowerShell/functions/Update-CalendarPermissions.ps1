########################################
# Update-CalendarPermission.ps1 -Identify <mailbox> -User <xxx> -Permission <permission>

param
(
	[Parameter(Mandatory = $true, HelpMessage = "Enter a mailbox where you apply permission to")]
	[ValidateNotNullOrEmpty()]
	[string]$Identity,
	[Parameter(Mandatory = $true, HelpMessage = "Enter a user/group who will be granted the permission  syntax domain\xxx might be needed")]
	[ValidateNotNullOrEmpty()]
	[string]$User = "",
	[parameter(Mandatory = $true, HelpMessage = "Enter a valid permission set")]
	[ValidateSet("ReadItems", "CreateItems", "EditOwnedItems", "DeleteOwnedItems", "EditAllItems", "DeleteAllItems", "CreateSubfolders", "FolderOwner", "FolderContact", "FolderVisible", "None", "Owner", "PublishingEditor", "Editor", "PublishingAuthor", "Author", "NonEditingAuthor", "Reviewer", "Contributor", "AvailabilityOnly", "LimitedDetails", "Remove")]
	[string]$Permission = ""
)

#Add Exchange 2010 Management Shell if needed
if (! (Get-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:SilentlyContinue))
{
	Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:Stop
}

$MBX = Get-Mailbox $identity

$CalendarName = (Get-MailboxFolderStatistics -Identity $MBX.alias -FolderScope Calendar | Select-Object -First 1).Name
$folderID = $MBX.alias + ':\' + $CalendarName

if ($Permission -eq 'remove')
{
	# special case, remove permission from user
	Remove-MailboxFolderPermission -Identity $folderID -User $User -Confirm:$False
}
else
{
	$i = @(Get-MailboxFolderPermission -Identity $folderID -User $User -ErrorAction SilentlyContinue).count
	if ($i -eq 0)
	{
		# not in ACL, add permission
		Add-MailboxFolderPermission -Identity $folderID -User $User -AccessRights $Permission > $Null
	}
	else
	{
		# user is already in ACL, change permission
		Set-MailboxFolderPermission -Identity $folderID -User $User -AccessRights $Permission
	}
	
	# display new permission for $user
	Get-MailboxFolderPermission -Identity $folderID -User $User
}

