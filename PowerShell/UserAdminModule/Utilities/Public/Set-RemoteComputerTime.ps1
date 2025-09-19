Function Set-RemoteComputerTime {
	<#
		.SYNOPSIS
			Function to correct wrong time and date on remote machines

		.DESCRIPTION
			Set-RemoteComputerTime -ComputerName <Hostname> -Domain <domain> (default = )

		.EXAMPLE
			Set-RemoteComputerTime Computer01
		
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
		[string[]]$ComputerName,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[String]$Domain
	)
	try {
		$Computer = (Get-ADComputer $ComputerName -properties DNSHostname, description, OperatingSystem -server $Domain -ErrorAction stop)
		$AdCheck = $true
	}
	Catch {
		Write-Host -ForegroundColor Red "Machine $($ComputerName) not found in AD"
		$Computer = $_.Exception.Message
		$AdCheck = $false
	}
	# Check machine is online
	if ($True -eq $AdCheck) {
		$PathTest = Test-Connection -Computername $Computer.DNSHostname -BufferSize 16 -Count 1 -Quiet
	}
	if ($True -eq $PathTest) {
		Write-host -ForegroundColor Green "$($ComputerName) is online"
		$RemoteTimeAndDate = Invoke-Command -ComputerName $Computer.DNSHostname -ScriptBlock { return Get-Date -Format "dddd MM/dd/yyyy HH:mm" }
		$TimeAndDate = Get-date -Format "dddd MM/dd/yyyy HH:mm"
		if ($RemoteTimeAndDate -ne $TimeAndDate) {
			Write-Host -ForegroundColor RED "$($ComputerName) time is out"
			Write-Host -ForegroundColor RED "Remote Time - $($RemoteTimeAndDate)"
			Write-Host -ForegroundColor RED "Local Time - $($TimeAndDate)"
			$Continue = Read-Host -Prompt 'Do you wish to correct? -  Press Y to continue'
			if ("Y" -eq $Continue.ToUpper()) {
				Write-Warning -Message "Correcting time on $($ComputerName)"
				$TimeAndDate = Get-date
				$RemoteTimeAndDate = Invoke-Command -ComputerName $Computer.DNSHostname -ScriptBlock { Set-Date -Date $using:TimeAndDate
					return Get-Date -Format "dddd MM/dd/yyyy HH:mm" }
				if ($RemoteTimeAndDate -eq $TimeAndDate) {
					Write-Host -ForegroundColor Green "$($ComputerName) time was successfully corrected"
				}
				else {
					Write-Host -ForegroundColor RED "$($ComputerName) issue correcting time"
					Write-Host -ForegroundColor RED "Remote Time - $($RemoteTimeAndDate)"
					Write-Host -ForegroundColor RED "Remote Time - $($TimeAndDate)"
				}
			}
	
		}
		else {
			Write-Host -ForegroundColor Green "$($ComputerName) time is correct"
		}
	}
	else {
		Write-host -ForegroundColor Red "$($ComputerName) is offline"
	}
}
