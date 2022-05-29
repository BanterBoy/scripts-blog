function Start-Blogging {
	if (Test-IsAdmin = $True) {
		New-BlogServer
	}
	else {
		Write-Warning -message "Starting Admin Shell"
		Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
	}
}