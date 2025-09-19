<#
.SYNOPSIS
    Get-ADGroupMembers

.DESCRIPTION
    This function exports the users within Active Directory groups that match a specified search string.

.PARAMETER GroupName
    Specifies the name of the group to search for. This parameter supports wildcards.

.EXAMPLE
    Get-ADGroupMembers -GroupName "Domain Admins"
    Outputs a list of users in the Active Directory groups matching the search string.

.NOTES
    Author: Luke Leigh
    Date: 05/07/2023
    Version: 0001
    Changelog:
        - initial version

.INPUTS
    [string]GroupName
#>
function Get-ADGroupMembers {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [String]$GroupName = '*'
    )

    begin {
        # Update-FormatData -PrependPath "$PSScriptRoot\Get-ADGroupMembers.Format.ps1xml"
    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            $groups = Get-ADGroup -Filter "Name -like '$GroupName'"
            foreach ($group in $groups) {
                $groupMembers = Get-ADGroupMember -Identity $group.SamAccountName
                foreach ($member in $groupMembers) {
                    if ($member.objectClass -eq "user") {
                        $user = Get-ADUser -Identity $member.SamAccountName -Properties *
                        Write-Output $user
                    }
                }
            }
        }
    }
}
