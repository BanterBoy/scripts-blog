function Set-TimeZoneID {
	<#
	.SYNOPSIS
		A brief description of the Set-TimeZoneID function.
	
	.DESCRIPTION
		A detailed description of the Set-TimeZoneID function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.EXAMPLE
		PS C:\> Set-TimeZoneID -ComputerName 'value1'
	
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
		$Credential,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input'
		)]
		[Alias('tz')]
		[ArgumentCompleter( {
				$Zones = Get-TimeZone -ListAvailable | Select-Object -Property Id
				foreach ($Zone in $Zones) {
					$Zone.Id
				}
			}) ]
		[string]$TimeZone = "GMT Standard Time"
	)
	BEGIN {
	}
	PROCESS {
		if ($PSCmdlet.ShouldProcess("$Computer to $TimeZone", "Setting Time Zone information...")) {
			if ($credential) {
				foreach ($Computer in $ComputerName) {
					Invoke-Command -ComputerName $Computer -ScriptBlock -Credential $Credential {
						Set-TimeZone -Id $TimeZone
					}
				}
			}
			else {
				foreach ($Computer in $ComputerName) {
					Invoke-Command -ComputerName $Computer -ScriptBlock {
						Set-TimeZone -Id $TimeZone
					}
				}
			}
		}
	}
	END {
	}
}
