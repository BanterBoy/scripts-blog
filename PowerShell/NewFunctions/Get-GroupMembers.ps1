<#
.SYNOPSIS
    Get-GroupMembers

.DESCRIPTION
    This function exports the users within Active Directory groups that match a specified search string.

.PARAMETER GroupName
    Specifies the name of the group to search for. This parameter supports wildcards.

.EXAMPLE
    Get-GroupMembers -GroupName "Domain Admins"
    Outputs a list of users in the Active Directory groups matching the search string.

.OUTPUTS
    [Object]

.NOTES
    Author: Luke Leigh
    Date: 05/07/2023
    Version: 0001
    Changelog:
        - initial version

.INPUTS
    [string]GroupName
#>
function Get-GroupMembers {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ggm')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [Alias('gn')]
        [String]$GroupName
    )

    begin {

    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            $groups = Get-ADGroup -Filter ' Name -like $GroupName '
            $groups | ForEach-Object -Process {
                $groupMembers = Get-ADGroupMember -Identity $_.SamAccountName
                $groupMembers |
                ForEach-Object -Process {
                    Get-ADUser -Filter ' SamAccountName -like $_.SamAccountName ' -Properties *
                }
            }
        }
    }
    end {

    }
}
