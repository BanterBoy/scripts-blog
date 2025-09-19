<#
.SYNOPSIS
    Retrieves mailbox permissions for Office 365 mailboxes.

.DESCRIPTION
    The Get-O365MailboxPermissions function retrieves mailbox permissions for Office 365 mailboxes. It queries the mailbox permissions for the specified mailbox owners and returns the relevant information.

.PARAMETER UserPrincipalName
    Specifies the UserPrincipalName for the mailbox owner whose mailbox permissions you want to query. This parameter can accept multiple values and can be piped. If not specified, the function will retrieve mailbox permissions for all mailbox owners.

.INPUTS
    None. You cannot pipe objects to this function.

.OUTPUTS
    System.String
    The function returns a string containing the mailbox permissions information.

.EXAMPLE
    Get-O365MailboxPermissions -UserPrincipalName user1@contoso.com
    Retrieves mailbox permissions for the mailbox owner with the UserPrincipalName 'user1@contoso.com'.

.EXAMPLE
    'user1@contoso.com', 'user2@contoso.com' | Get-O365MailboxPermissions
    Retrieves mailbox permissions for the mailbox owners with the UserPrincipalNames 'user1@contoso.com' and 'user2@contoso.com'.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-O365MailboxPermissions {

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
            HelpMessage = 'Enter the UserPrincipalName for the mailbox owner whose mailbox you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserPrincipalName
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Querying mailbox permissions for")) {
            foreach ($User in $UserPrincipalName) {
                try {
                    # Full Access permissions
                    $FullAccessPermissions = Get-MailboxPermission -Identity $User -ErrorAction Stop | Where-Object { $_.IsInherited -eq $false -and $_.AccessRights -contains 'FullAccess' }
                    foreach ($Permission in $FullAccessPermissions) {
                        $userDisplay = $Permission.User.DisplayName
                        if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                            $userDisplay = $Permission.User
                        }
                        [PSCustomObject]@{
                            MailboxOwner      = $User
                            PermissionType    = 'FullAccess'
                            User              = $userDisplay
                            UserType          = $Permission.User.UserType
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send As permissions
                    $SendAsPermissions = Get-RecipientPermission -Identity $User -ErrorAction SilentlyContinue | Where-Object { $_.Trustee -ne $null -and $_.AccessRights -contains 'SendAs' }
                    foreach ($Permission in $SendAsPermissions) {
                        $userDisplay = $Permission.Trustee
                        if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                            $userDisplay = $Permission.Trustee
                        }
                        [PSCustomObject]@{
                            MailboxOwner      = $User
                            PermissionType    = 'SendAs'
                            User              = $userDisplay
                            UserType          = 'Unknown'
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send on Behalf permissions
                    $MailboxObj = Get-Mailbox -Identity $User -ErrorAction SilentlyContinue
                    if ($MailboxObj -and $MailboxObj.GrantSendOnBehalfTo) {
                        foreach ($Delegate in $MailboxObj.GrantSendOnBehalfTo) {
                            $userDisplay = $Delegate
                            if ([string]::IsNullOrWhiteSpace($userDisplay)) {
                                $userDisplay = $Delegate
                            }
                            [PSCustomObject]@{
                                MailboxOwner      = $User
                                PermissionType    = 'SendOnBehalf'
                                User              = $userDisplay
                                UserType          = 'Unknown'
                                AccessRights      = 'Send on Behalf'
                            }
                        }
                    }
                } catch {
                    Write-Warning "Could not retrieve permissions for mailbox: $User. $_"
                }
            }
        }
    }

    end {
        
    }

}