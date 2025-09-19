Function Copy-DistributionGroupMembership {
    <#
    .SYNOPSIS
    Copies the distribution group membership of one user to another user.
    
    .DESCRIPTION
    This function copies the distribution group membership of one user to another user. It can also align the destination user's distribution group membership with the source user's.
    
    .PARAMETER SourceUser
    The SamAccountName of the user you are copying from.
    
    .PARAMETER DestinationUser
    The SamAccountName of the user you are copying to.
    
    .PARAMETER AlignMembership
    If specified, aligns the destination user's distribution group membership with the source user's.
    
    .EXAMPLE
    Copy-DistributionGroupMembership -SourceUser "User1" -DestinationUser "User2" -AlignMembership
    Copies the distribution group membership of User1 to User2 and aligns User2's distribution group membership with User1's.
    
    .NOTES
    Author: Unknown
    Date: Unknown
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName for the user you are copying from."
        )]
        [string]
        $SourceUser,

        [Parameter( Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the SamAccountName of the user you are copying to."
        )]
        [string]
        $DestinationUser,

        [Parameter(
            HelpMessage = "Align the destination user's distribution group membership with the source user's."
        )]
        [switch]
        $AlignMembership
    )

    process {
        if ($PSCmdlet.ShouldProcess("$DestinationUser", "Copy User $SourceUser Distribution Group Memberships")) {
            $SourceUserGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember -Identity $_.Identity -ResultSize Unlimited).PrimarySmtpAddress -contains $SourceUser }

            if ($AlignMembership) {
                $DestinationUserGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember -Identity $_.Identity -ResultSize Unlimited).PrimarySmtpAddress -contains $DestinationUser }
                foreach ($Group in $DestinationUserGroups) {
                    if ($SourceUserGroups -notcontains $Group) {
                        Remove-DistributionGroupMember -Identity $Group.Identity -Member $DestinationUser -Confirm:$false
                    }
                }
            }

            foreach ($Group in $SourceUserGroups) {
                Add-DistributionGroupMember -Identity $Group.Identity -Member $DestinationUser -ErrorAction SilentlyContinue
            }
        }
    }
}