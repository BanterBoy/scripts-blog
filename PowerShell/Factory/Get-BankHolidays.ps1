<#
$URI = "http://www.holidaywebservice.com/HolidayService_v2/HolidayService2.asmx"
$proxy = New-WebServiceProxy -Uri $URI -Class holiday -Namespace webservice
$proxy.GetCountriesAvailable()
$proxy.GetHolidaysAvailable("GreatBritain")
$proxy.GetHolidayDate("UnitedStates","LABOR-DAY",2018)
$proxy.GetHolidaysForYear("GreatBritain","2018") | Format-Table -AutoSize
#>

$Year = (Get-Date).Year
$URI = "http://www.holidaywebservice.com/HolidayService_v2/HolidayService2.asmx"
$proxy = New-WebServiceProxy -Uri $URI -Class holiday -Namespace webservice
$proxy.GetHolidaysForYear("GreatBritain","$Year") | Where-Object { $_.BankHoliday -eq 'Recognized' } | Select-Object -Property BankHoliday,Descriptor,Date
