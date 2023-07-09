function Set-O365CalendarPermissions {

    <#

    .SYNOPSIS
    Set-O365CalendarPermissions - A function to set the permissions for a calendar.
	
	.DESCRIPTION
    Set-O365CalendarPermissions - A function to set the permissions for a calendar. This function will only set the permissions for the calendar of the user named in Owner. It will not set the permissions for any other calendars that the user may have access to. This function will also remove any existing permissions for the user named in User when setting the permissions to none. Users with permissions already granted can be updated using the Update parameter.

    The AccessLevel parameter has been populated with the roles that are available within Outlook. The permissions assigned by each role are described in the parameter help.
	
	.PARAMETER Owner
    [string]Owner - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.

    .PARAMETER User
    [string]User - Enter the UserPrincipalName for the user who will be granted access to the calendar. This parameter can be piped.

    .PARAMETER AccessLevel
    [string]AccessLevel - Enter the access level to grant to the user. The access level can be None, Owner, PublishingEditor, Editor, Reviewer, Author, NoneditingAuthor, PublishingAuthor, AvailabilityOnly or LimitedDetails. This parameter can be piped.

    The AccessLevel parameter has been populated with the roles that are available within Outlook. The permissions assigned by each role are described in the following list:

    Author: CreateItems, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems
    Contributor: CreateItems, FolderVisible
    Editor: CreateItems, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems
    NonEditingAuthor: CreateItems, DeleteOwnedItems, FolderVisible, ReadItems
    Owner: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderContact, FolderOwner, FolderVisible, ReadItems
    PublishingAuthor: CreateItems, CreateSubfolders, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems
    PublishingEditor: CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems
    Reviewer: FolderVisible, ReadItems
    AvailabilityOnly: View only availability data
    LimitedDetails: View availability data with subject and location

    .PARAMETER Update
    [switch]Update - Update the permissions for the user named in User. This parameter can be piped. If this parameter is not used, the permissions for the user named in User will be added.
	
	.EXAMPLE
    Set-O365CalendarPermissions -Owner "user@example.com" -User "otheruser@example.com" -AccessLevel "Editor"

    Sets the permissions for the calendar of the user named in Owner to the access level named in AccessLevel for the user named in User.
    	
	.INPUTS
    You can pipe objects to these perameters.
    
    - Owner [string] - Enter the UserPrincipalName for the calendar owner whose calendar you want to query.
    - User [string] - Enter the UserPrincipalName for the user who will be granted access to the calendar.
    - AccessLevel [string] - Enter the access level to grant to the user. The access level can be None, Owner, PublishingEditor, Editor, Reviewer, Author, NoneditingAuthor, PublishingAuthor, AvailabilityOnly or LimitedDetails.
    - Update [switch] - Update the permissions for the user named in User. If this parameter is not used, the permissions for the user named in User will be added.
    	
	.OUTPUTS
    [string] - The output of this function is a string containing the name of the calendar and the permissions that have been set.
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.LINK
    https://scripts.lukeleigh.com
    Get-CalendarPermissions
    Remove-MailboxFolderPermission
    Add-MailboxFolderPermission
    Set-MailboxFolderPermission
    
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
        [string]$Owner,

        [Parameter(
            ParameterSetName = 'Default',    
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the user who will be granted access to the calendar. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string]$User,

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

        if ($PSCmdlet.ShouldProcess("$($Owner):\Calendar", "Set permissions for $User to $AccessLevel")) {

            if ( $AccessLevel -eq 'None' ) {
                Remove-MailboxFolderPermission -Identity "$($Owner):\Calendar" -User $User -Confirm:$false
                return
            }
            if ( $Update -eq $true ) {
                Set-MailboxFolderPermission -Identity "$($Owner):\Calendar" -User $User -AccessRights $AccessLevel
                return
            }
            if ( $Update -eq $false ) {
                Add-MailboxFolderPermission -Identity "$($Owner):\Calendar" -User $User -AccessRights $AccessLevel
                return
            }

        }

    }

    end {

    }

}
