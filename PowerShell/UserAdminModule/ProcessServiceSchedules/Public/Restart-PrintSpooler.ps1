function Restart-PrintSpooler
{
	<#
	.SYNOPSIS
		A brief description of the Restart-PrintSpooler function.
	
	.DESCRIPTION
		A detailed description of the Restart-PrintSpooler function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.EXAMPLE
		PS C:\> Restart-PrintSpooler -ComputerName 'value1'
	
	.OUTPUTS
		System.String
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
				   HelpUri = 'https://github.com/BanterBoy')]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Enter computer name or pipe input')]
		[Alias('cn')]
		[string[]]$ComputerName
	)
	BEGIN
	{
	}
	PROCESS
	{
		foreach ($Computer in $ComputerName)
		{
			Invoke-Command -ComputerName $Computer -ScriptBlock {
				Get-Service -Name Spooler | Restart-Service -Force
			}
		}
	}
	END
	{
	}
}

