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

| Category         | Function                                                                  |
| :--------------- | :------------------------------------------------------------------------ |
| ModuleManagement | [Import-PersonalModules](/_posts/UserAdminModule/Import-PersonalModules/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ADFunctions

| Category    | Function                                                                                                    |
| :---------- | :---------------------------------------------------------------------------------------------------------- |
| ADFunctions | [Add-ADUsertoLocalGroup](/_posts/UserAdminModule/Add-ADUsertoLocalGroup/)                                   |
| ADFunctions | [ADUserAccountFunctions](/_posts/UserAdminModule/ADUserAccountFunctions/)                                   |
| ADFunctions | [Amend-pwdLastSet](/_posts/UserAdminModule/Amend-pwdLastSet/)                                               |
| ADFunctions | [Compare-GroupMembership](/_posts/UserAdminModule/Compare-GroupMembership/)                                 |
| ADFunctions | [Copy-AdGroupMemberShip](/_posts/UserAdminModule/Copy-AdGroupMemberShip/)                                   |
| ADFunctions | [Copy-GroupMembership](/_posts/UserAdminModule/Copy-GroupMembership/)                                       |
| ADFunctions | [Disable-InactiveComputer](/_posts/UserAdminModule/Disable-InactiveComputer/)                               |
| ADFunctions | [DisableADAccountsMenu](/_posts/UserAdminModule/DisableADAccountsMenu/)                                     |
| ADFunctions | [Find-localAdmins](/_posts/UserAdminModule/Find-localAdmins/)                                               |
| ADFunctions | [Find-UnusedADAccounts](/_posts/UserAdminModule/Find-UnusedADAccounts/)                                     |
| ADFunctions | [FSMOFunctions](/_posts/UserAdminModule/FSMOFunctions/)                                                     |
| ADFunctions | [Get-ActiveDirectoryTombstonePeriod](/_posts/UserAdminModule/Get-ActiveDirectoryTombstonePeriod/)           |
| ADFunctions | [Get-ADComputerSearch](/_posts/UserAdminModule/Get-ADComputerSearch/)                                       |
| ADFunctions | [Get-ADDeletedUsers](/_posts/UserAdminModule/Get-ADDeletedUsers/)                                           |
| ADFunctions | [Get-ADDiagnosticConfiguration](/_posts/UserAdminModule/Get-ADDiagnosticConfiguration/)                     |
| ADFunctions | [Get-ADDiagnosticLogging](/_posts/UserAdminModule/Get-ADDiagnosticLogging/)                                 |
| ADFunctions | [Get-ADEmailAddress](/_posts/UserAdminModule/Get-ADEmailAddress/)                                           |
| ADFunctions | [Get-ADGroupAccountDetails](/_posts/UserAdminModule/Get-ADGroupAccountDetails/)                             |
| ADFunctions | [Get-ADGroupMembers](/_posts/UserAdminModule/Get-ADGroupMembers/)                                           |
| ADFunctions | [Get-ADGroupNames](/_posts/UserAdminModule/Get-ADGroupNames/)                                               |
| ADFunctions | [Get-AdminGroupsWithComputers](/_posts/UserAdminModule/Get-AdminGroupsWithComputers/)                       |
| ADFunctions | [Get-ADObjectAddress](/_posts/UserAdminModule/Get-ADObjectAddress/)                                         |
| ADFunctions | [Get-ADPasswordReminderUsers](/_posts/UserAdminModule/Get-ADPasswordReminderUsers/)                         |
| ADFunctions | [Get-ADUserAudit](/_posts/UserAdminModule/Get-ADUserAudit/)                                                 |
| ADFunctions | [Get-ADUserEmailProperties](/_posts/UserAdminModule/Get-ADUserEmailProperties/)                             |
| ADFunctions | [Get-ADUserExchangeDN](/_posts/UserAdminModule/Get-ADUserExchangeDN/)                                       |
| ADFunctions | [Get-ADUserLastLogon](/_posts/UserAdminModule/Get-ADUserLastLogon/)                                         |
| ADFunctions | [Get-ADUserSearch](/_posts/UserAdminModule/Get-ADUserSearch/)                                               |
| ADFunctions | [Get-ADUserSearch2](/_posts/UserAdminModule/Get-ADUserSearch2/)                                             |
| ADFunctions | [Get-AllDomainControllers](/_posts/UserAdminModule/Get-AllDomainControllers/)                               |
| ADFunctions | [Get-Cert](/_posts/UserAdminModule/Get-Cert/)                                                               |
| ADFunctions | [Get-ComputersWithoutBitLocker](/_posts/UserAdminModule/Get-ComputersWithoutBitLocker/)                     |
| ADFunctions | [Get-CurrentUserLogon](/_posts/UserAdminModule/Get-CurrentUserLogon/)                                       |
| ADFunctions | [Get-DirectReports](/_posts/UserAdminModule/Get-DirectReports/)                                             |
| ADFunctions | [Get-DomainControllers](/_posts/UserAdminModule/Get-DomainControllers/)                                     |
| ADFunctions | [Get-ElevatedUsers](/_posts/UserAdminModule/Get-ElevatedUsers/)                                             |
| ADFunctions | [Get-EmptyOUs](/_posts/UserAdminModule/Get-EmptyOUs/)                                                       |
| ADFunctions | [Get-FeaturesInventory](/_posts/UserAdminModule/Get-FeaturesInventory/)                                     |
| ADFunctions | [Get-FSMORoleOwner](/_posts/UserAdminModule/Get-FSMORoleOwner/)                                             |
| ADFunctions | [Get-GPProcessingTime](/_posts/UserAdminModule/Get-GPProcessingTime/)                                       |
| ADFunctions | [Get-LapsAndBitLocker](/_posts/UserAdminModule/Get-LapsAndBitLocker/)                                       |
| ADFunctions | [Get-LastGPOUpdateTime](/_posts/UserAdminModule/Get-LastGPOUpdateTime/)                                     |
| ADFunctions | [Get-LocalGroupMembership](/_posts/UserAdminModule/Get-LocalGroupMembership/)                               |
| ADFunctions | [Get-LockedOutUser](/_posts/UserAdminModule/Get-LockedOutUser/)                                             |
| ADFunctions | [Get-LockoutHistory](/_posts/UserAdminModule/Get-LockoutHistory/)                                           |
| ADFunctions | [Get-LoggedOnUser](/_posts/UserAdminModule/Get-LoggedOnUser/)                                               |
| ADFunctions | [Get-LogonEvents](/_posts/UserAdminModule/Get-LogonEvents/)                                                 |
| ADFunctions | [Get-LogonHistory](/_posts/UserAdminModule/Get-LogonHistory/)                                               |
| ADFunctions | [Get-NestedGroupMember](/_posts/UserAdminModule/Get-NestedGroupMember/)                                     |
| ADFunctions | [Get-O365LastLogonTime](/_posts/UserAdminModule/Get-O365LastLogonTime/)                                     |
| ADFunctions | [Get-OUDelegations](/_posts/UserAdminModule/Get-OUDelegations/)                                             |
| ADFunctions | [Get-PrimaryGroupsReport](/_posts/UserAdminModule/Get-PrimaryGroupsReport/)                                 |
| ADFunctions | [Get-RemoteServiceAccount](/_posts/UserAdminModule/Get-RemoteServiceAccount/)                               |
| ADFunctions | [Get-ServiceDetails](/_posts/UserAdminModule/Get-ServiceDetails/)                                           |
| ADFunctions | [Get-ServiceLogonAccount](/_posts/UserAdminModule/Get-ServiceLogonAccount/)                                 |
| ADFunctions | [Get-ServicePrivilege](/_posts/UserAdminModule/Get-ServicePrivilege/)                                       |
| ADFunctions | [Get-TargetGPResult](/_posts/UserAdminModule/Get-TargetGPResult/)                                           |
| ADFunctions | [Get-TokenSizeReport](/_posts/UserAdminModule/Get-TokenSizeReport/)                                         |
| ADFunctions | [Get-TopOUName](/_posts/UserAdminModule/Get-TopOUName/)                                                     |
| ADFunctions | [Get-UnlinkedGPO](/_posts/UserAdminModule/Get-UnlinkedGPO/)                                                 |
| ADFunctions | [Get-UserAccountControlReport](/_posts/UserAdminModule/Get-UserAccountControlReport/)                       |
| ADFunctions | [Get-UserLogon](/_posts/UserAdminModule/Get-UserLogon/)                                                     |
| ADFunctions | [Get-UserLogonEvents](/_posts/UserAdminModule/Get-UserLogonEvents/)                                         |
| ADFunctions | [get-usermembership](/_posts/UserAdminModule/get-usermembership/)                                           |
| ADFunctions | [Get-UserReport](/_posts/UserAdminModule/Get-UserReport/)                                                   |
| ADFunctions | [Get-UsersGroupMemberShips](/_posts/UserAdminModule/Get-UsersGroupMemberShips/)                             |
| ADFunctions | [Get-UserSupportedEncryptionTypes](/_posts/UserAdminModule/Get-UserSupportedEncryptionTypes/)               |
| ADFunctions | [GetMailboxPermission](/_posts/UserAdminModule/GetMailboxPermission/)                                       |
| ADFunctions | [GetUserLoggedOnto](/_posts/UserAdminModule/GetUserLoggedOnto/)                                             |
| ADFunctions | [Lock-UserAccount](/_posts/UserAdminModule/Lock-UserAccount/)                                               |
| ADFunctions | [Move-ADComputer](/_posts/UserAdminModule/Move-ADComputer/)                                                 |
| ADFunctions | [Move-FSMORolestoPDCEmulator](/_posts/UserAdminModule/Move-FSMORolestoPDCEmulator/)                         |
| ADFunctions | [MoveOU](/_posts/UserAdminModule/MoveOU/)                                                                   |
| ADFunctions | [New-EncryptedUser](/_posts/UserAdminModule/New-EncryptedUser/)                                             |
| ADFunctions | [New-FakeADUser](/_posts/UserAdminModule/New-FakeADUser/)                                                   |
| ADFunctions | [New-FakeADUserDetails](/_posts/UserAdminModule/New-FakeADUserDetails/)                                     |
| ADFunctions | [New-FakeUserDetails](/_posts/UserAdminModule/New-FakeUserDetails/)                                         |
| ADFunctions | [New-RandomUser](/_posts/UserAdminModule/New-RandomUser/)                                                   |
| ADFunctions | [Provision_Home_Folder](/_posts/UserAdminModule/Provision_Home_Folder/)                                     |
| ADFunctions | [Query-UserAccountControl](/_posts/UserAdminModule/Query-UserAccountControl/)                               |
| ADFunctions | [remove-ADM](/_posts/UserAdminModule/remove-ADM/)                                                           |
| ADFunctions | [Remove-AdminSDHolder](/_posts/UserAdminModule/Remove-AdminSDHolder/)                                       |
| ADFunctions | [Restore-ADDeletedUsers](/_posts/UserAdminModule/Restore-ADDeletedUsers/)                                   |
| ADFunctions | [Search-GPO](/_posts/UserAdminModule/Search-GPO/)                                                           |
| ADFunctions | [Search-GPOforString](/_posts/UserAdminModule/Search-GPOforString/)                                         |
| ADFunctions | [Search-GPOsForString](/_posts/UserAdminModule/Search-GPOsForString/)                                       |
| ADFunctions | [Search-GPOsForStringOrig](/_posts/UserAdminModule/Search-GPOsForStringOrig/)                               |
| ADFunctions | [Search-KerbDelegatedAccounts](/_posts/UserAdminModule/Search-KerbDelegatedAccounts/)                       |
| ADFunctions | [Set-ADDiagnosticConfiguration](/_posts/UserAdminModule/Set-ADDiagnosticConfiguration/)                     |
| ADFunctions | [Set-ADUserPassword](/_posts/UserAdminModule/Set-ADUserPassword/)                                           |
| ADFunctions | [Set-CustomAttributesForGroupMembers](/_posts/UserAdminModule/Set-CustomAttributesForGroupMembers/)         |
| ADFunctions | [Set-ExtensionAttribute](/_posts/UserAdminModule/Set-ExtensionAttribute/)                                   |
| ADFunctions | [Set-FSMORoleOwner](/_posts/UserAdminModule/Set-FSMORoleOwner/)                                             |
| ADFunctions | [SiteNameConsistencyReport](/_posts/UserAdminModule/SiteNameConsistencyReport/)                             |
| ADFunctions | [Sync-Office365ToADDS](/_posts/UserAdminModule/Sync-Office365ToADDS/)                                       |
| ADFunctions | [Test-ADUserCredentials](/_posts/UserAdminModule/Test-ADUserCredentials/)                                   |
| ADFunctions | [Test-ADUserHighPrivilegeGroupMembership](/_posts/UserAdminModule/Test-ADUserHighPrivilegeGroupMembership/) |
| ADFunctions | [Unlock-UserAccount](/_posts/UserAdminModule/Unlock-UserAccount/)                                           |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Azure

| Category | Function                                                                                                            |
| :------- | :------------------------------------------------------------------------------------------------------------------ |
| Azure    | [Connect-toAzure](/_posts/UserAdminModule/Connect-toAzure/)                                                         |
| Azure    | [Connect-toAzureSubscription](/_posts/UserAdminModule/Connect-toAzureSubscription/)                                 |
| Azure    | [Connect-toMSGraphApplicationWithCertificate](/_posts/UserAdminModule/Connect-toMSGraphApplicationWithCertificate/) |
| Azure    | [Convert-AzuretoOnPrem](/_posts/UserAdminModule/Convert-AzuretoOnPrem/)                                             |
| Azure    | [Get-AccessToken](/_posts/UserAdminModule/Get-AccessToken/)                                                         |
| Azure    | [Get-AzEnterpriseAppConfig](/_posts/UserAdminModule/Get-AzEnterpriseAppConfig/)                                     |
| Azure    | [Get-EntraGuestMembers](/_posts/UserAdminModule/Get-EntraGuestMembers/)                                             |
| Azure    | [Get-MFAMethods](/_posts/UserAdminModule/Get-MFAMethods/)                                                           |
| Azure    | [Get-MgAdmins](/_posts/UserAdminModule/Get-MgAdmins/)                                                               |
| Azure    | [Get-MgUserDetails](/_posts/UserAdminModule/Get-MgUserDetails/)                                                     |
| Azure    | [Invoke-AzureADApp](/_posts/UserAdminModule/Invoke-AzureADApp/)                                                     |
| Azure    | [Invoke-AzureMailApp](/_posts/UserAdminModule/Invoke-AzureMailApp/)                                                 |
| Azure    | [Manage-AzureADApp](/_posts/UserAdminModule/Manage-AzureADApp/)                                                     |
| Azure    | [New-AzureADDynamicGroup](/_posts/UserAdminModule/New-AzureADDynamicGroup/)                                         |
| Azure    | [New-EntraGuestInvitation](/_posts/UserAdminModule/New-EntraGuestInvitation/)                                       |
| Azure    | [New-EntraGuestInvitationEntra](/_posts/UserAdminModule/New-EntraGuestInvitationEntra/)                             |
| Azure    | [Send-EmailUsingAzureApp](/_posts/UserAdminModule/Send-EmailUsingAzureApp/)                                         |
| Azure    | [Set-EntraGuestMember](/_posts/UserAdminModule/Set-EntraGuestMember/)                                               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## CertificateUtilities

| Category             | Function                                                                        |
| :------------------- | :------------------------------------------------------------------------------ |
| CertificateUtilities | [Get-CertificateExpiry](/_posts/UserAdminModule/Get-CertificateExpiry/)         |
| CertificateUtilities | [Get-RemoteCertificates](/_posts/UserAdminModule/Get-RemoteCertificates/)       |
| CertificateUtilities | [Get-RemoteCipherDetails](/_posts/UserAdminModule/Get-RemoteCipherDetails/)     |
| CertificateUtilities | [Get-RemoteLdapCertDetails](/_posts/UserAdminModule/Get-RemoteLdapCertDetails/) |
| CertificateUtilities | [Install-RemoteCertificate](/_posts/UserAdminModule/Install-RemoteCertificate/) |
| CertificateUtilities | [New-CodeSigningCert](/_posts/UserAdminModule/New-CodeSigningCert/)             |
| CertificateUtilities | [Set-DigitalSignature](/_posts/UserAdminModule/Set-DigitalSignature/)           |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Database

| Category | Function                                                    |
| :------- | :---------------------------------------------------------- |
| Database | [Get-DBInstances](/_posts/UserAdminModule/Get-DBInstances/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## EnvironmentManagement

| Category              | Function                                                  |
| :-------------------- | :-------------------------------------------------------- |
| EnvironmentManagement | [Add-EnvPath](/_posts/UserAdminModule/Add-EnvPath/)       |
| EnvironmentManagement | [Get-EnvPath](/_posts/UserAdminModule/Get-EnvPath/)       |
| EnvironmentManagement | [Remove-EnvPath](/_posts/UserAdminModule/Remove-EnvPath/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Exchange

| Category | Function                                                                                                                |
| :------- | :---------------------------------------------------------------------------------------------------------------------- |
| Exchange | [Add-MemberToDistributionGroup](/_posts/UserAdminModule/Add-MemberToDistributionGroup/)                                 |
| Exchange | [Add-Office365Functions](/_posts/UserAdminModule/Add-Office365Functions/)                                               |
| Exchange | [Connect-ExchangeServer](/_posts/UserAdminModule/Connect-ExchangeServer/)                                               |
| Exchange | [Connect-O365Exchange](/_posts/UserAdminModule/Connect-O365Exchange/)                                                   |
| Exchange | [Connect-O365Session](/_posts/UserAdminModule/Connect-O365Session/)                                                     |
| Exchange | [Connect-Office365Services](/_posts/UserAdminModule/Connect-Office365Services/)                                         |
| Exchange | [Connect-OPExchange](/_posts/UserAdminModule/Connect-OPExchange/)                                                       |
| Exchange | [Copy-DistributionGroupMembers](/_posts/UserAdminModule/Copy-DistributionGroupMembers/)                                 |
| Exchange | [Copy-DistributionGroupMembership](/_posts/UserAdminModule/Copy-DistributionGroupMembership/)                           |
| Exchange | [Copy-OnPremToCloudDistributionGroupMembership](/_posts/UserAdminModule/Copy-OnPremToCloudDistributionGroupMembership/) |
| Exchange | [Copy-ReceiveConnector](/_posts/UserAdminModule/Copy-ReceiveConnector/)                                                 |
| Exchange | [Disconnect-ExchangeSessions](/_posts/UserAdminModule/Disconnect-ExchangeSessions/)                                     |
| Exchange | [Enter-O365Session](/_posts/UserAdminModule/Enter-O365Session/)                                                         |
| Exchange | [ExchangeConnector](/_posts/UserAdminModule/ExchangeConnector/)                                                         |
| Exchange | [ExchangeFunctions](/_posts/UserAdminModule/ExchangeFunctions/)                                                         |
| Exchange | [Export-CalendarPermissions](/_posts/UserAdminModule/Export-CalendarPermissions/)                                       |
| Exchange | [Export-DistributionGroupProperties](/_posts/UserAdminModule/Export-DistributionGroupProperties/)                       |
| Exchange | [Export-ExchangeContactData](/_posts/UserAdminModule/Export-ExchangeContactData/)                                       |
| Exchange | [Get-ADExchangeServer](/_posts/UserAdminModule/Get-ADExchangeServer/)                                                   |
| Exchange | [Get-ContactList](/_posts/UserAdminModule/Get-ContactList/)                                                             |
| Exchange | [Get-ContactsFromDomain](/_posts/UserAdminModule/Get-ContactsFromDomain/)                                               |
| Exchange | [Get-DistributionGroupsWithOwners](/_posts/UserAdminModule/Get-DistributionGroupsWithOwners/)                           |
| Exchange | [Get-DistributionListMembers](/_posts/UserAdminModule/Get-DistributionListMembers/)                                     |
| Exchange | [Get-DuplicateExchangeDN](/_posts/UserAdminModule/Get-DuplicateExchangeDN/)                                             |
| Exchange | [Get-ExchangeServer](/_posts/UserAdminModule/Get-ExchangeServer/)                                                       |
| Exchange | [Get-ExchangeServerInSite](/_posts/UserAdminModule/Get-ExchangeServerInSite/)                                           |
| Exchange | [Get-ExchangeVersion](/_posts/UserAdminModule/Get-ExchangeVersion/)                                                     |
| Exchange | [Get-FilteredContacts](/_posts/UserAdminModule/Get-FilteredContacts/)                                                   |
| Exchange | [Get-FilteredMailboxes](/_posts/UserAdminModule/Get-FilteredMailboxes/)                                                 |
| Exchange | [Get-MailboxAccessPerms](/_posts/UserAdminModule/Get-MailboxAccessPerms/)                                               |
| Exchange | [Get-MailboxContent](/_posts/UserAdminModule/Get-MailboxContent/)                                                       |
| Exchange | [Get-MailboxPermissions](/_posts/UserAdminModule/Get-MailboxPermissions/)                                               |
| Exchange | [Get-MailboxPermissionsExport](/_posts/UserAdminModule/Get-MailboxPermissionsExport/)                                   |
| Exchange | [Get-MailboxPermissionsReport](/_posts/UserAdminModule/Get-MailboxPermissionsReport/)                                   |
| Exchange | [Get-MailboxPermissionsReport2](/_posts/UserAdminModule/Get-MailboxPermissionsReport2/)                                 |
| Exchange | [Get-MailboxReport](/_posts/UserAdminModule/Get-MailboxReport/)                                                         |
| Exchange | [Get-MailboxStatistics](/_posts/UserAdminModule/Get-MailboxStatistics/)                                                 |
| Exchange | [Get-MailContactDetails](/_posts/UserAdminModule/Get-MailContactDetails/)                                               |
| Exchange | [Get-MBAccessPerms](/_posts/UserAdminModule/Get-MBAccessPerms/)                                                         |
| Exchange | [Get-MessageTraceFiltered](/_posts/UserAdminModule/Get-MessageTraceFiltered/)                                           |
| Exchange | [Get-O365CalendarPermissions](/_posts/UserAdminModule/Get-O365CalendarPermissions/)                                     |
| Exchange | [Get-O365MailboxPermissions](/_posts/UserAdminModule/Get-O365MailboxPermissions/)                                       |
| Exchange | [Get-O365SharedMailboxPermissions](/_posts/UserAdminModule/Get-O365SharedMailboxPermissions/)                           |
| Exchange | [Get-OOHMessage](/_posts/UserAdminModule/Get-OOHMessage/)                                                               |
| Exchange | [Get-OrphanedDistributionGroups](/_posts/UserAdminModule/Get-OrphanedDistributionGroups/)                               |
| Exchange | [Get-QuarantinedEmailMessages](/_posts/UserAdminModule/Get-QuarantinedEmailMessages/)                                   |
| Exchange | [Get-UsersCalendarAccess](/_posts/UserAdminModule/Get-UsersCalendarAccess/)                                             |
| Exchange | [New-DynamicListFromAttribute](/_posts/UserAdminModule/New-DynamicListFromAttribute/)                                   |
| Exchange | [New-ExchangeDistributionGroup](/_posts/UserAdminModule/New-ExchangeDistributionGroup/)                                 |
| Exchange | [New-MailContactObject](/_posts/UserAdminModule/New-MailContactObject/)                                                 |
| Exchange | [New-O365Contact](/_posts/UserAdminModule/New-O365Contact/)                                                             |
| Exchange | [New-OOHMessage](/_posts/UserAdminModule/New-OOHMessage/)                                                               |
| Exchange | [O365Session](/_posts/UserAdminModule/O365Session/)                                                                     |
| Exchange | [OnPremExchangeFunctions](/_posts/UserAdminModule/OnPremExchangeFunctions/)                                             |
| Exchange | [PasswordChangeNotification](/_posts/UserAdminModule/PasswordChangeNotification/)                                       |
| Exchange | [PasswordReminderAlso](/_posts/UserAdminModule/PasswordReminderAlso/)                                                   |
| Exchange | [Preview-QuarantinedEmailMessage](/_posts/UserAdminModule/Preview-QuarantinedEmailMessage/)                             |
| Exchange | [Remove-MailboxFolderPermissions](/_posts/UserAdminModule/Remove-MailboxFolderPermissions/)                             |
| Exchange | [Remove-UsersfromGAL](/_posts/UserAdminModule/Remove-UsersfromGAL/)                                                     |
| Exchange | [Repair-MissingOnPremMailbox](/_posts/UserAdminModule/Repair-MissingOnPremMailbox/)                                     |
| Exchange | [Restart-ExchangeServices](/_posts/UserAdminModule/Restart-ExchangeServices/)                                           |
| Exchange | [Send-OutlookMail](/_posts/UserAdminModule/Send-OutlookMail/)                                                           |
| Exchange | [Set-AutoDiscover](/_posts/UserAdminModule/Set-AutoDiscover/)                                                           |
| Exchange | [Set-CalendarPermsScript](/_posts/UserAdminModule/Set-CalendarPermsScript/)                                             |
| Exchange | [Set-DefaultReceiveConnector](/_posts/UserAdminModule/Set-DefaultReceiveConnector/)                                     |
| Exchange | [Set-DistributionGroupProperties](/_posts/UserAdminModule/Set-DistributionGroupProperties/)                             |
| Exchange | [Set-MailContactDetails](/_posts/UserAdminModule/Set-MailContactDetails/)                                               |
| Exchange | [Set-MailContactDetailsOnline](/_posts/UserAdminModule/Set-MailContactDetailsOnline/)                                   |
| Exchange | [Set-O365CalendarPermissions](/_posts/UserAdminModule/Set-O365CalendarPermissions/)                                     |
| Exchange | [Set-O365MailboxPermissions](/_posts/UserAdminModule/Set-O365MailboxPermissions/)                                       |
| Exchange | [Set-OOHmessage](/_posts/UserAdminModule/Set-OOHmessage/)                                                               |
| Exchange | [Unblock-QuarantineMessage](/_posts/UserAdminModule/Unblock-QuarantineMessage/)                                         |
| Exchange | [Update-CalendarPermissions](/_posts/UserAdminModule/Update-CalendarPermissions/)                                       |
| Exchange | [Update-DistributionGroupOwner](/_posts/UserAdminModule/Update-DistributionGroupOwner/)                                 |
| Exchange | [Update-DistributionList](/_posts/UserAdminModule/Update-DistributionList/)                                             |
| Exchange | [Update-MailContactDomain](/_posts/UserAdminModule/Update-MailContactDomain/)                                           |
| Exchange | [Update-MailContactProperties](/_posts/UserAdminModule/Update-MailContactProperties/)                                   |
| Exchange | [Update-O365CalendarPermissions](/_posts/UserAdminModule/Update-O365CalendarPermissions/)                               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## FileOperations

| Category       | Function                                                                                            |
| :------------- | :-------------------------------------------------------------------------------------------------- |
| FileOperations | [Convert-DnsZoneFile](/_posts/UserAdminModule/Convert-DnsZoneFile/)                                 |
| FileOperations | [Convert-FilenameToGUID](/_posts/UserAdminModule/Convert-FilenameToGUID/)                           |
| FileOperations | [Copy-FilestoComputer](/_posts/UserAdminModule/Copy-FilestoComputer/)                               |
| FileOperations | [Copy-FilestoRemote](/_posts/UserAdminModule/Copy-FilestoRemote/)                                   |
| FileOperations | [createRandomFilesFunctions](/_posts/UserAdminModule/createRandomFilesFunctions/)                   |
| FileOperations | [Expand-NinjaOne7Zip](/_posts/UserAdminModule/Expand-NinjaOne7Zip/)                                 |
| FileOperations | [Expand-NinjaOneZip](/_posts/UserAdminModule/Expand-NinjaOneZip/)                                   |
| FileOperations | [Format-FileSize](/_posts/UserAdminModule/Format-FileSize/)                                         |
| FileOperations | [Get-FileAndFolderPermissions](/_posts/UserAdminModule/Get-FileAndFolderPermissions/)               |
| FileOperations | [Get-FileOwner](/_posts/UserAdminModule/Get-FileOwner/)                                             |
| FileOperations | [Get-IniContent](/_posts/UserAdminModule/Get-IniContent/)                                           |
| FileOperations | [Get-LatestFiles](/_posts/UserAdminModule/Get-LatestFiles/)                                         |
| FileOperations | [Get-MediaDetails](/_posts/UserAdminModule/Get-MediaDetails/)                                       |
| FileOperations | [Get-NeglectedFiles](/_posts/UserAdminModule/Get-NeglectedFiles/)                                   |
| FileOperations | [Get-OldFiles](/_posts/UserAdminModule/Get-OldFiles/)                                               |
| FileOperations | [Get-PathPermissions](/_posts/UserAdminModule/Get-PathPermissions/)                                 |
| FileOperations | [Invoke-RemoteZipExpansion](/_posts/UserAdminModule/Invoke-RemoteZipExpansion/)                     |
| FileOperations | [Merge-Files](/_posts/UserAdminModule/Merge-Files/)                                                 |
| FileOperations | [New-DummyFile](/_posts/UserAdminModule/New-DummyFile/)                                             |
| FileOperations | [New-DummyFiles](/_posts/UserAdminModule/New-DummyFiles/)                                           |
| FileOperations | [New-FileArchive](/_posts/UserAdminModule/New-FileArchive/)                                         |
| FileOperations | [New-FileofSize](/_posts/UserAdminModule/New-FileofSize/)                                           |
| FileOperations | [New-FileReport](/_posts/UserAdminModule/New-FileReport/)                                           |
| FileOperations | [New-FolderCompare](/_posts/UserAdminModule/New-FolderCompare/)                                     |
| FileOperations | [New-PSDriveRootFolder](/_posts/UserAdminModule/New-PSDriveRootFolder/)                             |
| FileOperations | [New-Shortcut](/_posts/UserAdminModule/New-Shortcut/)                                               |
| FileOperations | [New-ZipFile](/_posts/UserAdminModule/New-ZipFile/)                                                 |
| FileOperations | [parse_NTFS](/_posts/UserAdminModule/parse_NTFS/)                                                   |
| FileOperations | [Randomize-FilesIntoSubfolders](/_posts/UserAdminModule/Randomize-FilesIntoSubfolders/)             |
| FileOperations | [Register-FileSystemWatcher](/_posts/UserAdminModule/Register-FileSystemWatcher/)                   |
| FileOperations | [Remove-DummyFiles](/_posts/UserAdminModule/Remove-DummyFiles/)                                     |
| FileOperations | [Remove-EmptyFolders](/_posts/UserAdminModule/Remove-EmptyFolders/)                                 |
| FileOperations | [Remove-Files](/_posts/UserAdminModule/Remove-Files/)                                               |
| FileOperations | [Remove-FoldersWithoutSpecifiedFiles](/_posts/UserAdminModule/Remove-FoldersWithoutSpecifiedFiles/) |
| FileOperations | [Reorganize-FilesByType](/_posts/UserAdminModule/Reorganize-FilesByType/)                           |
| FileOperations | [Save-PasswordFile](/_posts/UserAdminModule/Save-PasswordFile/)                                     |
| FileOperations | [Search-ForFiles](/_posts/UserAdminModule/Search-ForFiles/)                                         |
| FileOperations | [search-scripts](/_posts/UserAdminModule/search-scripts/)                                           |
| FileOperations | [Search-Scripts](/_posts/UserAdminModule/Search-Scripts/)                                           |
| FileOperations | [Show-PSDrive](/_posts/UserAdminModule/Show-PSDrive/)                                               |
| FileOperations | [Start-DownloadFileToTemp](/_posts/UserAdminModule/Start-DownloadFileToTemp/)                       |
| FileOperations | [Unblock-AndUnzipFiles](/_posts/UserAdminModule/Unblock-AndUnzipFiles/)                             |
| FileOperations | [UncompressZip-SameDestination](/_posts/UserAdminModule/UncompressZip-SameDestination/)             |
| FileOperations | [zipArchiveTool_recursive](/_posts/UserAdminModule/zipArchiveTool_recursive/)                       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## JekyllBlog

| Category   | Function                                                                    |
| :--------- | :-------------------------------------------------------------------------- |
| JekyllBlog | [Get-GistIframe](/_posts/UserAdminModule/Get-GistIframe/)                   |
| JekyllBlog | [New-BlogServer](/_posts/UserAdminModule/New-BlogServer/)                   |
| JekyllBlog | [New-JekyllBlogPost](/_posts/UserAdminModule/New-JekyllBlogPost/)           |
| JekyllBlog | [New-JekyllBlogServer](/_posts/UserAdminModule/New-JekyllBlogServer/)       |
| JekyllBlog | [New-JekyllBlogSession](/_posts/UserAdminModule/New-JekyllBlogSession/)     |
| JekyllBlog | [Remove-JekyllBlogServer](/_posts/UserAdminModule/Remove-JekyllBlogServer/) |
| JekyllBlog | [Show-JekyllBlogSite](/_posts/UserAdminModule/Show-JekyllBlogSite/)         |
| JekyllBlog | [Start-JekyllBlogging](/_posts/UserAdminModule/Start-JekyllBlogging/)       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Logging

| Category | Function                                                                    |
| :------- | :-------------------------------------------------------------------------- |
| Logging  | [Get-EventLogs](/_posts/UserAdminModule/Get-EventLogs/)                     |
| Logging  | [Get-EventsFromTimeframe](/_posts/UserAdminModule/Get-EventsFromTimeframe/) |
| Logging  | [Get-FilteredEvents](/_posts/UserAdminModule/Get-FilteredEvents/)           |
| Logging  | [Get-SystemEvent](/_posts/UserAdminModule/Get-SystemEvent/)                 |
| Logging  | [Get-WmiADEvent](/_posts/UserAdminModule/Get-WmiADEvent/)                   |
| Logging  | [Initialize-EventLogging](/_posts/UserAdminModule/Initialize-EventLogging/) |
| Logging  | [Log-Event](/_posts/UserAdminModule/Log-Event/)                             |
| Logging  | [New-LogEvent](/_posts/UserAdminModule/New-LogEvent/)                       |
| Logging  | [Script4logging](/_posts/UserAdminModule/Script4logging/)                   |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## MediaManagement

| Category        | Function                                                                                        |
| :-------------- | :---------------------------------------------------------------------------------------------- |
| MediaManagement | [Create-VLCPlaylists](/_posts/UserAdminModule/Create-VLCPlaylists/)                             |
| MediaManagement | [FFMpeg-Install](/_posts/UserAdminModule/FFMpeg-Install/)                                       |
| MediaManagement | [Get-FFProbeAudioStreams](/_posts/UserAdminModule/Get-FFProbeAudioStreams/)                     |
| MediaManagement | [Get-FFProbeVideoInfo](/_posts/UserAdminModule/Get-FFProbeVideoInfo/)                           |
| MediaManagement | [Find-Movies](/_posts/UserAdminModule/Find-Movies/)                                             |
| MediaManagement | [Remove-FFMpegVideoFileAudioStream](/_posts/UserAdminModule/Remove-FFMpegVideoFileAudioStream/) |
| MediaManagement | [Set-FFMpegVideoSpeed](/_posts/UserAdminModule/Set-FFMpegVideoSpeed/)                           |
| MediaManagement | [Set-TransmissionDefaultSettings](/_posts/UserAdminModule/Set-TransmissionDefaultSettings/)     |
| MediaManagement | [Start-Stream](/_posts/UserAdminModule/Start-Stream/)                                           |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Network

| Category | Function                                                                |
| :------- | :---------------------------------------------------------------------- |
| Network  | [Get-CidrIPRange](/_posts/UserAdminModule/Get-CidrIPRange/)             |
| Network  | [Get-ComputerIP](/_posts/UserAdminModule/Get-ComputerIP/)               |
| Network  | [Get-DKIMRecord](/_posts/UserAdminModule/Get-DKIMRecord/)               |
| Network  | [Get-DMARCRecord](/_posts/UserAdminModule/Get-DMARCRecord/)             |
| Network  | [Get-FTPFile-empty](/_posts/UserAdminModule/Get-FTPFile-empty/)         |
| Network  | [Get-HostIOResults](/_posts/UserAdminModule/Get-HostIOResults/)         |
| Network  | [Get-IPConfig](/_posts/UserAdminModule/Get-IPConfig/)                   |
| Network  | [Get-ipInfo](/_posts/UserAdminModule/Get-ipInfo/)                       |
| Network  | [Get-MullvadApiDetails](/_posts/UserAdminModule/Get-MullvadApiDetails/) |
| Network  | [Get-PingMonitor](/_posts/UserAdminModule/Get-PingMonitor/)             |
| Network  | [Get-PortInfo](/_posts/UserAdminModule/Get-PortInfo/)                   |
| Network  | [Get-PortService](/_posts/UserAdminModule/Get-PortService/)             |
| Network  | [Get-PublicDnsRecord](/_posts/UserAdminModule/Get-PublicDnsRecord/)     |
| Network  | [Get-RemoteIPSettings](/_posts/UserAdminModule/Get-RemoteIPSettings/)   |
| Network  | [Get-RemoteServerPorts](/_posts/UserAdminModule/Get-RemoteServerPorts/) |
| Network  | [Get-ServerIPInfo](/_posts/UserAdminModule/Get-ServerIPInfo/)           |
| Network  | [Get-SPFRecord](/_posts/UserAdminModule/Get-SPFRecord/)                 |
| Network  | [Get-WhoIsInformation](/_posts/UserAdminModule/Get-WhoIsInformation/)   |
| Network  | [Get-WTFismyIP](/_posts/UserAdminModule/Get-WTFismyIP/)                 |
| Network  | [Invoke-FTPUpload](/_posts/UserAdminModule/Invoke-FTPUpload/)           |
| Network  | [Resolve-DnsDomain](/_posts/UserAdminModule/Resolve-DnsDomain/)         |
| Network  | [Resolve-DNSList](/_posts/UserAdminModule/Resolve-DNSList/)             |
| Network  | [Resolve-DomainDNS](/_posts/UserAdminModule/Resolve-DomainDNS/)         |
| Network  | [Send-MagicPacket](/_posts/UserAdminModule/Send-MagicPacket/)           |
| Network  | [Set-DHCPIPAddress](/_posts/UserAdminModule/Set-DHCPIPAddress/)         |
| Network  | [Set-GoogleDynamicDNS](/_posts/UserAdminModule/Set-GoogleDynamicDNS/)   |
| Network  | [Set-StaticIPAddress](/_posts/UserAdminModule/Set-StaticIPAddress/)     |
| Network  | [Set-WMIPermissions](/_posts/UserAdminModule/Set-WMIPermissions/)       |
| Network  | [Switch-VpnFailover](/_posts/UserAdminModule/Switch-VpnFailover/)       |
| Network  | [Switch-VpnFailoverMac](/_posts/UserAdminModule/Switch-VpnFailoverMac/) |
| Network  | [Test-DNSPropagation](/_posts/UserAdminModule/Test-DNSPropagation/)     |
| Network  | [Update-CloudflareDDNS](/_posts/UserAdminModule/Update-CloudflareDDNS/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PKICertificateTools

| Category            | Function                                                                                                        |
| :------------------ | :-------------------------------------------------------------------------------------------------------------- |
| PKICertificateTools | [Backup-CAServer](/_posts/UserAdminModule/Backup-CAServer/)                                                     |
| PKICertificateTools | [Backup-CertificateServicesDatabase](/_posts/UserAdminModule/Backup-CertificateServicesDatabase/)               |
| PKICertificateTools | [Decommission-CA](/_posts/UserAdminModule/Decommission-CA/)                                                     |
| PKICertificateTools | [Export-CRL](/_posts/UserAdminModule/Export-CRL/)                                                               |
| PKICertificateTools | [Find-CertificateByTemplate](/_posts/UserAdminModule/Find-CertificateByTemplate/)                               |
| PKICertificateTools | [Get-ADCertificates](/_posts/UserAdminModule/Get-ADCertificates/)                                               |
| PKICertificateTools | [Get-AdCertificateTemplate](/_posts/UserAdminModule/Get-AdCertificateTemplate/)                                 |
| PKICertificateTools | [Get-AllPKICertificates](/_posts/UserAdminModule/Get-AllPKICertificates/)                                       |
| PKICertificateTools | [Get-CACertificateInfo](/_posts/UserAdminModule/Get-CACertificateInfo/)                                         |
| PKICertificateTools | [Get-Oid](/_posts/UserAdminModule/Get-Oid/)                                                                     |
| PKICertificateTools | [Get-PKICertificate](/_posts/UserAdminModule/Get-PKICertificate/)                                               |
| PKICertificateTools | [Get-PKICertificates](/_posts/UserAdminModule/Get-PKICertificates/)                                             |
| PKICertificateTools | [Get-PublishedTemplate](/_posts/UserAdminModule/Get-PublishedTemplate/)                                         |
| PKICertificateTools | [Get-RDGCAIssuedCert](/_posts/UserAdminModule/Get-RDGCAIssuedCert/)                                             |
| PKICertificateTools | [Get-RDGCARequestPending](/_posts/UserAdminModule/Get-RDGCARequestPending/)                                     |
| PKICertificateTools | [Get-Sid](/_posts/UserAdminModule/Get-Sid/)                                                                     |
| PKICertificateTools | [Move-CertificateServicesDatabase](/_posts/UserAdminModule/Move-CertificateServicesDatabase/)                   |
| PKICertificateTools | [Optimize-DomainControllerTlsConfiguration](/_posts/UserAdminModule/Optimize-DomainControllerTlsConfiguration/) |
| PKICertificateTools | [Publish-NewCRL](/_posts/UserAdminModule/Publish-NewCRL/)                                                       |
| PKICertificateTools | [Remove-ADCSArtifacts](/_posts/UserAdminModule/Remove-ADCSArtifacts/)                                           |
| PKICertificateTools | [Remove-CAFromNTAuth](/_posts/UserAdminModule/Remove-CAFromNTAuth/)                                             |
| PKICertificateTools | [Remove-CAKeys](/_posts/UserAdminModule/Remove-CAKeys/)                                                         |
| PKICertificateTools | [Remove-CASolution](/_posts/UserAdminModule/Remove-CASolution/)                                                 |
| PKICertificateTools | [Remove-CertLogDatabase](/_posts/UserAdminModule/Remove-CertLogDatabase/)                                       |
| PKICertificateTools | [Remove-ExpiredCertificate](/_posts/UserAdminModule/Remove-ExpiredCertificate/)                                 |
| PKICertificateTools | [Revoke-AllValidCerts](/_posts/UserAdminModule/Revoke-AllValidCerts/)                                           |
| PKICertificateTools | [Revoke-CACertificate](/_posts/UserAdminModule/Revoke-CACertificate/)                                           |
| PKICertificateTools | [Show-CertificateTemplateInformation](/_posts/UserAdminModule/Show-CertificateTemplateInformation/)             |
| PKICertificateTools | [Write-CAActivityLog](/_posts/UserAdminModule/Write-CAActivityLog/)                                             |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PrintManagement

| Category        | Function                                                              |
| :-------------- | :-------------------------------------------------------------------- |
| PrintManagement | [Disable-PrintSpooler](/_posts/UserAdminModule/Disable-PrintSpooler/) |
| PrintManagement | [Enable-PrintSpooler](/_posts/UserAdminModule/Enable-PrintSpooler/)   |
| PrintManagement | [Get-PrintSpooler](/_posts/UserAdminModule/Get-PrintSpooler/)         |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ProcessServiceSchedules

| Category                | Function                                                                            |
| :---------------------- | :---------------------------------------------------------------------------------- |
| ProcessServiceSchedules | [Get-AllScheduledScripts](/_posts/UserAdminModule/Get-AllScheduledScripts/)         |
| ProcessServiceSchedules | [Get-ProcessandServicePID](/_posts/UserAdminModule/Get-ProcessandServicePID/)       |
| ProcessServiceSchedules | [Get-ProcessStatus](/_posts/UserAdminModule/Get-ProcessStatus/)                     |
| ProcessServiceSchedules | [Get-RemoteScheduledTasks](/_posts/UserAdminModule/Get-RemoteScheduledTasks/)       |
| ProcessServiceSchedules | [Get-ScheduledScripts](/_posts/UserAdminModule/Get-ScheduledScripts/)               |
| ProcessServiceSchedules | [Get-ScheduledTasks](/_posts/UserAdminModule/Get-ScheduledTasks/)                   |
| ProcessServiceSchedules | [Get-ServiceStatus](/_posts/UserAdminModule/Get-ServiceStatus/)                     |
| ProcessServiceSchedules | [New-ScheduledScript](/_posts/UserAdminModule/New-ScheduledScript/)                 |
| ProcessServiceSchedules | [New-ScheduledTask](/_posts/UserAdminModule/New-ScheduledTask/)                     |
| ProcessServiceSchedules | [Remove-ScheduledScript](/_posts/UserAdminModule/Remove-ScheduledScript/)           |
| ProcessServiceSchedules | [Restart-NinjaRMMService](/_posts/UserAdminModule/Restart-NinjaRMMService/)         |
| ProcessServiceSchedules | [Restart-PrintSpooler](/_posts/UserAdminModule/Restart-PrintSpooler/)               |
| ProcessServiceSchedules | [Set-PrintSpoolerConfig](/_posts/UserAdminModule/Set-PrintSpoolerConfig/)           |
| ProcessServiceSchedules | [Set-ServiceConfig](/_posts/UserAdminModule/Set-ServiceConfig/)                     |
| ProcessServiceSchedules | [Start-BullwallServices](/_posts/UserAdminModule/Start-BullwallServices/)           |
| ProcessServiceSchedules | [Start-Outlook](/_posts/UserAdminModule/Start-Outlook/)                             |
| ProcessServiceSchedules | [Start-ProcessOnComputer](/_posts/UserAdminModule/Start-ProcessOnComputer/)         |
| ProcessServiceSchedules | [Start-ScheduledScript](/_posts/UserAdminModule/Start-ScheduledScript/)             |
| ProcessServiceSchedules | [Start-ServicesInOrder](/_posts/UserAdminModule/Start-ServicesInOrder/)             |
| ProcessServiceSchedules | [Stop-FailedService](/_posts/UserAdminModule/Stop-FailedService/)                   |
| ProcessServiceSchedules | [Stop-NonRespondingProcesses](/_posts/UserAdminModule/Stop-NonRespondingProcesses/) |
| ProcessServiceSchedules | [Stop-ProcessOnComputer](/_posts/UserAdminModule/Stop-ProcessOnComputer/)           |
| ProcessServiceSchedules | [Stop-ScheduledScript](/_posts/UserAdminModule/Stop-ScheduledScript/)               |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## RemoteConnections

| Category          | Function                                                                      |
| :---------------- | :---------------------------------------------------------------------------- |
| RemoteConnections | [Connect-CmRcViewer](/_posts/UserAdminModule/Connect-CmRcViewer/)             |
| RemoteConnections | [Connect-InternalPRTG](/_posts/UserAdminModule/Connect-InternalPRTG/)         |
| RemoteConnections | [Connect-Mstsc](/_posts/UserAdminModule/Connect-Mstsc/)                       |
| RemoteConnections | [Connect-PSExec](/_posts/UserAdminModule/Connect-PSExec/)                     |
| RemoteConnections | [Connect-PSExecPowershell](/_posts/UserAdminModule/Connect-PSExecPowershell/) |
| RemoteConnections | [Connect-RemoteAssistance](/_posts/UserAdminModule/Connect-RemoteAssistance/) |
| RemoteConnections | [Disable-RDPRemotely](/_posts/UserAdminModule/Disable-RDPRemotely/)           |
| RemoteConnections | [Enable-RDPRemotely](/_posts/UserAdminModule/Enable-RDPRemotely/)             |
| RemoteConnections | [Enable-RemoteDesktop](/_posts/UserAdminModule/Enable-RemoteDesktop/)         |
| RemoteConnections | [Get-LoggedOnRDPUser](/_posts/UserAdminModule/Get-LoggedOnRDPUser/)           |
| RemoteConnections | [Get-RDPStatus](/_posts/UserAdminModule/Get-RDPStatus/)                       |
| RemoteConnections | [Get-RDPUserReport](/_posts/UserAdminModule/Get-RDPUserReport/)               |
| RemoteConnections | [Remove-RDPUserSession](/_posts/UserAdminModule/Remove-RDPUserSession/)       |
| RemoteConnections | [Set-RDPRemotely](/_posts/UserAdminModule/Set-RDPRemotely/)                   |
| RemoteConnections | [Set-RDPStatus](/_posts/UserAdminModule/Set-RDPStatus/)                       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Replication

| Category    | Function                                                                                |
| :---------- | :-------------------------------------------------------------------------------------- |
| Replication | [Get-ComputerReplicationStatus](/_posts/UserAdminModule/Get-ComputerReplicationStatus/) |
| Replication | [Get-DCDIAGResults](/_posts/UserAdminModule/Get-DCDIAGResults/)                         |
| Replication | [Get-SysvolReplicationInfo](/_posts/UserAdminModule/Get-SysvolReplicationInfo/)         |
| Replication | [Get-UserReplicationStatus](/_posts/UserAdminModule/Get-UserReplicationStatus/)         |
| Replication | [New-SecurePassword](/_posts/UserAdminModule/New-SecurePassword/)                       |
| Replication | [Sync-ADwithAAD](/_posts/UserAdminModule/Sync-ADwithAAD/)                               |
| Replication | [Sync-DomainController](/_posts/UserAdminModule/Sync-DomainController/)                 |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Security

| Category | Function                                                                                        |
| :------- | :---------------------------------------------------------------------------------------------- |
| Security | [Disable-CiscoSecure](/_posts/UserAdminModule/Disable-CiscoSecure/)                             |
| Security | [Enable-CiscoSecure](/_posts/UserAdminModule/Enable-CiscoSecure/)                               |
| Security | [Export-Bitlocker](/_posts/UserAdminModule/Export-Bitlocker/)                                   |
| Security | [Export-BitlockerComp](/_posts/UserAdminModule/Export-BitlockerComp/)                           |
| Security | [Export-BitlockerParams](/_posts/UserAdminModule/Export-BitlockerParams/)                       |
| Security | [Get-CimNamespacePermissions](/_posts/UserAdminModule/Get-CimNamespacePermissions/)             |
| Security | [Get-CimNamespacePermissionsRemote](/_posts/UserAdminModule/Get-CimNamespacePermissionsRemote/) |
| Security | [Get-CimPermsLocal](/_posts/UserAdminModule/Get-CimPermsLocal/)                                 |
| Security | [Get-InsecureLDAPBinds](/_posts/UserAdminModule/Get-InsecureLDAPBinds/)                         |
| Security | [Get-NameSpacePerms](/_posts/UserAdminModule/Get-NameSpacePerms/)                               |
| Security | [Get-Namespaces](/_posts/UserAdminModule/Get-Namespaces/)                                       |
| Security | [Get-PasswordAttempts](/_posts/UserAdminModule/Get-PasswordAttempts/)                           |
| Security | [Get-PasswordAttempts2](/_posts/UserAdminModule/Get-PasswordAttempts2/)                         |
| Security | [Get-ProductKey](/_posts/UserAdminModule/Get-ProductKey/)                                       |
| Security | [Get-PSGalleryItemsForAuthor](/_posts/UserAdminModule/Get-PSGalleryItemsForAuthor/)             |
| Security | [Get-SettingsWithCPassword](/_posts/UserAdminModule/Get-SettingsWithCPassword/)                 |
| Security | [Get-SSLlabsScore](/_posts/UserAdminModule/Get-SSLlabsScore/)                                   |
| Security | [Get-UnknownDevices](/_posts/UserAdminModule/Get-UnknownDevices/)                               |
| Security | [Get-VpnFailoverEventLogs](/_posts/UserAdminModule/Get-VpnFailoverEventLogs/)                   |
| Security | [Invoke-CiscoSecureManagement](/_posts/UserAdminModule/Invoke-CiscoSecureManagement/)           |
| Security | [Invoke-PasswordifyPhrase](/_posts/UserAdminModule/Invoke-PasswordifyPhrase/)                   |
| Security | [Invoke-PasswordRoll](/_posts/UserAdminModule/Invoke-PasswordRoll/)                             |
| Security | [Invoke-UrlScan](/_posts/UserAdminModule/Invoke-UrlScan/)                                       |
| Security | [New-DynamicParameter](/_posts/UserAdminModule/New-DynamicParameter/)                           |
| Security | [New-PassPhrase](/_posts/UserAdminModule/New-PassPhrase/)                                       |
| Security | [New-Password](/_posts/UserAdminModule/New-Password/)                                           |
| Security | [PasswordFunctions](/_posts/UserAdminModule/PasswordFunctions/)                                 |
| Security | [ScreenPassword](/_posts/UserAdminModule/ScreenPassword/)                                       |
| Security | [Set-CIMPermissions](/_posts/UserAdminModule/Set-CIMPermissions/)                               |
| Security | [Set-LDAPSBinding](/_posts/UserAdminModule/Set-LDAPSBinding/)                                   |
| Security | [Update-SSLCertificate](/_posts/UserAdminModule/Update-SSLCertificate/)                         |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Shell

| Category | Function                                                                                              |
| :------- | :---------------------------------------------------------------------------------------------------- |
| Shell    | [Check-BirthdayCountdown](/_posts/UserAdminModule/Check-BirthdayCountdown/)                           |
| Shell    | [Convert-TimeUnit](/_posts/UserAdminModule/Convert-TimeUnit/)                                         |
| Shell    | [Copy-History](/_posts/UserAdminModule/Copy-History/)                                                 |
| Shell    | [Get-BankHolidays](/_posts/UserAdminModule/Get-BankHolidays/)                                         |
| Shell    | [Get-ConsoleConfig](/_posts/UserAdminModule/Get-ConsoleConfig/)                                       |
| Shell    | [Get-DayOfWeek](/_posts/UserAdminModule/Get-DayOfWeek/)                                               |
| Shell    | [Get-DSTInfo](/_posts/UserAdminModule/Get-DSTInfo/)                                                   |
| Shell    | [Get-ExportedFunction](/_posts/UserAdminModule/Get-ExportedFunction/)                                 |
| Shell    | [Get-FriendlySize](/_posts/UserAdminModule/Get-FriendlySize/)                                         |
| Shell    | [Get-Icon](/_posts/UserAdminModule/Get-Icon/)                                                         |
| Shell    | [Get-LastBootTime](/_posts/UserAdminModule/Get-LastBootTime/)                                         |
| Shell    | [Get-LastCommands](/_posts/UserAdminModule/Get-LastCommands/)                                         |
| Shell    | [Get-LastRebootEvent](/_posts/UserAdminModule/Get-LastRebootEvent/)                                   |
| Shell    | [Get-LastxOfMonth](/_posts/UserAdminModule/Get-LastxOfMonth/)                                         |
| Shell    | [Get-LoadedFunctions](/_posts/UserAdminModule/Get-LoadedFunctions/)                                   |
| Shell    | [Get-LocationStack](/_posts/UserAdminModule/Get-LocationStack/)                                       |
| Shell    | [Get-MonthOfYear](/_posts/UserAdminModule/Get-MonthOfYear/)                                           |
| Shell    | [Get-MoreCowbell](/_posts/UserAdminModule/Get-MoreCowbell/)                                           |
| Shell    | [Get-MyHistory](/_posts/UserAdminModule/Get-MyHistory/)                                               |
| Shell    | [Get-MyIpWtf](/_posts/UserAdminModule/Get-MyIpWtf/)                                                   |
| Shell    | [Get-NextPayDay](/_posts/UserAdminModule/Get-NextPayDay/)                                             |
| Shell    | [Get-OutlookAppointments](/_posts/UserAdminModule/Get-OutlookAppointments/)                           |
| Shell    | [Get-PatchTue](/_posts/UserAdminModule/Get-PatchTue/)                                                 |
| Shell    | [Get-PayDay](/_posts/UserAdminModule/Get-PayDay/)                                                     |
| Shell    | [Get-RageQuitEvents](/_posts/UserAdminModule/Get-RageQuitEvents/)                                     |
| Shell    | [GitHubCopilotAlias](/_posts/UserAdminModule/GitHubCopilotAlias/)                                     |
| Shell    | [HomePowerShell_profile](/_posts/UserAdminModule/HomePowerShell_profile/)                             |
| Shell    | [Initialize-Module](/_posts/UserAdminModule/Initialize-Module/)                                       |
| Shell    | [Install-LatestPWSH7](/_posts/UserAdminModule/Install-LatestPWSH7/)                                   |
| Shell    | [Install-ModuleIfNotPresent](/_posts/UserAdminModule/Install-ModuleIfNotPresent/)                     |
| Shell    | [Install-PSTools](/_posts/UserAdminModule/Install-PSTools/)                                           |
| Shell    | [Install-RequiredModules](/_posts/UserAdminModule/Install-RequiredModules/)                           |
| Shell    | [Install-WinGet](/_posts/UserAdminModule/Install-WinGet/)                                             |
| Shell    | [IsAdmin](/_posts/UserAdminModule/IsAdmin/)                                                           |
| Shell    | [Lock-Screen](/_posts/UserAdminModule/Lock-Screen/)                                                   |
| Shell    | [Lock-UserInput](/_posts/UserAdminModule/Lock-UserInput/)                                             |
| Shell    | [Microsoft.PowerShell_profile](/_posts/UserAdminModule/Microsoft.PowerShell_profile/)                 |
| Shell    | [Microsoft.PowerShell_profile_example](/_posts/UserAdminModule/Microsoft.PowerShell_profile_example/) |
| Shell    | [New-AdminShell](/_posts/UserAdminModule/New-AdminShell/)                                             |
| Shell    | [New-CopilotPrompt](/_posts/UserAdminModule/New-CopilotPrompt/)                                       |
| Shell    | [New-CountdownDate](/_posts/UserAdminModule/New-CountdownDate/)                                       |
| Shell    | [New-Greeting](/_posts/UserAdminModule/New-Greeting/)                                                 |
| Shell    | [New-PSM1Module](/_posts/UserAdminModule/New-PSM1Module/)                                             |
| Shell    | [New-QotD](/_posts/UserAdminModule/New-QotD/)                                                         |
| Shell    | [New-Shell](/_posts/UserAdminModule/New-Shell/)                                                       |
| Shell    | [New-StreamDeckShell](/_posts/UserAdminModule/New-StreamDeckShell/)                                   |
| Shell    | [PersonalModules](/_posts/UserAdminModule/PersonalModules/)                                           |
| Shell    | [RageQuit](/_posts/UserAdminModule/RageQuit/)                                                         |
| Shell    | [Restart-PowershellProfile](/_posts/UserAdminModule/Restart-PowershellProfile/)                       |
| Shell    | [Restart-Profile](/_posts/UserAdminModule/Restart-Profile/)                                           |
| Shell    | [Restore-Location](/_posts/UserAdminModule/Restore-Location/)                                         |
| Shell    | [Search-Google](/_posts/UserAdminModule/Search-Google/)                                               |
| Shell    | [Select-FolderLocation](/_posts/UserAdminModule/Select-FolderLocation/)                               |
| Shell    | [Set-ConsoleConfig](/_posts/UserAdminModule/Set-ConsoleConfig/)                                       |
| Shell    | [Set-DisplayIsAdmin](/_posts/UserAdminModule/Set-DisplayIsAdmin/)                                     |
| Shell    | [Set-Home](/_posts/UserAdminModule/Set-Home/)                                                         |
| Shell    | [Set-PromptisAdmin](/_posts/UserAdminModule/Set-PromptisAdmin/)                                       |
| Shell    | [Show-IsAdminOrNot](/_posts/UserAdminModule/Show-IsAdminOrNot/)                                       |
| Shell    | [Show-Notification](/_posts/UserAdminModule/Show-Notification/)                                       |
| Shell    | [Show-RandomCommand](/_posts/UserAdminModule/Show-RandomCommand/)                                     |
| Shell    | [Show-RandomHelpAbout](/_posts/UserAdminModule/Show-RandomHelpAbout/)                                 |
| Shell    | [Start-PSCountdown](/_posts/UserAdminModule/Start-PSCountdown/)                                       |
| Shell    | [Stop-Outlook](/_posts/UserAdminModule/Stop-Outlook/)                                                 |
| Shell    | [Update-PowerShell](/_posts/UserAdminModule/Update-PowerShell/)                                       |
| Shell    | [WorkPowerShell_profile](/_posts/UserAdminModule/WorkPowerShell_profile/)                             |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ShutdownCommands

| Category         | Function                                                                                              |
| :--------------- | :---------------------------------------------------------------------------------------------------- |
| ShutdownCommands | [Get-RemoteComputerScheduledShutdown](/_posts/UserAdminModule/Get-RemoteComputerScheduledShutdown/)   |
| ShutdownCommands | [Get-ShutdownExample](/_posts/UserAdminModule/Get-ShutdownExample/)                                   |
| ShutdownCommands | [Invoke-RemoteComputerShutdown](/_posts/UserAdminModule/Invoke-RemoteComputerShutdown/)               |
| ShutdownCommands | [New-PowerOutage](/_posts/UserAdminModule/New-PowerOutage/)                                           |
| ShutdownCommands | [Schedule-Shutdown](/_posts/UserAdminModule/Schedule-Shutdown/)                                       |
| ShutdownCommands | [Start-RemoteComputerShutdownSchedule](/_posts/UserAdminModule/Start-RemoteComputerShutdownSchedule/) |
| ShutdownCommands | [Stop-RemoteComputerShutdown](/_posts/UserAdminModule/Stop-RemoteComputerShutdown/)                   |
| ShutdownCommands | [Wait-RemoteComputerShutdown](/_posts/UserAdminModule/Wait-RemoteComputerShutdown/)                   |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Teams

| Category | Function                                                                                        |
| :------- | :---------------------------------------------------------------------------------------------- |
| Teams    | [Clear-TeamsCache](/_posts/UserAdminModule/Clear-TeamsCache/)                                   |
| Teams    | [Convert-ImageForTeams](/_posts/UserAdminModule/Convert-ImageForTeams/)                         |
| Teams    | [Get-MSTeamsPhone](/_posts/UserAdminModule/Get-MSTeamsPhone/)                                   |
| Teams    | [Get-TeamsFolderStructure](/_posts/UserAdminModule/Get-TeamsFolderStructure/)                   |
| Teams    | [Get-TeamsVersion](/_posts/UserAdminModule/Get-TeamsVersion/)                                   |
| Teams    | [Get-UsersTeamsFolders](/_posts/UserAdminModule/Get-UsersTeamsFolders/)                         |
| Teams    | [Initialize-TeamsLocalUploadFolder](/_posts/UserAdminModule/Initialize-TeamsLocalUploadFolder/) |
| Teams    | [New-MSTeamsPhone](/_posts/UserAdminModule/New-MSTeamsPhone/)                                   |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Testing

| Category | Function                                                                        |
| :------- | :------------------------------------------------------------------------------ |
| Testing  | [Test-ADReplication](/_posts/UserAdminModule/Test-ADReplication/)               |
| Testing  | [Test-CiscoSecure](/_posts/UserAdminModule/Test-CiscoSecure/)                   |
| Testing  | [Test-Computer](/_posts/UserAdminModule/Test-Computer/)                         |
| Testing  | [Test-ComputerName](/_posts/UserAdminModule/Test-ComputerName/)                 |
| Testing  | [Test-ContactEmail](/_posts/UserAdminModule/Test-ContactEmail/)                 |
| Testing  | [Test-DeathstarBackUp](/_posts/UserAdminModule/Test-DeathstarBackUp/)           |
| Testing  | [Test-DisplayName](/_posts/UserAdminModule/Test-DisplayName/)                   |
| Testing  | [test-dnsrecord](/_posts/UserAdminModule/test-dnsrecord/)                       |
| Testing  | [Test-DNSRecord](/_posts/UserAdminModule/Test-DNSRecord/)                       |
| Testing  | [Test-DnsRecordEndpoints](/_posts/UserAdminModule/Test-DnsRecordEndpoints/)     |
| Testing  | [Test-DomainMailRecords](/_posts/UserAdminModule/Test-DomainMailRecords/)       |
| Testing  | [Test-EmailAddress](/_posts/UserAdminModule/Test-EmailAddress/)                 |
| Testing  | [Test-ExchangeConnection](/_posts/UserAdminModule/Test-ExchangeConnection/)     |
| Testing  | [Test-ExchangeDNSRR](/_posts/UserAdminModule/Test-ExchangeDNSRR/)               |
| Testing  | [Test-FileExists](/_posts/UserAdminModule/Test-FileExists/)                     |
| Testing  | [Test-FolderExists](/_posts/UserAdminModule/Test-FolderExists/)                 |
| Testing  | [Test-ifContactExists](/_posts/UserAdminModule/Test-ifContactExists/)           |
| Testing  | [Test-IsAdmin](/_posts/UserAdminModule/Test-IsAdmin/)                           |
| Testing  | [Test-LDAPconnection](/_posts/UserAdminModule/Test-LDAPconnection/)             |
| Testing  | [Test-NetworkPort](/_posts/UserAdminModule/Test-NetworkPort/)                   |
| Testing  | [Test-O365EmailExists](/_posts/UserAdminModule/Test-O365EmailExists/)           |
| Testing  | [Test-OnlineFast](/_posts/UserAdminModule/Test-OnlineFast/)                     |
| Testing  | [Test-OpenPorts](/_posts/UserAdminModule/Test-OpenPorts/)                       |
| Testing  | [Test-OpenPortsWitch](/_posts/UserAdminModule/Test-OpenPortsWitch/)             |
| Testing  | [Test-ProfileExists](/_posts/UserAdminModule/Test-ProfileExists/)               |
| Testing  | [Test-RemoteTimeSettings](/_posts/UserAdminModule/Test-RemoteTimeSettings/)     |
| Testing  | [Test-SamAccountName](/_posts/UserAdminModule/Test-SamAccountName/)             |
| Testing  | [Test-ServerExists](/_posts/UserAdminModule/Test-ServerExists/)                 |
| Testing  | [Test-ServerRolePortGroup](/_posts/UserAdminModule/Test-ServerRolePortGroup/)   |
| Testing  | [Test-SMB1Enabled](/_posts/UserAdminModule/Test-SMB1Enabled/)                   |
| Testing  | [Test-SSLProtocols](/_posts/UserAdminModule/Test-SSLProtocols/)                 |
| Testing  | [Test-Surname](/_posts/UserAdminModule/Test-Surname/)                           |
| Testing  | [Test-TLSConnection](/_posts/UserAdminModule/Test-TLSConnection/)               |
| Testing  | [Test-TransmissionSettings](/_posts/UserAdminModule/Test-TransmissionSettings/) |
| Testing  | [Test-UserExists](/_posts/UserAdminModule/Test-UserExists/)                     |
| Testing  | [Test-WebsiteAvailability](/_posts/UserAdminModule/Test-WebsiteAvailability/)   |
| Testing  | [Test-WebSiteUp](/_posts/UserAdminModule/Test-WebSiteUp/)                       |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Utilities

| Category  | Function                                                                              |
| :-------- | :------------------------------------------------------------------------------------ |
| Utilities | [Cleanup-TestFiles](/_posts/UserAdminModule/Cleanup-TestFiles/)                       |
| Utilities | [ConvertFrom-ErrorRecord](/_posts/UserAdminModule/ConvertFrom-ErrorRecord/)           |
| Utilities | [ConvertFrom-Text](/_posts/UserAdminModule/ConvertFrom-Text/)                         |
| Utilities | [ConvertObject-ToHashTable](/_posts/UserAdminModule/ConvertObject-ToHashTable/)       |
| Utilities | [Export-Functions](/_posts/UserAdminModule/Export-Functions/)                         |
| Utilities | [Export-SingleFunction](/_posts/UserAdminModule/Export-SingleFunction/)               |
| Utilities | [Get-2amOfThirdMondayInMonth](/_posts/UserAdminModule/Get-2amOfThirdMondayInMonth/)   |
| Utilities | [Get-AdminURL](/_posts/UserAdminModule/Get-AdminURL/)                                 |
| Utilities | [Get-ChuckNorrisJoke](/_posts/UserAdminModule/Get-ChuckNorrisJoke/)                   |
| Utilities | [Get-CPUTemperature](/_posts/UserAdminModule/Get-CPUTemperature/)                     |
| Utilities | [get-DotNetVersion](/_posts/UserAdminModule/get-DotNetVersion/)                       |
| Utilities | [Get-DotNetVersion](/_posts/UserAdminModule/Get-DotNetVersion/)                       |
| Utilities | [Get-DownloadPercent](/_posts/UserAdminModule/Get-DownloadPercent/)                   |
| Utilities | [Get-ErrorInfo](/_posts/UserAdminModule/Get-ErrorInfo/)                               |
| Utilities | [Get-InfoBadService](/_posts/UserAdminModule/Get-InfoBadService/)                     |
| Utilities | [Get-InfoCompSystem](/_posts/UserAdminModule/Get-InfoCompSystem/)                     |
| Utilities | [Get-InfoDisk](/_posts/UserAdminModule/Get-InfoDisk/)                                 |
| Utilities | [Get-InfoNIC](/_posts/UserAdminModule/Get-InfoNIC/)                                   |
| Utilities | [Get-InfoOS](/_posts/UserAdminModule/Get-InfoOS/)                                     |
| Utilities | [Get-InfoProc](/_posts/UserAdminModule/Get-InfoProc/)                                 |
| Utilities | [Get-InstalledDotNetVersions](/_posts/UserAdminModule/Get-InstalledDotNetVersions/)   |
| Utilities | [Get-InstalledUpdates](/_posts/UserAdminModule/Get-InstalledUpdates/)                 |
| Utilities | [Get-KMSclientActivations](/_posts/UserAdminModule/Get-KMSclientActivations/)         |
| Utilities | [Get-KMSserverActivations](/_posts/UserAdminModule/Get-KMSserverActivations/)         |
| Utilities | [Get-LastInstalledApplication](/_posts/UserAdminModule/Get-LastInstalledApplication/) |
| Utilities | [Get-Lines](/_posts/UserAdminModule/Get-Lines/)                                       |
| Utilities | [Get-NTPStatusFromHost](/_posts/UserAdminModule/Get-NTPStatusFromHost/)               |
| Utilities | [Get-Ntptime](/_posts/UserAdminModule/Get-Ntptime/)                                   |
| Utilities | [Get-PatchTuesday](/_posts/UserAdminModule/Get-PatchTuesday/)                         |
| Utilities | [Get-PendingReboot](/_posts/UserAdminModule/Get-PendingReboot/)                       |
| Utilities | [Get-PendingUpdate](/_posts/UserAdminModule/Get-PendingUpdate/)                       |
| Utilities | [Get-PendingUpdates](/_posts/UserAdminModule/Get-PendingUpdates/)                     |
| Utilities | [Get-RebootReport](/_posts/UserAdminModule/Get-RebootReport/)                         |
| Utilities | [Get-RemoteTime](/_posts/UserAdminModule/Get-RemoteTime/)                             |
| Utilities | [Get-Resources](/_posts/UserAdminModule/Get-Resources/)                               |
| Utilities | [Get-RestartHistory](/_posts/UserAdminModule/Get-RestartHistory/)                     |
| Utilities | [Get-RunOnceRegKeys](/_posts/UserAdminModule/Get-RunOnceRegKeys/)                     |
| Utilities | [Get-RunRegKeys](/_posts/UserAdminModule/Get-RunRegKeys/)                             |
| Utilities | [Get-ScriptFunctionNames](/_posts/UserAdminModule/Get-ScriptFunctionNames/)           |
| Utilities | [Get-ServerInstalledFeatures](/_posts/UserAdminModule/Get-ServerInstalledFeatures/)   |
| Utilities | [Get-ServerTimeZone](/_posts/UserAdminModule/Get-ServerTimeZone/)                     |
| Utilities | [Get-SpeedTestServers](/_posts/UserAdminModule/Get-SpeedTestServers/)                 |
| Utilities | [Get-Time](/_posts/UserAdminModule/Get-Time/)                                         |
| Utilities | [Get-TimeServer](/_posts/UserAdminModule/Get-TimeServer/)                             |
| Utilities | [Get-TimeSource](/_posts/UserAdminModule/Get-TimeSource/)                             |
| Utilities | [Get-TimeZoneID](/_posts/UserAdminModule/Get-TimeZoneID/)                             |
| Utilities | [Get-UserProfiles](/_posts/UserAdminModule/Get-UserProfiles/)                         |
| Utilities | [Get-W32TimeConfiguration](/_posts/UserAdminModule/Get-W32TimeConfiguration/)         |
| Utilities | [Get-W32TimeServiceStatus](/_posts/UserAdminModule/Get-W32TimeServiceStatus/)         |
| Utilities | [Get-W32TimeSource](/_posts/UserAdminModule/Get-W32TimeSource/)                       |
| Utilities | [Get-W32TimeStripchartResults](/_posts/UserAdminModule/Get-W32TimeStripchartResults/) |
| Utilities | [Get-WeekDayInMonth](/_posts/UserAdminModule/Get-WeekDayInMonth/)                     |
| Utilities | [GetWindowsFeatures](/_posts/UserAdminModule/GetWindowsFeatures/)                     |
| Utilities | [Import-CSVCustom](/_posts/UserAdminModule/Import-CSVCustom/)                         |
| Utilities | [Invoke-BatchArray](/_posts/UserAdminModule/Invoke-BatchArray/)                       |
| Utilities | [Invoke-CDRomDrive](/_posts/UserAdminModule/Invoke-CDRomDrive/)                       |
| Utilities | [Invoke-WebrequestCookie](/_posts/UserAdminModule/Invoke-WebrequestCookie/)           |
| Utilities | [Invoke-WithPsGalleryStats](/_posts/UserAdminModule/Invoke-WithPsGalleryStats/)       |
| Utilities | [Measure-Lines](/_posts/UserAdminModule/Measure-Lines/)                               |
| Utilities | [Move-FilesByType](/_posts/UserAdminModule/Move-FilesByType/)                         |
| Utilities | [New-Email](/_posts/UserAdminModule/New-Email/)                                       |
| Utilities | [New-LocalRunOnceRegKey](/_posts/UserAdminModule/New-LocalRunOnceRegKey/)             |
| Utilities | [New-NTPRecord](/_posts/UserAdminModule/New-NTPRecord/)                               |
| Utilities | [New-SpeedTest](/_posts/UserAdminModule/New-SpeedTest/)                               |
| Utilities | [New-SYDIDocument](/_posts/UserAdminModule/New-SYDIDocument/)                         |
| Utilities | [Open-CDTray](/_posts/UserAdminModule/Open-CDTray/)                                   |
| Utilities | [Out-Excel](/_posts/UserAdminModule/Out-Excel/)                                       |
| Utilities | [PadOrTruncate](/_posts/UserAdminModule/PadOrTruncate/)                               |
| Utilities | [ProgressBar](/_posts/UserAdminModule/ProgressBar/)                                   |
| Utilities | [Remove-NTPRecord](/_posts/UserAdminModule/Remove-NTPRecord/)                         |
| Utilities | [Remove-RunOnceRegKey](/_posts/UserAdminModule/Remove-RunOnceRegKey/)                 |
| Utilities | [Remove-RunRegKey](/_posts/UserAdminModule/Remove-RunRegKey/)                         |
| Utilities | [Remove-UserProfile](/_posts/UserAdminModule/Remove-UserProfile/)                     |
| Utilities | [Remove-UserProfiles](/_posts/UserAdminModule/Remove-UserProfiles/)                   |
| Utilities | [RemoveLocalUserProfile](/_posts/UserAdminModule/RemoveLocalUserProfile/)             |
| Utilities | [Save-LogResults](/_posts/UserAdminModule/Save-LogResults/)                           |
| Utilities | [Search-RoadWorks](/_posts/UserAdminModule/Search-RoadWorks/)                         |
| Utilities | [Set-DNSRecord](/_posts/UserAdminModule/Set-DNSRecord/)                               |
| Utilities | [Set-NTPRecord](/_posts/UserAdminModule/Set-NTPRecord/)                               |
| Utilities | [Set-RegEntry](/_posts/UserAdminModule/Set-RegEntry/)                                 |
| Utilities | [Set-RegistryShouldBe](/_posts/UserAdminModule/Set-RegistryShouldBe/)                 |
| Utilities | [Set-RemoteComputerTime](/_posts/UserAdminModule/Set-RemoteComputerTime/)             |
| Utilities | [Set-RunOnceRegKeys](/_posts/UserAdminModule/Set-RunOnceRegKeys/)                     |
| Utilities | [Set-RunRegKey](/_posts/UserAdminModule/Set-RunRegKey/)                               |
| Utilities | [Set-ServerTimeZone](/_posts/UserAdminModule/Set-ServerTimeZone/)                     |
| Utilities | [Set-TimeZoneID](/_posts/UserAdminModule/Set-TimeZoneID/)                             |
| Utilities | [Start-WindowsUpdate](/_posts/UserAdminModule/Start-WindowsUpdate/)                   |
| Utilities | [Validate-LDAPSBinding](/_posts/UserAdminModule/Validate-LDAPSBinding/)               |
| Utilities | [Write-ProgressHelper](/_posts/UserAdminModule/Write-ProgressHelper/)                 |
| Utilities | [Write-ProgressPipeline](/_posts/UserAdminModule/Write-ProgressPipeline/)             |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Virtualization

| Category       | Function                                                                          |
| :------------- | :-------------------------------------------------------------------------------- |
| Virtualization | [Get-DiskReport](/_posts/UserAdminModule/Get-DiskReport/)                         |
| Virtualization | [Get-DockerStatsSnapshot](/_posts/UserAdminModule/Get-DockerStatsSnapshot/)       |
| Virtualization | [Get-DriveSpaceReport](/_posts/UserAdminModule/Get-DriveSpaceReport/)             |
| Virtualization | [Get-ServerInfo](/_posts/UserAdminModule/Get-ServerInfo/)                         |
| Virtualization | [Get-Uptime](/_posts/UserAdminModule/Get-Uptime/)                                 |
| Virtualization | [Get-UptimeResult](/_posts/UserAdminModule/Get-UptimeResult/)                     |
| Virtualization | [Get-UptimeV1](/_posts/UserAdminModule/Get-UptimeV1/)                             |
| Virtualization | [Get-VMGuestHardwareDetails](/_posts/UserAdminModule/Get-VMGuestHardwareDetails/) |
| Virtualization | [Get-VMInfoCustom](/_posts/UserAdminModule/Get-VMInfoCustom/)                     |
| Virtualization | [Get-VMInformation](/_posts/UserAdminModule/Get-VMInformation/)                   |
| Virtualization | [Get-VMInformationPlus](/_posts/UserAdminModule/Get-VMInformationPlus/)           |
| Virtualization | [Get-WMIHardwareOSInfo](/_posts/UserAdminModule/Get-WMIHardwareOSInfo/)           |
| Virtualization | [New-WindowsSandbox](/_posts/UserAdminModule/New-WindowsSandbox/)                 |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Weather

| Category | Function                                                        |
| :------- | :-------------------------------------------------------------- |
| Weather  | [Get-Weather](/_posts/UserAdminModule/Get-Weather/)             |
| Weather  | [Get-WeatherDetail](/_posts/UserAdminModule/Get-WeatherDetail/) |

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---
