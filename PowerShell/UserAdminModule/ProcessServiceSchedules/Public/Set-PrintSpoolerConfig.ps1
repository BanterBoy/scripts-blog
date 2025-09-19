function Set-PrintSpoolerConfig {

	<#
    .SYNOPSIS
        Configures the Print Spooler service status on one or more computers.

    .DESCRIPTION
        This function allows you to start, stop, enable, or disable the Print Spooler service on one or more computers. 
        It supports both local and remote operations, using the `Get-Service`, `Start-Service`, `Stop-Service`, and `Set-Service` cmdlets for local operations,
        and `Invoke-Command` for remote operations.

    .PARAMETER ComputerName
        The name(s) of the computer(s) where the Print Spooler service should be configured. This parameter can accept pipeline input.

    .PARAMETER Status
        The desired status of the Print Spooler service. Valid values are 'Running', 'Stopped', 'Disabled', and 'Enabled'.

    .EXAMPLE
        Set-PrintSpoolerConfig -ComputerName "Server01" -Status Running
        Starts the Print Spooler service on Server01 if it is not already running.

    .EXAMPLE
        "Server01", "Server02" | Set-PrintSpoolerConfig -Status Disabled
        Disables the Print Spooler service on Server01 and Server02.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30

    .LINK
        https://github.com/BanterBoy
    #>

	[CmdletBinding(DefaultParameterSetName = 'Default',
		HelpUri = 'https://github.com/BanterBoy',
		SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter computer name or pipe input')]
		[Alias('cn')]
		[string[]]$ComputerName,

		[Parameter(ParameterSetName = 'Default',
			Mandatory = $true,
			HelpMessage = 'Enter desired status of the Print Spooler service')]
		[ValidateSet('Running', 'Stopped', 'Disabled', 'Enabled')]
		[string]$Status
	)

	PROCESS {
		foreach ($Computer in $ComputerName) {
			try {
				$localComputerName = [System.Environment]::MachineName
				if ($localComputerName -eq $Computer) {
					# Run the command locally
					$spoolerService = Get-Service -Name Spooler

					switch ($Status) {
						'Running' {
							if ($spoolerService.Status -ne 'Running') {
								if ($PSCmdlet.ShouldProcess("$Computer", "Start Spooler service")) {
									$spoolerService | Start-Service
									Write-Verbose "Started Spooler service on $Computer"
								}
							}
						}
						'Stopped' {
							if ($spoolerService.Status -ne 'Stopped') {
								if ($PSCmdlet.ShouldProcess("$Computer", "Stop Spooler service")) {
									$spoolerService | Stop-Service
									Write-Verbose "Stopped Spooler service on $Computer"
								}
							}
						}
						'Disabled' {
							if ($spoolerService.StartType -ne 'Disabled') {
								if ($PSCmdlet.ShouldProcess("$Computer", "Disable Spooler service")) {
									$spoolerService | Set-Service -StartupType Disabled
									Write-Verbose "Disabled Spooler service on $Computer"
								}
							}
						}
						'Enabled' {
							if ($spoolerService.StartType -eq 'Disabled') {
								if ($PSCmdlet.ShouldProcess("$Computer", "Enable Spooler service")) {
									$spoolerService | Set-Service -StartupType Automatic
									Write-Verbose "Enabled Spooler service on $Computer"
								}
							}
						}
					}
				}
				else {
					# Run the command remotely
					Invoke-Command -ComputerName $Computer -ScriptBlock {
						param ($Status)
						$spoolerService = Get-Service -Name Spooler

						switch ($Status) {
							'Running' {
								if ($spoolerService.Status -ne 'Running') {
									if ($PSCmdlet.ShouldProcess("$using:Computer", "Start Spooler service")) {
										$spoolerService | Start-Service
										Write-Verbose "Started Spooler service on $using:Computer"
									}
								}
							}
							'Stopped' {
								if ($spoolerService.Status -ne 'Stopped') {
									if ($PSCmdlet.ShouldProcess("$using:Computer", "Stop Spooler service")) {
										$spoolerService | Stop-Service
										Write-Verbose "Stopped Spooler service on $using:Computer"
									}
								}
							}
							'Disabled' {
								if ($spoolerService.StartType -ne 'Disabled') {
									if ($PSCmdlet.ShouldProcess("$using:Computer", "Disable Spooler service")) {
										$spoolerService | Set-Service -StartupType Disabled
										Write-Verbose "Disabled Spooler service on $using:Computer"
									}
								}
							}
							'Enabled' {
								if ($spoolerService.StartType -eq 'Disabled') {
									if ($PSCmdlet.ShouldProcess("$using:Computer", "Enable Spooler service")) {
										$spoolerService | Set-Service -StartupType Automatic
										Write-Verbose "Enabled Spooler service on $using:Computer"
									}
								}
							}
						}
					} -ArgumentList $Status
				}
			}
			catch {
				Write-Error "Failed to set Print Spooler service status on ${Computer}: $_"
			}
		}
	}
}
