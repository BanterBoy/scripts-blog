function Get-PatchTue {
	<#
    .SYNOPSIS
        Gets the Patch Tuesday date of a specified month and year.

    .DESCRIPTION
        This function calculates and returns the date of Patch Tuesday for a given month and year. Patch Tuesday is the second Tuesday of each month when Microsoft releases updates for its software products.

    .PARAMETER Month
        The month for which to calculate Patch Tuesday. Defaults to the current month if not specified.

    .PARAMETER Year
        The year for which to calculate Patch Tuesday. Defaults to the current year if not specified.

    .EXAMPLE
        Get-PatchTue -Month 6 -Year 2015
        Returns the date of Patch Tuesday in June 2015.

    .EXAMPLE
        Get-PatchTue -Month June -Year 2015
        Returns the date of Patch Tuesday in June 2015.

    .EXAMPLE
        Get-PatchTue
        Returns the date of Patch Tuesday for the current month and year.

    .NOTES
        This function uses the current date if no month and year are specified.

    .LINK
        https://docs.microsoft.com/en-us/windows/release-information/
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[ValidateSet("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")]
		[string]$Month = (Get-Date).Month.ToString(),

		[Parameter(Mandatory = $false)]
		[ValidatePattern('^\d{4}$')]
		[int]$Year = (Get-Date).Year
	)

	Begin {
		# Convert the month name to a number if necessary
		if ($Month -match '^\D+$') {
			$MonthNumber = [datetime]::ParseExact($Month, 'MMMM', [cultureinfo]::CurrentCulture).Month
		}
		else {
			$MonthNumber = [int]$Month
		}

		# Ensure the month number is valid
		if ($MonthNumber -lt 1 -or $MonthNumber -gt 12) {
			throw "Invalid month value: $Month. Please provide a month between 1 and 12 or the full month name."
		}
	}

	Process {
		# Get the first day of the specified month and year
		$firstDayOfMonth = Get-Date -Year $Year -Month $MonthNumber -Day 1

		# Calculate Patch Tuesday (second Tuesday of the month)
		$patchTuesday = 1..31 | ForEach-Object {
			$currentDate = $firstDayOfMonth.AddDays($_ - 1)
			if ($currentDate.Month -eq $MonthNumber -and $currentDate.DayOfWeek -eq [DayOfWeek]::Tuesday) {
				$currentDate
			}
		} | Select-Object -Index 1

		# Output the Patch Tuesday date
		$patchTuesday
	}
}
