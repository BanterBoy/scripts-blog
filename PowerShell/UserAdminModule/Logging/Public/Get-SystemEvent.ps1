<#
.SYNOPSIS
Retrieves system events from one or more computers.

.DESCRIPTION
The Get-SystemEvent function retrieves system events from one or more computers. It filters the events based on the specified criteria, such as the computer name, credentials, and number of days of events to retrieve. The function uses the Get-WinEvent cmdlet to retrieve the events and outputs the selected properties of the events.

.PARAMETER ComputerName
Specifies the name of the computer from which to retrieve events. The default value is the local computer.

.PARAMETER Credential
Specifies the credentials to use when connecting to the computer. This parameter is optional.

.PARAMETER Days
Specifies the number of days of events to retrieve. The default value is 10.

.OUTPUTS
System.String
The function outputs a string that represents the selected properties of the retrieved events. The selected properties include TimeCreated, Message, and MachineName.

.EXAMPLE
Get-SystemEvent -ComputerName 'Server01', 'Server02' -Days 7
Retrieves system events from Server01 and Server02 that occurred within the last 7 days.

.EXAMPLE
Get-SystemEvent -ComputerName 'Server01' -Credential $cred -Days 30
Retrieves system events from Server01 that occurred within the last 30 days using the specified credentials.

.LINK
https://github.com/BanterBoy
The function's help URI.

#>
function Get-SystemEvent {
	[CmdletBinding(DefaultParameterSetName = 'Default',
		supportsShouldProcess = $true,
		HelpUri = 'https://github.com/BanterBoy'
	)]
	[OutputType([string])]
	param (
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter the name of the computer from which to retrieve events.'
		)]
		[Alias('cn')]
		[string[]]$ComputerName = $env:COMPUTERNAME,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter the credentials to use when connecting to the computer.'
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
			HelpMessage = 'Enter the number of days of events to retrieve.'
		)]
		[int[]]$Days = 10
	)
	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			if ($PSCmdlet.ShouldProcess("$Computer", "Extracting events")) {
				if ($Credential) {
					try {
						$Results = Get-WinEvent -ComputerName $Computer -Credential $Credential | Where-Object -FilterScript { ($_.Level -eq 2) -or ($_.Level -eq 3) } | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(- "$Days") -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message, MachineName
						if ($null -eq $Results) {
							Write-Error "No events Found on $Computer"
						}
						else {
							Write-Output $Results
						}
					}
					catch {
						Write-Error "Failed to retrieve events from $Computer"
					}

				}
				else {
					try {
						$Results = Get-WinEvent -ComputerName $Computer | Where-Object -FilterScript { ($_.Level -eq 2) -or ($_.Level -eq 3) } | Where-Object -Property TimeCreated -GT (Get-Date).AddDays(- "$Days") -ErrorAction SilentlyContinue | Select-Object TimeCreated, Message, MachineName
						if ($null -eq $Results) {
							Write-Error "No events Found on $Computer"
						}
						else {
							Write-Output $Results
						}
					}
					catch {
						Write-Error "Failed to retrieve events from $Computer. Error: $_"
					}
				}
			}
		}
	}
	END {
	}
}