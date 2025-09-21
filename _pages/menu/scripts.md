---
layout: page
title: "PowerShell Scripts | Maintenance Scripts"
nav_title: Scripts
heading: PowerShell Scripts Library
description: "Directory of complete PowerShell scripts covering Active Directory, Exchange, and more."
permalink: /menu/_pages/scripts.html
---

<video width="380" height="160" controls autoplay loop muted>
    <source src="/assets/menu/scripts.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [activeDirectory](#activedirectory)
- [eventLogs](#eventlogs)
- [exchange](#exchange)
- [fileManagement](#filemanagement)
- [information](#information)
- [installScripts](#installscripts)
- [miscellaneous](#miscellaneous)
- [ping](#ping)
- [security](#security)
- [time](#time)
- [windowsUpdates](#windowsupdates)

---

## activeDirectory

| Section         | FileName                                                                                                      |
| :-------------- | :------------------------------------------------------------------------------------------------------------ |
| activeDirectory | [Active_Directory_Information.ps1]({% link _posts/scripts/Active_Directory_Information.md %})                             |
| activeDirectory | [ActiveDirectoryDocument.ps1]({% link _posts/scripts/ActiveDirectoryDocument.md %})                                       |
| activeDirectory | [ActiveDirectorySitesandSubnetsReport.ps1]({% link _posts/scripts/ActiveDirectorySitesandSubnetsReport.md %})             |
| activeDirectory | [ActiveDirectorySitesLinksReport.ps1]({% link _posts/scripts/ActiveDirectorySitesLinksReport.md %})                       |
| activeDirectory | [AD-Find_missing_subnets_in_ActiveDirectory.ps1]({% link _posts/scripts/AD-Find_missing_subnets_in_ActiveDirectory.md %}) |
| activeDirectory | [AD-Reporting.ps1]({% link _posts/scripts/AD-Reporting.md %})                                                             |
| activeDirectory | [Ad_Report_Generator_Community.ps1]({% link _posts/scripts/Ad_Report_Generator_Community.md %})                           |
| activeDirectory | [ADACLScan1.3.3.ps1]({% link _posts/scripts/ADACLScan1.3.3.md %})                                                         |
| activeDirectory | [ADChangeReport.ps1]({% link _posts/scripts/ADChangeReport.md %})                                                         |
| activeDirectory | [ADDS_Inventory.ps1]({% link _posts/scripts/ADDS_Inventory.md %})                                                         |
| activeDirectory | [Audit-ADSubnets.ps1]({% link _posts/scripts/Audit-ADSubnets.md %})                                                       |
| activeDirectory | [Audit-ADTrusts.ps1]({% link _posts/scripts/Audit-ADTrusts.md %})                                                         |
| activeDirectory | [CheckActiveDirectorySites.ps1]({% link _posts/scripts/CheckActiveDirectorySites.md %})                                   |
| activeDirectory | [CheckProtectedFromAccidentalDeletion.ps1]({% link _posts/scripts/CheckProtectedFromAccidentalDeletion.md %})             |
| activeDirectory | [CheckRecycleBinStatus.ps1]({% link _posts/scripts/CheckRecycleBinStatus.md %})                                           |
| activeDirectory | [CheckW32TimeSource.ps1]({% link _posts/scripts/CheckW32TimeSource.md %})                                                 |
| activeDirectory | [CircularNestedGroups.ps1]({% link _posts/scripts/CircularNestedGroups.md %})                                             |
| activeDirectory | [Cleanup-AdminSDHolder.ps1]({% link _posts/scripts/Cleanup-AdminSDHolder.md %})                                           |
| activeDirectory | [CreateADMXCentralStore.ps1]({% link _posts/scripts/CreateADMXCentralStore.md %}) |
| activeDirectory | [CreateTimeServerGPOs.ps1]({% link _posts/scripts/CreateTimeServerGPOs.md %}) |
| activeDirectory | [CreateUser.ps1]({% link _posts/scripts/CreateUser.md %})                                                                 |
| activeDirectory | [dhcp_inventory.ps1]({% link _posts/scripts/dhcp_inventory.md %})                                                         |
| activeDirectory | [Export-ADUserInfo.ps1]({% link _posts/scripts/Export-ADUserInfo.md %})                                                   |
| activeDirectory | [Export-PSWNOTREQD.ps1]({% link _posts/scripts/Export-PSWNOTREQD.md %})                                                   |
| activeDirectory | [Find-InactiveUsers.ps1]({% link _posts/scripts/Find-InactiveUsers.md %})                                                 |
| activeDirectory | [Find-SPNs.ps1]({% link _posts/scripts/Find-SPNs.md %})                                                                   |
| activeDirectory | [Find_missing_subnets_in_ActiveDirectory.ps1]({% link _posts/scripts/Find_missing_subnets_in_ActiveDirectory.md %})       |
| activeDirectory | [FindDHCPServers.ps1]({% link _posts/scripts/FindDHCPServers.md %})                                                       |
| activeDirectory | [FindDNSServersAndLocalZones.ps1]({% link _posts/scripts/FindDNSServersAndLocalZones.md %})                               |
| activeDirectory | [FindDuplicateEmployeeIDs.ps1]({% link _posts/scripts/FindDuplicateEmployeeIDs.md %})                                     |
| activeDirectory | [FindOrphanedGPOs.ps1]({% link _posts/scripts/FindOrphanedGPOs.md %})                                                     |
| activeDirectory | [Force-LoggedOnUsertoLogOff.ps1]({% link _posts/scripts/Force-LoggedOnUsertoLogOff.md %})                                 |
| activeDirectory | [GenerateBPAReports.ps1]({% link _posts/scripts/GenerateBPAReports.md %})                                                 |
| activeDirectory | [Get-ADCount.ps1]({% link _posts/scripts/Get-ADCount.md %})                                                               |
| activeDirectory | [Get-ADGroupNesting.ps1]({% link _posts/scripts/Get-ADGroupNesting.md %})                                                 |
| activeDirectory | [Get-ADSchemaReport.ps1]({% link _posts/scripts/Get-ADSchemaReport.md %})                                                 |
| activeDirectory | [Get-AllComputerAccounts.ps1]({% link _posts/scripts/Get-AllComputerAccounts.md %})                                       |
| activeDirectory | [Get-AlternateMailboxes.ps1]({% link _posts/scripts/Get-AlternateMailboxes.md %})                                         |
| activeDirectory | [Get-AuthorizedDHCPServers.ps1]({% link _posts/scripts/Get-AuthorizedDHCPServers.md %})                                   |
| activeDirectory | [Get-CalendarPermissionsReport.ps1]({% link _posts/scripts/Get-CalendarPermissionsReport.md %})                           |
| activeDirectory | [Get-DFSNameSpaceReport.ps1]({% link _posts/scripts/Get-DFSNameSpaceReport.md %})                                         |
| activeDirectory | [Get-dhcpscope.ps1]({% link _posts/scripts/Get-dhcpscope.md %})                                                           |
| activeDirectory | [Get-DHCPServers.ps1]({% link _posts/scripts/Get-DHCPServers.md %})                                                       |
| activeDirectory | [Get-GPOLogonScriptReport.ps1]({% link _posts/scripts/Get-GPOLogonScriptReport.md %})                                     |
| activeDirectory | [Get-GPProcessingTime.ps1]({% link _posts/UserAdminModule/Get-GPProcessingTime.md %})                                             |
| activeDirectory | [Get-LastLogonToCSV.ps1]({% link _posts/scripts/Get-LastLogonToCSV.md %})                                                 |
| activeDirectory | [Get-LockedOutUser.ps1]({% link _posts/scripts/Get-LockedOutUser.md %}) |
| activeDirectory | [Get-NoSettingsGPO.ps1]({% link _posts/scripts/Get-NoSettingsGPO.md %})                                                   |
| activeDirectory | [Get-PrimaryGroupsReport.ps1]({% link _posts/scripts/Get-PrimaryGroupsReport.md %}) |
| activeDirectory | [Get-RODCPasswordRPs.ps1]({% link _posts/scripts/Get-RODCPasswordRPs.md %})                                               |
| activeDirectory | [Get-UserAccountControlReport.ps1]({% link _posts/scripts/Get-UserAccountControlReport.md %}) |
| activeDirectory | [get-usermembership.ps1]({% link _posts/scripts/get-usermembership.md %}) |
| activeDirectory | [Get-UserReport.ps1]({% link _posts/scripts/Get-UserReport.md %}) |
| activeDirectory | [Get_AD_Users_Logon_History.ps1]({% link _posts/scripts/Get_AD_Users_Logon_History.md %})                                 |
| activeDirectory | [GetUserLoggedOnto.ps1]({% link _posts/scripts/GetUserLoggedOnto.md %}) |
| activeDirectory | [gPLink_Report.ps1]({% link _posts/scripts/gPLink_Report.md %})                                                           |
| activeDirectory | [Move-DisabledUsers.ps1]({% link _posts/scripts/Move-DisabledUsers.md %})                                                 |
| activeDirectory | [MoveOU.ps1]({% link _posts/scripts/MoveOU.md %}) |
| activeDirectory | [New-ADAssetReport.ps1]({% link _posts/scripts/New-ADAssetReport.md %})                                                   |
| activeDirectory | [New-ADAssetReportGUI.ps1]({% link _posts/scripts/New-ADAssetReportGUI.md %})                                             |
| activeDirectory | [New-Computer.ps1]({% link _posts/scripts/New-Computer.md %})                                                             |
| activeDirectory | [New-EncryptedUser.ps1]({% link _posts/scripts/New-EncryptedUser.md %}) |
| activeDirectory | [New-KrbtgtKeys.ps1]({% link _posts/scripts/New-KrbtgtKeys.md %}) |
| activeDirectory | [newuserimport.ps1]({% link _posts/scripts/newuserimport.md %})                                                           |
| activeDirectory | [OU_permissions.ps1]({% link _posts/scripts/OU_permissions.md %})                                                         |
| activeDirectory | [privilegedUsersV2.ps1]({% link _posts/scripts/privilegedUsersV2.md %})                                                   |
| activeDirectory | [Query-UserAccountControl.ps1]({% link _posts/scripts/Query-UserAccountControl.md %}) |
| activeDirectory | [RaiseActiveDirectoryFunctionalLevel.ps1]({% link _posts/scripts/RaiseActiveDirectoryFunctionalLevel.md %})               |
| activeDirectory | [Reset-UsersPassword.ps1]({% link _posts/scripts/Reset-UsersPassword.md %}) |
| activeDirectory | [Search-GPO.ps1]({% link _posts/scripts/Search-GPO.md %}) |
| activeDirectory | [Search-GPOsForStringOrig.ps1]({% link _posts/scripts/Search-GPOsForStringOrig.md %}) |
| activeDirectory | [Search-KerbDelegatedAccounts.ps1]({% link _posts/scripts/Search-KerbDelegatedAccounts.md %}) |
| activeDirectory | [Show-OUStructure.ps1]({% link _posts/scripts/Show-OUStructure.md %})                                                     |
| activeDirectory | [Start-ADSyncCycle.ps1]({% link _posts/scripts/Start-ADSyncCycle.md %})                                                   |

---

## EventLogs

| Section   | FileName                                                    |
| :-------- | :---------------------------------------------------------- |
| EventLogs | [Evaluate-EventLog.ps1]({% link _posts/scripts/Evaluate-EventLog.md %}) |
| EventLogs | [EventLogs.ps1]({% link _posts/scripts/EventLogs.md %})                 |
| EventLogs | [EventLogsExported.ps1]({% link _posts/scripts/EventLogsExported.md %}) |
| EventLogs | [EventsToEmail.ps1]({% link _posts/scripts/EventsToEmail.md %})         |
| EventLogs | [EventTest.ps1]({% link _posts/scripts/EventTest.md %})                 |

---

## Exchange

| Section  | FileName                                                                          |
| :------- | :-------------------------------------------------------------------------------- |
| Exchange | [Copy-ReceiveConnector.ps1]({% link _posts/scripts/Copy-ReceiveConnector.md %}) |
| Exchange | [Enter-O365Session.ps1]({% link _posts/scripts/Enter-O365Session.md %}) |
| Exchange | [Exch-AgentLogs.ps1]({% link _posts/scripts/Exch-AgentLogs.md %})                             |
| Exchange | [Exch_AdminAuditReport.ps1]({% link _posts/scripts/Exch_AdminAuditReport.md %})               |
| Exchange | [ExchangeVersions.ps1]({% link _posts/scripts/ExchangeVersions.md %})                         |
| Exchange | [Export-CalendarPermissions.ps1]({% link _posts/scripts/Export-CalendarPermissions.md %}) |
| Exchange | [Export-MailboxSizetoCSV.ps1]({% link _posts/scripts/Export-MailboxSizetoCSV.md %})           |
| Exchange | [Get-MailboxAccessPerms.ps1]({% link _posts/scripts/Get-MailboxAccessPerms.md %}) |
| Exchange | [Get-MailboxPermissions.ps1]({% link _posts/scripts/Get-MailboxPermissions.md %}) |
| Exchange | [Get-MailboxPermissionsExport.ps1]({% link _posts/scripts/Get-MailboxPermissionsExport.md %}) |
| Exchange | [Get-MailboxPermissionsReport.ps1]({% link _posts/scripts/Get-MailboxPermissionsReport.md %}) |
| Exchange | [Get-MailboxPermissionsReport2.ps1]({% link _posts/scripts/Get-MailboxPermissionsReport2.md %}) |
| Exchange | [Get-MailboxPermissionsScript.ps1]({% link _posts/scripts/Get-MailboxPermissionsScript.md %}) |
| Exchange | [Get-MailboxReport.ps1]({% link _posts/scripts/Get-MailboxReport.md %}) |
| Exchange | [Get-MailboxStatistics.ps1]({% link _posts/scripts/Get-MailboxStatistics.md %}) |
| Exchange | [Get-MBAccessPerms.ps1]({% link _posts/scripts/Get-MBAccessPerms.md %}) |
| Exchange | [HideUsersfromAddressBook.ps1]({% link _posts/scripts/HideUsersfromAddressBook.md %})         |
| Exchange | [Locate-Exchange.ps1]({% link _posts/scripts/Locate-Exchange.md %})                           |
| Exchange | [mailbox.ps1]({% link _posts/scripts/mailbox.md %})                                           |
| Exchange | [New-DistributionList.ps1]({% link _posts/scripts/New-DistributionList.md %})                 |
| Exchange | [New-HistoricalSearch.ps1]({% link _posts/scripts/New-HistoricalSearch.md %})                 |
| Exchange | [PasswordChangeNotification.ps1]({% link _posts/scripts/PasswordChangeNotification.md %}) |
| Exchange | [PasswordReminderAlso.ps1]({% link _posts/scripts/PasswordReminderAlso.md %}) |
| Exchange | [Remove-MailboxFolderPermissions.ps1]({% link _posts/scripts/Remove-MailboxFolderPermissions.md %}) |
| Exchange | [Remove-UsersfromGAL.ps1]({% link _posts/scripts/Remove-UsersfromGAL.md %}) |
| Exchange | [Set-AutoDiscover.ps1]({% link _posts/scripts/Set-AutoDiscover.md %}) |
| Exchange | [Set-DefaultReceiveConnector.ps1]({% link _posts/scripts/Set-DefaultReceiveConnector.md %}) |
| Exchange | [Test-ExchangeServerHealth.ps1]({% link _posts/scripts/Test-ExchangeServerHealth.md %})       |

---

## fileManagement

| Section        | FileName                                                                  |
| :------------- | :------------------------------------------------------------------------ |
| fileManagement | [Compare-Folder.ps1]({% link _posts/scripts/Compare-Folder.md %})                     |
| fileManagement | [copyFilestoServers.ps1]({% link _posts/scripts/copyFilestoServers.md %})             |
| fileManagement | [DataDriveSizes.ps1]({% link _posts/scripts/DataDriveSizes.md %})                     |
| fileManagement | [Delete-UnusedHomeFolders.ps1]({% link _posts/scripts/Delete-UnusedHomeFolders.md %}) |
| fileManagement | [Export-FilePermissions.ps1]({% link _posts/scripts/Export-FilePermissions.md %})     |
| fileManagement | [Export-FilePermsAcc.ps1]({% link _posts/scripts/Export-FilePermsAcc.md %})           |
| fileManagement | [FileSizes.ps1]({% link _posts/scripts/FileSizes.md %})                               |
| fileManagement | [Find-DuplicateFiles.ps1]({% link _posts/scripts/Find-DuplicateFiles.md %})           |
| fileManagement | [Find-MissingFiles.ps1]({% link _posts/scripts/Find-MissingFiles.md %})               |
| fileManagement | [Get-FileDownload.ps1]({% link _posts/scripts/Get-FileDownload.md %})                 |
| fileManagement | [Get-FileOwner.ps1]({% link _posts/scripts/Get-FileOwner.md %}) |
| fileManagement | [IISLogsCleanup.ps1]({% link _posts/scripts/IISLogsCleanup.md %}) |
| fileManagement | [LastAccess.ps1]({% link _posts/scripts/LastAccess.md %})                             |
| fileManagement | [New-dummyFile.ps1]({% link _posts/scripts/New-dummyFile.md %})                       |
| fileManagement | [New-FileArchive.ps1]({% link _posts/scripts/New-FileArchive.md %}) |
| fileManagement | [Remove-UserProfile.ps1]({% link _posts/scripts/Remove-UserProfile.md %}) |
| fileManagement | [RemoveLocalUserProfile.ps1]({% link _posts/scripts/RemoveLocalUserProfile.md %}) |
| fileManagement | [SyncFoldersScript.ps1]({% link _posts/scripts/SyncFoldersScript.md %})               |
| fileManagement | [UncompressZip-SameDestination.ps1]({% link _posts/scripts/UncompressZip-SameDestination.md %}) |

---

## information

| Section     | FileName                                                            |
| :---------- | :------------------------------------------------------------------ |
| information | [Collect-ServerInfo.ps1]({% link _posts/scripts/Collect-ServerInfo.md %})       |
| information | [Export-PrinterQueues.ps1]({% link _posts/scripts/Export-PrinterQueues.md %})   |
| information | [ExportFirewallRules.ps1]({% link _posts/scripts/ExportFirewallRules.md %})     |
| information | [Get-DiskSpace.ps1]({% link _posts/scripts/Get-DiskSpace.md %})                 |
| information | [Get-IPConfig.ps1]({% link _posts/scripts/Get-IPConfig.md %}) |
| information | [Get-ReportDownload.ps1]({% link _posts/scripts/Get-ReportDownload.md %})       |
| information | [Get-WifiPassword.ps1]({% link _posts/scripts/Get-WifiPassword.md %})           |
| information | [GetComputerHTMLReport.ps1]({% link _posts/scripts/GetComputerHTMLReport.md %}) |
| information | [GetComputerInventory.ps1]({% link _posts/scripts/GetComputerInventory.md %})   |
| information | [GetWindowsFeatures.ps1]({% link _posts/scripts/GetWindowsFeatures.md %}) |
| information | [Hardware-Report.ps1]({% link _posts/scripts/Hardware-Report.md %})             |
| information | [html-report.ps1]({% link _posts/scripts/html-report.md %})                     |
| information | [O365UserLicenseReport.ps1]({% link _posts/scripts/O365UserLicenseReport.md %}) |
| information | [Office365HTMLReport.ps1]({% link _posts/scripts/Office365HTMLReport.md %})     |
| information | [Resolve-DNSList.ps1]({% link _posts/scripts/Resolve-DNSList.md %}) |

---

## installScripts

| Section        | FileName                                                                |
| :------------- | :---------------------------------------------------------------------- |
| installScripts | [Install-O365Modules.ps1]({% link _posts/scripts/Install-O365Modules.md %})         |
| installScripts | [Install-PoshBot.ps1]({% link _posts/scripts/Install-PoshBot.md %})                 |
| installScripts | [Install-RSATonline.ps1]({% link _posts/scripts/Install-RSATonline.md %})           |
| installScripts | [InstallADDocsModules.ps1]({% link _posts/scripts/InstallADDocsModules.md %})       |
| installScripts | [InstallPwnedPasswordDLL.ps1]({% link _posts/scripts/InstallPwnedPasswordDLL.md %}) |

---

## ping

| Section | FileName                                                  |
| :------ | :-------------------------------------------------------- |
| ping    | [Dotnetping.ps1]({% link _posts/scripts/Dotnetping.md %})             |
| ping    | [Get-PingMonitor.ps1]({% link _posts/scripts/Get-PingMonitor.md %}) |
| ping    | [Ping-DNSServers.ps1]({% link _posts/scripts/Ping-DNSServers.md %})   |
| ping    | [PingAllComputers.ps1]({% link _posts/scripts/PingAllComputers.md %}) |

---

## security

| Section | FileName |
| :------ | :------- |
| security | [Export-Bitlocker.ps1]({% link _posts/scripts/Export-Bitlocker.md %}) |
| security | [Export-BitlockerComp.ps1]({% link _posts/scripts/Export-BitlockerComp.md %}) |
| security | [Export-BitlockerParams.ps1]({% link _posts/scripts/Export-BitlockerParams.md %}) |
| security | [Invoke-UrlScan.ps1]({% link _posts/scripts/Invoke-UrlScan.md %}) |
| security | [New-PassPhrase.ps1]({% link _posts/scripts/New-PassPhrase.md %}) |
| security | [New-KrbtgtKeys.ps1](/scripts/security/new-krbtgtkeys/) |
---

## time

| Section | FileName                                                                |
| :------ | :---------------------------------------------------------------------- |
| time    | [Get-CurrentWorldTime.ps1]({% link _posts/scripts/Get-CurrentWorldTime.md %})       |
| time    | [Get-TimeZoneInformation.ps1]({% link _posts/scripts/Get-TimeZoneInformation.md %}) |
| time    | [Worldtimeclock.ps1]({% link _posts/scripts/Worldtimeclock.md %})                   |

---

## windowsUpdates

| Section        | FileName                                                                                |
| :------------- | :-------------------------------------------------------------------------------------- |
| windowsUpdates | [Export-WindowsUpdates.ps1]({% link _posts/scripts/Export-WindowsUpdates.md %})                     |
| windowsUpdates | [Export-WUpdateHistory.ps1]({% link _posts/scripts/Export-WUpdateHistory.md %})                     |
| windowsUpdates | [Get-HotFixReport.ps1]({% link _posts/scripts/Get-HotFixReport.md %})                               |
| windowsUpdates | [Get-WindowsUpdatesInstalled.ps1]({% link _posts/scripts/Get-WindowsUpdatesInstalled.md %})         |
| windowsUpdates | [Get-WindowsUpdatesInstalledList.ps1]({% link _posts/scripts/Get-WindowsUpdatesInstalledList.md %}) |

---

## miscellaneous

| Section       | FileName                                                                    |
| :------------ | :-------------------------------------------------------------------------- |
| miscellaneous | [AutoBitlocker.ps1]({% link _posts/scripts/AutoBitlocker.md %})                         |
| miscellaneous | [Blank-Page.ps1]({% link _posts/scripts/Encrypt-Laptop.md %})                           |
| miscellaneous | [chart-driveSpace.V2.ps1]({% link _posts/scripts/chart-driveSpace.V2.md %})             |
| miscellaneous | [Config-Psmodulepath.ps1]({% link _posts/scripts/Config-Psmodulepath.md %})             |
| miscellaneous | [ConfigureWinrm.ps1]({% link _posts/scripts/ConfigureWinrm.md %})                       |
| miscellaneous | [DiskCleanup.ps1]({% link _posts/scripts/DiskCleanup.md %})                             |
| miscellaneous | [diskmonitor.ps1]({% link _posts/scripts/diskmonitor.md %})                             |
| miscellaneous | [HyperVGoldenImage.ps1]({% link _posts/scripts/HyperVGoldenImage.md %})                 |
| miscellaneous | [Invoke-FTPUpload.ps1]({% link _posts/scripts/Invoke-FTPUpload.md %}) |
| miscellaneous | [Invoke-WebrequestCookie.ps1]({% link _posts/scripts/Invoke-WebrequestCookie.md %}) |
| miscellaneous | [Stop-FailedServiceScript.ps1]({% link _posts/scripts/Stop-FailedServiceScript.md %})   |
| miscellaneous | [Test-EmailAddress.ps1]({% link _posts/scripts/Test-EmailAddress.md %}) |
| miscellaneous | [Update-DynamicDNSTemplate.ps1]({% link _posts/scripts/Update-DynamicDNSTemplate.md %}) |
| miscellaneous | [VMWareGoldenImage.ps1]({% link _posts/scripts/VMWareGoldenImage.md %})                 |
| miscellaneous | [VMWareHealthcheck.ps1]({% link _posts/scripts/VMWareHealthcheck.md %}) |
| miscellaneous | [Write-MatrixMessage.ps1]({% link _posts/scripts/Write-MatrixMessage.md %})             |

---


