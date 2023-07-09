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
        [ValidateSet([GreetingsValidator])]
		[string]$Day
	)

	Begin {
        $greetings = [Greetings]::new()

		if ([String]::IsNullOrWhiteSpace($Day)) {
			$Day = $greetings.CurrentDay
		}
	}

	Process {
		Write-Output $($greetings.GetMessageForDay($Day))
	}
}

class Greetings {
    $greetings = @{
        Monday		= "Don't want to work today"
        Friday  	= "Almost the weekend"
        Saturday 	= "Everyone loves a Saturday ;-)"
        Sunday 		= "A good day to rest, or so I hear."
    }

    [string[]] $Days = @( "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" )

    $Date = $(Get-Date)

    [string] $CurrentDay = $this.Date.DayOfWeek

    [object] GetMessageForDay([string] $day) {
        $time = $this.Date.ToShortTimeString()

        $message = $this.greetings[$day]

        if ([String]::IsNullOrWhiteSpace($message)) {
            $message = "Business as usual."
        }

        $properties = [ordered]@{
            "Date"    = $this.Date.ToShortDateString()
            "Day"     = $day
            "Time"    = $time
            "Message" = $message
        }
        
        return New-Object -TypeName PSObject -Property $properties
    }

    Process([String] $name) {
        Write-Host($this.asciiMappings[$name] | Set-Clipboard -PassThru)
    }
}

class GreetingsValidator : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [Greetings]::new().Days
    }
}