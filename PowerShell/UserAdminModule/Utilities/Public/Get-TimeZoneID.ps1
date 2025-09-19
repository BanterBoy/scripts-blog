function Get-ServerTimeZone {
	<#
	.SYNOPSIS
		A brief description of the Get-ServerTimeZone function.
	
	.DESCRIPTION
		A detailed description of the Get-ServerTimeZone function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.EXAMPLE
		PS C:\> Get-ServerTimeZone -ComputerName 'value1'
	
	.OUTPUTS
		System.String
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy'
	)]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cn')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('cred')]
		[ValidateNotNull()]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential
	)
	BEGIN {
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$Computer", "Retrieving Time Zone information...")) {
			
		}
		foreach ($Computer in $ComputerName)
		{
			Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock {
				Get-TimeZone
			}
		}
	}
	END {
	}
}
