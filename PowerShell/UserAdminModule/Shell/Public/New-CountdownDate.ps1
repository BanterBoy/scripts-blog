<#
.SYNOPSIS
    Creates a CountdownDate object and calculates the days left until the specified countdown date.

.DESCRIPTION
    The CountdownDate class represents a countdown date and provides a method to calculate the days left until the countdown date.
    The New-CountdownDate function creates a CountdownDate object and returns the countdown information.

.PARAMETER CountdownDay
    Specifies the countdown date as a string in the format "dd/MM/yyyy" or as a DateTime object.
    Either CountdownDay or DaysUntilCountdown must be specified.

.PARAMETER DaysUntilCountdown
    Specifies the number of days until the countdown date.
    Either CountdownDay or DaysUntilCountdown must be specified.

.OUTPUTS
    Returns a PSObject with the following properties:
    - CurrentDate: The current date in the format "dd/MM/yyyy".
    - CountdownDate: The countdown date in the format "dd/MM/yyyy".
    - CountdownDay: The countdown day of the week and month in the format "dddd dd MMMM".
    - DaysLeft: The number of days left until the countdown date.

.EXAMPLE
    PS C:\> New-CountdownDate -CountdownDay "25/12/2022"
    Returns the days left until Christmas Day (25th December 2022).

.EXAMPLE
    PS C:\> New-CountdownDate -DaysUntilCountdown 30
    Returns the days left until 30 days from the current date.

.NOTES
    Author: Your Name
    Date: Today's Date
#>

class CountdownDate {
    [string]$CountdownDay
    [int]$DaysUntilCountdown

    CountdownDate([string]$CountdownDay, [int]$DaysUntilCountdown) {
        $this.CountdownDay = $CountdownDay
        $this.DaysUntilCountdown = $DaysUntilCountdown
    }

    [PSObject]GetCountdown() {
        if ($this.CountdownDay) {
            try {
                $CountdownDate = [datetime]::ParseExact($this.CountdownDay, "dd/MM/yyyy", $null)
            }
            catch {
                $CountdownDate = [datetime]$this.CountdownDay
            }
        }
        elseif ($this.DaysUntilCountdown) {
            $CountdownDate = (Get-Date).AddDays($this.DaysUntilCountdown)
        }
        else {
            throw "Please specify either CountdownDay or DaysUntilCountdown"
        }

        $Today = Get-Date
        $DaysLeft = New-TimeSpan -Start $Today -End $CountdownDate

        $output = New-Object PSObject
        $output | Add-Member -MemberType NoteProperty -Name "CurrentDate" -Value $Today.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDate" -Value $CountdownDate.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDay" -Value $CountdownDate.ToString("dddd dd MMMM")
        $output | Add-Member -MemberType NoteProperty -Name "DaysLeft" -Value "$($DaysLeft.Days) Days"

        return $output
    }
}

function New-CountdownDate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$CountdownDay,
        [Parameter(Mandatory = $false)]
        [int]$DaysUntilCountdown
    )

    try {
        $countdown = [CountdownDate]::new($CountdownDay, $DaysUntilCountdown)
        return $countdown.GetCountdown()
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
