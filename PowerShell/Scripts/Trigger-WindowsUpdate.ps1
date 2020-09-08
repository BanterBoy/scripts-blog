<#
Windows Update
The wuauclt.exe /detectnow command has been removed and is no longer supported (Windows 2016)
To trigger a scan for updates, do the following:
#>

$AutoUpdates = New-Object -ComObject "Microsoft.Update.AutoUpdate"
$AutoUpdates.DetectNow()
