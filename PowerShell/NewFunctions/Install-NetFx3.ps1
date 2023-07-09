# Install .Net 3.5
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -Value 0
Get-Service wuauserv | Restart-Service
Add-WindowsCapability -Online -Name "NetFx3~~~~"
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -Value 1
