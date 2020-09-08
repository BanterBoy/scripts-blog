Get-WmiObject -Class "win32_quickfixengineering" | 
Select-Object -Property "Description", "HotfixID", "InstalledBy", @{Name="InstalledOn"; Expression={([DateTime]($_.InstalledOn)).ToLocalTime()}} |
Sort-Object InstalledOn |
Out-File $HOME\Desktop\InstalledUpdatesReport.txt

