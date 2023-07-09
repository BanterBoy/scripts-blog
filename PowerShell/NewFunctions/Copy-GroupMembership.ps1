function Copy-GroupMembership {

    <#
	.SYNOPSIS
		Copy Group Membership from an existing Active Directory User to another Active Directory User
	
	.DESCRIPTION
		This function will copy a users Active Directory Group Membership to another Active Directory User by querying a users current membership and adding the same groups to another user.
	
	.PARAMETER CopyMembershipFrom
		Enter the SamAccountName for the user you are copying from.
	
	.PARAMETER CopyMembershipTo
		Enter the SamAccountName of the user you are copying to.
	
	.EXAMPLE
		PS C:\> Copy-GroupMembership -CopyMembershipFrom SAMACCOUNTNAME -CopyMembershipTo SAMACCOUNTNAME
		Copies all group membership from one Active Directory User and replicates on another Active Directory User
	
	.OUTPUTS
		Outputs a list of Active Directory Groups the Active Directory User has been added to.
	
	.NOTES
		General notes
	
	.INPUTS
		Active Directory SamAccountName
	#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('cgm')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the SamAccountName for the user you are copying from.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cmf')]
        [string]$CopyMembershipFrom,
	
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 2,
            HelpMessage = 'Enter the SamAccountName of the user you are copying to.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cmt')]
        [string]$CopyMembershipTo
    )
	
    begin {
    }
	
    process {
		
        if ($PSCmdlet.ShouldProcess("$CopyMembershipTo", "Copying Group Membership from $($CopyMembershipFrom)")) {

            $GroupMembership = Get-ADUser -Identity $CopyMembershipFrom -Properties memberof
            foreach ($Group in $GroupMembership.memberof) {
                try {
                    if ($Group -notcontains $Group.SamAccountName) {
                        Add-ADGroupMember -Identity $Group $CopyMembershipTo -ErrorAction Stop
                        Write-Output "Added to - $($Group)"
                    }
                }
                catch {
                    Write-Warning "$($_)"
                    Write-Verbose "$($Group)" -Verbose
                }
            }
        }
    }

    end {
    }

}
