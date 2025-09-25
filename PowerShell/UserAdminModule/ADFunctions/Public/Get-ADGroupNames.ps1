<#
.SYNOPSIS
    Extracts members of an Active Directory group based on the group name.

.DESCRIPTION
    The Get-ADGroupNames function extracts members of an Active Directory group based on the group name. 
    It supports wildcards in the group name.

.PARAMETER GroupName
    Specifies the name of the group to search for. This field supports wildcards.

.EXAMPLE
    Get-ADGroupNames -GroupName "Domain Admins"
    Extracts members of the "Domain Admins" group.

.EXAMPLE
    Get-ADGroupNames -GroupName "Sales*"
    Extracts members of all groups starting with "Sales".

.INPUTS
    None.

.OUTPUTS
    Returns a list of members of the specified group.

.NOTES
    Author: Your Name
    Date:   Today's date
#>
#requires -PSEdition Desktop
function Get-ADGroupNames {
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
        # Update-FormatData -PrependPath "$PSScriptRoot\Get-ADGroupNames.Format.ps1xml"
    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            Get-ADGroup -Filter "Name -like '$GroupName'" -Properties *
        }
    }

    end {
    }
}
