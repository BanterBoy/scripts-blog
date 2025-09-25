<#
.SYNOPSIS
    Copies the group membership of one user to another user.

.DESCRIPTION
    This function copies the group membership of one user to another user. It can also align the destination user's group membership with the source user's by removing groups that the destination user is a member of but the source user is not.

.PARAMETER SourceUser
    The SamAccountName of the user you are copying from.

.PARAMETER DestinationUser
    The SamAccountName of the user you are copying to.

.PARAMETER AlignMembership
    If specified, aligns the destination user's group membership with the source user's by removing groups that the destination user is a member of but the source user is not.

.EXAMPLE
    Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2"
    Copies the group membership of User1 to User2.

.EXAMPLE
    Copy-GroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
    Copies the group membership of User1 to User2 and aligns User2's group membership with User1's.

.NOTES
    Author: Your Name
    Date: Today's Date
#>
#requires -PSEdition Desktop

function Copy-GroupMembership {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceUser,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationUser,

        [Parameter()]
        [switch]$AlignMembership
    )

    process {
        if ($PSCmdlet.ShouldProcess("$DestinationUser", "Copy group memberships from $SourceUser")) {
            try {
                # Retrieve source user groups
                Write-Verbose "Retrieving groups for SourceUser: $SourceUser"
                $SourceUserObject = Get-ADUser -Identity $SourceUser -Properties MemberOf
                $SourceUserGroups = @($SourceUserObject.MemberOf)

                # Align membership if the switch is specified
                if ($AlignMembership) {
                    Write-Verbose "Aligning group memberships for DestinationUser: $DestinationUser"
                    $DestinationUserObject = Get-ADUser -Identity $DestinationUser -Properties MemberOf
                    $DestinationUserGroups = @($DestinationUserObject.MemberOf)

                    foreach ($Group in $DestinationUserGroups) {
                        if ($SourceUserGroups -notcontains $Group) {
                            try {
                                Write-Verbose "Removing $DestinationUser from group: $Group"
                                Remove-ADGroupMember -Identity $Group -Members $DestinationUser -Confirm:$false -ErrorAction Stop
                            }
                            catch {
                                Write-Error "Failed to remove $DestinationUser from group $Group. $_"
                            }
                        }
                    }
                }

                # Add destination user to source user's groups
                foreach ($Group in $SourceUserGroups) {
                    try {
                        Write-Verbose "Adding $DestinationUser to group: $Group"
                        Add-ADGroupMember -Identity $Group -Members $DestinationUser -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Error "Failed to add $DestinationUser to group $Group. $_"
                    }
                }
            }
            catch {
                Write-Error "An error occurred while processing group memberships: $_"
            }
        }
    }
}
