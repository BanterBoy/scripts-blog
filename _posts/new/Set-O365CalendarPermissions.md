---
layout: post
title: Set-O365CalendarPermissions.ps1
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

**_@GitHub Copilot_** - This is a PowerShell script that sets permissions for a user on a calendar in Office 365. The script defines a function called Set-O365CalendarPermissions that takes two parameters: AccessLevel and Update. AccessLevel is a mandatory parameter that specifies the level of access to grant to the user. The parameter is validated using the ValidateSet attribute to ensure that only valid values are accepted. Update is an optional parameter that specifies whether to update the permissions for the user or add new permissions.

The function begins by checking if the ShouldProcess method of the PSCmdlet object returns true. This method is used to confirm that the user wants to perform the operation. If ShouldProcess returns true, the function checks if the AccessLevel parameter is set to 'None'. If it is, the function removes the permissions for the user using the Remove-MailboxFolderPermission cmdlet. If AccessLevel is not set to 'None', the function checks if the Update parameter is set to true. If it is, the function updates the permissions for the user using the Set-MailboxFolderPermission cmdlet. If Update is false, the function adds new permissions for the user using the Add-MailboxFolderPermission cmdlet.

Overall, this script is a useful tool for managing calendar permissions in Office 365. It provides a simple and flexible way to grant or update permissions for users on a calendar. However, the script could be improved by adding more error handling and logging to make it more robust and reliable. Additionally, the script could be made more readable by adding comments and formatting the code to make it easier to understand.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here's an example of how to use the Set-O365CalendarPermissions function:

```
Set-O365CalendarPermissions -Owner john.doe@contoso.com -User jane.doe@contoso.com -AccessLevel Editor -Update $true
```

In this example, we're setting the calendar permissions for the user 'jane.doe@contoso.com' on the calendar owned by 'john.doe@contoso.com' to 'Editor' level. We're also setting the 'Update' parameter to $true, which means that we want to update the existing permissions for the user rather than adding new permissions.

Note that you'll need to replace 'john.doe@contoso.com' and 'jane.doe@contoso.com' with the actual email addresses of the calendar owner and user, respectively. You'll also need to specify the appropriate access level for your needs.

**_@BanterBoy:_** - What are the different access levels available for calendar permissions in Office 365?

**_@GitHub Copilot_** - There are several access levels available for calendar permissions in Office 365. These include:

- None: The user has no access to the calendar.
- Owner: The user has full control over the calendar, including the ability to add and remove other users' permissions.
- PublishingEditor: The user can create, read, modify, and delete all items and files, and can create subfolders. The user cannot delete the calendar itself.
- Editor: The user can create, read, modify, and delete all items and files.
- Reviewer: The user can read items and files only.
- Author: The user can create and read items and files, and modify and delete items and files that they create.
- NoneditingAuthor: The user can create and read items and files, but cannot modify or delete any items or files.
- PublishingAuthor: The user can create and read items and files, and create subfolders. The user cannot modify or delete items or files, or delete the calendar itself.
- Contributor: The user can create items and files only. The user cannot read, modify, or delete any items or files.
- AvailabilityOnly: The user can see only free/busy information for the calendar.
- LimitedDetails: The user can see free/busy information, subject, and location for calendar items.

These access levels provide a range of options for controlling who can access and modify calendar information in Office 365.

---

#### Script

```powershell
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

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Set-O365CalendarPermissions.ps1')">
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

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
