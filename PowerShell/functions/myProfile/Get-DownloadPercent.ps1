function Get-DownloadPercent([decimal]$d) {
	$p = [math]::Round($d * 100)
	return "$p%"
}