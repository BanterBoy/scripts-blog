<#
    .SYNOPSIS
        Compares the group membership of two Active Directory users.
    
    .DESCRIPTION
        The Compare-GroupMembership function compares the group membership of two Active Directory users and returns a list of all the groups that either user is a member of, along with a Boolean value indicating whether each user is a member of each group.
    
    .PARAMETER SourceUser
        The username of the source user to compare. Supports pipeline input.
    
    .PARAMETER DestinationUser
        The username of the destination user to compare. Supports pipeline input.
    
    .EXAMPLE
        Compare-GroupMembership -SourceUser "jdoe" -DestinationUser "asmith"
    
        This example compares the group membership of the "jdoe" and "asmith" users.
    
    .NOTES
        Author: Your Name
        Date:   Today's Date
#>
#requires -PSEdition Desktop

function Compare-GroupMembership {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $SourceUser,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $DestinationUser
    )

    begin {
        Write-Verbose "Starting group membership comparison..."
    }

    process {
        try {
            # Retrieve source user groups
            Write-Verbose "Retrieving groups for SourceUser: $SourceUser"
            $SourceUserObject = Get-ADUser -Identity $SourceUser -Properties MemberOf, PrimaryGroup
            $SourceUserGroups = @($SourceUserObject.MemberOf)
            $SourceUserPrimaryGroup = (Get-ADGroup -Identity $SourceUserObject.PrimaryGroup).DistinguishedName
            $SourceUserGroups += $SourceUserPrimaryGroup
        }
        catch {
            Write-Error "Failed to retrieve groups for SourceUser: $SourceUser. $_"
            return
        }

        try {
            # Retrieve destination user groups
            Write-Verbose "Retrieving groups for DestinationUser: $DestinationUser"
            $DestinationUserObject = Get-ADUser -Identity $DestinationUser -Properties MemberOf, PrimaryGroup
            $DestinationUserGroups = @($DestinationUserObject.MemberOf)
            $DestinationUserPrimaryGroup = (Get-ADGroup -Identity $DestinationUserObject.PrimaryGroup).DistinguishedName
            $DestinationUserGroups += $DestinationUserPrimaryGroup
        }
        catch {
            Write-Error "Failed to retrieve groups for DestinationUser: $DestinationUser. $_"
            return
        }

        # Combine and deduplicate all groups
        Write-Verbose "Combining and deduplicating group memberships..."
        $AllGroups = ($SourceUserGroups + $DestinationUserGroups) | Sort-Object -Unique

        # Retrieve group names
        Write-Verbose "Retrieving group names..."
        $GroupNames = @{}
        foreach ($Group in $AllGroups) {
            try {
                $GroupObject = Get-ADGroup -Identity $Group -ErrorAction Stop
                $GroupNames[$Group] = $GroupObject.Name
            }
            catch {
                Write-Verbose "Failed to retrieve group name for $Group. $_"
            }
        }

        # Generate output
        Write-Verbose "Generating output..."
        foreach ($Group in $AllGroups) {
            $GroupName = $GroupNames[$Group]
            $SourceUserMember = $SourceUserGroups -contains $Group
            $DestinationUserMember = $DestinationUserGroups -contains $Group

            [PSCustomObject]@{
                GroupName         = $GroupName
                DistinguishedName = $Group
                $SourceUser       = $SourceUserMember
                $DestinationUser  = $DestinationUserMember
            }
        }
    }

    end {
        Write-Verbose "Group membership comparison completed."
    }
}
