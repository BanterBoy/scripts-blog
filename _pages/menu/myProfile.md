---
layout: page
title: myProfile
description: "Luke's personal PowerShell profile modules and helper functions organized by area."
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Microsoft.PowerShell_profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download myProfile
</button>

---

## Office365

| Office365 | Function                                                              |
| :-------- | :-------------------------------------------------------------------- |
| Category  | [Add-Office365Functions](/_posts/UserAdminModule/Add-Office365Functions/)   |
|           | [Stop-Outlook](/_posts/UserAdminModule/Stop-Outlook/)                       |
|           | [Get-OutlookAppointments](/_posts/UserAdminModule/Get-OutlookAppointments/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Connect

| Connect  | Function                                                        |
| :------- | :-------------------------------------------------------------- |
| Category | [Connect-CmRcViewer](/_posts/UserAdminModule/Connect-CmRcViewer/)     |
|          | [Connect-InternalPRTG](/_posts/UserAdminModule/Connect-InternalPRTG/) |
|          | [Connect-PSExec](/_posts/UserAdminModule/Connect-PSExec/)             |
|          | [Connect-RDPSession](/_posts/myProfile/Connect-RDPSession/)     |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## RDPfunctions

| RDPfunctions | Function                                                            |
| :----------- | :------------------------------------------------------------------ |
| Category     | [Get-RDPStatusCIM](/_posts/myProfile/Get-RDPStatusCIM/)             |
|              | [Enable-RDPRemotelyCIM](/_posts/myProfile/Enable-RDPRemotelyCIM/)   |
|              | [Disable-RDPRemotelyCIM](/_posts/myProfile/Disable-RDPRemotelyCIM/) |
|              | [Get-RDPStatusWMI](/_posts/myProfile/Get-RDPStatusWMI/)             |
|              | [Enable-RDPRemotelyWMI](/_posts/myProfile/Enable-RDPRemotelyWMI/)   |
|              | [Disable-RDPRemotelyWMI](/_posts/myProfile/Disable-RDPRemotelyWMI/) |
|              | [Get-RDPUserReport](/_posts/UserAdminModule/Get-RDPUserReport/)           |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PrintSpooler

| PrintSpooler | Function                                                        |
| :----------- | :-------------------------------------------------------------- |
| Category     | [Disable-PrintSpooler](/_posts/UserAdminModule/Disable-PrintSpooler/) |
|              | [Enable-PrintSpooler](/_posts/UserAdminModule/Enable-PrintSpooler/)   |
|              | [Get-PrintSpooler](/_posts/UserAdminModule/Get-PrintSpooler/)         |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## fileManagement

| fileManagement | Function                                                                        |
| :------------- | :------------------------------------------------------------------------------ |
| Category       | [Find-Movies](/_posts/UserAdminModule/Find-Movies/)                                   |
|                | [Show-PSDrive](/_posts/UserAdminModule/Show-PSDrive/)                                 |
|                | [New-GitDrives](/_posts/myProfile/New-GitDrives/)                               |
|                | [New-PSDrives](/_posts/myProfile/New-PSDrives/)                                 |
|                | [Get-LatestFiles](/_posts/UserAdminModule/Get-LatestFiles/)                           |
|                | [New-DummyFile](/_posts/UserAdminModule/New-DummyFile/)                               |
|                | [New-Shortcut](/_posts/UserAdminModule/New-Shortcut/)                                 |
|                | [Get-FileAndFolderPermissions](/_posts/UserAdminModule/Get-FileAndFolderPermissions/) |
|                | [Search-ForFiles](/_posts/UserAdminModule/Search-ForFiles/)                           |
|                | [Search-Scripts](/_posts/UserAdminModule/Search-Scripts/)                             |
|                | [Select-FolderLocation](/_posts/UserAdminModule/Select-FolderLocation/)               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## InternetIP

| InternetIP | Function                                                        |
| :--------- | :-------------------------------------------------------------- |
| Category   | [Test-OpenPorts](/_posts/UserAdminModule/Test-OpenPorts/)             |
|            | [Set-GoogleDynamicDNS](/_posts/UserAdminModule/Set-GoogleDynamicDNS/) |
|            | [Set-StaticIPAddress](/_posts/UserAdminModule/Set-StaticIPAddress/)   |
|            | [Test-SSLProtocols](/_posts/UserAdminModule/Test-SSLProtocols/)       |
|            | [Get-CidrIPRange](/_posts/UserAdminModule/Get-CidrIPRange/)           |
|            | [Get-ComputerIP](/_posts/UserAdminModule/Get-ComputerIP/)             |
|            | [Get-ServerIPInfo](/_posts/UserAdminModule/Get-ServerIPInfo/)         |
|            | [Send-MagicPacket](/_posts/UserAdminModule/Send-MagicPacket/)         |
|            | [Set-DHCPIPAddress](/_posts/UserAdminModule/Set-DHCPIPAddress/)       |
|            | [Get-ipInfo](/_posts/UserAdminModule/Get-ipInfo/)                     |
|            | [Get-HostIOResults](/_posts/UserAdminModule/Get-HostIOResults/)       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ProfileSpecific

| ProfileSpecific | Function                                                                                        |
| :-------------- | :---------------------------------------------------------------------------------------------- |
| Category        | [Restart-myProfile](/_posts/myProfile/Restart-myProfile/)                                       |
|                 | [Restart-PrintSpooler](/_posts/UserAdminModule/Restart-PrintSpooler/)                                 |
|                 | [Restart-Profile](/_posts/UserAdminModule/Restart-Profile/)                                           |
|                 | [Get-ProfileFunctions](/_posts/myProfile/Get-ProfileFunctions/)                                 |
|                 | [Microsoft.PowerShell_profile](/_posts/myProfile/Microsoft.PowerShell_profile/)                 |
|                 | [Microsoft.PowerShell_profile_Example](/_posts/myProfile/Microsoft.PowerShell_profile_Example/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## activeDirectory

| activeDirectory | Function                                                                |
| :-------------- | :---------------------------------------------------------------------- |
| Category        | [Get-AllDomainControllers](/_posts/UserAdminModule/Get-AllDomainControllers/) |
|                 | [Copy-GroupMembership](/_posts/UserAdminModule/Copy-GroupMembership/)         |
|                 | [Disable-InactiveComputer](/_posts/UserAdminModule/Disable-InactiveComputer/) |
|                 | [Get-FeaturesInventory](/_posts/UserAdminModule/Get-FeaturesInventory/)       |
|                 | [Test-ADReplication](/_posts/UserAdminModule/Test-ADReplication/)             |
|                 | [Unlock-UserAccount](/_posts/myProfile/Unlock-UserAccount/)             |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## InternetSearch

| InternetSearch | Function                                                        |
| :------------- | :-------------------------------------------------------------- |
| Category       | [Get-GoogleDirections](/_posts/myProfile/Get-GoogleDirections/) |
|                | [Get-GoogleSearch](/_posts/myProfile/Get-GoogleSearch/)         |
|                | [Get-DuckDuckGoSearch](/_posts/myProfile/Get-DuckDuckGoSearch/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## miscellaneous

| miscellaneous | Function                                                                        |
| :------------ | :------------------------------------------------------------------------------ |
| Category      | [Get-DownloadPercent](/_posts/UserAdminModule/Get-DownloadPercent/)                   |
|               | [Get-FriendlySize](/_posts/UserAdminModule/Get-FriendlySize/)                         |
|               | [Get-LastBootTime](/_posts/UserAdminModule/Get-LastBootTime/)                         |
|               | [Get-LastInstalledApplication](/_posts/UserAdminModule/Get-LastInstalledApplication/) |
|               | [Get-MyHistory](/_posts/UserAdminModule/Get-MyHistory/)                               |
|               | [Get-PatchTue](/_posts/UserAdminModule/Get-PatchTue/)                                 |
|               | [Get-PayDay](/_posts/UserAdminModule/Get-PayDay/)                                     |
|               | [Get-ScriptFunctionNames](/_posts/UserAdminModule/Get-ScriptFunctionNames/)           |
|               | [Get-ServerTimeZone](/_posts/UserAdminModule/Get-ServerTimeZone/)                     |
|               | [Get-ServiceDetails](/_posts/myProfile/Get-ServiceDetails/)                     |
|               | [Get-SpeedTestServers](/_posts/UserAdminModule/Get-SpeedTestServers/)                 |
|               | [Get-TargetGPResult](/_posts/UserAdminModule/Get-TargetGPResult/)                     |
|               | [Get-TempHumidData](/_posts/myProfile/Get-TempHumidData/)                       |
|               | [Get-Uptime](/_posts/myProfile/Get-Uptime/)                                     |
|               | [Get-Weather](/_posts/UserAdminModule/Get-Weather/)                                   |
|               | [Get-WmiADEvent](/_posts/UserAdminModule/Get-WmiADEvent/)                             |
|               | [Get-WMIHardwareOSInfo](/_posts/UserAdminModule/Get-WMIHardwareOSInfo/)               |
|               | [Get-WTFismyIP](/_posts/UserAdminModule/Get-WTFismyIP/)                               |
|               | [Import-CSVCustom](/_posts/UserAdminModule/Import-CSVCustom/)                         |
|               | [Invoke-BatchArray](/_posts/UserAdminModule/Invoke-BatchArray/)                       |
|               | [Install-PSTools](/_posts/UserAdminModule/Install-PSTools/)                           |
|               | [Test-Computer](/_posts/UserAdminModule/Test-Computer/)                               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## shell

| shell    | Function                                                  |
| :------- | :-------------------------------------------------------- |
| Category | [New-AdminShell](/_posts/myProfile/New-AdminShell/)       |
|          | [New-AdminTerminal](/_posts/myProfile/New-AdminTerminal/) |
|          | [New-Shell](/_posts/UserAdminModule/New-Shell/)                 |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## BloggingFunctions

| BloggingFunctions | Function                                                              |
| :---------------- | :-------------------------------------------------------------------- |
| Category          | [New-JekyllBlogServer](/_posts/UserAdminModule/New-JekyllBlogServer/)       |
|                   | [New-JekyllBlogPost](/_posts/UserAdminModule/New-JekyllBlogPost/)           |
|                   | [New-JekyllBlogSession](/_posts/UserAdminModule/New-JekyllBlogSession/)     |
|                   | [Start-JekyllBlogging](/_posts/UserAdminModule/Start-JekyllBlogging/)       |
|                   | [Remove-JekyllBlogServer](/_posts/UserAdminModule/Remove-JekyllBlogServer/) |
|                   | [Show-JekyllBlogSite](/_posts/UserAdminModule/Show-JekyllBlogSite/)         |
|                   | [Get-GistIframe](/_posts/UserAdminModule/Get-GistIframe/)                   |
|                   | [Get-DockerStatsSnapshot](/_posts/UserAdminModule/Get-DockerStatsSnapshot/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## shellConfig

| shellConfig | Function                                                        |
| :---------- | :-------------------------------------------------------------- |
| Category    | [New-Greeting](/_posts/UserAdminModule/New-Greeting/)                 |
|             | [New-DynamicParameter](/_posts/UserAdminModule/New-DynamicParameter/) |
|             | [New-SpeedTest](/_posts/UserAdminModule/New-SpeedTest/)               |
|             | [Save-PasswordFile](/_posts/UserAdminModule/Save-PasswordFile/)       |
|             | [Set-ServerTimeZone](/_posts/UserAdminModule/Set-ServerTimeZone/)     |
|             | [Set-DisplayIsAdmin](/_posts/UserAdminModule/Set-DisplayIsAdmin/)     |
|             | [Show-IsAdminOrNot](/_posts/UserAdminModule/Show-IsAdminOrNot/)       |
|             | [Test-IsAdmin](/_posts/UserAdminModule/Test-IsAdmin/)                 |
|             | [PadOrTruncate](/_posts/UserAdminModule/PadOrTruncate/)               |
|             | [Set-ConsoleConfig](/_posts/UserAdminModule/Set-ConsoleConfig/)       |
|             | [Show-Notification](/_posts/UserAdminModule/Show-Notification/)       |
|             | [Start-TaskList](/_posts/myProfile/Start-TaskList/)             |
|             | [Stop-FailedService](/_posts/UserAdminModule/Stop-FailedService/)     |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## transmission

| transmission | Function                                                                              |
| :----------- | :------------------------------------------------------------------------------------ |
| Category     | [Test-TransmissionSettings](/_posts/UserAdminModule/Test-TransmissionSettings/)             |
|              | [Set-TransmissionDefaultSettings](/_posts/UserAdminModule/Set-TransmissionDefaultSettings/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---
