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
