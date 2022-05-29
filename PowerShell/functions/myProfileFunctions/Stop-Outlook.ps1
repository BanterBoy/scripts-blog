function Stop-Outlook {
	$OutlookRunning = Get-Process -ProcessName "Outlook"
	if (($OutlookRunning) = $true) {
		Stop-Process -ProcessName Outlook
	}
}