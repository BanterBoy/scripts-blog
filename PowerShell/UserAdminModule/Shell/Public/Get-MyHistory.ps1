Function Get-MyHistory
{
<#
	.SYNOPSIS
		Get-MyHistory will recall the previous commands entered into the console in a format that is easy to copy and paste.
	
	.DESCRIPTION
		Get-MyHistory will recall the previous commands entered into the console in a format that is easy to copy and paste.
	
	.PARAMETER Quantity
		Enter a value between 1 and 9999 to recall the number of hitorical commands.
	
	.EXAMPLE
				PS C:\> Get-MyHistory
	
	.OUTPUTS
		string
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
				   PositionalBinding = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	Param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[int32]
		$Quantity = 1
	)
	
	Get-History | Select-Object -Property CommandLine -Last $Quantity
}
