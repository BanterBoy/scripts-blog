function New-Greeting {
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	[OutputType([string])]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = 'Enter '
		)]
		[string]$Day
	)

	Begin {
		$greetings = @{
			Monday		= "Don't want to work today"
			Friday  	= "Almost the weekend"
			Saturday 	= "Everyone loves a Saturday ;-)"
			Sunday 		= "A good day to rest, or so I hear."
		}

		$date = $(Get-Date)

		function GetMessageForDay([string] $day) {
			$time = $date.ToShortTimeString()
	
			$message = $greetings[$day]
	
			if ([String]::IsNullOrWhiteSpace($message)) {
				$message = "Business as usual."
			}
	
			$properties = [ordered]@{
				"Date"    = $date.ToShortDateString()
				"Day"     = $day
				"Time"    = $time
				"Message" = $message
			}
			
			return New-Object -TypeName PSObject -Property $properties
		}

		if ([String]::IsNullOrWhiteSpace($Day)) {
			$Day = $date.DayOfWeek
		}
	}

	Process {
		Write-Output $(GetMessageForDay($Day))
	}
}
