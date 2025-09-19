Function Get-PayDay {
	<#
	.SYNOPSIS
		Get-PayDay - A function to calculate the next date that your payment will take place.
	
	.DESCRIPTION
		Get-PayDay - A function to calculate the next date that your payment will take place. The function tests to see if the expected payment date occurs on a weekend and displays the expected pay date. it is presumed that if the expected pay date falls on a Saturday or Sunday, then you would typically be paid on the Friday before your normal payday.
		
		Outputs inlcude
		[string]CurrentTime
		[string]Date
		[int]Day
		[string]DayOfWeek
		[string]LongDate
		[string]Month
		[string]Year
	
	.PARAMETER Day
		[int]Day - Enter value for the payment Day.
	
	.PARAMETER Month
		[string]Month - Enter value for the payment Day.
	
	.PARAMETER Year
		[string] Year - Enter value for the payment Year. Defaults to the current year.
	
	.PARAMETER CurrentTime
		[string] CurrentTime - Enter value for the current time. Expected format = HH:mm:ss. Defaults to the current time.
	
	.EXAMPLE
		Get-PayDay -Day 01 -Month January -Year 2020
		
		DayOfWeek   : Wednesday
		Day         : 1
		Month       : January
		Year        : 2020
		Date        : 01/01/2020
		LongDate    : 01 January 2020
		CurrentTime : 07:13:39
	
	.OUTPUTS
		System.String. Get-PayDay returns an object of type System.String.
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- Day [string]
		- Nonth [string]
		- Year [string]
		- CurrentTume [string]
	
	.LINK
		https://scripts.lukeleigh.com
		Get-Date
		Write-Output
#>
	
	[CmdletBinding(DefaultParameterSetName = 'Default',
		ConfirmImpact = 'Medium',
		HelpUri = 'http://scripts.lukeleigh.com/',
		PositionalBinding = $true)]
	[OutputType([string], ParameterSetName = 'Default')]
	[OutputType([String])]
	Param
	(
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 1,
			HelpMessage = '[int] Day - Enter value for the payment Day. Default value 30')]
		[ValidateRange(1, 31)]
		[int]
		$Day = 30,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 2,
			HelpMessage = '[string] Month - Enter value for the payment Day. Press TAB to cycle through the months or enter a partial and tab complete. Defaults to the current month.')]
		[ValidateSet('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December', IgnoreCase = $true)]
		[string]
		$Month = (Get-Date).Month,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 3,
			HelpMessage = '[string] Year - Enter value for the payment Year. Defaults to the current year.')]
		[ValidatePattern('^[1-9]\d{3,}$')]
		[ValidateRange(1000, 2999)]
		[string]
		$Year = (Get-Date).Year,
		[Parameter(ParameterSetName = 'Default',
			Mandatory = $false,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ValueFromRemainingArguments = $false,
			Position = 4,
			HelpMessage = '[string] CurrentTime - Enter value for the current time. Expected format = HH:mm:ss. Defaults to the current time.')]
		[ValidatePattern('^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$')]
		[string]
		$CurrentTime = (Get-Date).ToString('HH:mm:ss')
	)
	
	Begin {
	}
	
	Process {
		Try {
			$PayDay = [datetime] ([string]$Month + "/" + [string]$Day + "/" + [string]$Year)
			If ($PayDay.DayOfWeek -eq "Sunday") {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.AddDays( - 2).DayOfWeek
					"Day"         = $PayDay.AddDays( - 2).Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.AddDays( - 2).ToShortDateString()
					"LongDate"    = $PayDay.AddDays( - 2).ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
			ElseIf ($PayDay.dayofweek -eq "Saturday") {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.AddDays(-1).DayOfWeek
					"Day"         = $PayDay.AddDays(-1).Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.AddDays(-1).ToShortDateString()
					"LongDate"    = $PayDay.AddDays(-1).ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
			Else {
				$properties = [ordered]@{
					"DayOfWeek"   = $PayDay.DayOfWeek
					"Day"         = $PayDay.Day
					"Month"       = $PayDay.ToString('MMMM')
					"Year"        = $PayDay.Year
					"Date"        = $PayDay.ToShortDateString()
					"LongDate"    = $PayDay.ToLongDateString()
					"CurrentTime" = $CurrentTime
				}
			}
		}
		Catch {
			Write-Error "Invalid date"
		}
		Finally {
			$obj = New-Object -TypeName PSObject -Property $properties
			Write-Output $obj
		}
	}
	
	End {
	}
}
