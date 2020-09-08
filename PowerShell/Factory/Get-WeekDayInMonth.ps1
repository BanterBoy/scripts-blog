Function Get-WeekDayInMonth ([int]$Month, [int]$year, [int]$WeekNumber, [int]$WeekDay)
{
    $FirstDayOfMonth = Get-Date -Year $year -Month $Month -Day 1 -Hour 0 -Minute 0 -Second 0

#First week day of the month (i.e. first monday of the month)
    [int]$FirstDayofMonthDay = $FirstDayOfMonth.DayOfWeek
    $Difference = $WeekDay - $FirstDayofMonthDay
    If ($Difference -lt 0)
        {
        $DaysToAdd = 7 - ($FirstDayofMonthDay - $WeekDay)
        }
        elseif ($difference -eq 0 )
        {
        $DaysToAdd = 0
        }
        else
        {
        $DaysToAdd = $Difference
        }
        $FirstWeekDayofMonth = $FirstDayOfMonth.AddDays($DaysToAdd)
    
    Remove-Variable DaysToAdd
    #Add Weeks
    $DaysToAdd = ($WeekNumber -1)*7
    $TheDay = $FirstWeekDayofMonth.AddDays($DaysToAdd)
    If (!($TheDay.Month -eq $Month -and $TheDay.Year -eq $Year))
    {
    $TheDay = $null
    }
    $TheDay
    }