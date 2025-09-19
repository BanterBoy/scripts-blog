function Get-LastxOfMonth {
    <#
    .SYNOPSIS
        Retrieves the last occurrence of a specified day of the week or date in a given month and year.

    .DESCRIPTION
        This function can find the last occurrence of a specified day of the week (e.g., Tuesday) or a specified date (e.g., the 15th) in a given month and year.

    .PARAMETER DayNum
        The date (1-31) to find the last occurrence of.

    .PARAMETER Day
        The day of the week (e.g., Sunday, Monday, Tuesday, etc.) to find the last occurrence of.

    .PARAMETER MonthNum
        The month number (1-12) for which to find the last occurrence.

    .PARAMETER Month
        The month name (e.g., January, February, etc.) for which to find the last occurrence.

    .PARAMETER Year
        The year for which to find the last occurrence.

    .EXAMPLE
        Get-LastxOfMonth -Day Tuesday -MonthNum 1 -Year 2024
        Retrieves the last Tuesday of January 2024.

    .EXAMPLE
        Get-LastxOfMonth -DayNum 15 -Month February -Year 2024
        Retrieves the last occurrence of the 15th in February 2024 and returns the day of the week.

    .NOTES
        Author: Luke Leigh
    #>

    [CmdletBinding(DefaultParameterSetName = 'DayOfWeekSet')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'DayOfMonthSet', HelpMessage = 'Enter the date (1-31)')]
        [ValidateRange(1, 31)]
        [int]$DayNum,

        [Parameter(Mandatory = $false, ParameterSetName = 'DayOfWeekSet', HelpMessage = 'Enter the day of the week (Sunday, Monday, etc.)')]
        [ValidateSet('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        [string]$Day,

        [Parameter(Mandatory = $false, HelpMessage = 'Enter the month number (1-12)')]
        [ValidateRange(1, 12)]
        [int]$MonthNum,

        [Parameter(Mandatory = $false, HelpMessage = 'Enter the month name (January, February, etc.)')]
        [ValidateSet('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')]
        [string]$Month,

        [Parameter(Mandatory = $true, HelpMessage = 'Enter the year')]
        [ValidateRange(1, 9999)]
        [int]$Year
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('MonthNum') -and -not $PSBoundParameters.ContainsKey('Month')) {
            throw "You must specify either the MonthNum or Month parameter."
        }
        if ($PSBoundParameters.ContainsKey('Month')) {
            $MonthNum = [datetime]::ParseExact($Month, 'MMMM', [System.Globalization.CultureInfo]::InvariantCulture).Month
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('Day')) {
            $lastDayOfMonth = [datetime]::new($Year, $MonthNum, [datetime]::DaysInMonth($Year, $MonthNum))
            while ($lastDayOfMonth.DayOfWeek -ne [System.DayOfWeek]::$Day) {
                $lastDayOfMonth = $lastDayOfMonth.AddDays(-1)
            }
            return $lastDayOfMonth.ToString('dd MMMM yyyy')
        }
        elseif ($PSBoundParameters.ContainsKey('DayNum')) {
            $lastDayOfMonth = [datetime]::new($Year, $MonthNum, [datetime]::DaysInMonth($Year, $MonthNum))
            if ($DayNum -gt $lastDayOfMonth.Day) {
                throw "The specified day exceeds the number of days in the specified month."
            }
            return ([datetime]::new($Year, $MonthNum, $DayNum)).DayOfWeek.ToString()
        }
    }
}

# Example usage:
# Get-LastxOfMonth -Day Tuesday -MonthNum 1 -Year 2024
# Get-LastxOfMonth -DayNum 15 -Month February -Year 2024
