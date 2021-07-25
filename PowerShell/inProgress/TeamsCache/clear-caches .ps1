Write-Output "Stopping Teams Process"
try {
    Get-Process -ProcessName Teams | Stop-Process -Force
    Start-Sleep -Seconds 3
    Write-Output "Teams Process Sucessfully Stopped"
}
catch {
    Write-Output $_
}
Write-Output "Clearing Teams Disk Cache"
try {
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache\cache" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage" | Remove-Item -Recurse -Force -Confirm:$false
    Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp" | Remove-Item -Recurse -Force -Confirm:$false
    Write-Output "Teams Disk Cache Cleaned"
}
catch {
    Write-Output $_
}
Write-Output "Stopping Chrome Process"
try {
    Get-Process -ProcessName Chrome | Stop-Process -Force
    Start-Sleep -Seconds 3
    Write-Output "Chrome Process Sucessfully Stopped"
}
catch {
    Write-Output $_
}
Write-Output "Clearing Chrome Cache"
try {
    Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Cache" | Remove-Item -Confirm:$false
    Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Cookies" -File | Remove-Item -Confirm:$false
    Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Web Data" -File | Remove-Item -Confirm:$false
    Write-Output "Chrome Cleaned"
}
catch {
    Write-Output $_
}
Write-Output "Stopping IE Process"
try {
    Get-Process -ProcessName MicrosoftEdge | Stop-Process -Force
    Get-Process -ProcessName IExplore | Stop-Process -Force
    Write-Output "Internet Explorer and Edge Processes Sucessfully Stopped"
}
catch {
    Write-Output $_
}
Write-Output "Clearing IE Cache"
try {
    RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
    RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2
    Write-Output "IE and Edge Cleaned"
}
catch {
    Write-Output $_
}
Write-Output "Cleanup Complete... Launching Teams"
Start-Process -FilePath $env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe
Stop-Process -Id $PID
