function Start-JekyllBlogging {
	if (Test-IsAdmin = $True) {
		New-JekyllBlogServer
	}
	else {
		Write-Warning -message "Starting Admin Shell"
		Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
	}
}