---
layout: page
title: UserAdminModule
description: "Scripts v2.0 overview for the UserAdminModule—now helper-driven, categorized, and blissfully free of dot-sourcing."
permalink: /menu/_pages/UserAdminModule.html
---

<video width="380" height="160" controls autoplay loop muted>
    <source src="/assets/menu/scripts-blog-intro.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Module Overview](#module-overview)
- [ModuleManagement](#modulemanagement)
- [ADFunctions](#adfunctions)
- [Azure](#azure)
- [CertificateUtilities](#certificateutilities)
- [Database](#database)
- [EnvironmentManagement](#environmentmanagement)
- [Exchange](#exchange)
- [FileOperations](#fileoperations)
- [JekyllBlog](#jekyllblog)
- [Logging](#logging)
- [MediaManagement](#mediamanagement)
- [Network](#network)
- [PKICertificateTools](#pkicertificatetools)
- [PrintManagement](#printmanagement)
- [ProcessServiceSchedules](#processserviceschedules)
- [RemoteConnections](#remoteconnections)
- [Replication](#replication)
- [Security](#security)
- [Shell](#shell)
- [ShutdownCommands](#shutdowncommands)
- [Teams](#teams)
- [Testing](#testing)
- [Utilities](#utilities)
- [Virtualization](#virtualization)
- [Weather](#weather)

---

## Module Overview

Scripts v2.0 gives the **UserAdminModule** a fresh coat of paint and a neatly labelled toolbox. The release retires dot-sourcing in favour of clean module imports, so your profile scripts load faster than the coffee machine warms up.

- **Module-first loading:** Wave goodbye to dot-sourcing; functions now ship in a proper module so imports stay predictable and portable.
- **Helper scripts at the ready:** `Import-PersonalModules.ps1` wrangles profile imports, while `New-PSM1Module.ps1` scaffolds new function packs without rummaging through legacy snippets.
- **Categorized muscle:** The module leans into broader, service-focused categories so you can dive straight into AD, Azure, or whichever drawer holds the tool you need.

Browse the categories below to explore the reorganised toolkit, open each function page for usage guidance, and enjoy knowing the drawers finally close without a shove.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ModuleManagement


| ModuleManagement | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Import-PersonalModules](/_posts/UserAdminModule/Import-PersonalModules/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ADFunctions


| ADFunctions | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Add-ADUsertoLocalGroup](/_posts/UserAdminModule/Add-ADUsertoLocalGroup/) |
| Category | [ADUserAccountFunctions](/_posts/UserAdminModule/ADUserAccountFunctions/) |
| Category | [Amend-pwdLastSet](/_posts/UserAdminModule/Amend-pwdLastSet/) |
| Category | [Compare-GroupMembership](/_posts/UserAdminModule/Compare-GroupMembership/) |
| Category | [Copy-AdGroupMemberShip](/_posts/UserAdminModule/Copy-AdGroupMemberShip/) |
| Category | [Copy-GroupMembership](/_posts/UserAdminModule/Copy-GroupMembership/) |
| Category | [Disable-InactiveComputer](/_posts/UserAdminModule/Disable-InactiveComputer/) |
| Category | [DisableADAccountsMenu](/_posts/UserAdminModule/DisableADAccountsMenu/) |
| Category | [Find-localAdmins](/_posts/UserAdminModule/Find-localAdmins/) |
| Category | [Find-UnusedADAccounts](/_posts/UserAdminModule/Find-UnusedADAccounts/) |
| Category | [FSMOFunctions](/_posts/UserAdminModule/FSMOFunctions/) |
| Category | [Get-ActiveDirectoryTombstonePeriod](/_posts/UserAdminModule/Get-ActiveDirectoryTombstonePeriod/) |
| Category | [Get-ADComputerSearch](/_posts/UserAdminModule/Get-ADComputerSearch/) |
| Category | [Get-ADDeletedUsers](/_posts/UserAdminModule/Get-ADDeletedUsers/) |
| Category | [Get-ADDiagnosticConfiguration](/_posts/UserAdminModule/Get-ADDiagnosticConfiguration/) |
| Category | [Get-ADDiagnosticLogging](/_posts/UserAdminModule/Get-ADDiagnosticLogging/) |
| Category | [Get-ADEmailAddress](/_posts/UserAdminModule/Get-ADEmailAddress/) |
| Category | [Get-ADGroupAccountDetails](/_posts/UserAdminModule/Get-ADGroupAccountDetails/) |
| Category | [Get-ADGroupMembers](/_posts/UserAdminModule/Get-ADGroupMembers/) |
| Category | [Get-ADGroupNames](/_posts/UserAdminModule/Get-ADGroupNames/) |
| Category | [Get-AdminGroupsWithComputers](/_posts/UserAdminModule/Get-AdminGroupsWithComputers/) |
| Category | [Get-ADObjectAddress](/_posts/UserAdminModule/Get-ADObjectAddress/) |
| Category | [Get-ADPasswordReminderUsers](/_posts/UserAdminModule/Get-ADPasswordReminderUsers/) |
| Category | [Get-ADUserAudit](/_posts/UserAdminModule/Get-ADUserAudit/) |
| Category | [Get-ADUserEmailProperties](/_posts/UserAdminModule/Get-ADUserEmailProperties/) |
| Category | [Get-ADUserExchangeDN](/_posts/UserAdminModule/Get-ADUserExchangeDN/) |
| Category | [Get-ADUserLastLogon](/_posts/UserAdminModule/Get-ADUserLastLogon/) |
| Category | [Get-ADUserSearch](/_posts/UserAdminModule/Get-ADUserSearch/) |
| Category | [Get-ADUserSearch2](/_posts/UserAdminModule/Get-ADUserSearch2/) |
| Category | [Get-AllDomainControllers](/_posts/UserAdminModule/Get-AllDomainControllers/) |
| Category | [Get-Cert](/_posts/UserAdminModule/Get-Cert/) |
| Category | [Get-ComputersWithoutBitLocker](/_posts/UserAdminModule/Get-ComputersWithoutBitLocker/) |
| Category | [Get-CurrentUserLogon](/_posts/UserAdminModule/Get-CurrentUserLogon/) |
| Category | [Get-DirectReports](/_posts/UserAdminModule/Get-DirectReports/) |
| Category | [Get-DomainControllers](/_posts/UserAdminModule/Get-DomainControllers/) |
| Category | [Get-ElevatedUsers](/_posts/UserAdminModule/Get-ElevatedUsers/) |
| Category | [Get-EmptyOUs](/_posts/UserAdminModule/Get-EmptyOUs/) |
| Category | [Get-FeaturesInventory](/_posts/UserAdminModule/Get-FeaturesInventory/) |
| Category | [Get-FSMORoleOwner](/_posts/UserAdminModule/Get-FSMORoleOwner/) |
| Category | [Get-GPProcessingTime](/_posts/UserAdminModule/Get-GPProcessingTime/) |
| Category | [Get-LapsAndBitLocker](/_posts/UserAdminModule/Get-LapsAndBitLocker/) |
| Category | [Get-LastGPOUpdateTime](/_posts/UserAdminModule/Get-LastGPOUpdateTime/) |
| Category | [Get-LocalGroupMembership](/_posts/UserAdminModule/Get-LocalGroupMembership/) |
| Category | [Get-LockedOutUser](/_posts/UserAdminModule/Get-LockedOutUser/) |
| Category | [Get-LockoutHistory](/_posts/UserAdminModule/Get-LockoutHistory/) |
| Category | [Get-LoggedOnUser](/_posts/UserAdminModule/Get-LoggedOnUser/) |
| Category | [Get-LogonEvents](/_posts/UserAdminModule/Get-LogonEvents/) |
| Category | [Get-LogonHistory](/_posts/UserAdminModule/Get-LogonHistory/) |
| Category | [Get-NestedGroupMember](/_posts/UserAdminModule/Get-NestedGroupMember/) |
| Category | [Get-O365LastLogonTime](/_posts/UserAdminModule/Get-O365LastLogonTime/) |
| Category | [Get-OUDelegations](/_posts/UserAdminModule/Get-OUDelegations/) |
| Category | [Get-PrimaryGroupsReport](/_posts/UserAdminModule/Get-PrimaryGroupsReport/) |
| Category | [Get-RemoteServiceAccount](/_posts/UserAdminModule/Get-RemoteServiceAccount/) |
| Category | [Get-ServiceDetails](/_posts/UserAdminModule/Get-ServiceDetails/) |
| Category | [Get-ServiceLogonAccount](/_posts/UserAdminModule/Get-ServiceLogonAccount/) |
| Category | [Get-ServicePrivilege](/_posts/UserAdminModule/Get-ServicePrivilege/) |
| Category | [Get-TargetGPResult](/_posts/UserAdminModule/Get-TargetGPResult/) |
| Category | [Get-TokenSizeReport](/_posts/UserAdminModule/Get-TokenSizeReport/) |
| Category | [Get-TopOUName](/_posts/UserAdminModule/Get-TopOUName/) |
| Category | [Get-UnlinkedGPO](/_posts/UserAdminModule/Get-UnlinkedGPO/) |
| Category | [Get-UserAccountControlReport](/_posts/UserAdminModule/Get-UserAccountControlReport/) |
| Category | [Get-UserLogon](/_posts/UserAdminModule/Get-UserLogon/) |
| Category | [Get-UserLogonEvents](/_posts/UserAdminModule/Get-UserLogonEvents/) |
| Category | [get-usermembership](/_posts/UserAdminModule/get-usermembership/) |
| Category | [Get-UserReport](/_posts/UserAdminModule/Get-UserReport/) |
| Category | [Get-UsersGroupMemberShips](/_posts/UserAdminModule/Get-UsersGroupMemberShips/) |
| Category | [Get-UserSupportedEncryptionTypes](/_posts/UserAdminModule/Get-UserSupportedEncryptionTypes/) |
| Category | [GetMailboxPermission](/_posts/UserAdminModule/GetMailboxPermission/) |
| Category | [GetUserLoggedOnto](/_posts/UserAdminModule/GetUserLoggedOnto/) |
| Category | [Lock-UserAccount](/_posts/UserAdminModule/Lock-UserAccount/) |
| Category | [Move-ADComputer](/_posts/UserAdminModule/Move-ADComputer/) |
| Category | [Move-FSMORolestoPDCEmulator](/_posts/UserAdminModule/Move-FSMORolestoPDCEmulator/) |
| Category | [MoveOU](/_posts/UserAdminModule/MoveOU/) |
| Category | [New-EncryptedUser](/_posts/UserAdminModule/New-EncryptedUser/) |
| Category | [New-FakeADUser](/_posts/UserAdminModule/New-FakeADUser/) |
| Category | [New-FakeADUserDetails](/_posts/UserAdminModule/New-FakeADUserDetails/) |
| Category | [New-FakeUserDetails](/_posts/UserAdminModule/New-FakeUserDetails/) |
| Category | [New-RandomUser](/_posts/UserAdminModule/New-RandomUser/) |
| Category | [Provision_Home_Folder](/_posts/UserAdminModule/Provision_Home_Folder/) |
| Category | [Query-UserAccountControl](/_posts/UserAdminModule/Query-UserAccountControl/) |
| Category | [remove-ADM](/_posts/UserAdminModule/remove-ADM/) |
| Category | [Remove-AdminSDHolder](/_posts/UserAdminModule/Remove-AdminSDHolder/) |
| Category | [Restore-ADDeletedUsers](/_posts/UserAdminModule/Restore-ADDeletedUsers/) |
| Category | [Search-GPO](/_posts/UserAdminModule/Search-GPO/) |
| Category | [Search-GPOforString](/_posts/UserAdminModule/Search-GPOforString/) |
| Category | [Search-GPOsForString](/_posts/UserAdminModule/Search-GPOsForString/) |
| Category | [Search-GPOsForStringOrig](/_posts/UserAdminModule/Search-GPOsForStringOrig/) |
| Category | [Search-KerbDelegatedAccounts](/_posts/UserAdminModule/Search-KerbDelegatedAccounts/) |
| Category | [Set-ADDiagnosticConfiguration](/_posts/UserAdminModule/Set-ADDiagnosticConfiguration/) |
| Category | [Set-ADUserPassword](/_posts/UserAdminModule/Set-ADUserPassword/) |
| Category | [Set-CustomAttributesForGroupMembers](/_posts/UserAdminModule/Set-CustomAttributesForGroupMembers/) |
| Category | [Set-ExtensionAttribute](/_posts/UserAdminModule/Set-ExtensionAttribute/) |
| Category | [Set-FSMORoleOwner](/_posts/UserAdminModule/Set-FSMORoleOwner/) |
| Category | [SiteNameConsistencyReport](/_posts/UserAdminModule/SiteNameConsistencyReport/) |
| Category | [Sync-Office365ToADDS](/_posts/UserAdminModule/Sync-Office365ToADDS/) |
| Category | [Test-ADUserCredentials](/_posts/UserAdminModule/Test-ADUserCredentials/) |
| Category | [Test-ADUserHighPrivilegeGroupMembership](/_posts/UserAdminModule/Test-ADUserHighPrivilegeGroupMembership/) |
| Category | [Unlock-UserAccount](/_posts/UserAdminModule/Unlock-UserAccount/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Azure


| Azure | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Connect-toAzure](/_posts/UserAdminModule/Connect-toAzure/) |
| Category | [Connect-toAzureSubscription](/_posts/UserAdminModule/Connect-toAzureSubscription/) |
| Category | [Connect-toMSGraphApplicationWithCertificate](/_posts/UserAdminModule/Connect-toMSGraphApplicationWithCertificate/) |
| Category | [Convert-AzuretoOnPrem](/_posts/UserAdminModule/Convert-AzuretoOnPrem/) |
| Category | [Get-AccessToken](/_posts/UserAdminModule/Get-AccessToken/) |
| Category | [Get-AzEnterpriseAppConfig](/_posts/UserAdminModule/Get-AzEnterpriseAppConfig/) |
| Category | [Get-EntraGuestMembers](/_posts/UserAdminModule/Get-EntraGuestMembers/) |
| Category | [Get-MFAMethods](/_posts/UserAdminModule/Get-MFAMethods/) |
| Category | [Get-MgAdmins](/_posts/UserAdminModule/Get-MgAdmins/) |
| Category | [Get-MgUserDetails](/_posts/UserAdminModule/Get-MgUserDetails/) |
| Category | [Invoke-AzureADApp](/_posts/UserAdminModule/Invoke-AzureADApp/) |
| Category | [Invoke-AzureMailApp](/_posts/UserAdminModule/Invoke-AzureMailApp/) |
| Category | [Manage-AzureADApp](/_posts/UserAdminModule/Manage-AzureADApp/) |
| Category | [New-AzureADDynamicGroup](/_posts/UserAdminModule/New-AzureADDynamicGroup/) |
| Category | [New-EntraGuestInvitation](/_posts/UserAdminModule/New-EntraGuestInvitation/) |
| Category | [New-EntraGuestInvitationEntra](/_posts/UserAdminModule/New-EntraGuestInvitationEntra/) |
| Category | [Send-EmailUsingAzureApp](/_posts/UserAdminModule/Send-EmailUsingAzureApp/) |
| Category | [Set-EntraGuestMember](/_posts/UserAdminModule/Set-EntraGuestMember/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## CertificateUtilities


| CertificateUtilities | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-CertificateExpiry](/_posts/UserAdminModule/Get-CertificateExpiry/) |
| Category | [Get-RemoteCertificates](/_posts/UserAdminModule/Get-RemoteCertificates/) |
| Category | [Get-RemoteCipherDetails](/_posts/UserAdminModule/Get-RemoteCipherDetails/) |
| Category | [Get-RemoteLdapCertDetails](/_posts/UserAdminModule/Get-RemoteLdapCertDetails/) |
| Category | [Install-RemoteCertificate](/_posts/UserAdminModule/Install-RemoteCertificate/) |
| Category | [New-CodeSigningCert](/_posts/UserAdminModule/New-CodeSigningCert/) |
| Category | [Set-DigitalSignature](/_posts/UserAdminModule/Set-DigitalSignature/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Database


| Database | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-DBInstances](/_posts/UserAdminModule/Get-DBInstances/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## EnvironmentManagement


| EnvironmentManagement | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Add-EnvPath](/_posts/UserAdminModule/Add-EnvPath/) |
| Category | [Get-EnvPath](/_posts/UserAdminModule/Get-EnvPath/) |
| Category | [Remove-EnvPath](/_posts/UserAdminModule/Remove-EnvPath/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Exchange


| Exchange | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Add-MemberToDistributionGroup](/_posts/UserAdminModule/Add-MemberToDistributionGroup/) |
| Category | [Add-Office365Functions](/_posts/UserAdminModule/Add-Office365Functions/) |
| Category | [Connect-ExchangeServer](/_posts/UserAdminModule/Connect-ExchangeServer/) |
| Category | [Connect-O365Exchange](/_posts/UserAdminModule/Connect-O365Exchange/) |
| Category | [Connect-O365Session](/_posts/UserAdminModule/Connect-O365Session/) |
| Category | [Connect-Office365Services](/_posts/UserAdminModule/Connect-Office365Services/) |
| Category | [Connect-OPExchange](/_posts/UserAdminModule/Connect-OPExchange/) |
| Category | [Copy-DistributionGroupMembers](/_posts/UserAdminModule/Copy-DistributionGroupMembers/) |
| Category | [Copy-DistributionGroupMembership](/_posts/UserAdminModule/Copy-DistributionGroupMembership/) |
| Category | [Copy-OnPremToCloudDistributionGroupMembership](/_posts/UserAdminModule/Copy-OnPremToCloudDistributionGroupMembership/) |
| Category | [Copy-ReceiveConnector](/_posts/UserAdminModule/Copy-ReceiveConnector/) |
| Category | [Disconnect-ExchangeSessions](/_posts/UserAdminModule/Disconnect-ExchangeSessions/) |
| Category | [Enter-O365Session](/_posts/UserAdminModule/Enter-O365Session/) |
| Category | [ExchangeConnector](/_posts/UserAdminModule/ExchangeConnector/) |
| Category | [ExchangeFunctions](/_posts/UserAdminModule/ExchangeFunctions/) |
| Category | [Export-CalendarPermissions](/_posts/UserAdminModule/Export-CalendarPermissions/) |
| Category | [Export-DistributionGroupProperties](/_posts/UserAdminModule/Export-DistributionGroupProperties/) |
| Category | [Export-ExchangeContactData](/_posts/UserAdminModule/Export-ExchangeContactData/) |
| Category | [Get-ADExchangeServer](/_posts/UserAdminModule/Get-ADExchangeServer/) |
| Category | [Get-ContactList](/_posts/UserAdminModule/Get-ContactList/) |
| Category | [Get-ContactsFromDomain](/_posts/UserAdminModule/Get-ContactsFromDomain/) |
| Category | [Get-DistributionGroupsWithOwners](/_posts/UserAdminModule/Get-DistributionGroupsWithOwners/) |
| Category | [Get-DistributionListMembers](/_posts/UserAdminModule/Get-DistributionListMembers/) |
| Category | [Get-DuplicateExchangeDN](/_posts/UserAdminModule/Get-DuplicateExchangeDN/) |
| Category | [Get-ExchangeServer](/_posts/UserAdminModule/Get-ExchangeServer/) |
| Category | [Get-ExchangeServerInSite](/_posts/UserAdminModule/Get-ExchangeServerInSite/) |
| Category | [Get-ExchangeVersion](/_posts/UserAdminModule/Get-ExchangeVersion/) |
| Category | [Get-FilteredContacts](/_posts/UserAdminModule/Get-FilteredContacts/) |
| Category | [Get-FilteredMailboxes](/_posts/UserAdminModule/Get-FilteredMailboxes/) |
| Category | [Get-MailboxAccessPerms](/_posts/UserAdminModule/Get-MailboxAccessPerms/) |
| Category | [Get-MailboxContent](/_posts/UserAdminModule/Get-MailboxContent/) |
| Category | [Get-MailboxPermissions](/_posts/UserAdminModule/Get-MailboxPermissions/) |
| Category | [Get-MailboxPermissionsExport](/_posts/UserAdminModule/Get-MailboxPermissionsExport/) |
| Category | [Get-MailboxPermissionsReport](/_posts/UserAdminModule/Get-MailboxPermissionsReport/) |
| Category | [Get-MailboxPermissionsReport2](/_posts/UserAdminModule/Get-MailboxPermissionsReport2/) |
| Category | [Get-MailboxReport](/_posts/UserAdminModule/Get-MailboxReport/) |
| Category | [Get-MailboxStatistics](/_posts/UserAdminModule/Get-MailboxStatistics/) |
| Category | [Get-MailContactDetails](/_posts/UserAdminModule/Get-MailContactDetails/) |
| Category | [Get-MBAccessPerms](/_posts/UserAdminModule/Get-MBAccessPerms/) |
| Category | [Get-MessageTraceFiltered](/_posts/UserAdminModule/Get-MessageTraceFiltered/) |
| Category | [Get-O365CalendarPermissions](/_posts/UserAdminModule/Get-O365CalendarPermissions/) |
| Category | [Get-O365MailboxPermissions](/_posts/UserAdminModule/Get-O365MailboxPermissions/) |
| Category | [Get-O365SharedMailboxPermissions](/_posts/UserAdminModule/Get-O365SharedMailboxPermissions/) |
| Category | [Get-OOHMessage](/_posts/UserAdminModule/Get-OOHMessage/) |
| Category | [Get-OrphanedDistributionGroups](/_posts/UserAdminModule/Get-OrphanedDistributionGroups/) |
| Category | [Get-QuarantinedEmailMessages](/_posts/UserAdminModule/Get-QuarantinedEmailMessages/) |
| Category | [Get-UsersCalendarAccess](/_posts/UserAdminModule/Get-UsersCalendarAccess/) |
| Category | [New-DynamicListFromAttribute](/_posts/UserAdminModule/New-DynamicListFromAttribute/) |
| Category | [New-ExchangeDistributionGroup](/_posts/UserAdminModule/New-ExchangeDistributionGroup/) |
| Category | [New-MailContactObject](/_posts/UserAdminModule/New-MailContactObject/) |
| Category | [New-O365Contact](/_posts/UserAdminModule/New-O365Contact/) |
| Category | [New-OOHMessage](/_posts/UserAdminModule/New-OOHMessage/) |
| Category | [O365Session](/_posts/UserAdminModule/O365Session/) |
| Category | [OnPremExchangeFunctions](/_posts/UserAdminModule/OnPremExchangeFunctions/) |
| Category | [PasswordChangeNotification](/_posts/UserAdminModule/PasswordChangeNotification/) |
| Category | [PasswordReminderAlso](/_posts/UserAdminModule/PasswordReminderAlso/) |
| Category | [Preview-QuarantinedEmailMessage](/_posts/UserAdminModule/Preview-QuarantinedEmailMessage/) |
| Category | [Remove-MailboxFolderPermissions](/_posts/UserAdminModule/Remove-MailboxFolderPermissions/) |
| Category | [Remove-UsersfromGAL](/_posts/UserAdminModule/Remove-UsersfromGAL/) |
| Category | [Repair-MissingOnPremMailbox](/_posts/UserAdminModule/Repair-MissingOnPremMailbox/) |
| Category | [Restart-ExchangeServices](/_posts/UserAdminModule/Restart-ExchangeServices/) |
| Category | [Send-OutlookMail](/_posts/UserAdminModule/Send-OutlookMail/) |
| Category | [Set-AutoDiscover](/_posts/UserAdminModule/Set-AutoDiscover/) |
| Category | [Set-CalendarPermsScript](/_posts/UserAdminModule/Set-CalendarPermsScript/) |
| Category | [Set-DefaultReceiveConnector](/_posts/UserAdminModule/Set-DefaultReceiveConnector/) |
| Category | [Set-DistributionGroupProperties](/_posts/UserAdminModule/Set-DistributionGroupProperties/) |
| Category | [Set-MailContactDetails](/_posts/UserAdminModule/Set-MailContactDetails/) |
| Category | [Set-MailContactDetailsOnline](/_posts/UserAdminModule/Set-MailContactDetailsOnline/) |
| Category | [Set-O365CalendarPermissions](/_posts/UserAdminModule/Set-O365CalendarPermissions/) |
| Category | [Set-O365MailboxPermissions](/_posts/UserAdminModule/Set-O365MailboxPermissions/) |
| Category | [Set-OOHmessage](/_posts/UserAdminModule/Set-OOHmessage/) |
| Category | [Unblock-QuarantineMessage](/_posts/UserAdminModule/Unblock-QuarantineMessage/) |
| Category | [Update-CalendarPermissions](/_posts/UserAdminModule/Update-CalendarPermissions/) |
| Category | [Update-DistributionGroupOwner](/_posts/UserAdminModule/Update-DistributionGroupOwner/) |
| Category | [Update-DistributionList](/_posts/UserAdminModule/Update-DistributionList/) |
| Category | [Update-MailContactDomain](/_posts/UserAdminModule/Update-MailContactDomain/) |
| Category | [Update-MailContactProperties](/_posts/UserAdminModule/Update-MailContactProperties/) |
| Category | [Update-O365CalendarPermissions](/_posts/UserAdminModule/Update-O365CalendarPermissions/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## FileOperations


| FileOperations | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Convert-DnsZoneFile](/_posts/UserAdminModule/Convert-DnsZoneFile/) |
| Category | [Convert-FilenameToGUID](/_posts/UserAdminModule/Convert-FilenameToGUID/) |
| Category | [Copy-FilestoComputer](/_posts/UserAdminModule/Copy-FilestoComputer/) |
| Category | [Copy-FilestoRemote](/_posts/UserAdminModule/Copy-FilestoRemote/) |
| Category | [createRandomFilesFunctions](/_posts/UserAdminModule/createRandomFilesFunctions/) |
| Category | [Expand-NinjaOne7Zip](/_posts/UserAdminModule/Expand-NinjaOne7Zip/) |
| Category | [Expand-NinjaOneZip](/_posts/UserAdminModule/Expand-NinjaOneZip/) |
| Category | [Format-FileSize](/_posts/UserAdminModule/Format-FileSize/) |
| Category | [Get-FileAndFolderPermissions](/_posts/UserAdminModule/Get-FileAndFolderPermissions/) |
| Category | [Get-FileOwner](/_posts/UserAdminModule/Get-FileOwner/) |
| Category | [Get-IniContent](/_posts/UserAdminModule/Get-IniContent/) |
| Category | [Get-LatestFiles](/_posts/UserAdminModule/Get-LatestFiles/) |
| Category | [Get-MediaDetails](/_posts/UserAdminModule/Get-MediaDetails/) |
| Category | [Get-NeglectedFiles](/_posts/UserAdminModule/Get-NeglectedFiles/) |
| Category | [Get-OldFiles](/_posts/UserAdminModule/Get-OldFiles/) |
| Category | [Get-PathPermissions](/_posts/UserAdminModule/Get-PathPermissions/) |
| Category | [Invoke-RemoteZipExpansion](/_posts/UserAdminModule/Invoke-RemoteZipExpansion/) |
| Category | [Merge-Files](/_posts/UserAdminModule/Merge-Files/) |
| Category | [New-DummyFile](/_posts/UserAdminModule/New-DummyFile/) |
| Category | [New-DummyFiles](/_posts/UserAdminModule/New-DummyFiles/) |
| Category | [New-FileArchive](/_posts/UserAdminModule/New-FileArchive/) |
| Category | [New-FileofSize](/_posts/UserAdminModule/New-FileofSize/) |
| Category | [New-FileReport](/_posts/UserAdminModule/New-FileReport/) |
| Category | [New-FolderCompare](/_posts/UserAdminModule/New-FolderCompare/) |
| Category | [New-PSDriveRootFolder](/_posts/UserAdminModule/New-PSDriveRootFolder/) |
| Category | [New-Shortcut](/_posts/UserAdminModule/New-Shortcut/) |
| Category | [New-ZipFile](/_posts/UserAdminModule/New-ZipFile/) |
| Category | [parse_NTFS](/_posts/UserAdminModule/parse_NTFS/) |
| Category | [Randomize-FilesIntoSubfolders](/_posts/UserAdminModule/Randomize-FilesIntoSubfolders/) |
| Category | [Register-FileSystemWatcher](/_posts/UserAdminModule/Register-FileSystemWatcher/) |
| Category | [Remove-DummyFiles](/_posts/UserAdminModule/Remove-DummyFiles/) |
| Category | [Remove-EmptyFolders](/_posts/UserAdminModule/Remove-EmptyFolders/) |
| Category | [Remove-Files](/_posts/UserAdminModule/Remove-Files/) |
| Category | [Remove-FoldersWithoutSpecifiedFiles](/_posts/UserAdminModule/Remove-FoldersWithoutSpecifiedFiles/) |
| Category | [Reorganize-FilesByType](/_posts/UserAdminModule/Reorganize-FilesByType/) |
| Category | [Save-PasswordFile](/_posts/UserAdminModule/Save-PasswordFile/) |
| Category | [Search-ForFiles](/_posts/UserAdminModule/Search-ForFiles/) |
| Category | [search-scripts](/_posts/UserAdminModule/search-scripts/) |
| Category | [Search-Scripts](/_posts/UserAdminModule/Search-Scripts/) |
| Category | [Show-PSDrive](/_posts/UserAdminModule/Show-PSDrive/) |
| Category | [Start-DownloadFileToTemp](/_posts/UserAdminModule/Start-DownloadFileToTemp/) |
| Category | [Unblock-AndUnzipFiles](/_posts/UserAdminModule/Unblock-AndUnzipFiles/) |
| Category | [UncompressZip-SameDestination](/_posts/UserAdminModule/UncompressZip-SameDestination/) |
| Category | [zipArchiveTool_recursive](/_posts/UserAdminModule/zipArchiveTool_recursive/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## JekyllBlog


| JekyllBlog | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-GistIframe](/_posts/UserAdminModule/Get-GistIframe/) |
| Category | [New-BlogServer](/_posts/UserAdminModule/New-BlogServer/) |
| Category | [New-JekyllBlogPost](/_posts/UserAdminModule/New-JekyllBlogPost/) |
| Category | [New-JekyllBlogServer](/_posts/UserAdminModule/New-JekyllBlogServer/) |
| Category | [New-JekyllBlogSession](/_posts/UserAdminModule/New-JekyllBlogSession/) |
| Category | [Remove-JekyllBlogServer](/_posts/UserAdminModule/Remove-JekyllBlogServer/) |
| Category | [Show-JekyllBlogSite](/_posts/UserAdminModule/Show-JekyllBlogSite/) |
| Category | [Start-JekyllBlogging](/_posts/UserAdminModule/Start-JekyllBlogging/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Logging


| Logging | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-EventLogs](/_posts/UserAdminModule/Get-EventLogs/) |
| Category | [Get-EventsFromTimeframe](/_posts/UserAdminModule/Get-EventsFromTimeframe/) |
| Category | [Get-FilteredEvents](/_posts/UserAdminModule/Get-FilteredEvents/) |
| Category | [Get-SystemEvent](/_posts/UserAdminModule/Get-SystemEvent/) |
| Category | [Get-WmiADEvent](/_posts/UserAdminModule/Get-WmiADEvent/) |
| Category | [Initialize-EventLogging](/_posts/UserAdminModule/Initialize-EventLogging/) |
| Category | [Log-Event](/_posts/UserAdminModule/Log-Event/) |
| Category | [New-LogEvent](/_posts/UserAdminModule/New-LogEvent/) |
| Category | [Script4logging](/_posts/UserAdminModule/Script4logging/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## MediaManagement


| MediaManagement | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Create-VLCPlaylists](/_posts/UserAdminModule/Create-VLCPlaylists/) |
| Category | [FFMpeg-Install](/_posts/UserAdminModule/FFMpeg-Install/) |
| Category | [Get-FFProbeAudioStreams](/_posts/UserAdminModule/Get-FFProbeAudioStreams/) |
| Category | [Get-FFProbeVideoInfo](/_posts/UserAdminModule/Get-FFProbeVideoInfo/) |
| Category | [Find-Movies](/_posts/UserAdminModule/Find-Movies/) |
| Category | [Remove-FFMpegVideoFileAudioStream](/_posts/UserAdminModule/Remove-FFMpegVideoFileAudioStream/) |
| Category | [Set-FFMpegVideoSpeed](/_posts/UserAdminModule/Set-FFMpegVideoSpeed/) |
| Category | [Set-TransmissionDefaultSettings](/_posts/UserAdminModule/Set-TransmissionDefaultSettings/) |
| Category | [Start-Stream](/_posts/UserAdminModule/Start-Stream/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Network


| Network | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-CidrIPRange](/_posts/UserAdminModule/Get-CidrIPRange/) |
| Category | [Get-ComputerIP](/_posts/UserAdminModule/Get-ComputerIP/) |
| Category | [Get-DKIMRecord](/_posts/UserAdminModule/Get-DKIMRecord/) |
| Category | [Get-DMARCRecord](/_posts/UserAdminModule/Get-DMARCRecord/) |
| Category | [Get-FTPFile-empty](/_posts/UserAdminModule/Get-FTPFile-empty/) |
| Category | [Get-HostIOResults](/_posts/UserAdminModule/Get-HostIOResults/) |
| Category | [Get-IPConfig](/_posts/UserAdminModule/Get-IPConfig/) |
| Category | [Get-ipInfo](/_posts/UserAdminModule/Get-ipInfo/) |
| Category | [Get-MullvadApiDetails](/_posts/UserAdminModule/Get-MullvadApiDetails/) |
| Category | [Get-PingMonitor](/_posts/UserAdminModule/Get-PingMonitor/) |
| Category | [Get-PortInfo](/_posts/UserAdminModule/Get-PortInfo/) |
| Category | [Get-PortService](/_posts/UserAdminModule/Get-PortService/) |
| Category | [Get-PublicDnsRecord](/_posts/UserAdminModule/Get-PublicDnsRecord/) |
| Category | [Get-RemoteIPSettings](/_posts/UserAdminModule/Get-RemoteIPSettings/) |
| Category | [Get-RemoteServerPorts](/_posts/UserAdminModule/Get-RemoteServerPorts/) |
| Category | [Get-ServerIPInfo](/_posts/UserAdminModule/Get-ServerIPInfo/) |
| Category | [Get-SPFRecord](/_posts/UserAdminModule/Get-SPFRecord/) |
| Category | [Get-WhoIsInformation](/_posts/UserAdminModule/Get-WhoIsInformation/) |
| Category | [Get-WTFismyIP](/_posts/UserAdminModule/Get-WTFismyIP/) |
| Category | [Invoke-FTPUpload](/_posts/UserAdminModule/Invoke-FTPUpload/) |
| Category | [Resolve-DnsDomain](/_posts/UserAdminModule/Resolve-DnsDomain/) |
| Category | [Resolve-DNSList](/_posts/UserAdminModule/Resolve-DNSList/) |
| Category | [Resolve-DomainDNS](/_posts/UserAdminModule/Resolve-DomainDNS/) |
| Category | [Send-MagicPacket](/_posts/UserAdminModule/Send-MagicPacket/) |
| Category | [Set-DHCPIPAddress](/_posts/UserAdminModule/Set-DHCPIPAddress/) |
| Category | [Set-GoogleDynamicDNS](/_posts/UserAdminModule/Set-GoogleDynamicDNS/) |
| Category | [Set-StaticIPAddress](/_posts/UserAdminModule/Set-StaticIPAddress/) |
| Category | [Set-WMIPermissions](/_posts/UserAdminModule/Set-WMIPermissions/) |
| Category | [Switch-VpnFailover](/_posts/UserAdminModule/Switch-VpnFailover/) |
| Category | [Switch-VpnFailoverMac](/_posts/UserAdminModule/Switch-VpnFailoverMac/) |
| Category | [Test-DNSPropagation](/_posts/UserAdminModule/Test-DNSPropagation/) |
| Category | [Update-CloudflareDDNS](/_posts/UserAdminModule/Update-CloudflareDDNS/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PKICertificateTools


| PKICertificateTools | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Backup-CAServer](/_posts/UserAdminModule/Backup-CAServer/) |
| Category | [Backup-CertificateServicesDatabase](/_posts/UserAdminModule/Backup-CertificateServicesDatabase/) |
| Category | [Decommission-CA](/_posts/UserAdminModule/Decommission-CA/) |
| Category | [Export-CRL](/_posts/UserAdminModule/Export-CRL/) |
| Category | [Find-CertificateByTemplate](/_posts/UserAdminModule/Find-CertificateByTemplate/) |
| Category | [Get-ADCertificates](/_posts/UserAdminModule/Get-ADCertificates/) |
| Category | [Get-AdCertificateTemplate](/_posts/UserAdminModule/Get-AdCertificateTemplate/) |
| Category | [Get-AllPKICertificates](/_posts/UserAdminModule/Get-AllPKICertificates/) |
| Category | [Get-CACertificateInfo](/_posts/UserAdminModule/Get-CACertificateInfo/) |
| Category | [Get-Oid](/_posts/UserAdminModule/Get-Oid/) |
| Category | [Get-PKICertificate](/_posts/UserAdminModule/Get-PKICertificate/) |
| Category | [Get-PKICertificates](/_posts/UserAdminModule/Get-PKICertificates/) |
| Category | [Get-PublishedTemplate](/_posts/UserAdminModule/Get-PublishedTemplate/) |
| Category | [Get-RDGCAIssuedCert](/_posts/UserAdminModule/Get-RDGCAIssuedCert/) |
| Category | [Get-RDGCARequestPending](/_posts/UserAdminModule/Get-RDGCARequestPending/) |
| Category | [Get-Sid](/_posts/UserAdminModule/Get-Sid/) |
| Category | [Move-CertificateServicesDatabase](/_posts/UserAdminModule/Move-CertificateServicesDatabase/) |
| Category | [Optimize-DomainControllerTlsConfiguration](/_posts/UserAdminModule/Optimize-DomainControllerTlsConfiguration/) |
| Category | [Publish-NewCRL](/_posts/UserAdminModule/Publish-NewCRL/) |
| Category | [Remove-ADCSArtifacts](/_posts/UserAdminModule/Remove-ADCSArtifacts/) |
| Category | [Remove-CAFromNTAuth](/_posts/UserAdminModule/Remove-CAFromNTAuth/) |
| Category | [Remove-CAKeys](/_posts/UserAdminModule/Remove-CAKeys/) |
| Category | [Remove-CASolution](/_posts/UserAdminModule/Remove-CASolution/) |
| Category | [Remove-CertLogDatabase](/_posts/UserAdminModule/Remove-CertLogDatabase/) |
| Category | [Remove-ExpiredCertificate](/_posts/UserAdminModule/Remove-ExpiredCertificate/) |
| Category | [Revoke-AllValidCerts](/_posts/UserAdminModule/Revoke-AllValidCerts/) |
| Category | [Revoke-CACertificate](/_posts/UserAdminModule/Revoke-CACertificate/) |
| Category | [Show-CertificateTemplateInformation](/_posts/UserAdminModule/Show-CertificateTemplateInformation/) |
| Category | [Write-CAActivityLog](/_posts/UserAdminModule/Write-CAActivityLog/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PrintManagement


| PrintManagement | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Disable-PrintSpooler](/_posts/UserAdminModule/Disable-PrintSpooler/) |
| Category | [Enable-PrintSpooler](/_posts/UserAdminModule/Enable-PrintSpooler/) |
| Category | [Get-PrintSpooler](/_posts/UserAdminModule/Get-PrintSpooler/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ProcessServiceSchedules


| ProcessServiceSchedules | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-AllScheduledScripts](/_posts/UserAdminModule/Get-AllScheduledScripts/) |
| Category | [Get-ProcessandServicePID](/_posts/UserAdminModule/Get-ProcessandServicePID/) |
| Category | [Get-ProcessStatus](/_posts/UserAdminModule/Get-ProcessStatus/) |
| Category | [Get-RemoteScheduledTasks](/_posts/UserAdminModule/Get-RemoteScheduledTasks/) |
| Category | [Get-ScheduledScripts](/_posts/UserAdminModule/Get-ScheduledScripts/) |
| Category | [Get-ScheduledTasks](/_posts/UserAdminModule/Get-ScheduledTasks/) |
| Category | [Get-ServiceStatus](/_posts/UserAdminModule/Get-ServiceStatus/) |
| Category | [New-ScheduledScript](/_posts/UserAdminModule/New-ScheduledScript/) |
| Category | [New-ScheduledTask](/_posts/UserAdminModule/New-ScheduledTask/) |
| Category | [Remove-ScheduledScript](/_posts/UserAdminModule/Remove-ScheduledScript/) |
| Category | [Restart-NinjaRMMService](/_posts/UserAdminModule/Restart-NinjaRMMService/) |
| Category | [Restart-PrintSpooler](/_posts/UserAdminModule/Restart-PrintSpooler/) |
| Category | [Set-PrintSpoolerConfig](/_posts/UserAdminModule/Set-PrintSpoolerConfig/) |
| Category | [Set-ServiceConfig](/_posts/UserAdminModule/Set-ServiceConfig/) |
| Category | [Start-BullwallServices](/_posts/UserAdminModule/Start-BullwallServices/) |
| Category | [Start-Outlook](/_posts/UserAdminModule/Start-Outlook/) |
| Category | [Start-ProcessOnComputer](/_posts/UserAdminModule/Start-ProcessOnComputer/) |
| Category | [Start-ScheduledScript](/_posts/UserAdminModule/Start-ScheduledScript/) |
| Category | [Start-ServicesInOrder](/_posts/UserAdminModule/Start-ServicesInOrder/) |
| Category | [Stop-FailedService](/_posts/UserAdminModule/Stop-FailedService/) |
| Category | [Stop-NonRespondingProcesses](/_posts/UserAdminModule/Stop-NonRespondingProcesses/) |
| Category | [Stop-ProcessOnComputer](/_posts/UserAdminModule/Stop-ProcessOnComputer/) |
| Category | [Stop-ScheduledScript](/_posts/UserAdminModule/Stop-ScheduledScript/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## RemoteConnections


| RemoteConnections | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Connect-CmRcViewer](/_posts/UserAdminModule/Connect-CmRcViewer/) |
| Category | [Connect-InternalPRTG](/_posts/UserAdminModule/Connect-InternalPRTG/) |
| Category | [Connect-Mstsc](/_posts/UserAdminModule/Connect-Mstsc/) |
| Category | [Connect-PSExec](/_posts/UserAdminModule/Connect-PSExec/) |
| Category | [Connect-PSExecPowershell](/_posts/UserAdminModule/Connect-PSExecPowershell/) |
| Category | [Connect-RemoteAssistance](/_posts/UserAdminModule/Connect-RemoteAssistance/) |
| Category | [Disable-RDPRemotely](/_posts/UserAdminModule/Disable-RDPRemotely/) |
| Category | [Enable-RDPRemotely](/_posts/UserAdminModule/Enable-RDPRemotely/) |
| Category | [Enable-RemoteDesktop](/_posts/UserAdminModule/Enable-RemoteDesktop/) |
| Category | [Get-LoggedOnRDPUser](/_posts/UserAdminModule/Get-LoggedOnRDPUser/) |
| Category | [Get-RDPStatus](/_posts/UserAdminModule/Get-RDPStatus/) |
| Category | [Get-RDPUserReport](/_posts/UserAdminModule/Get-RDPUserReport/) |
| Category | [Remove-RDPUserSession](/_posts/UserAdminModule/Remove-RDPUserSession/) |
| Category | [Set-RDPRemotely](/_posts/UserAdminModule/Set-RDPRemotely/) |
| Category | [Set-RDPStatus](/_posts/UserAdminModule/Set-RDPStatus/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Replication


| Replication | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-ComputerReplicationStatus](/_posts/UserAdminModule/Get-ComputerReplicationStatus/) |
| Category | [Get-DCDIAGResults](/_posts/UserAdminModule/Get-DCDIAGResults/) |
| Category | [Get-SysvolReplicationInfo](/_posts/UserAdminModule/Get-SysvolReplicationInfo/) |
| Category | [Get-UserReplicationStatus](/_posts/UserAdminModule/Get-UserReplicationStatus/) |
| Category | [New-SecurePassword](/_posts/UserAdminModule/New-SecurePassword/) |
| Category | [Sync-ADwithAAD](/_posts/UserAdminModule/Sync-ADwithAAD/) |
| Category | [Sync-DomainController](/_posts/UserAdminModule/Sync-DomainController/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Security


| Security | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Disable-CiscoSecure](/_posts/UserAdminModule/Disable-CiscoSecure/) |
| Category | [Enable-CiscoSecure](/_posts/UserAdminModule/Enable-CiscoSecure/) |
| Category | [Export-Bitlocker](/_posts/UserAdminModule/Export-Bitlocker/) |
| Category | [Export-BitlockerComp](/_posts/UserAdminModule/Export-BitlockerComp/) |
| Category | [Export-BitlockerParams](/_posts/UserAdminModule/Export-BitlockerParams/) |
| Category | [Get-CimNamespacePermissions](/_posts/UserAdminModule/Get-CimNamespacePermissions/) |
| Category | [Get-CimNamespacePermissionsRemote](/_posts/UserAdminModule/Get-CimNamespacePermissionsRemote/) |
| Category | [Get-CimPermsLocal](/_posts/UserAdminModule/Get-CimPermsLocal/) |
| Category | [Get-InsecureLDAPBinds](/_posts/UserAdminModule/Get-InsecureLDAPBinds/) |
| Category | [Get-NameSpacePerms](/_posts/UserAdminModule/Get-NameSpacePerms/) |
| Category | [Get-Namespaces](/_posts/UserAdminModule/Get-Namespaces/) |
| Category | [Get-PasswordAttempts](/_posts/UserAdminModule/Get-PasswordAttempts/) |
| Category | [Get-PasswordAttempts2](/_posts/UserAdminModule/Get-PasswordAttempts2/) |
| Category | [Get-ProductKey](/_posts/UserAdminModule/Get-ProductKey/) |
| Category | [Get-PSGalleryItemsForAuthor](/_posts/UserAdminModule/Get-PSGalleryItemsForAuthor/) |
| Category | [Get-SettingsWithCPassword](/_posts/UserAdminModule/Get-SettingsWithCPassword/) |
| Category | [Get-SSLlabsScore](/_posts/UserAdminModule/Get-SSLlabsScore/) |
| Category | [Get-UnknownDevices](/_posts/UserAdminModule/Get-UnknownDevices/) |
| Category | [Get-VpnFailoverEventLogs](/_posts/UserAdminModule/Get-VpnFailoverEventLogs/) |
| Category | [Invoke-CiscoSecureManagement](/_posts/UserAdminModule/Invoke-CiscoSecureManagement/) |
| Category | [Invoke-PasswordifyPhrase](/_posts/UserAdminModule/Invoke-PasswordifyPhrase/) |
| Category | [Invoke-PasswordRoll](/_posts/UserAdminModule/Invoke-PasswordRoll/) |
| Category | [Invoke-UrlScan](/_posts/UserAdminModule/Invoke-UrlScan/) |
| Category | [New-DynamicParameter](/_posts/UserAdminModule/New-DynamicParameter/) |
| Category | [New-PassPhrase](/_posts/UserAdminModule/New-PassPhrase/) |
| Category | [New-Password](/_posts/UserAdminModule/New-Password/) |
| Category | [PasswordFunctions](/_posts/UserAdminModule/PasswordFunctions/) |
| Category | [ScreenPassword](/_posts/UserAdminModule/ScreenPassword/) |
| Category | [Set-CIMPermissions](/_posts/UserAdminModule/Set-CIMPermissions/) |
| Category | [Set-LDAPSBinding](/_posts/UserAdminModule/Set-LDAPSBinding/) |
| Category | [Update-SSLCertificate](/_posts/UserAdminModule/Update-SSLCertificate/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Shell


| Shell | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Check-BirthdayCountdown](/_posts/UserAdminModule/Check-BirthdayCountdown/) |
| Category | [Convert-TimeUnit](/_posts/UserAdminModule/Convert-TimeUnit/) |
| Category | [Copy-History](/_posts/UserAdminModule/Copy-History/) |
| Category | [Get-BankHolidays](/_posts/UserAdminModule/Get-BankHolidays/) |
| Category | [Get-ConsoleConfig](/_posts/UserAdminModule/Get-ConsoleConfig/) |
| Category | [Get-DayOfWeek](/_posts/UserAdminModule/Get-DayOfWeek/) |
| Category | [Get-DSTInfo](/_posts/UserAdminModule/Get-DSTInfo/) |
| Category | [Get-ExportedFunction](/_posts/UserAdminModule/Get-ExportedFunction/) |
| Category | [Get-FriendlySize](/_posts/UserAdminModule/Get-FriendlySize/) |
| Category | [Get-Icon](/_posts/UserAdminModule/Get-Icon/) |
| Category | [Get-LastBootTime](/_posts/UserAdminModule/Get-LastBootTime/) |
| Category | [Get-LastCommands](/_posts/UserAdminModule/Get-LastCommands/) |
| Category | [Get-LastRebootEvent](/_posts/UserAdminModule/Get-LastRebootEvent/) |
| Category | [Get-LastxOfMonth](/_posts/UserAdminModule/Get-LastxOfMonth/) |
| Category | [Get-LoadedFunctions](/_posts/UserAdminModule/Get-LoadedFunctions/) |
| Category | [Get-LocationStack](/_posts/UserAdminModule/Get-LocationStack/) |
| Category | [Get-MonthOfYear](/_posts/UserAdminModule/Get-MonthOfYear/) |
| Category | [Get-MoreCowbell](/_posts/UserAdminModule/Get-MoreCowbell/) |
| Category | [Get-MyHistory](/_posts/UserAdminModule/Get-MyHistory/) |
| Category | [Get-MyIpWtf](/_posts/UserAdminModule/Get-MyIpWtf/) |
| Category | [Get-NextPayDay](/_posts/UserAdminModule/Get-NextPayDay/) |
| Category | [Get-OutlookAppointments](/_posts/UserAdminModule/Get-OutlookAppointments/) |
| Category | [Get-PatchTue](/_posts/UserAdminModule/Get-PatchTue/) |
| Category | [Get-PayDay](/_posts/UserAdminModule/Get-PayDay/) |
| Category | [Get-RageQuitEvents](/_posts/UserAdminModule/Get-RageQuitEvents/) |
| Category | [GitHubCopilotAlias](/_posts/UserAdminModule/GitHubCopilotAlias/) |
| Category | [HomePowerShell_profile](/_posts/UserAdminModule/HomePowerShell_profile/) |
| Category | [Initialize-Module](/_posts/UserAdminModule/Initialize-Module/) |
| Category | [Install-LatestPWSH7](/_posts/UserAdminModule/Install-LatestPWSH7/) |
| Category | [Install-ModuleIfNotPresent](/_posts/UserAdminModule/Install-ModuleIfNotPresent/) |
| Category | [Install-PSTools](/_posts/UserAdminModule/Install-PSTools/) |
| Category | [Install-RequiredModules](/_posts/UserAdminModule/Install-RequiredModules/) |
| Category | [Install-WinGet](/_posts/UserAdminModule/Install-WinGet/) |
| Category | [IsAdmin](/_posts/UserAdminModule/IsAdmin/) |
| Category | [Lock-Screen](/_posts/UserAdminModule/Lock-Screen/) |
| Category | [Lock-UserInput](/_posts/UserAdminModule/Lock-UserInput/) |
| Category | [Microsoft.PowerShell_profile](/_posts/UserAdminModule/Microsoft.PowerShell_profile/) |
| Category | [Microsoft.PowerShell_profile_example](/_posts/UserAdminModule/Microsoft.PowerShell_profile_example/) |
| Category | [New-AdminShell](/_posts/UserAdminModule/New-AdminShell/) |
| Category | [New-CopilotPrompt](/_posts/UserAdminModule/New-CopilotPrompt/) |
| Category | [New-CountdownDate](/_posts/UserAdminModule/New-CountdownDate/) |
| Category | [New-Greeting](/_posts/UserAdminModule/New-Greeting/) |
| Category | [New-PSM1Module](/_posts/UserAdminModule/New-PSM1Module/) |
| Category | [New-QotD](/_posts/UserAdminModule/New-QotD/) |
| Category | [New-Shell](/_posts/UserAdminModule/New-Shell/) |
| Category | [New-StreamDeckShell](/_posts/UserAdminModule/New-StreamDeckShell/) |
| Category | [PersonalModules](/_posts/UserAdminModule/PersonalModules/) |
| Category | [RageQuit](/_posts/UserAdminModule/RageQuit/) |
| Category | [Restart-PowershellProfile](/_posts/UserAdminModule/Restart-PowershellProfile/) |
| Category | [Restart-Profile](/_posts/UserAdminModule/Restart-Profile/) |
| Category | [Restore-Location](/_posts/UserAdminModule/Restore-Location/) |
| Category | [Search-Google](/_posts/UserAdminModule/Search-Google/) |
| Category | [Select-FolderLocation](/_posts/UserAdminModule/Select-FolderLocation/) |
| Category | [Set-ConsoleConfig](/_posts/UserAdminModule/Set-ConsoleConfig/) |
| Category | [Set-DisplayIsAdmin](/_posts/UserAdminModule/Set-DisplayIsAdmin/) |
| Category | [Set-Home](/_posts/UserAdminModule/Set-Home/) |
| Category | [Set-PromptisAdmin](/_posts/UserAdminModule/Set-PromptisAdmin/) |
| Category | [Show-IsAdminOrNot](/_posts/UserAdminModule/Show-IsAdminOrNot/) |
| Category | [Show-Notification](/_posts/UserAdminModule/Show-Notification/) |
| Category | [Show-RandomCommand](/_posts/UserAdminModule/Show-RandomCommand/) |
| Category | [Show-RandomHelpAbout](/_posts/UserAdminModule/Show-RandomHelpAbout/) |
| Category | [Start-PSCountdown](/_posts/UserAdminModule/Start-PSCountdown/) |
| Category | [Stop-Outlook](/_posts/UserAdminModule/Stop-Outlook/) |
| Category | [Update-PowerShell](/_posts/UserAdminModule/Update-PowerShell/) |
| Category | [WorkPowerShell_profile](/_posts/UserAdminModule/WorkPowerShell_profile/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ShutdownCommands


| ShutdownCommands | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-RemoteComputerScheduledShutdown](/_posts/UserAdminModule/Get-RemoteComputerScheduledShutdown/) |
| Category | [Get-ShutdownExample](/_posts/UserAdminModule/Get-ShutdownExample/) |
| Category | [Invoke-RemoteComputerShutdown](/_posts/UserAdminModule/Invoke-RemoteComputerShutdown/) |
| Category | [New-PowerOutage](/_posts/UserAdminModule/New-PowerOutage/) |
| Category | [Schedule-Shutdown](/_posts/UserAdminModule/Schedule-Shutdown/) |
| Category | [Start-RemoteComputerShutdownSchedule](/_posts/UserAdminModule/Start-RemoteComputerShutdownSchedule/) |
| Category | [Stop-RemoteComputerShutdown](/_posts/UserAdminModule/Stop-RemoteComputerShutdown/) |
| Category | [Wait-RemoteComputerShutdown](/_posts/UserAdminModule/Wait-RemoteComputerShutdown/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Teams


| Teams | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Clear-TeamsCache](/_posts/UserAdminModule/Clear-TeamsCache/) |
| Category | [Convert-ImageForTeams](/_posts/UserAdminModule/Convert-ImageForTeams/) |
| Category | [Get-MSTeamsPhone](/_posts/UserAdminModule/Get-MSTeamsPhone/) |
| Category | [Get-TeamsFolderStructure](/_posts/UserAdminModule/Get-TeamsFolderStructure/) |
| Category | [Get-TeamsVersion](/_posts/UserAdminModule/Get-TeamsVersion/) |
| Category | [Get-UsersTeamsFolders](/_posts/UserAdminModule/Get-UsersTeamsFolders/) |
| Category | [Initialize-TeamsLocalUploadFolder](/_posts/UserAdminModule/Initialize-TeamsLocalUploadFolder/) |
| Category | [New-MSTeamsPhone](/_posts/UserAdminModule/New-MSTeamsPhone/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Testing


| Testing | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Test-ADReplication](/_posts/UserAdminModule/Test-ADReplication/) |
| Category | [Test-CiscoSecure](/_posts/UserAdminModule/Test-CiscoSecure/) |
| Category | [Test-Computer](/_posts/UserAdminModule/Test-Computer/) |
| Category | [Test-ComputerName](/_posts/UserAdminModule/Test-ComputerName/) |
| Category | [Test-ContactEmail](/_posts/UserAdminModule/Test-ContactEmail/) |
| Category | [Test-DeathstarBackUp](/_posts/UserAdminModule/Test-DeathstarBackUp/) |
| Category | [Test-DisplayName](/_posts/UserAdminModule/Test-DisplayName/) |
| Category | [test-dnsrecord](/_posts/UserAdminModule/test-dnsrecord/) |
| Category | [Test-DNSRecord](/_posts/UserAdminModule/Test-DNSRecord/) |
| Category | [Test-DnsRecordEndpoints](/_posts/UserAdminModule/Test-DnsRecordEndpoints/) |
| Category | [Test-DomainMailRecords](/_posts/UserAdminModule/Test-DomainMailRecords/) |
| Category | [Test-EmailAddress](/_posts/UserAdminModule/Test-EmailAddress/) |
| Category | [Test-ExchangeConnection](/_posts/UserAdminModule/Test-ExchangeConnection/) |
| Category | [Test-ExchangeDNSRR](/_posts/UserAdminModule/Test-ExchangeDNSRR/) |
| Category | [Test-FileExists](/_posts/UserAdminModule/Test-FileExists/) |
| Category | [Test-FolderExists](/_posts/UserAdminModule/Test-FolderExists/) |
| Category | [Test-ifContactExists](/_posts/UserAdminModule/Test-ifContactExists/) |
| Category | [Test-IsAdmin](/_posts/UserAdminModule/Test-IsAdmin/) |
| Category | [Test-LDAPconnection](/_posts/UserAdminModule/Test-LDAPconnection/) |
| Category | [Test-NetworkPort](/_posts/UserAdminModule/Test-NetworkPort/) |
| Category | [Test-O365EmailExists](/_posts/UserAdminModule/Test-O365EmailExists/) |
| Category | [Test-OnlineFast](/_posts/UserAdminModule/Test-OnlineFast/) |
| Category | [Test-OpenPorts](/_posts/UserAdminModule/Test-OpenPorts/) |
| Category | [Test-OpenPortsWitch](/_posts/UserAdminModule/Test-OpenPortsWitch/) |
| Category | [Test-ProfileExists](/_posts/UserAdminModule/Test-ProfileExists/) |
| Category | [Test-RemoteTimeSettings](/_posts/UserAdminModule/Test-RemoteTimeSettings/) |
| Category | [Test-SamAccountName](/_posts/UserAdminModule/Test-SamAccountName/) |
| Category | [Test-ServerExists](/_posts/UserAdminModule/Test-ServerExists/) |
| Category | [Test-ServerRolePortGroup](/_posts/UserAdminModule/Test-ServerRolePortGroup/) |
| Category | [Test-SMB1Enabled](/_posts/UserAdminModule/Test-SMB1Enabled/) |
| Category | [Test-SSLProtocols](/_posts/UserAdminModule/Test-SSLProtocols/) |
| Category | [Test-Surname](/_posts/UserAdminModule/Test-Surname/) |
| Category | [Test-TLSConnection](/_posts/UserAdminModule/Test-TLSConnection/) |
| Category | [Test-TransmissionSettings](/_posts/UserAdminModule/Test-TransmissionSettings/) |
| Category | [Test-UserExists](/_posts/UserAdminModule/Test-UserExists/) |
| Category | [Test-WebsiteAvailability](/_posts/UserAdminModule/Test-WebsiteAvailability/) |
| Category | [Test-WebSiteUp](/_posts/UserAdminModule/Test-WebSiteUp/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Utilities


| Utilities | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Cleanup-TestFiles](/_posts/UserAdminModule/Cleanup-TestFiles/) |
| Category | [ConvertFrom-ErrorRecord](/_posts/UserAdminModule/ConvertFrom-ErrorRecord/) |
| Category | [ConvertFrom-Text](/_posts/UserAdminModule/ConvertFrom-Text/) |
| Category | [ConvertObject-ToHashTable](/_posts/UserAdminModule/ConvertObject-ToHashTable/) |
| Category | [Export-Functions](/_posts/UserAdminModule/Export-Functions/) |
| Category | [Export-SingleFunction](/_posts/UserAdminModule/Export-SingleFunction/) |
| Category | [Get-2amOfThirdMondayInMonth](/_posts/UserAdminModule/Get-2amOfThirdMondayInMonth/) |
| Category | [Get-AdminURL](/_posts/UserAdminModule/Get-AdminURL/) |
| Category | [Get-ChuckNorrisJoke](/_posts/UserAdminModule/Get-ChuckNorrisJoke/) |
| Category | [Get-CPUTemperature](/_posts/UserAdminModule/Get-CPUTemperature/) |
| Category | [get-DotNetVersion](/_posts/UserAdminModule/get-DotNetVersion/) |
| Category | [Get-DotNetVersion](/_posts/UserAdminModule/Get-DotNetVersion/) |
| Category | [Get-DownloadPercent](/_posts/UserAdminModule/Get-DownloadPercent/) |
| Category | [Get-ErrorInfo](/_posts/UserAdminModule/Get-ErrorInfo/) |
| Category | [Get-InfoBadService](/_posts/UserAdminModule/Get-InfoBadService/) |
| Category | [Get-InfoCompSystem](/_posts/UserAdminModule/Get-InfoCompSystem/) |
| Category | [Get-InfoDisk](/_posts/UserAdminModule/Get-InfoDisk/) |
| Category | [Get-InfoNIC](/_posts/UserAdminModule/Get-InfoNIC/) |
| Category | [Get-InfoOS](/_posts/UserAdminModule/Get-InfoOS/) |
| Category | [Get-InfoProc](/_posts/UserAdminModule/Get-InfoProc/) |
| Category | [Get-InstalledDotNetVersions](/_posts/UserAdminModule/Get-InstalledDotNetVersions/) |
| Category | [Get-InstalledUpdates](/_posts/UserAdminModule/Get-InstalledUpdates/) |
| Category | [Get-KMSclientActivations](/_posts/UserAdminModule/Get-KMSclientActivations/) |
| Category | [Get-KMSserverActivations](/_posts/UserAdminModule/Get-KMSserverActivations/) |
| Category | [Get-LastInstalledApplication](/_posts/UserAdminModule/Get-LastInstalledApplication/) |
| Category | [Get-Lines](/_posts/UserAdminModule/Get-Lines/) |
| Category | [Get-NTPStatusFromHost](/_posts/UserAdminModule/Get-NTPStatusFromHost/) |
| Category | [Get-Ntptime](/_posts/UserAdminModule/Get-Ntptime/) |
| Category | [Get-PatchTuesday](/_posts/UserAdminModule/Get-PatchTuesday/) |
| Category | [Get-PendingReboot](/_posts/UserAdminModule/Get-PendingReboot/) |
| Category | [Get-PendingUpdate](/_posts/UserAdminModule/Get-PendingUpdate/) |
| Category | [Get-PendingUpdates](/_posts/UserAdminModule/Get-PendingUpdates/) |
| Category | [Get-RebootReport](/_posts/UserAdminModule/Get-RebootReport/) |
| Category | [Get-RemoteTime](/_posts/UserAdminModule/Get-RemoteTime/) |
| Category | [Get-Resources](/_posts/UserAdminModule/Get-Resources/) |
| Category | [Get-RestartHistory](/_posts/UserAdminModule/Get-RestartHistory/) |
| Category | [Get-RunOnceRegKeys](/_posts/UserAdminModule/Get-RunOnceRegKeys/) |
| Category | [Get-RunRegKeys](/_posts/UserAdminModule/Get-RunRegKeys/) |
| Category | [Get-ScriptFunctionNames](/_posts/UserAdminModule/Get-ScriptFunctionNames/) |
| Category | [Get-ServerInstalledFeatures](/_posts/UserAdminModule/Get-ServerInstalledFeatures/) |
| Category | [Get-ServerTimeZone](/_posts/UserAdminModule/Get-ServerTimeZone/) |
| Category | [Get-SpeedTestServers](/_posts/UserAdminModule/Get-SpeedTestServers/) |
| Category | [Get-Time](/_posts/UserAdminModule/Get-Time/) |
| Category | [Get-TimeServer](/_posts/UserAdminModule/Get-TimeServer/) |
| Category | [Get-TimeSource](/_posts/UserAdminModule/Get-TimeSource/) |
| Category | [Get-TimeZoneID](/_posts/UserAdminModule/Get-TimeZoneID/) |
| Category | [Get-UserProfiles](/_posts/UserAdminModule/Get-UserProfiles/) |
| Category | [Get-W32TimeConfiguration](/_posts/UserAdminModule/Get-W32TimeConfiguration/) |
| Category | [Get-W32TimeServiceStatus](/_posts/UserAdminModule/Get-W32TimeServiceStatus/) |
| Category | [Get-W32TimeSource](/_posts/UserAdminModule/Get-W32TimeSource/) |
| Category | [Get-W32TimeStripchartResults](/_posts/UserAdminModule/Get-W32TimeStripchartResults/) |
| Category | [Get-WeekDayInMonth](/_posts/UserAdminModule/Get-WeekDayInMonth/) |
| Category | [GetWindowsFeatures](/_posts/UserAdminModule/GetWindowsFeatures/) |
| Category | [Import-CSVCustom](/_posts/UserAdminModule/Import-CSVCustom/) |
| Category | [Invoke-BatchArray](/_posts/UserAdminModule/Invoke-BatchArray/) |
| Category | [Invoke-CDRomDrive](/_posts/UserAdminModule/Invoke-CDRomDrive/) |
| Category | [Invoke-WebrequestCookie](/_posts/UserAdminModule/Invoke-WebrequestCookie/) |
| Category | [Invoke-WithPsGalleryStats](/_posts/UserAdminModule/Invoke-WithPsGalleryStats/) |
| Category | [Measure-Lines](/_posts/UserAdminModule/Measure-Lines/) |
| Category | [Move-FilesByType](/_posts/UserAdminModule/Move-FilesByType/) |
| Category | [New-Email](/_posts/UserAdminModule/New-Email/) |
| Category | [New-LocalRunOnceRegKey](/_posts/UserAdminModule/New-LocalRunOnceRegKey/) |
| Category | [New-NTPRecord](/_posts/UserAdminModule/New-NTPRecord/) |
| Category | [New-SpeedTest](/_posts/UserAdminModule/New-SpeedTest/) |
| Category | [New-SYDIDocument](/_posts/UserAdminModule/New-SYDIDocument/) |
| Category | [Open-CDTray](/_posts/UserAdminModule/Open-CDTray/) |
| Category | [Out-Excel](/_posts/UserAdminModule/Out-Excel/) |
| Category | [PadOrTruncate](/_posts/UserAdminModule/PadOrTruncate/) |
| Category | [ProgressBar](/_posts/UserAdminModule/ProgressBar/) |
| Category | [Remove-NTPRecord](/_posts/UserAdminModule/Remove-NTPRecord/) |
| Category | [Remove-RunOnceRegKey](/_posts/UserAdminModule/Remove-RunOnceRegKey/) |
| Category | [Remove-RunRegKey](/_posts/UserAdminModule/Remove-RunRegKey/) |
| Category | [Remove-UserProfile](/_posts/UserAdminModule/Remove-UserProfile/) |
| Category | [Remove-UserProfiles](/_posts/UserAdminModule/Remove-UserProfiles/) |
| Category | [RemoveLocalUserProfile](/_posts/UserAdminModule/RemoveLocalUserProfile/) |
| Category | [Save-LogResults](/_posts/UserAdminModule/Save-LogResults/) |
| Category | [Search-RoadWorks](/_posts/UserAdminModule/Search-RoadWorks/) |
| Category | [Set-DNSRecord](/_posts/UserAdminModule/Set-DNSRecord/) |
| Category | [Set-NTPRecord](/_posts/UserAdminModule/Set-NTPRecord/) |
| Category | [Set-RegEntry](/_posts/UserAdminModule/Set-RegEntry/) |
| Category | [Set-RegistryShouldBe](/_posts/UserAdminModule/Set-RegistryShouldBe/) |
| Category | [Set-RemoteComputerTime](/_posts/UserAdminModule/Set-RemoteComputerTime/) |
| Category | [Set-RunOnceRegKeys](/_posts/UserAdminModule/Set-RunOnceRegKeys/) |
| Category | [Set-RunRegKey](/_posts/UserAdminModule/Set-RunRegKey/) |
| Category | [Set-ServerTimeZone](/_posts/UserAdminModule/Set-ServerTimeZone/) |
| Category | [Set-TimeZoneID](/_posts/UserAdminModule/Set-TimeZoneID/) |
| Category | [Start-WindowsUpdate](/_posts/UserAdminModule/Start-WindowsUpdate/) |
| Category | [Validate-LDAPSBinding](/_posts/UserAdminModule/Validate-LDAPSBinding/) |
| Category | [Write-ProgressHelper](/_posts/UserAdminModule/Write-ProgressHelper/) |
| Category | [Write-ProgressPipeline](/_posts/UserAdminModule/Write-ProgressPipeline/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Virtualization


| Virtualization | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-DiskReport](/_posts/UserAdminModule/Get-DiskReport/) |
| Category | [Get-DockerStatsSnapshot](/_posts/UserAdminModule/Get-DockerStatsSnapshot/) |
| Category | [Get-DriveSpaceReport](/_posts/UserAdminModule/Get-DriveSpaceReport/) |
| Category | [Get-ServerInfo](/_posts/UserAdminModule/Get-ServerInfo/) |
| Category | [Get-Uptime](/_posts/UserAdminModule/Get-Uptime/) |
| Category | [Get-UptimeResult](/_posts/UserAdminModule/Get-UptimeResult/) |
| Category | [Get-UptimeV1](/_posts/UserAdminModule/Get-UptimeV1/) |
| Category | [Get-VMGuestHardwareDetails](/_posts/UserAdminModule/Get-VMGuestHardwareDetails/) |
| Category | [Get-VMInfoCustom](/_posts/UserAdminModule/Get-VMInfoCustom/) |
| Category | [Get-VMInformation](/_posts/UserAdminModule/Get-VMInformation/) |
| Category | [Get-VMInformationPlus](/_posts/UserAdminModule/Get-VMInformationPlus/) |
| Category | [Get-WMIHardwareOSInfo](/_posts/UserAdminModule/Get-WMIHardwareOSInfo/) |
| Category | [New-WindowsSandbox](/_posts/UserAdminModule/New-WindowsSandbox/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Weather


| Weather | Function |
| :----------- | :-------------------------------------------------------------- |
| Category | [Get-Weather](/_posts/UserAdminModule/Get-Weather/) |
| Category | [Get-WeatherDetail](/_posts/UserAdminModule/Get-WeatherDetail/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---
