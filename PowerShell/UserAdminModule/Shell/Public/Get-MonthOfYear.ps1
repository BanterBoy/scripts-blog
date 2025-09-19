<#
.SYNOPSIS
    Returns the current month of the year, a random month, or a shuffled list of all months.

.DESCRIPTION
    This function generates the current month of the year by default. If the `-Random` switch is provided, 
    it returns a single random month. If the `-ShuffleList` switch is provided, it returns a shuffled list 
    of all months.

.PARAMETER ShuffleList
    If specified, the function returns a shuffled list of all months of the year.

.PARAMETER Random
    If specified, the function returns a single random month of the year.

.EXAMPLE
    Get-MonthOfYear
    Returns the current month of the year, e.g., "April".

.EXAMPLE
    Get-MonthOfYear -Random
    Returns a single random month of the year, e.g., "March".

.EXAMPLE
    Get-MonthOfYear -ShuffleList
    Returns a shuffled list of all months of the year, e.g., "October", "January", "May", etc.

.NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Version: 1.1
    This function uses the `Get-Random` cmdlet with the `-Shuffle` parameter for shuffling.

#>
function Get-MonthOfYear {
    [CmdletBinding()]
    param (
        [switch]$ShuffleList,
        [switch]$Random
    )

    # Define the months of the year
    $monthsOfYear = @(
        "January", "February", "March", "April", "May", "June", 
        "July", "August", "September", "October", "November", "December"
    )

    if ($ShuffleList) {
        # Use the -Shuffle parameter to shuffle the list
        return $monthsOfYear | Get-Random -Shuffle
    }
    elseif ($Random) {
        # Return a single random month
        return Get-Random -InputObject $monthsOfYear
    }
    else {
        # Return the current month
        return (Get-Date).ToString("MMMM")
    }
}