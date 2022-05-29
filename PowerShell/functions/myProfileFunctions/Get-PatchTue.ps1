function Get-PatchTue {
	<#
	.SYNOPSIS
	Get the Patch Tuesday of a month
	.PARAMETER month
	The month to check
	.PARAMETER year
	The year to check
	.EXAMPLE
	Get-PatchTue -month 6 -year 2015
	.EXAMPLE
	Get-PatchTue June 2015
	#>
	
param(
	[string]$month = (get-date).month,
	[string]$year = (get-date).year
	)
	$firstdayofmonth = [datetime] ([string]$month + "/1/" + [string]$year)
	(0..30 | ForEach-Object {
		$firstdayofmonth.adddays($_)
	} |
	Where-Object {
		$_.dayofweek -like "Tue*"
	})[1]
}