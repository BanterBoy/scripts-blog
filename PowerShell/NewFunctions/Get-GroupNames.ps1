function Get-GroupNames {

    <#
	.SYNOPSIS
		Get-GroupNames 
	
	.DESCRIPTION
		Get-GroupNames - This function will query Active Directory and export the details for the matching Groups.
	
	.PARAMETER GroupName
		Enter the group name that you want to search for. This field supports wildcards..
	
	.EXAMPLE
		Get-GroupNames -GroupName "*Admins*"
		Outputs a list of Active Directory Groups matching the search string.
	
	.OUTPUTS
		[Object]
	
	.NOTES
		General notes
	
	.INPUTS
		[string]GroupName
	#>
	
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
            Get-ADGroup -Filter ' Name -like $GroupName ' -Properties *
        }
    }

    end {
    }

}
