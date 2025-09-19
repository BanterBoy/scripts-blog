<#
.SYNOPSIS
    Returns the current day of the week, a random day, or a shuffled list of all days.

.DESCRIPTION
    This function generates the current day of the week by default. If the `-Random` switch is provided, 
    it returns a single random day. If the `-ShuffleList` switch is provided, it returns a shuffled list 
    of all days.

.PARAMETER ShuffleList
    If specified, the function returns a shuffled list of all days of the week.

.PARAMETER Random
    If specified, the function returns a single random day of the week.

.EXAMPLE
    Get-DayOfWeek
    Returns the current day of the week, e.g., "Wednesday".

.EXAMPLE
    Get-DayOfWeek -Random
    Returns a single random day of the week, e.g., "Monday".

.EXAMPLE
    Get-DayOfWeek -ShuffleList
    Returns a shuffled list of all days of the week, e.g., "Friday", "Monday", "Sunday", etc.

.NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Version: 1.1
    This function uses the `Get-Random` cmdlet with the `-Shuffle` parameter for shuffling.

#>
function Get-DayOfWeek {
    [CmdletBinding()]
    param (
        [switch]$ShuffleList,
        [switch]$Random
    )

    # Define the days of the week
    $daysOfWeek = @("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

    if ($ShuffleList) {
        # Use the -Shuffle parameter to shuffle the list
        return $daysOfWeek | Get-Random -Shuffle
    }
    elseif ($Random) {
        # Return a single random day
        return Get-Random -InputObject $daysOfWeek
    }
    else {
        # Return the current day of the week
        return (Get-Date).DayOfWeek
    }
}