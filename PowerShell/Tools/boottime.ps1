# This script permits to get UpTime from localHost or a set of remote Computer
# usage
# localHost
# .\BootTime.ps1
# set of remote computers
# get-content .\MyserverList.txt | .\boottime.ps1
# Optionally pipe output to Export-Csv, ConverTo-Html

Process {
	$ServerName = $_
	if ($serverName -eq $Null) {
		$serverName= $env:COMPUTERNAME
	}
	$timeVal = (Get-WmiObject -ComputerName $ServerName -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem").LastBootUpTime
	#$timeVal
	$DbPoint = [char]58
	$Years = $timeVal.substring(0,4)
	$Months = $timeVal.substring(4,2)
	$Days = $timeVal.substring(6,2)
	$Hours = $timeVal.substring(8,2)
	$Mins = $timeVal.substring(10,2)
	$Secondes = $timeVal.substring(12,2)
	$dayDiff = New-TimeSpan  $(Get-Date –month $Months -day $Days -year $Years -hour $Hours -minute $Mins -Second $Secondes) $(Get-Date)

	$Info = "" | Select-Object ServerName, Uptime
	$Info.servername = $servername
	$d =$dayDiff.days
	$h =$dayDiff.hours
	$m =$dayDiff.Minutes
	$s = $daydiff.Seconds
	$info.Uptime = "$d Days $h Hours $m Min $s Sec"

	$Info
}
