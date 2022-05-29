---
layout: page
title: myProfile
permalink: /menu/_pages/myProfile.html
---

<video width="380" height="160" controls autoplay loop muted>
    <source src="/assets/menu/functions.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Microsoft.PowerShell_profile.ps1](#microsoftpowershell-profileps1)
- [Office365](#office365)
- [Connect](#connect)
- [RDPfunctions](#rdpfunctions)
- [PrintSpooler](#printspooler)
- [fileManagement](#filemanagement)
- [InternetIP](#internetip)
- [ProfileSpecific](#profilespecific)
- [activeDirectory](#activedirectory)
- [InternetSearch](#internetsearch)
- [miscellaneous](#miscellaneous)
- [shell](#shell)
- [BloggingFunctions](#bloggingfunctions)
- [shellConfig](#shellconfig)
- [transmission](#transmission)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

## Microsoft.PowerShell_profile.ps1

There are several articles scattered around the internet that provide either a cursory overview of PowerShell profiles or a detailed explanation of their functionality. I have written one such article about PowerShell profiles which can be found [here](https://blog.lukeleigh.com/blog/The-PowerShell-Profile)

[![Microsoft.PowerShell_profile](/assets/images/PoshProfile.png)](/_posts/myProfile/Microsoft.PowerShell_profile/)

```powershell
#--------------------
# Generic Profile Commands
Get-ChildItem C:\GitRepos\ProfileFunctions\ProfileFunctions\*.ps1 | ForEach-Object {. $_ }
oh-my-posh init pwsh --config C:\GitRepos\ProfileFunctions\BanterBoyOhMyPoshConfig.json | Invoke-Expression

# basic greeting function, contents to be added to current function
Write-Output "Type Get-ProfileFunctions to see the available functions"

#--------------------
# Configure PowerShell Console Window Size/Preferences
Set-ConsoleConfig -WindowHeight 45 -WindowWidth 180 | Out-Null

#--------------------
# PSDrives
New-PSDrive -Name GitRepos -PSProvider FileSystem -Root C:\GitRepos\ -Description "GitHub Repositories" | Out-Null
New-PSDrive -Name Sysint -PSProvider FileSystem -Root "$env:OneDrive\Software\SysinternalsSuite" -Description "Sysinternals Suite Software" | Out-Null

#--------------------
# Aliases
New-Alias -Name 'Notepad++' -Value 'C:\Program Files\Notepad++\notepad++.exe' -Description 'Launch Notepad++'

#--------------------
# Profile Starts here!
Write-Output ""
Show-IsAdminOrNot
Write-Output ""
New-Greeting
```

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Microsoft.PowerShell_profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download myProfile
</button>

---

## Office365

| Section   | FileName                                                              |
| :-------- | :-------------------------------------------------------------------- |
| myProfile | [Add-Office365Functions](/_posts/myProfile/Add-Office365Functions/)   |
| myProfile | [Stop-Outlook](/_posts/myProfile/Stop-Outlook/)                       |
| myProfile | [Get-OutlookAppointments](/_posts/myProfile/Get-OutlookAppointments/) |

---

## Connect

| Section   | FileName                                                        |
| :-------- | :-------------------------------------------------------------- |
| myProfile | [Connect-InternalPRTG](/_posts/myProfile/Connect-InternalPRTG/) |
| myProfile | [Connect-PSExec](/_posts/myProfile/Connect-PSExec/)             |
| myProfile | [Connect-RDPSession](/_posts/myProfile/Connect-RDPSession/)     |
| myProfile | [Connect-CmRcViewer](/_posts/myProfile/Connect-CmRcViewer/)     |

---

## RDPfunctions

| Section   | FileName                                                            |
| :-------- | :------------------------------------------------------------------ |
| myProfile | [Get-RDPStatusCIM](/_posts/myProfile/Get-RDPStatusCIM/)             |
| myProfile | [Enable-RDPRemotelyCIM](/_posts/myProfile/Enable-RDPRemotelyCIM/)   |
| myProfile | [Disable-RDPRemotelyCIM](/_posts/myProfile/Disable-RDPRemotelyCIM/) |
| myProfile | [Get-RDPStatusWMI](/_posts/myProfile/Get-RDPStatusWMI/)             |
| myProfile | [Enable-RDPRemotelyWMI](/_posts/myProfile/Enable-RDPRemotelyWMI/)   |
| myProfile | [Disable-RDPRemotelyWMI](/_posts/myProfile/Disable-RDPRemotelyWMI/) |
| myProfile | [Get-RDPUserReport](/_posts/myProfile/Get-RDPUserReport/)           |

---

## PrintSpooler

| Section   | FileName                                                        |
| :-------- | :-------------------------------------------------------------- |
| myProfile | [Disable-PrintSpooler](/_posts/myProfile/Disable-PrintSpooler/) |
| myProfile | [Enable-PrintSpooler](/_posts/myProfile/Enable-PrintSpooler/)   |
| myProfile | [Get-PrintSpooler](/_posts/myProfile/Get-PrintSpooler/)         |

---

## fileManagement

| Section   | FileName                                                          |
| :-------- | :---------------------------------------------------------------- |
| myProfile | [Find-Movies](/_posts/myProfile/Find-Movies/)                     |
| myProfile | [Show-PSDrive](/_posts/myProfile/Show-PSDrive/)                   |
| myProfile | [New-GitDrives](/_posts/myProfile/New-GitDrives/)                 |
| myProfile | [New-PSDrives](/_posts/myProfile/New-PSDrives/)                   |
| myProfile | [Get-LatestFiles](/_posts/myProfile/Get-LatestFiles/)             |
| myProfile | [New-DummyFile](/_posts/myProfile/New-DummyFile/)                 |
| myProfile | [New-Shortcut](/_posts/myProfile/New-Shortcut/)                   |
| myProfile | [Get-FolderPermissions](/_posts/myProfile/Get-FolderPermissions/) |
| myProfile | [Search-ForFiles](/_posts/myProfile/Search-ForFiles/)             |
| myProfile | [Search-Scripts](/_posts/myProfile/Search-Scripts/)               |
| myProfile | [Select-FolderLocation](/_posts/myProfile/Select-FolderLocation/) |

---

## InternetIP

| Section   | FileName                                                        |
| :-------- | :-------------------------------------------------------------- |
| myProfile | [Test-OpenPorts](/_posts/myProfile/Test-OpenPorts/)             |
| myProfile | [Set-GoogleDynamicDNS](/_posts/myProfile/Set-GoogleDynamicDNS/) |
| myProfile | [Set-StaticIPAddress](/_posts/myProfile/Set-StaticIPAddress/)   |
| myProfile | [Test-SSLProtocols](/_posts/myProfile/Test-SSLProtocols/)       |
| myProfile | [Get-CidrIPRange](/_posts/myProfile/Get-CidrIPRange/)           |
| myProfile | [Get-ComputerIP](/_posts/myProfile/Get-ComputerIP/)             |
| myProfile | [Get-ServerIPInfo](/_posts/myProfile/Get-ServerIPInfo/)         |
| myProfile | [Send-MagicPacket](/_posts/myProfile/Send-MagicPacket/)         |
| myProfile | [Set-DHCPIPAddress](/_posts/myProfile/Set-DHCPIPAddress/)       |
| myProfile | [Get-ipInfo](/_posts/myProfile/Get-ipInfo/)                     |
| myProfile | [Get-HostIOResults](/_posts/myProfile/Get-HostIOResults/)       |

---

## ProfileSpecific

| Section   | FileName                                                                                        |
| :-------- | :---------------------------------------------------------------------------------------------- |
| myProfile | [Restart-myProfile](/_posts/myProfile/Restart-myProfile/)                                       |
| myProfile | [Restart-PrintSpooler](/_posts/myProfile/Restart-PrintSpooler/)                                 |
| myProfile | [Restart-Profile](/_posts/myProfile/Restart-Profile/)                                           |
| myProfile | [Get-ProfileFunctions](/_posts/myProfile/Get-ProfileFunctions/)                                 |
| myProfile | [Microsoft.PowerShell_profile](/_posts/myProfile/Microsoft.PowerShell_profile/)                 |
| myProfile | [Microsoft.PowerShell_profile_Example](/_posts/myProfile/Microsoft.PowerShell_profile_Example/) |

---

## activeDirectory

| Section   | FileName                                                                |
| :-------- | :---------------------------------------------------------------------- |
| myProfile | [Get-AllDomainControllers](/_posts/myProfile/Get-AllDomainControllers/) |
| myProfile | [Copy-GroupMembership](/_posts/myProfile/Copy-GroupMembership/)         |
| myProfile | [Disable-InactiveComputer](/_posts/myProfile/Disable-InactiveComputer/) |
| myProfile | [Get-FeaturesInventory](/_posts/myProfile/Get-FeaturesInventory/)       |
| myProfile | [Test-ADReplication](/_posts/myProfile/Test-ADReplication/)             |
| myProfile | [Unlock-UserAccount](/_posts/myProfile/Unlock-UserAccount/)             |

---

## InternetSearch

| Section   | FileName                                                        |
| :-------- | :-------------------------------------------------------------- |
| myProfile | [Get-GoogleDirections](/_posts/myProfile/Get-GoogleDirections/) |
| myProfile | [Get-GoogleSearch](/_posts/myProfile/Get-GoogleSearch/)         |
| myProfile | [Get-DuckDuckGoSearch](/_posts/myProfile/Get-DuckDuckGoSearch/) |

---

## miscellaneous

| Section   | FileName                                                                        |
| :-------- | :------------------------------------------------------------------------------ |
| myProfile | [Get-DownloadPercent](/_posts/myProfile/Get-DownloadPercent/)                   |
| myProfile | [Get-FriendlySize](/_posts/myProfile/Get-FriendlySize/)                         |
| myProfile | [Get-LastBootTime](/_posts/myProfile/Get-LastBootTime/)                         |
| myProfile | [Get-LastInstalledApplication](/_posts/myProfile/Get-LastInstalledApplication/) |
| myProfile | [Get-MyHistory](/_posts/myProfile/Get-MyHistory/)                               |
| myProfile | [Get-PatchTue](/_posts/myProfile/Get-PatchTue/)                                 |
| myProfile | [Get-PayDay](/_posts/myProfile/Get-PayDay/)                                     |
| myProfile | [Get-ScriptFunctionNames](/_posts/myProfile/Get-ScriptFunctionNames/)           |
| myProfile | [Get-ServerTimeZone](/_posts/myProfile/Get-ServerTimeZone/)                     |
| myProfile | [Get-ServiceDetails](/_posts/myProfile/Get-ServiceDetails/)                     |
| myProfile | [Get-SpeedTestServers](/_posts/myProfile/Get-SpeedTestServers/)                 |
| myProfile | [Get-TargetGPResult](/_posts/myProfile/Get-TargetGPResult/)                     |
| myProfile | [Get-TempHumidData](/_posts/myProfile/Get-TempHumidData/)                       |
| myProfile | [Get-Uptime](/_posts/myProfile/Get-Uptime/)                                     |
| myProfile | [Get-Weather](/_posts/myProfile/Get-Weather/)                                   |
| myProfile | [Get-WmiADEvent](/_posts/myProfile/Get-WmiADEvent/)                             |
| myProfile | [Get-WMIHardwareOSInfo](/_posts/myProfile/Get-WMIHardwareOSInfo/)               |
| myProfile | [Get-WTFismyIP](/_posts/myProfile/Get-WTFismyIP/)                               |
| myProfile | [Import-CSVCustom](/_posts/myProfile/Import-CSVCustom/)                         |
| myProfile | [Invoke-BatchArray](/_posts/myProfile/Invoke-BatchArray/)                       |
| myProfile | [Install-PSTools](/_posts/myProfile/Install-PSTools/)                           |
| myProfile | [Test-Computer](/_posts/myProfile/Test-Computer/)                               |

---

## shell

| Section   | FileName                                                  |
| :-------- | :-------------------------------------------------------- |
| myProfile | [New-AdminShell](/_posts/myProfile/New-AdminShell/)       |
| myProfile | [New-AdminTerminal](/_posts/myProfile/New-AdminTerminal/) |
| myProfile | [New-Shell](/_posts/myProfile/New-Shell/)                 |

---

## BloggingFunctions

| Section   | FileName                                                              |
| :-------- | :-------------------------------------------------------------------- |
| myProfile | [New-BlogServer](/_posts/myProfile/New-BlogServer/)                   |
| myProfile | [New-BlogSession](/_posts/myProfile/New-BlogSession/)                 |
| myProfile | [Remove-BlogServer](/_posts/myProfile/Remove-BlogServer/)             |
| myProfile | [Show-LocalBlogSite](/_posts/myProfile/Show-LocalBlogSite/)           |
| myProfile | [Start-Blogging](/_posts/myProfile/Start-Blogging/)                   |
| myProfile | [Get-GistIframe](/_posts/myProfile/Get-GistIframe/)                   |
| myProfile | [Get-DockerStatsSnapshot](/_posts/myProfile/Get-DockerStatsSnapshot/) |

---

## shellConfig

| Section   | FileName                                                        |
| :-------- | :-------------------------------------------------------------- |
| myProfile | [New-Greeting](/_posts/myProfile/New-Greeting/)                 |
| myProfile | [New-DynamicParameter](/_posts/myProfile/New-DynamicParameter/) |
| myProfile | [New-SpeedTest](/_posts/myProfile/New-SpeedTest/)               |
| myProfile | [Save-PasswordFile](/_posts/myProfile/Save-PasswordFile/)       |
| myProfile | [Set-ServerTimeZone](/_posts/myProfile/Set-ServerTimeZone/)     |
| myProfile | [Set-DisplayIsAdmin](/_posts/myProfile/Set-DisplayIsAdmin/)     |
| myProfile | [Show-IsAdminOrNot](/_posts/myProfile/Show-IsAdminOrNot/)       |
| myProfile | [Test-IsAdmin](/_posts/myProfile/Test-IsAdmin/)                 |
| myProfile | [PadOrTruncate](/_posts/myProfile/PadOrTruncate/)               |
| myProfile | [Set-ConsoleConfig](/_posts/myProfile/Set-ConsoleConfig/)       |
| myProfile | [Show-Notification](/_posts/myProfile/Show-Notification/)       |
| myProfile | [Start-TaskList](/_posts/myProfile/Start-TaskList/)             |
| myProfile | [Stop-FailedService](/_posts/myProfile/Stop-FailedService/)     |

---

## transmission

| Section   | FileName                                                                              |
| :-------- | :------------------------------------------------------------------------------------ |
| myProfile | [Test-TransmissionSettings](/_posts/myProfile/Test-TransmissionSettings/)             |
| myProfile | [Set-TransmissionDefaultSettings](/_posts/myProfile/Set-TransmissionDefaultSettings/) |

---
