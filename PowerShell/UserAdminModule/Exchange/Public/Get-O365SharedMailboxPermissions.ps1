<#
.SYNOPSIS
    Retrieves permissions for Office 365 shared mailboxes.

.DESCRIPTION
    The Get-O365SharedMailboxPermissions function retrieves permissions for Office 365 shared mailboxes. It queries the mailbox permissions for the specified shared mailbox owners and returns the relevant information.

.PARAMETER SharedMailboxIdentity
    Specifies the identity (name or email address) of the shared mailbox whose permissions you want to query. This parameter can accept multiple values and can be piped. If not specified, the function will retrieve permissions for all shared mailboxes.

.INPUTS
    None. You cannot pipe objects to this function.

.OUTPUTS
    System.String
    The function returns a string containing the shared mailbox permissions information.

.EXAMPLE
    Get-O365SharedMailboxPermissions -SharedMailboxIdentity shared@contoso.com
    Retrieves permissions for the shared mailbox with the identity 'shared@contoso.com'.

.EXAMPLE
    'shared1@contoso.com', 'shared2@contoso.com' | Get-O365SharedMailboxPermissions
    Retrieves permissions for the shared mailboxes with the identities 'shared1@contoso.com' and 'shared2@contoso.com'.

.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Get-O365SharedMailboxPermissions {

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
            HelpMessage = 'Enter the identity for the shared mailbox you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$SharedMailboxIdentity
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$SharedMailboxIdentity", "Querying shared mailbox permissions for")) {
            foreach ($Mailbox in $SharedMailboxIdentity) {
                try {
                    # Full Access permissions
                    $FullAccessPermissions = Get-MailboxPermission -Identity $Mailbox -ErrorAction Stop | Where-Object { $_.IsInherited -eq $false -and $_.AccessRights -contains 'FullAccess' }
                    foreach ($Permission in $FullAccessPermissions) {
                        [PSCustomObject]@{
                            MailboxIdentity   = $Mailbox
                            PermissionType    = 'FullAccess'
                            User              = $Permission.User.DisplayName
                            UserType          = $Permission.User.UserType
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send As permissions
                    $SendAsPermissions = Get-RecipientPermission -Identity $Mailbox -ErrorAction SilentlyContinue | Where-Object { $_.Trustee -ne $null -and $_.AccessRights -contains 'SendAs' }
                    foreach ($Permission in $SendAsPermissions) {
                        [PSCustomObject]@{
                            MailboxIdentity   = $Mailbox
                            PermissionType    = 'SendAs'
                            User              = $Permission.Trustee
                            UserType          = 'Unknown'
                            AccessRights      = $Permission.AccessRights
                        }
                    }

                    # Send on Behalf permissions
                    $MailboxObj = Get-Mailbox -Identity $Mailbox -ErrorAction SilentlyContinue
                    if ($MailboxObj -and $MailboxObj.GrantSendOnBehalfTo) {
                        foreach ($User in $MailboxObj.GrantSendOnBehalfTo) {
                            [PSCustomObject]@{
                                MailboxIdentity   = $Mailbox
                                PermissionType    = 'SendOnBehalf'
                                User              = $User
                                UserType          = 'Unknown'
                                AccessRights      = 'Send on Behalf'
                            }
                        }
                    }
                } catch {
                    Write-Warning "Could not retrieve permissions for mailbox: $Mailbox. $_"
                }
            }
        }
    }

    end {
    }
}