<#
.SYNOPSIS
    Retrieves the next payday from a CSV file.

.DESCRIPTION
    The Get-NextPayDay function reads a CSV file containing a list of payday dates and returns the next upcoming payday.

.PARAMETER None

.INPUTS
    None

.OUTPUTS
    A custom object representing the next payday, including the number of days left until that payday.

.EXAMPLE
    Get-NextPayDay

    This example retrieves the next payday from the PayDays.csv file and returns the corresponding countdown date.

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Get-NextPayDay {
    $PayDays = Get-Content -Raw -Path $PSScriptRoot\resources\PayDays.csv | ConvertFrom-Csv
    $PayDays | ForEach-Object -Process { New-CountdownDate -CountdownDay $_.PayDay } | Where-Object -FilterScript { $_.DaysLeft -notlike '-*' } | Select-Object -First 1
}
