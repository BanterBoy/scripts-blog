function Get-LastBootTime {
	<#
	.SYNOPSIS
		A brief description of the Get-LastBootTime function.
	
	.DESCRIPTION
		A detailed description of the Get-LastBootTime function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER DaysPast
		A description of the DaysPast parameter.
	
	.EXAMPLE
		PS C:\> Get-LastBootTime -ComputerName 'value1'
	
	.OUTPUTS
		System.String
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy')]
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
			HelpMessage = 'Enter the number of days past or pipe input')]
		[int]$DaysPast = 1
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$($Computer)", "Find last Boot Time")) {
				$Test = (Test-Connection -ComputerName $Computer -Ping -Count 1).Status
				if ($Test -eq "Success") {
					if ($Credential) {
						try {
							$StartTime = (Get-Date).AddDays(-$DaysPast)
							Get-WinEvent -ComputerName $Computer -FilterHashtable @{
								logname = 'System';
								id      = '1074'
							} | Where-Object -Property TimeCreated -GT $StartTime
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
					else {
						try {
							$StartTime = (Get-Date).AddDays(-$DaysPast)
							Get-WinEvent -ComputerName $Computer -FilterHashtable @{
								logname = 'System';
								id      = '1074'
							} | Where-Object -Property TimeCreated -GT $StartTime
						}
						catch {
							Write-Output "No Matching Events Found on $Computer"
						}
					}
				}
				else {
					Write-Output "Computer $Computer is not reachable."
				}
			}
		}
	}
	END {
	}
}

# Get-LastBootTime -ComputerName KAMINO, DANTOOINE, HOTH -DaysPast 100 | Format-Table -AutoSize -Wrap
