<# 
Bypass WSUS to Install Features/Updates Directly from Windows Update
To fix the problem, temporarily bypass WSUS server using the following registry edit (requires administrator privileges).

Right-click Start, and click Run
Type regedit.exe and click OK
Go to the following registry key:
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
On the right-pane, if the value named UseWUServer exists, set its data to 0
Exit the Registry Editor
Restart Windows.

#>

# Automated Solution

Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -value 0
Get-Service wuauserv | Restart-Service
Add-WindowsCapability -Online -Name NetFx3~~~~
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

If (Get-WindowsCapability -Name "Rsat*" -Online | Where-Object { $_.State -eq "Installed" }) { 
	Write-Output "Installed"
}
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -value 1
