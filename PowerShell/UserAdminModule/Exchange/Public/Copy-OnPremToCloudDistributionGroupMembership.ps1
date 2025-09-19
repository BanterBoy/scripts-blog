Function Copy-OnPremToCloudDistributionGroupMembership {
    <#
    .SYNOPSIS
    Copies the distribution group membership from an on-premise distribution group to a cloud distribution group.
    
    .DESCRIPTION
    This function copies the distribution group membership from an on-premise distribution group to a cloud distribution group.
    
    .PARAMETER OnPremGroup
    The name of the on-premise distribution group.
    
    .PARAMETER CloudGroup
    The name of the cloud distribution group.
    
    .EXAMPLE
    Copy-OnPremToCloudDistributionGroupMembership -OnPremGroup "OnPremGroup1" -CloudGroup "CloudGroup1"
    Copies the distribution group membership from OnPremGroup1 to CloudGroup1.
    
    .NOTES
    Author: Unknown
    Date: Unknown
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter( Mandatory = $true,
            HelpMessage = "Enter the name of the on-premise distribution group."
        )]
        [string]
        $OnPremGroup,

        [Parameter( Mandatory = $true,
            HelpMessage = "Enter the name of the cloud distribution group."
        )]
        [string]
        $CloudGroup
    )

    process {
        if ($PSCmdlet.ShouldProcess("$CloudGroup", "Copy On-Premise Group $OnPremGroup Memberships")) {
            # Get members of the on-premise distribution group
            $OnPremGroupMembers = Get-DistributionGroupMember -Identity $OnPremGroup -ResultSize Unlimited

            # Get members of the cloud distribution group
            $CloudGroupMembers = Get-DistributionGroupMember -Identity $CloudGroup -ResultSize Unlimited

            # Add members to the cloud distribution group
            foreach ($Member in $OnPremGroupMembers) {
                if ($CloudGroupMembers -notcontains $Member) {
                    Add-DistributionGroupMember -Identity $CloudGroup -Member $Member.PrimarySmtpAddress -ErrorAction SilentlyContinue
                }
            }
        }
    }
}