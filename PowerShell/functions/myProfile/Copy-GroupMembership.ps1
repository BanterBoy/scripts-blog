Function Copy-GroupMembership {

    <#
    .SYNOPSIS
        Copy Group Membership from an existing Active Directory User to another Active Directory User
    .DESCRIPTION
        This function will copy a users Active Directory Group Membership to another Active Directory User by querying a users current membership and adding the same groups to another user.
    .EXAMPLE
        PS C:\> Copy-GroupMembership -CopyMembershipFrom SAMACCOUNTNAME -CopyMembershipTo SAMACCOUNTNAME
        Copies all group membership from one Active Directory User and replicates on another Active Directory User
    .INPUTS
        Active Directory SamAccountName
    .OUTPUTS
        Outputs a list of Active Directory Groups the Active Directory User has been added to.
    .NOTES
        General notes
    #>

    [CmdletBinding()]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName for the user you are copying from."
        )]
        [string]
        $CopyMembershipFrom,

        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName of the user you are copying to."
        )]
        [string]
        $CopyMembershipTo

        )

    $GroupMembership = Get-ADUser -Identity $CopyMembershipFrom -Properties memberof
    foreach ($Group in $GroupMembership.memberof) {
        if ($Group -notcontains $Group.SamAccountName) {
            Add-ADGroupMember -Identity $Group $CopyMembershipTo -ErrorAction SilentlyContinue
            Write-Output $Group
        } 
    }
}
