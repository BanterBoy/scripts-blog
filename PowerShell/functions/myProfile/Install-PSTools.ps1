function Install-PSTools {
	Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile 'pstools.zip'
	Expand-Archive -Path 'pstools.zip' -DestinationPath "$env:TEMP\pstools"
	New-Item -Path 'C:\Program Files\Sysinternals'
	Copy-Item -Path "$env:TEMP\pstools\*.*" -Destination 'C:\Program Files\Sysinternals'
	Remove-Item -Path "$env:TEMP\pstools" -Recurse
}
