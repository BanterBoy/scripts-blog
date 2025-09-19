<#
.SYNOPSIS
Calculates the download percentage based on a decimal value.

.DESCRIPTION
The Get-DownloadPercent function takes a decimal value and calculates the corresponding download percentage. It multiplies the decimal value by 100 and rounds it to the nearest whole number.

.PARAMETER d
The decimal value representing the progress of the download.

.EXAMPLE
Get-DownloadPercent 0.75
Returns: "75%"

#>

function Get-DownloadPercent([decimal]$d) {
	$p = [math]::Round($d * 100)
	return "$p%"
}