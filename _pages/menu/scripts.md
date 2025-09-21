---
layout: page
title: scripts
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
- [ping](#ping)
- [time](#time)
- [windowsUpdates](#windowsupdates)
- [miscellaneous](#miscellaneous)
- [network](#network)
- [security](#security)
- [testing](#testing)
- [utilities](#utilities)

---

## activeDirectory

| Section         | FileName                                                                                                      |
| :-------------- | :------------------------------------------------------------------------------------------------------------ |
| activeDirectory | [Active_Directory_Information.ps1](/scripts/active-directory-information/)                             |
| activeDirectory | [ActiveDirectoryDocument.ps1](/scripts/activedirectorydocument/)                                       |
| activeDirectory | [ActiveDirectorySitesandSubnetsReport.ps1](/scripts/activedirectorysitesandsubnetsreport/)             |
| activeDirectory | [ActiveDirectorySitesLinksReport.ps1](/scripts/activedirectorysiteslinksreport/)                       |
| activeDirectory | [Ad_Report_Generator_Community.ps1](/scripts/ad-report-generator-community/)                           |
| activeDirectory | [AD-Find_missing_subnets_in_ActiveDirectory.ps1](/scripts/ad-find-missing-subnets-in-activedirectory/) |
| activeDirectory | [AD-Reporting.ps1](/scripts/ad-reporting/)                                                             |
| activeDirectory | [ADACLScan1.3.3.ps1](/scripts/adaclscan1-3-3/)                                                         |
| activeDirectory | [ADChangeReport.ps1](/scripts/adchangereport/)                                                         |
| activeDirectory | [ADDS_Inventory.ps1](/scripts/adds-inventory/)                                                         |
| activeDirectory | [Audit-ADSubnets.ps1](/scripts/audit-adsubnets/)                                                       |
| activeDirectory | [Audit-ADTrusts.ps1](/scripts/audit-adtrusts/)                                                         |
| activeDirectory | [CheckActiveDirectorySites.ps1](/scripts/checkactivedirectorysites/)                                   |
| activeDirectory | [CheckProtectedFromAccidentalDeletion.ps1](/scripts/checkprotectedfromaccidentaldeletion/)             |
| activeDirectory | [CheckRecycleBinStatus.ps1](/scripts/checkrecyclebinstatus/)                                           |
| activeDirectory | [CheckW32TimeSource.ps1](/scripts/checkw32timesource/)                                                 |
| activeDirectory | [CircularNestedGroups.ps1](/scripts/circularnestedgroups/)                                             |
| activeDirectory | [Cleanup-AdminSDHolder.ps1](/scripts/cleanup-adminsdholder/)                                           |
| activeDirectory | [CreateUser.ps1](/scripts/createuser/)                                                                 |
| activeDirectory | [dhcp_inventory.ps1](/scripts/dhcp-inventory/)                                                         |
| activeDirectory | [Export-ADUserInfo.ps1](/scripts/export-aduserinfo/)                                                   |
| activeDirectory | [Export-PSWNOTREQD.ps1](/scripts/export-pswnotreqd/)                                                   |
| activeDirectory | [Find_missing_subnets_in_ActiveDirectory.ps1](/scripts/find-missing-subnets-in-activedirectory/)       |
| activeDirectory | [Find-InactiveUsers.ps1](/scripts/find-inactiveusers/)                                                 |
| activeDirectory | [Find-SPNs.ps1](/scripts/find-spns/)                                                                   |
| activeDirectory | [FindDHCPServers.ps1](/scripts/finddhcpservers/)                                                       |
| activeDirectory | [FindDNSServersAndLocalZones.ps1](/scripts/finddnsserversandlocalzones/)                               |
| activeDirectory | [FindDuplicateEmployeeIDs.ps1](/scripts/findduplicateemployeeids/)                                     |
| activeDirectory | [FindOrphanedGPOs.ps1](/scripts/findorphanedgpos/)                                                     |
| activeDirectory | [Force-LoggedOnUsertoLogOff.ps1](/scripts/force-loggedonusertologoff/)                                 |
| activeDirectory | [GenerateBPAReports.ps1](/scripts/generatebpareports/)                                                 |
| activeDirectory | [Get_AD_Users_Logon_History.ps1](/scripts/get-ad-users-logon-history/)                                 |
| activeDirectory | [Get-ADCount.ps1](/scripts/get-adcount/)                                                               |
| activeDirectory | [Get-ADGroupNesting.ps1](/scripts/get-adgroupnesting/)                                                 |
| activeDirectory | [Get-ADSchemaReport.ps1](/scripts/get-adschemareport/)                                                 |
| activeDirectory | [Get-AllComputerAccounts.ps1](/scripts/get-allcomputeraccounts/)                                       |
| activeDirectory | [Get-AlternateMailboxes.ps1](/scripts/get-alternatemailboxes/)                                         |
| activeDirectory | [Get-AuthorizedDHCPServers.ps1](/scripts/get-authorizeddhcpservers/)                                   |
| activeDirectory | [Get-CalendarPermissionsReport.ps1](/scripts/get-calendarpermissionsreport/)                           |
| activeDirectory | [Get-DFSNameSpaceReport.ps1](/scripts/get-dfsnamespacereport/)                                         |
| activeDirectory | [Get-dhcpscope.ps1](/scripts/get-dhcpscope/)                                                           |
| activeDirectory | [Get-DHCPServers.ps1](/scripts/get-dhcpservers/)                                                       |
| activeDirectory | [Get-GPOLogonScriptReport.ps1](/scripts/get-gpologonscriptreport/)                                     |
| activeDirectory | [Get-GPProcessingTime.ps1](/scripts/get-gpprocessingtime/)                                             |
| activeDirectory | [Get-LastLogonToCSV.ps1](/scripts/get-lastlogontocsv/)                                                 |
| activeDirectory | [Get-NoSettingsGPO.ps1](/scripts/get-nosettingsgpo/)                                                   |
| activeDirectory | [Get-RODCPasswordRPs.ps1](/scripts/get-rodcpasswordrps/)                                               |
| activeDirectory | [gPLink_Report.ps1](/scripts/gplink-report/)                                                           |
| activeDirectory | [Move-DisabledUsers.ps1](/scripts/move-disabledusers/)                                                 |
| activeDirectory | [New-ADAssetReport.ps1](/scripts/new-adassetreport/)                                                   |
| activeDirectory | [New-ADAssetReportGUI.ps1](/scripts/new-adassetreportgui/)                                             |
| activeDirectory | [New-Computer.ps1](/scripts/new-computer/)                                                             |
| activeDirectory | [newuserimport.ps1](/scripts/newuserimport/)                                                           |
| activeDirectory | [OU_permissions.ps1](/scripts/ou-permissions/)                                                         |
| activeDirectory | [privilegedUsersV2.ps1](/scripts/privilegedusersv2/)                                                   |
| activeDirectory | [RaiseActiveDirectoryFunctionalLevel.ps1](/scripts/raiseactivedirectoryfunctionallevel/)               |
| activeDirectory | [Show-OUStructure.ps1](/scripts/show-oustructure/)                                                     |
| activeDirectory | [Start-ADSyncCycle.ps1](/scripts/start-adsynccycle/)                                                   |

---

## EventLogs

| Section   | FileName                                                    |
| :-------- | :---------------------------------------------------------- |
| EventLogs | [Evaluate-EventLog.ps1](/scripts/evaluate-eventlog/) |
| EventLogs | [EventLogs.ps1](/scripts/eventlogs/)                 |
| EventLogs | [EventLogsExported.ps1](/scripts/eventlogsexported/) |
| EventLogs | [EventsToEmail.ps1](/scripts/eventstoemail/)         |
| EventLogs | [EventTest.ps1](/scripts/eventtest/)                 |

---

## Exchange

| Section  | FileName                                                                          |
| :------- | :-------------------------------------------------------------------------------- |
| Exchange | [Exch_AdminAuditReport.ps1](/scripts/exch-adminauditreport/)               |
| Exchange | [Exch-AgentLogs.ps1](/scripts/exch-agentlogs/)                             |
| Exchange | [ExchangeVersions.ps1](/scripts/exchangeversions/)                         |
| Exchange | [Export-MailboxSizetoCSV.ps1](/scripts/export-mailboxsizetocsv/)           |
| Exchange | [Get-MailboxPermissionsScript.ps1](/scripts/get-mailboxpermissionsscript/) |
| Exchange | [HideUsersfromAddressBook.ps1](/scripts/hideusersfromaddressbook/)         |
| Exchange | [Locate-Exchange.ps1](/scripts/locate-exchange/)                           |
| Exchange | [mailbox.ps1](/scripts/mailbox/)                                           |
| Exchange | [New-DistributionList.ps1](/scripts/new-distributionlist/)                 |
| Exchange | [New-HistoricalSearch.ps1](/scripts/new-historicalsearch/)                 |
| Exchange | [Test-ExchangeServerHealth.ps1](/scripts/test-exchangeserverhealth/)       |

---

## fileManagement

| Section        | FileName                                                                  |
| :------------- | :------------------------------------------------------------------------ |
| fileManagement | [Compare-Folder.ps1](/scripts/compare-folder/)                     |
| fileManagement | [copyFilestoServers.ps1](/scripts/copyfilestoservers/)             |
| fileManagement | [DataDriveSizes.ps1](/scripts/datadrivesizes/)                     |
| fileManagement | [Delete-UnusedHomeFolders.ps1](/scripts/delete-unusedhomefolders/) |
| fileManagement | [Export-FilePermissions.ps1](/scripts/export-filepermissions/)     |
| fileManagement | [Export-FilePermsAcc.ps1](/scripts/export-filepermsacc/)           |
| fileManagement | [FileSizes.ps1](/scripts/filesizes/)                               |
| fileManagement | [Find-DuplicateFiles.ps1](/scripts/find-duplicatefiles/)           |
| fileManagement | [Find-MissingFiles.ps1](/scripts/find-missingfiles/)               |
| fileManagement | [Get-FileDownload.ps1](/scripts/get-filedownload/)                 |
| fileManagement | [LastAccess.ps1](/scripts/lastaccess/)                             |
| fileManagement | [New-dummyFile.ps1](/scripts/new-dummyfile/)                       |
| fileManagement | [SyncFoldersScript.ps1](/scripts/syncfoldersscript/)               |

---

## information

| Section     | FileName                                                            |
| :---------- | :------------------------------------------------------------------ |
| information | [Collect-ServerInfo.ps1](/scripts/collect-serverinfo/)       |
| information | [Export-PrinterQueues.ps1](/scripts/export-printerqueues/)   |
| information | [ExportFirewallRules.ps1](/scripts/exportfirewallrules/)     |
| information | [Get-DiskSpace.ps1](/scripts/get-diskspace/)                 |
| information | [Get-ReportDownload.ps1](/scripts/get-reportdownload/)       |
| information | [Get-WifiPassword.ps1](/scripts/get-wifipassword/)           |
| information | [GetComputerHTMLReport.ps1](/scripts/getcomputerhtmlreport/) |
| information | [GetComputerInventory.ps1](/scripts/getcomputerinventory/)   |
| information | [Hardware-Report.ps1](/scripts/hardware-report/)             |
| information | [html-report.ps1](/scripts/html-report/)                     |
| information | [O365UserLicenseReport.ps1](/scripts/o365userlicensereport/) |
| information | [Office365HTMLReport.ps1](/scripts/office365htmlreport/)     |

---

## installScripts

| Section        | FileName                                                                |
| :------------- | :---------------------------------------------------------------------- |
| installScripts | [Install-O365Modules.ps1](/scripts/install-o365modules/)         |
| installScripts | [Install-PoshBot.ps1](/scripts/install-poshbot/)                 |
| installScripts | [Install-RSATonline.ps1](/scripts/install-rsatonline/)           |
| installScripts | [InstallADDocsModules.ps1](/scripts/installaddocsmodules/)       |
| installScripts | [InstallPwnedPasswordDLL.ps1](/scripts/installpwnedpassworddll/) |

---

## ping

| Section | FileName                                                  |
| :------ | :-------------------------------------------------------- |
| ping    | [Dotnetping.ps1](/scripts/dotnetping/)             |
| ping    | [Ping-DNSServers.ps1](/scripts/ping-dnsservers/)   |
| ping    | [PingAllComputers.ps1](/scripts/pingallcomputers/) |

---

## time

| Section | FileName                                                                |
| :------ | :---------------------------------------------------------------------- |
| time    | [Get-CurrentWorldTime.ps1](/scripts/get-currentworldtime/)       |
| time    | [Get-TimeZoneInformation.ps1](/scripts/get-timezoneinformation/) |
| time    | [Worldtimeclock.ps1](/scripts/worldtimeclock/)                   |

---

## windowsUpdates

| Section        | FileName                                                                                |
| :------------- | :-------------------------------------------------------------------------------------- |
| windowsUpdates | [Export-WindowsUpdates.ps1](/scripts/export-windowsupdates/)                     |
| windowsUpdates | [Export-WUpdateHistory.ps1](/scripts/export-wupdatehistory/)                     |
| windowsUpdates | [Get-HotFixReport.ps1](/scripts/get-hotfixreport/)                               |
| windowsUpdates | [Get-WindowsUpdatesInstalled.ps1](/scripts/get-windowsupdatesinstalled/)         |
| windowsUpdates | [Get-WindowsUpdatesInstalledList.ps1](/scripts/get-windowsupdatesinstalledlist/) |

---

## miscellaneous

| Section       | FileName                                                                    |
| :------------ | :-------------------------------------------------------------------------- |
| miscellaneous | [AutoBitlocker.ps1](/scripts/autobitlocker/)                         |
| miscellaneous | [chart-driveSpace.V2.ps1](/scripts/chart-drivespace-v2/)             |
| miscellaneous | [Config-Psmodulepath.ps1](/scripts/config-psmodulepath/)             |
| miscellaneous | [ConfigureWinrm.ps1](/scripts/configurewinrm/)                       |
| miscellaneous | [DiskCleanup.ps1](/scripts/diskcleanup/)                             |
| miscellaneous | [diskmonitor.ps1](/scripts/diskmonitor/)                             |
| miscellaneous | [Blank-Page.ps1](/scripts/encrypt-laptop/)                           |
| miscellaneous | [HyperVGoldenImage.ps1](/scripts/hypervgoldenimage/)                 |
| miscellaneous | [Stop-FailedServiceScript.ps1](/scripts/stop-failedservicescript/)   |
| miscellaneous | [Update-DynamicDNSTemplate.ps1](/scripts/update-dynamicdnstemplate/) |
| miscellaneous | [VMWareGoldenImage.ps1](/scripts/vmwaregoldenimage/)                 |
| miscellaneous | [Write-MatrixMessage.ps1](/scripts/write-matrixmessage/)             |

---

## network

| Section | FileName                                                                |
| :------ | :----------------------------------------------------------------------- |
| network | [Get-DKIMRecord.ps1](/scripts/get-dkimrecord/) |
| network | [Get-DMARCRecord.ps1](/scripts/get-dmarcrecord/) |
| network | [Get-FTPFile-empty.ps1](/scripts/get-ftpfile-empty/) |
| network | [Get-IPConfig.ps1](/scripts/get-ipconfig/) |
| network | [Get-PingMonitor.ps1](/scripts/get-pingmonitor/) |
| network | [Get-PortInfo.ps1](/scripts/get-portinfo/) |
| network | [Get-PublicDnsRecord.ps1](/scripts/get-publicdnsrecord/) |
| network | [Get-SPFRecord.ps1](/scripts/get-spfrecord/) |
| network | [Invoke-FTPUpload.ps1](/scripts/invoke-ftpupload/) |
| network | [network packV3.ps1](/scripts/network-packv3/) |
| network | [Resolve-DnsDomain.ps1](/scripts/resolve-dnsdomain/) |
| network | [Resolve-DNSList.ps1](/scripts/resolve-dnslist/) |
| network | [Resolve-DomainDNS.ps1](/scripts/resolve-domaindns/) |
| network | [Test-DNSPropagation.ps1](/scripts/test-dnspropagation/) |

---

## security

| Section | FileName                                                                |
| :------ | :----------------------------------------------------------------------- |
| security | [Export-Bitlocker.ps1](/scripts/export-bitlocker/) |
| security | [Export-BitlockerComp.ps1](/scripts/export-bitlockercomp/) |
| security | [Export-BitlockerParams.ps1](/scripts/export-bitlockerparams/) |
| security | [Get-ProductKey.ps1](/scripts/get-productkey/) |
| security | [Get-SettingsWithCPassword.ps1](/scripts/get-settingswithcpassword/) |
| security | [Get-SSLlabsScore.ps1](/scripts/get-ssllabsscore/) |
| security | [Get-UnknownDevices.ps1](/scripts/get-unknowndevices/) |
| security | [Invoke-PasswordRoll.ps1](/scripts/invoke-passwordroll/) |
| security | [Invoke-UrlScan.ps1](/scripts/invoke-urlscan/) |
| security | [New-PassPhrase.ps1](/scripts/new-passphrase/) |
| security | [New-Password.ps1](/scripts/new-password/) |
| security | [PasswordFunctions.ps1](/scripts/passwordfunctions/) |
| security | [ScreenPassword.ps1](/scripts/screenpassword/) |

---

## testing

| Section | FileName                                                |
| :------ | :------------------------------------------------------ |
| testing | [Test-ComputerName.ps1](/scripts/test-computername/) |
| testing | [Test-EmailAddress.ps1](/scripts/test-emailaddress/) |
| testing | [Test-OnlineFast.ps1](/scripts/test-onlinefast/) |
| testing | [Test-ServerExists.ps1](/scripts/test-serverexists/) |
| testing | [Test-WebSiteUp.ps1](/scripts/test-websiteup/) |

---

## utilities

| Section   | FileName                                                                  |
| :-------- | :------------------------------------------------------------------------- |
| utilities | [ConvertFrom-ErrorRecord.ps1](/scripts/convertfrom-errorrecord/) |
| utilities | [ConvertObject-ToHashTable.ps1](/scripts/convertobject-tohashtable/) |
| utilities | [Get-2amOfThirdMondayInMonth.ps1](/scripts/get-2amofthirdmondayinmonth/) |
| utilities | [Get-ChuckNorrisJoke.ps1](/scripts/get-chucknorrisjoke/) |
| utilities | [Get-CPUTemperature.ps1](/scripts/get-cputemperature/) |
| utilities | [Get-DotNetVersion.ps1](/scripts/get-dotnetversion/) |
| utilities | [Get-ErrorInfo.ps1](/scripts/get-errorinfo/) |
| utilities | [Get-InfoBadService.ps1](/scripts/get-infobadservice/) |
| utilities | [Get-InfoCompSystem.ps1](/scripts/get-infocompsystem/) |
| utilities | [Get-InfoDisk.ps1](/scripts/get-infodisk/) |
| utilities | [Get-InfoNIC.ps1](/scripts/get-infonic/) |
| utilities | [Get-InfoOS.ps1](/scripts/get-infoos/) |
| utilities | [Get-InfoProc.ps1](/scripts/get-infoproc/) |
| utilities | [Get-InstalledUpdates.ps1](/scripts/get-installedupdates/) |
| utilities | [Get-NTPStatusFromHost.ps1](/scripts/get-ntpstatusfromhost/) |
| utilities | [Get-Ntptime.ps1](/scripts/get-ntptime/) |
| utilities | [Get-PatchTuesday.ps1](/scripts/get-patchtuesday/) |
| utilities | [Get-PendingReboot.ps1](/scripts/get-pendingreboot/) |
| utilities | [Get-PendingUpdates.ps1](/scripts/get-pendingupdates/) |
| utilities | [Get-RebootReport.ps1](/scripts/get-rebootreport/) |
| utilities | [Get-RemoteTime.ps1](/scripts/get-remotetime/) |
| utilities | [Get-Resources.ps1](/scripts/get-resources/) |
| utilities | [Get-Time.ps1](/scripts/get-time/) |
| utilities | [Get-TimeServer.ps1](/scripts/get-timeserver/) |
| utilities | [Get-Uptime.ps1](/scripts/get-uptime/) |
| utilities | [Get-WeekDayInMonth.ps1](/scripts/get-weekdayinmonth/) |
| utilities | [GetWindowsFeatures.ps1](/scripts/getwindowsfeatures/) |
| utilities | [Invoke-CDRomDrive.ps1](/scripts/invoke-cdromdrive/) |
| utilities | [Invoke-WebrequestCookie.ps1](/scripts/invoke-webrequestcookie/) |
| utilities | [Open-CDTray.ps1](/scripts/open-cdtray/) |
| utilities | [Out-Excel.ps1](/scripts/out-excel/) |
| utilities | [ProgressBar.ps1](/scripts/progressbar/) |
| utilities | [Remove-UserProfile.ps1](/scripts/remove-userprofile/) |
| utilities | [RemoveLocalUserProfile.ps1](/scripts/removelocaluserprofile/) |
| utilities | [Search-RoadWorks.ps1](/scripts/search-roadworks/) |
| utilities | [Start-WindowsUpdate.ps1](/scripts/start-windowsupdate/) |

---
