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

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Microsoft.PowerShell_profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download myProfile
</button>

---

## Office365

| Office365 | Function                                                              |
| :-------- | :-------------------------------------------------------------------- |
| Category  | [Add-Office365Functions](/_posts/myProfile/Add-Office365Functions/)   |
|           | [Stop-Outlook](/_posts/myProfile/Stop-Outlook/)                       |
|           | [Get-OutlookAppointments](/_posts/myProfile/Get-OutlookAppointments/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Connect

| Connect  | Function                                                        |
| :------- | :-------------------------------------------------------------- |
| Category | [Connect-CmRcViewer](/_posts/myProfile/Connect-CmRcViewer/)     |
|          | [Connect-InternalPRTG](/_posts/myProfile/Connect-InternalPRTG/) |
|          | [Connect-PSExec](/_posts/myProfile/Connect-PSExec/)             |
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
|              | [Get-RDPUserReport](/_posts/myProfile/Get-RDPUserReport/)           |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PrintSpooler

| PrintSpooler | Function                                                        |
| :----------- | :-------------------------------------------------------------- |
| Category     | [Disable-PrintSpooler](/_posts/myProfile/Disable-PrintSpooler/) |
|              | [Enable-PrintSpooler](/_posts/myProfile/Enable-PrintSpooler/)   |
|              | [Get-PrintSpooler](/_posts/myProfile/Get-PrintSpooler/)         |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## fileManagement

| fileManagement | Function                                                                        |
| :------------- | :------------------------------------------------------------------------------ |
| Category       | [Find-Movies](/_posts/myProfile/Find-Movies/)                                   |
|                | [Show-PSDrive](/_posts/myProfile/Show-PSDrive/)                                 |
|                | [New-GitDrives](/_posts/myProfile/New-GitDrives/)                               |
|                | [New-PSDrives](/_posts/myProfile/New-PSDrives/)                                 |
|                | [Get-LatestFiles](/_posts/myProfile/Get-LatestFiles/)                           |
|                | [New-DummyFile](/_posts/myProfile/New-DummyFile/)                               |
|                | [New-Shortcut](/_posts/myProfile/New-Shortcut/)                                 |
|                | [Get-FileAndFolderPermissions](/_posts/myProfile/Get-FileAndFolderPermissions/) |
|                | [Search-ForFiles](/_posts/myProfile/Search-ForFiles/)                           |
|                | [Search-Scripts](/_posts/myProfile/Search-Scripts/)                             |
|                | [Select-FolderLocation](/_posts/myProfile/Select-FolderLocation/)               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## InternetIP

| InternetIP | Function                                                        |
| :--------- | :-------------------------------------------------------------- |
| Category   | [Test-OpenPorts](/_posts/myProfile/Test-OpenPorts/)             |
|            | [Set-GoogleDynamicDNS](/_posts/myProfile/Set-GoogleDynamicDNS/) |
|            | [Set-StaticIPAddress](/_posts/myProfile/Set-StaticIPAddress/)   |
|            | [Test-SSLProtocols](/_posts/myProfile/Test-SSLProtocols/)       |
|            | [Get-CidrIPRange](/_posts/myProfile/Get-CidrIPRange/)           |
|            | [Get-ComputerIP](/_posts/myProfile/Get-ComputerIP/)             |
|            | [Get-ServerIPInfo](/_posts/myProfile/Get-ServerIPInfo/)         |
|            | [Send-MagicPacket](/_posts/myProfile/Send-MagicPacket/)         |
|            | [Set-DHCPIPAddress](/_posts/myProfile/Set-DHCPIPAddress/)       |
|            | [Get-ipInfo](/_posts/myProfile/Get-ipInfo/)                     |
|            | [Get-HostIOResults](/_posts/myProfile/Get-HostIOResults/)       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ProfileSpecific

| ProfileSpecific | Function                                                                                        |
| :-------------- | :---------------------------------------------------------------------------------------------- |
| Category        | [Restart-myProfile](/_posts/myProfile/Restart-myProfile/)                                       |
|                 | [Restart-PrintSpooler](/_posts/myProfile/Restart-PrintSpooler/)                                 |
|                 | [Restart-Profile](/_posts/myProfile/Restart-Profile/)                                           |
|                 | [Get-ProfileFunctions](/_posts/myProfile/Get-ProfileFunctions/)                                 |
|                 | [Microsoft.PowerShell_profile](/_posts/myProfile/Microsoft.PowerShell_profile/)                 |
|                 | [Microsoft.PowerShell_profile_Example](/_posts/myProfile/Microsoft.PowerShell_profile_Example/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## activeDirectory

| activeDirectory | Function                                                                |
| :-------------- | :---------------------------------------------------------------------- |
| Category        | [Get-AllDomainControllers](/_posts/myProfile/Get-AllDomainControllers/) |
|                 | [Copy-GroupMembership](/_posts/myProfile/Copy-GroupMembership/)         |
|                 | [Disable-InactiveComputer](/_posts/myProfile/Disable-InactiveComputer/) |
|                 | [Get-FeaturesInventory](/_posts/myProfile/Get-FeaturesInventory/)       |
|                 | [Test-ADReplication](/_posts/myProfile/Test-ADReplication/)             |
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
| Category      | [Get-DownloadPercent](/_posts/myProfile/Get-DownloadPercent/)                   |
|               | [Get-FriendlySize](/_posts/myProfile/Get-FriendlySize/)                         |
|               | [Get-LastBootTime](/_posts/myProfile/Get-LastBootTime/)                         |
|               | [Get-LastInstalledApplication](/_posts/myProfile/Get-LastInstalledApplication/) |
|               | [Get-MyHistory](/_posts/myProfile/Get-MyHistory/)                               |
|               | [Get-PatchTue](/_posts/myProfile/Get-PatchTue/)                                 |
|               | [Get-PayDay](/_posts/myProfile/Get-PayDay/)                                     |
|               | [Get-ScriptFunctionNames](/_posts/myProfile/Get-ScriptFunctionNames/)           |
|               | [Get-ServerTimeZone](/_posts/myProfile/Get-ServerTimeZone/)                     |
|               | [Get-ServiceDetails](/_posts/myProfile/Get-ServiceDetails/)                     |
|               | [Get-SpeedTestServers](/_posts/myProfile/Get-SpeedTestServers/)                 |
|               | [Get-TargetGPResult](/_posts/myProfile/Get-TargetGPResult/)                     |
|               | [Get-TempHumidData](/_posts/myProfile/Get-TempHumidData/)                       |
|               | [Get-Uptime](/_posts/myProfile/Get-Uptime/)                                     |
|               | [Get-Weather](/_posts/myProfile/Get-Weather/)                                   |
|               | [Get-WmiADEvent](/_posts/myProfile/Get-WmiADEvent/)                             |
|               | [Get-WMIHardwareOSInfo](/_posts/myProfile/Get-WMIHardwareOSInfo/)               |
|               | [Get-WTFismyIP](/_posts/myProfile/Get-WTFismyIP/)                               |
|               | [Import-CSVCustom](/_posts/myProfile/Import-CSVCustom/)                         |
|               | [Invoke-BatchArray](/_posts/myProfile/Invoke-BatchArray/)                       |
|               | [Install-PSTools](/_posts/myProfile/Install-PSTools/)                           |
|               | [Test-Computer](/_posts/myProfile/Test-Computer/)                               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## shell

| shell    | Function                                                  |
| :------- | :-------------------------------------------------------- |
| Category | [New-AdminShell](/_posts/myProfile/New-AdminShell/)       |
|          | [New-AdminTerminal](/_posts/myProfile/New-AdminTerminal/) |
|          | [New-Shell](/_posts/myProfile/New-Shell/)                 |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## BloggingFunctions

| BloggingFunctions | Function                                                              |
| :---------------- | :-------------------------------------------------------------------- |
| Category          | [New-JekyllBlogServer](/_posts/myProfile/New-JekyllBlogServer/)       |
|                   | [New-JekyllBlogPost](/_posts/myProfile/New-JekyllBlogPost/)           |
|                   | [New-JekyllBlogSession](/_posts/myProfile/New-JekyllBlogSession/)     |
|                   | [Start-JekyllBlogging](/_posts/myProfile/Start-JekyllBlogging/)       |
|                   | [Remove-JekyllBlogServer](/_posts/myProfile/Remove-JekyllBlogServer/) |
|                   | [Show-JekyllBlogSite](/_posts/myProfile/Show-JekyllBlogSite/)         |
|                   | [Get-GistIframe](/_posts/myProfile/Get-GistIframe/)                   |
|                   | [Get-DockerStatsSnapshot](/_posts/myProfile/Get-DockerStatsSnapshot/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## shellConfig

| shellConfig | Function                                                        |
| :---------- | :-------------------------------------------------------------- |
| Category    | [New-Greeting](/_posts/myProfile/New-Greeting/)                 |
|             | [New-DynamicParameter](/_posts/myProfile/New-DynamicParameter/) |
|             | [New-SpeedTest](/_posts/myProfile/New-SpeedTest/)               |
|             | [Save-PasswordFile](/_posts/myProfile/Save-PasswordFile/)       |
|             | [Set-ServerTimeZone](/_posts/myProfile/Set-ServerTimeZone/)     |
|             | [Set-DisplayIsAdmin](/_posts/myProfile/Set-DisplayIsAdmin/)     |
|             | [Show-IsAdminOrNot](/_posts/myProfile/Show-IsAdminOrNot/)       |
|             | [Test-IsAdmin](/_posts/myProfile/Test-IsAdmin/)                 |
|             | [PadOrTruncate](/_posts/myProfile/PadOrTruncate/)               |
|             | [Set-ConsoleConfig](/_posts/myProfile/Set-ConsoleConfig/)       |
|             | [Show-Notification](/_posts/myProfile/Show-Notification/)       |
|             | [Start-TaskList](/_posts/myProfile/Start-TaskList/)             |
|             | [Stop-FailedService](/_posts/myProfile/Stop-FailedService/)     |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## transmission

| transmission | Function                                                                              |
| :----------- | :------------------------------------------------------------------------------------ |
| Category     | [Test-TransmissionSettings](/_posts/myProfile/Test-TransmissionSettings/)             |
|              | [Set-TransmissionDefaultSettings](/_posts/myProfile/Set-TransmissionDefaultSettings/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---
