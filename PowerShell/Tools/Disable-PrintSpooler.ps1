function Disable-PrintSpooler {
	[CmdletBinding(DefaultParameterSetName = 'Default',
		HelpURI = 'https://github.com/BanterBoy/AdminToolkit/wiki')]
	param (
		[parameter(Mandatory = $true, HelpMessage = "Enter computer name or pipe input")]
		[string[]]$ComputerName
	)

	BEGIN {
	}
	PROCESS {
		foreach ($Computer in $ComputerName) {
			Get-Service -Name Spooler -ComputerName $Computer | Stop-Service
			Set-Service -ComputerName $Computer -Name Spooler -StartupType Disabled
		}
	}
	END {
	
	}

}
