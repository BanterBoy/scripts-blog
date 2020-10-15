$isSummer = (Get-Date).IsDaylightSavingTime()
Get-TimeZone -ListAvailable | ForEach-Object {
    $dateTime = [DateTime]::UtcNow + $_.BaseUtcOffset
    $cities = $_.DisplayName.Split(')')[-1].Trim()
    if ($isSummer -and $_.SupportsDaylightSavingTime) {
        $dateTime = $dateTime.AddHours(1)
    }
    '{0,-30}: {1:HH:mm"h"} ({2})' -f $_.Id, $dateTime, $cities
}

function Get-SummerTime {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $isSummer = (Get-Date).IsDaylightSavingTime()
    )
    $Timezones = Get-TimeZone -ListAvailable
    foreach ($Zone in $Timezones) {
        $dateTime = [DateTime]::UtcNow + $Zone.BaseUtcOffset
        $cities = $Zone.DisplayName.Split(')')[-1].Trim()
        if ($isSummer -and $_.SupportsDaylightSavingTime) {
            $dateTime = $dateTime.AddHours(1)
            '{0,-30}: {1:HH:mm"h"} ({2})' -f $Zone.Id, $dateTime, $cities
        }
        else {
            $dateTime = $dateTime
            '{0,-30}: {1:HH:mm"h"} ({2})' -f $Zone.Id, $dateTime, $cities
        }
    }
}
