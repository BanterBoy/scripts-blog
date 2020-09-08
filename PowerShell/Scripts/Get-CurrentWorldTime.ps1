# World Time Clock

$isSummer = (Get-Date).IsDaylightSavingTime()


Get-TimeZone -ListAvailable | ForEach-Object {
    $dateTime = [DateTime]::UtcNow + $_.BaseUtcOffset
    $cities = $_.DisplayName.Split(')')[-1].Trim()
    if ($isSummer -and $_.SupportsDaylightSavingTime)
    {
        $dateTime = $dateTime.AddHours(1)
    }
  '{0,-30}: {1:HH:mm"h"} ({2})' -f $_.Id, $dateTime, $cities
  }

