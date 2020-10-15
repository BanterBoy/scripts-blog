# Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
# Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property Name, State

<#
Add-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
Remove-WindowsCapability -Name Rsat.CertificateServices.Tools~~~~0.0.1.0 –Online
#>

Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName,Online,RestartNeeded,State | Format-Table -AutoSize
