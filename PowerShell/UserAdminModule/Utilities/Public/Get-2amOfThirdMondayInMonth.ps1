function Get-2amOfThirdMondayInMonth ($Date) {
    #get the number of the current month
    $thisMonth = $date.Month
    # set the date to first of the current month,
    #the hours, minutes and the rest are taken from the current time,
    #so use the .Date to get midnight instead
    $midnightOfFirst = (Get-Date -Day 1 -Month $thisMonth).Date

    #What day of week is the first?
    $dayOfWeek = $midnightOfFirst.DayOfWeek

    #sunday is 0 in the WeekOfDay enum , but we need monday to be 0,
    #so we move the sunday at the end (6)
    #use [enum]::GetValues([dayofweek]) | foreach { "$_ : " + [int]$_ } to
    #see the values for yourself
    if ($dayOfWeek -eq "Sunday") {
        $dayOfWeek = 6
    }
    else {
        $dayOfWeek = [int]$dayOfWeek - 1
    }
    #add two weeks and number of days that remain from week to reach monday
    #(on monday we need 0 days to reach monday, on sunday we need one)
    $thirdMonday = New-TimeSpan -Days (2 * 7 + 7 - $dayofweek)

    #add the weeks + offset to the first of the month
    $thirdMonday = $midnightOfFirst.Add($thirdMonday)
    #add two hours to read 2 am
    $thirdMonday.AddHours(2)
}

<# test
$startDate = (Get-Date).AddYears(1)
1..20 | foreach {
Get-2amOfThirdMondayInMonth $startDate.AddMonths($_)
}
#>
