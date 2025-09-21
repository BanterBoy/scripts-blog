---
layout: page
title: "User Admin Module | Maintenance Scripts"
nav_title: User Admin Module
heading: User Admin Module Overview
description: "Scripts v2.0 overview for the UserAdminModule—now helper-driven, categorized, and blissfully free of dot-sourcing."
permalink: /menu/_pages/UserAdminModule.html
---

---

<video width="380" height="160" controls autoplay loop muted>
    <source src="/assets/menu/scripts-blog-intro.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

---

> **⚠️ Important Disclaimer**  
> These PowerShell scripts are provided as-is for educational and administrative purposes. While I've tested them in various environments, using them in production systems is entirely at your own risk. I cannot be held responsible for any unintended consequences, data loss, or system disruptions that may occur.  
> Remember: PowerShell is like a lightsaber - powerful but potentially dangerous in the wrong hands. Use responsibly, and may the Force be with you! 🛡️

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

> **ℹ️ Important Notes on Usage**  
> While these scripts have been published and tested in various environments, some functions may encounter issues depending on your specific setup, permissions, or system configuration. If you run into any problems or unexpected behavior, please don't hesitate to report it! Each script explanation page includes an issue submission feature at the bottom - simply use that to let me know about any bugs, compatibility issues, or suggestions for improvement. Your feedback helps make these tools better for everyone!

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ModuleManagement

The ModuleManagement category provides essential tools for managing and importing PowerShell modules within the UserAdminModule ecosystem. These utilities help streamline module loading and ensure proper initialization of the various function categories available in the toolkit.

| Category         | Function                                                                  |
| :--------------- | :------------------------------------------------------------------------ |
| ModuleManagement | [Import-PersonalModules](/useradminmodule/modulemanagement/import-personalmodules/) |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ADFunctions

The ADFunctions category contains a comprehensive collection of PowerShell tools for Active Directory management and administration. These functions cover user account management, group operations, domain controller queries, Group Policy management, and various AD diagnostic and reporting capabilities. Whether you're managing user lifecycles, troubleshooting authentication issues, or performing bulk operations, this category provides the essential toolkit for AD administrators.

| Category    | Function                                                                                                    |
| :---------- | :---------------------------------------------------------------------------------------------------------- |
| ADFunctions | [Add-ADUsertoLocalGroup](/useradminmodule/adfunctions/add-adusertolocalgroup/)                                   |
| ADFunctions | [ADUserAccountFunctions](/useradminmodule/adfunctions/aduseraccountfunctions/)                                   |
| ADFunctions | [Amend-pwdLastSet](/useradminmodule/adfunctions/amend-pwdlastset/)                                               |
| ADFunctions | [Compare-GroupMembership](/useradminmodule/adfunctions/compare-groupmembership/)                                 |
| ADFunctions | [Copy-AdGroupMemberShip](/useradminmodule/adfunctions/copy-adgroupmembership/)                                   |
| ADFunctions | [Copy-GroupMembership](/useradminmodule/adfunctions/copy-groupmembership/)                                       |
| ADFunctions | [CreateADMXCentralStore](/useradminmodule/adfunctions/createadmxcentralstore/)                                   |
| ADFunctions | [CreateTimeServerGPOs](/useradminmodule/adfunctions/createtimeservergpos/)                                       |
| ADFunctions | [Disable-InactiveComputer](/useradminmodule/adfunctions/disable-inactivecomputer/)                               |
| ADFunctions | [DisableADAccountsMenu](/useradminmodule/adfunctions/disableadaccountsmenu/)                                     |
| ADFunctions | [Find-localAdmins](/useradminmodule/adfunctions/find-localadmins/)                                               |
| ADFunctions | [Find-UnusedADAccounts](/useradminmodule/adfunctions/find-unusedadaccounts/)                                     |
| ADFunctions | [FSMOFunctions](/useradminmodule/adfunctions/fsmofunctions/)                                                     |
| ADFunctions | [Get-ActiveDirectoryTombstonePeriod](/useradminmodule/adfunctions/get-activedirectorytombstoneperiod/)           |
| ADFunctions | [Get-ADComputerSearch](/useradminmodule/adfunctions/get-adcomputersearch/)                                       |
| ADFunctions | [Get-ADDeletedUsers](/useradminmodule/adfunctions/get-addeletedusers/)                                           |
| ADFunctions | [Get-ADDiagnosticConfiguration](/useradminmodule/adfunctions/get-addiagnosticconfiguration/)                     |
| ADFunctions | [Get-ADDiagnosticLogging](/useradminmodule/adfunctions/get-addiagnosticlogging/)                                 |
| ADFunctions | [Get-ADEmailAddress](/useradminmodule/adfunctions/get-ademailaddress/)                                           |
| ADFunctions | [Get-ADGroupAccountDetails](/useradminmodule/adfunctions/get-adgroupaccountdetails/)                             |
| ADFunctions | [Get-ADGroupMembers](/useradminmodule/adfunctions/get-adgroupmembers/)                                           |
| ADFunctions | [Get-GroupMembers](/useradminmodule/adfunctions/get-groupmembers/)                                               |
| ADFunctions | [Get-ADGroupNames](/useradminmodule/adfunctions/get-adgroupnames/)                                               |
| ADFunctions | [Get-GroupNames](/useradminmodule/adfunctions/get-groupnames/)                                                   |
| ADFunctions | [Get-AdminGroupsWithComputers](/useradminmodule/adfunctions/get-admingroupswithcomputers/)                       |
| ADFunctions | [Get-ADObjectAddress](/useradminmodule/adfunctions/get-adobjectaddress/)                                         |
| ADFunctions | [Get-ADPasswordReminderUsers](/useradminmodule/adfunctions/get-adpasswordreminderusers/)                         |
| ADFunctions | [Get-ADUserAudit](/useradminmodule/adfunctions/get-aduseraudit/)                                                 |
| ADFunctions | [Get-ADUserEmailProperties](/useradminmodule/adfunctions/get-aduseremailproperties/)                             |
| ADFunctions | [Get-ADUserExchangeDN](/useradminmodule/adfunctions/get-aduserexchangedn/)                                       |
| ADFunctions | [Get-ADUserLastLogon](/useradminmodule/adfunctions/get-aduserlastlogon/)                                         |
| ADFunctions | [Get-ADUserSearch](/useradminmodule/adfunctions/get-adusersearch/)                                               |
| ADFunctions | [Get-ADUserSearch2](/useradminmodule/adfunctions/get-adusersearch2/)                                             |
| ADFunctions | [Get-AllDomainControllers](/useradminmodule/adfunctions/get-alldomaincontrollers/)                               |
| ADFunctions | [Get-Cert](/useradminmodule/adfunctions/get-cert/)                                                               |
| ADFunctions | [Get-ComputersWithoutBitLocker](/useradminmodule/adfunctions/get-computerswithoutbitlocker/)                     |
| ADFunctions | [Get-CurrentUserLogon](/useradminmodule/adfunctions/get-currentuserlogon/)                                       |
| ADFunctions | [Get-DirectReports](/useradminmodule/adfunctions/get-directreports/)                                             |
| ADFunctions | [Get-DomainControllers](/useradminmodule/adfunctions/get-domaincontrollers/)                                     |
| ADFunctions | [Get-ElevatedUsers](/useradminmodule/adfunctions/get-elevatedusers/)                                             |
| ADFunctions | [Get-EmptyOUs](/useradminmodule/adfunctions/get-emptyous/)                                                       |
| ADFunctions | [Get-FeaturesInventory](/useradminmodule/adfunctions/get-featuresinventory/)                                     |
| ADFunctions | [Get-FSMORoleOwner](/useradminmodule/adfunctions/get-fsmoroleowner/)                                             |
| ADFunctions | [Get-GPProcessingTime](/useradminmodule/adfunctions/get-gpprocessingtime/)                                       |
| ADFunctions | [Get-LapsAndBitLocker](/useradminmodule/adfunctions/get-lapsandbitlocker/)                                       |
| ADFunctions | [Get-LastGPOUpdateTime](/useradminmodule/adfunctions/get-lastgpoupdatetime/)                                     |
| ADFunctions | [Get-LocalGroupMembership](/useradminmodule/adfunctions/get-localgroupmembership/)                               |
| ADFunctions | [Get-LockedOutUser](/useradminmodule/adfunctions/get-lockedoutuser/)                                             |
| ADFunctions | [Get-LockoutHistory](/useradminmodule/adfunctions/get-lockouthistory/)                                           |
| ADFunctions | [Get-LoggedOnUser](/useradminmodule/adfunctions/get-loggedonuser/)                                               |
| ADFunctions | [Get-LogonEvents](/useradminmodule/adfunctions/get-logonevents/)                                                 |
| ADFunctions | [Get-LogonHistory](/useradminmodule/adfunctions/get-logonhistory/)                                               |
| ADFunctions | [Get-NestedGroupMember](/useradminmodule/adfunctions/get-nestedgroupmember/)                                     |
| ADFunctions | [Get-O365LastLogonTime](/useradminmodule/adfunctions/get-o365lastlogontime/)                                     |
| ADFunctions | [Get-OUDelegations](/useradminmodule/adfunctions/get-oudelegations/)                                             |
| ADFunctions | [Get-PrimaryGroupsReport](/useradminmodule/adfunctions/get-primarygroupsreport/)                                 |
| ADFunctions | [Get-RemoteServiceAccount](/useradminmodule/adfunctions/get-remoteserviceaccount/)                               |
| ADFunctions | [Get-ServiceDetails](/useradminmodule/adfunctions/get-servicedetails/)                                           |
| ADFunctions | [Get-ServiceLogonAccount](/useradminmodule/adfunctions/get-servicelogonaccount/)                                 |
| ADFunctions | [Get-ServicePrivilege](/useradminmodule/adfunctions/get-serviceprivilege/)                                       |
| ADFunctions | [Get-TargetGPResult](/useradminmodule/adfunctions/get-targetgpresult/)                                           |
| ADFunctions | [Get-TokenSizeReport](/useradminmodule/adfunctions/get-tokensizereport/)                                         |
| ADFunctions | [Get-TopOUName](/useradminmodule/adfunctions/get-topouname/)                                                     |
| ADFunctions | [Get-UnlinkedGPO](/useradminmodule/adfunctions/get-unlinkedgpo/)                                                 |
| ADFunctions | [Get-UserAccountControlReport](/useradminmodule/adfunctions/get-useraccountcontrolreport/)                       |
| ADFunctions | [Get-UserLogon](/useradminmodule/adfunctions/get-userlogon/)                                                     |
| ADFunctions | [Get-UserLogonEvents](/useradminmodule/adfunctions/get-userlogonevents/)                                         |
| ADFunctions | [get-usermembership](/useradminmodule/adfunctions/get-usermembership/)                                           |
| ADFunctions | [Get-UserReport](/useradminmodule/adfunctions/get-userreport/)                                                   |
| ADFunctions | [Get-UsersGroupMemberShips](/useradminmodule/adfunctions/get-usersgroupmemberships/)                             |
| ADFunctions | [Get-UserSupportedEncryptionTypes](/useradminmodule/adfunctions/get-usersupportedencryptiontypes/)               |
| ADFunctions | [GetMailboxPermission](/useradminmodule/adfunctions/getmailboxpermission/)                                       |
| ADFunctions | [GetUserLoggedOnto](/useradminmodule/adfunctions/getuserloggedonto/)                                             |
| ADFunctions | [Lock-UserAccount](/useradminmodule/adfunctions/lock-useraccount/)                                               |
| ADFunctions | [Move-ADComputer](/useradminmodule/adfunctions/move-adcomputer/)                                                 |
| ADFunctions | [Move-FSMORolestoPDCEmulator](/useradminmodule/adfunctions/move-fsmorolestopdcemulator/)                         |
| ADFunctions | [MoveOU](/useradminmodule/adfunctions/moveou/)                                                                   |
| ADFunctions | [New-ADAssetReport](/useradminmodule/adfunctions/new-adassetreport/)                                             |
| ADFunctions | [New-EncryptedUser](/useradminmodule/adfunctions/new-encrypteduser/)                                             |
| ADFunctions | [New-FakeADUser](/useradminmodule/adfunctions/new-fakeaduser/)                                                   |
| ADFunctions | [New-FakeADUserDetails](/useradminmodule/adfunctions/new-fakeaduserdetails/)                                     |
| ADFunctions | [New-FakeUserDetails](/useradminmodule/adfunctions/new-fakeuserdetails/)                                         |
| ADFunctions | [New-KrbtgtKeys](/useradminmodule/security/new-krbtgtkeys/)                                                   |
| ADFunctions | [New-RandomUser](/useradminmodule/adfunctions/new-randomuser/)                                                   |
| ADFunctions | [OU_permissions](/useradminmodule/adfunctions/ou-permissions/)                                                   |
| ADFunctions | [Provision_Home_Folder](/useradminmodule/adfunctions/provision-home-folder/)                                     |
| ADFunctions | [Query-UserAccountControl](/useradminmodule/adfunctions/query-useraccountcontrol/)                               |
| ADFunctions | [remove-ADM](/useradminmodule/adfunctions/remove-adm/)                                                           |
| ADFunctions | [Remove-AdminSDHolder](/useradminmodule/adfunctions/remove-adminsdholder/)                                       |
| ADFunctions | [Reset-UsersPassword](/useradminmodule/adfunctions/reset-userspassword/)                                         |
| ADFunctions | [Restore-ADDeletedUsers](/useradminmodule/adfunctions/restore-addeletedusers/)                                   |
| ADFunctions | [Search-GPO](/useradminmodule/adfunctions/search-gpo/)                                                           |
| ADFunctions | [Search-GPOforString](/useradminmodule/adfunctions/search-gpoforstring/)                                         |
| ADFunctions | [Search-GPOsForString](/useradminmodule/adfunctions/search-gposforstring/)                                       |
| ADFunctions | [Search-GPOsForStringOrig](/useradminmodule/adfunctions/search-gposforstringorig/)                               |
| ADFunctions | [Search-KerbDelegatedAccounts](/useradminmodule/adfunctions/search-kerbdelegatedaccounts/)                       |
| ADFunctions | [Set-ADDiagnosticConfiguration](/useradminmodule/adfunctions/set-addiagnosticconfiguration/)                     |
| ADFunctions | [Set-ADUserPassword](/useradminmodule/adfunctions/set-aduserpassword/)                                           |
| ADFunctions | [Set-CustomAttributesForGroupMembers](/useradminmodule/adfunctions/set-customattributesforgroupmembers/)         |
| ADFunctions | [Set-ExtensionAttribute](/useradminmodule/adfunctions/set-extensionattribute/)                                   |
| ADFunctions | [Set-FSMORoleOwner](/useradminmodule/adfunctions/set-fsmoroleowner/)                                             |
| ADFunctions | [SiteNameConsistencyReport](/useradminmodule/adfunctions/sitenameconsistencyreport/)                             |
| ADFunctions | [Sync-Office365ToADDS](/useradminmodule/adfunctions/sync-office365toadds/)                                       |
| ADFunctions | [Test-ADUserCredentials](/useradminmodule/adfunctions/test-adusercredentials/)                                   |
| ADFunctions | [Test-ADUserHighPrivilegeGroupMembership](/useradminmodule/adfunctions/test-aduserhighprivilegegroupmembership/) |
| ADFunctions | [Unlock-UserAccount](/useradminmodule/adfunctions/unlock-useraccount/)                                           |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Azure

The Azure category provides a robust set of PowerShell functions for managing Microsoft Azure and Microsoft 365 services. These tools enable seamless connectivity to Azure subscriptions, Azure AD (now Entra ID), Microsoft Graph API, and various Azure services. Whether you're managing user identities, configuring enterprise applications, handling guest access, or working with Azure resources, this category offers the essential functions for cloud administration and automation.

| Category | Function                                                                                                            |
| :------- | :------------------------------------------------------------------------------------------------------------------ |
| Azure    | [Connect-toAzure](/useradminmodule/azure/connect-toazure/)                                                         |
| Azure    | [Connect-toAzureSubscription](/useradminmodule/azure/connect-toazuresubscription/)                                 |
| Azure    | [Connect-toMSGraphApplicationWithCertificate](/useradminmodule/azure/connect-tomsgraphapplicationwithcertificate/) |
| Azure    | [Convert-AzuretoOnPrem](/useradminmodule/azure/convert-azuretoonprem/)                                             |
| Azure    | [Get-AccessToken](/useradminmodule/azure/get-accesstoken/)                                                         |
| Azure    | [Get-AzEnterpriseAppConfig](/useradminmodule/azure/get-azenterpriseappconfig/)                                     |
| Azure    | [Get-EntraGuestMembers](/useradminmodule/azure/get-entraguestmembers/)                                             |
| Azure    | [Get-MFAMethods](/useradminmodule/azure/get-mfamethods/)                                                           |
| Azure    | [Get-MgAdmins](/useradminmodule/azure/get-mgadmins/)                                                               |
| Azure    | [Get-MgUserDetails](/useradminmodule/azure/get-mguserdetails/)                                                     |
| Azure    | [Get-O365AdminGroupsReport](/useradminmodule/azure/get-o365admingroupsreport/)                                     |
| Azure    | [Invoke-AzureADApp](/useradminmodule/azure/invoke-azureadapp/)                                                     |
| Azure    | [Invoke-AzureMailApp](/useradminmodule/azure/invoke-azuremailapp/)                                                 |
| Azure    | [Manage-AzureADApp](/useradminmodule/azure/manage-azureadapp/)                                                     |
| Azure    | [New-AzureADDynamicGroup](/useradminmodule/azure/new-azureaddynamicgroup/)                                         |
| Azure    | [New-EntraGuestInvitation](/useradminmodule/azure/new-entraguestinvitation/)                                       |
| Azure    | [New-EntraGuestInvitationEntra](/useradminmodule/azure/new-entraguestinvitationentra/)                             |
| Azure    | [Send-EmailUsingAzureApp](/useradminmodule/azure/send-emailusingazureapp/)                                         |
| Azure    | [Set-EntraGuestMember](/useradminmodule/azure/set-entraguestmember/)                                               |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## CertificateUtilities

The CertificateUtilities category offers specialized PowerShell functions for certificate management, security assessment, and cryptographic operations. These tools help administrators monitor certificate expiration dates, analyze SSL/TLS configurations, manage remote certificates, and handle code signing certificates. Essential for maintaining security compliance and preventing certificate-related outages in enterprise environments.

| Category             | Function                                                                        |
| :------------------- | :------------------------------------------------------------------------------ |
| CertificateUtilities | [Get-CertificateExpiry](/useradminmodule/certificateutilities/get-certificateexpiry/)         |
| CertificateUtilities | [Get-RemoteCertificates](/useradminmodule/certificateutilities/get-remotecertificates/)       |
| CertificateUtilities | [Get-IISCertificates](/useradminmodule/certificateutilities/get-iiscertificates/)             |
| CertificateUtilities | [Get-RemoteCipherDetails](/useradminmodule/certificateutilities/get-remotecipherdetails/)     |
| CertificateUtilities | [Get-RemoteLdapCertDetails](/useradminmodule/certificateutilities/get-remoteldapcertdetails/) |
| CertificateUtilities | [Install-RemoteCertificate](/useradminmodule/certificateutilities/install-remotecertificate/) |
| CertificateUtilities | [New-CodeSigningCert](/useradminmodule/certificateutilities/new-codesigningcert/)             |
| CertificateUtilities | [Set-DigitalSignature](/useradminmodule/certificateutilities/set-digitalsignature/)           |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Database

The Database category provides PowerShell functions for database administration and management tasks. These tools enable administrators to discover database instances, perform health checks, and manage database-related operations across various database platforms. Essential for database administrators who need to automate routine database management tasks and monitoring.

| Category | Function                                                    |
| :------- | :---------------------------------------------------------- |
| Database | [Get-DBInstances](/useradminmodule/database/get-dbinstances/) |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## EnvironmentManagement

The EnvironmentManagement category contains PowerShell functions for managing system environment variables and paths. These tools help administrators configure and maintain environment settings across local and remote systems, ensuring proper application execution and system configuration. Critical for maintaining consistent environments in enterprise deployments.

| Category              | Function                                                  |
| :-------------------- | :-------------------------------------------------------- |
| EnvironmentManagement | [Add-EnvPath](/useradminmodule/environmentmanagement/add-envpath/)       |
| EnvironmentManagement | [Get-EnvPath](/useradminmodule/environmentmanagement/get-envpath/)       |
| EnvironmentManagement | [Remove-EnvPath](/useradminmodule/environmentmanagement/remove-envpath/) |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Exchange

The Exchange category provides comprehensive PowerShell functions for managing Microsoft Exchange Server and Exchange Online (Office 365) environments. These tools cover mailbox management, distribution groups, mail contacts, calendar permissions, message tracing, and connectivity operations. Essential for Exchange administrators handling both on-premises and cloud-based Exchange deployments, enabling efficient email system management and troubleshooting.

| Category | Function                                                                                                                |
| :------- | :---------------------------------------------------------------------------------------------------------------------- |
| Exchange | [Add-MemberToDistributionGroup](/useradminmodule/exchange/add-membertodistributiongroup/)                                 |
| Exchange | [Add-Office365Functions](/useradminmodule/exchange/add-office365functions/)                                               |
| Exchange | [ArgumentCompleterExample](/useradminmodule/exchange/argumentcompleterexample/)                                           |
| Exchange | [Connect-ExchangeServer](/useradminmodule/exchange/connect-exchangeserver/)                                               |
| Exchange | [Connect-O365Exchange](/useradminmodule/exchange/connect-o365exchange/)                                                   |
| Exchange | [Connect-O365Session](/useradminmodule/exchange/connect-o365session/)                                                     |
| Exchange | [Connect-Office365Services](/useradminmodule/exchange/connect-office365services/)                                         |
| Exchange | [Connect-OPExchange](/useradminmodule/exchange/connect-opexchange/)                                                       |
| Exchange | [Copy-DistributionGroupMembers](/useradminmodule/exchange/copy-distributiongroupmembers/)                                 |
| Exchange | [Copy-DistributionGroupMembership](/useradminmodule/exchange/copy-distributiongroupmembership/)                           |
| Exchange | [Copy-OnPremToCloudDistributionGroupMembership](/useradminmodule/exchange/copy-onpremtoclouddistributiongroupmembership/) |
| Exchange | [Copy-ReceiveConnector](/useradminmodule/exchange/copy-receiveconnector/)                                                 |
| Exchange | [Disconnect-ExchangeSessions](/useradminmodule/exchange/disconnect-exchangesessions/)                                     |
| Exchange | [Enter-O365Session](/useradminmodule/exchange/enter-o365session/)                                                         |
| Exchange | [ExchangeConnector](/useradminmodule/exchange/exchangeconnector/)                                                         |
| Exchange | [ExchangeFunctions](/useradminmodule/exchange/exchangefunctions/)                                                         |
| Exchange | [Export-CalendarPermissions](/useradminmodule/exchange/export-calendarpermissions/)                                       |
| Exchange | [Export-DistributionGroupProperties](/useradminmodule/exchange/export-distributiongroupproperties/)                       |
| Exchange | [Export-ExchangeContactData](/useradminmodule/exchange/export-exchangecontactdata/)                                       |
| Exchange | [Get-ADExchangeServer](/useradminmodule/exchange/get-adexchangeserver/)                                                   |
| Exchange | [Get-ContactList](/useradminmodule/exchange/get-contactlist/)                                                             |
| Exchange | [Get-ContactsFromDomain](/useradminmodule/exchange/get-contactsfromdomain/)                                               |
| Exchange | [Get-DistributionGroupsWithOwners](/useradminmodule/exchange/get-distributiongroupswithowners/)                           |
| Exchange | [Get-DistributionListMembers](/useradminmodule/exchange/get-distributionlistmembers/)                                     |
| Exchange | [Get-DuplicateExchangeDN](/useradminmodule/exchange/get-duplicateexchangedn/)                                             |
| Exchange | [Get-ExchangeServer](/useradminmodule/exchange/get-exchangeserver/)                                                       |
| Exchange | [Get-ExchangeServerInSite](/useradminmodule/exchange/get-exchangeserverinsite/)                                           |
| Exchange | [Get-ExchangeVersion](/useradminmodule/exchange/get-exchangeversion/)                                                     |
| Exchange | [Get-FilteredContacts](/useradminmodule/exchange/get-filteredcontacts/)                                                   |
| Exchange | [Get-FilteredMailboxes](/useradminmodule/exchange/get-filteredmailboxes/)                                                 |
| Exchange | [Get-MailboxAccessPerms](/useradminmodule/exchange/get-mailboxaccessperms/)                                               |
| Exchange | [Get-MailboxContent](/useradminmodule/exchange/get-mailboxcontent/)                                                       |
| Exchange | [Get-MailboxPermissions](/useradminmodule/exchange/get-mailboxpermissions/)                                               |
| Exchange | [Get-MailboxPermissionsExport](/useradminmodule/exchange/get-mailboxpermissionsexport/)                                   |
| Exchange | [Get-MailboxPermissionsReport](/useradminmodule/exchange/get-mailboxpermissionsreport/)                                   |
| Exchange | [Get-MailboxPermissionsReport2](/useradminmodule/exchange/get-mailboxpermissionsreport2/)                                 |
| Exchange | [Get-MailboxReport](/useradminmodule/exchange/get-mailboxreport/)                                                         |
| Exchange | [Get-MailboxStatistics](/useradminmodule/exchange/get-mailboxstatistics/)                                                 |
| Exchange | [Get-MailContactDetails](/useradminmodule/exchange/get-mailcontactdetails/)                                               |
| Exchange | [Get-MBAccessPerms](/useradminmodule/exchange/get-mbaccessperms/)                                                         |
| Exchange | [Get-MessageTraceFiltered](/useradminmodule/exchange/get-messagetracefiltered/)                                           |
| Exchange | [Get-O365CalendarPermissions](/useradminmodule/exchange/get-o365calendarpermissions/)                                     |
| Exchange | [Get-O365MailboxPermissions](/useradminmodule/exchange/get-o365mailboxpermissions/)                                       |
| Exchange | [Get-O365SharedMailboxPermissions](/useradminmodule/exchange/get-o365sharedmailboxpermissions/)                           |
| Exchange | [Get-OOHMessage](/useradminmodule/exchange/get-oohmessage/)                                                               |
| Exchange | [Get-OrphanedDistributionGroups](/useradminmodule/exchange/get-orphaneddistributiongroups/)                               |
| Exchange | [Get-QuarantinedEmailMessages](/useradminmodule/exchange/get-quarantinedemailmessages/)                                   |
| Exchange | [Get-UsersCalendarAccess](/useradminmodule/exchange/get-userscalendaraccess/)                                             |
| Exchange | [New-DynamicListFromAttribute](/useradminmodule/exchange/new-dynamiclistfromattribute/)                                   |
| Exchange | [New-ExchangeDistributionGroup](/useradminmodule/exchange/new-exchangedistributiongroup/)                                 |
| Exchange | [New-MailContactObject](/useradminmodule/exchange/new-mailcontactobject/)                                                 |
| Exchange | [New-O365Contact](/useradminmodule/exchange/new-o365contact/)                                                             |
| Exchange | [New-OOHMessage](/useradminmodule/exchange/new-oohmessage/)                                                               |
| Exchange | [O365Session](/useradminmodule/exchange/o365session/)                                                                     |
| Exchange | [OnPremExchangeFunctions](/useradminmodule/exchange/onpremexchangefunctions/)                                             |
| Exchange | [PasswordChangeNotification](/useradminmodule/exchange/passwordchangenotification/)                                       |
| Exchange | [PasswordReminderAlso](/useradminmodule/exchange/passwordreminderalso/)                                                   |
| Exchange | [Preview-QuarantinedEmailMessage](/useradminmodule/exchange/preview-quarantinedemailmessage/)                             |
| Exchange | [Remove-MailboxFolderPermissions](/useradminmodule/exchange/remove-mailboxfolderpermissions/)                             |
| Exchange | [Remove-UsersfromGAL](/useradminmodule/exchange/remove-usersfromgal/)                                                     |
| Exchange | [Repair-MissingOnPremMailbox](/useradminmodule/exchange/repair-missingonpremmailbox/)                                     |
| Exchange | [Restart-ExchangeServices](/useradminmodule/exchange/restart-exchangeservices/)                                           |
| Exchange | [Send-OutlookMail](/useradminmodule/exchange/send-outlookmail/)                                                           |
| Exchange | [Set-AutoDiscover](/useradminmodule/exchange/set-autodiscover/)                                                           |
| Exchange | [Set-CalendarPermsScript](/useradminmodule/exchange/set-calendarpermsscript/)                                             |
| Exchange | [Set-DefaultReceiveConnector](/useradminmodule/exchange/set-defaultreceiveconnector/)                                     |
| Exchange | [Set-DistributionGroupProperties](/useradminmodule/exchange/set-distributiongroupproperties/)                             |
| Exchange | [Set-MailContactDetails](/useradminmodule/exchange/set-mailcontactdetails/)                                               |
| Exchange | [Set-MailContactDetailsOnline](/useradminmodule/exchange/set-mailcontactdetailsonline/)                                   |
| Exchange | [Set-O365CalendarPermissions](/useradminmodule/exchange/set-o365calendarpermissions/)                                     |
| Exchange | [Set-O365MailboxPermissions](/useradminmodule/exchange/set-o365mailboxpermissions/)                                       |
| Exchange | [Set-OOHmessage](/useradminmodule/exchange/set-oohmessage/)                                                               |
| Exchange | [Unblock-QuarantineMessage](/useradminmodule/exchange/unblock-quarantinemessage/)                                         |
| Exchange | [Update-CalendarPermissions](/useradminmodule/exchange/update-calendarpermissions/)                                       |
| Exchange | [Update-DistributionGroupOwner](/useradminmodule/exchange/update-distributiongroupowner/)                                 |
| Exchange | [Update-DistributionList](/useradminmodule/exchange/update-distributionlist/)                                             |
| Exchange | [Update-MailContactDomain](/useradminmodule/exchange/update-mailcontactdomain/)                                           |
| Exchange | [Update-MailContactProperties](/useradminmodule/exchange/update-mailcontactproperties/)                                   |
| Exchange | [Update-O365CalendarPermissions](/useradminmodule/exchange/update-o365calendarpermissions/)                               |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## FileOperations

The FileOperations category offers a comprehensive suite of PowerShell functions for file system management, archiving, and data manipulation. These tools enable administrators to perform bulk file operations, manage archives, monitor file systems, convert file formats, and handle file permissions. Perfect for system administrators who need to automate file management tasks across multiple systems and maintain organized file structures.

| Category       | Function                                                                                            |
| :------------- | :-------------------------------------------------------------------------------------------------- |
| FileOperations | [Convert-DnsZoneFile](/useradminmodule/fileoperations/convert-dnszonefile/)                                 |
| FileOperations | [Convert-FilenameToGUID](/useradminmodule/fileoperations/convert-filenametoguid/)                           |
| FileOperations | [Copy-FilestoComputer](/useradminmodule/fileoperations/copy-filestocomputer/)                               |
| FileOperations | [Copy-FilestoRemote](/useradminmodule/fileoperations/copy-filestoremote/)                                   |
| FileOperations | [createRandomFilesFunctions](/useradminmodule/fileoperations/createrandomfilesfunctions/)                   |
| FileOperations | [Expand-NinjaOne7Zip](/useradminmodule/fileoperations/expand-ninjaone7zip/)                                 |
| FileOperations | [Expand-NinjaOneZip](/useradminmodule/fileoperations/expand-ninjaonezip/)                                   |
| FileOperations | [IISLogsCleanup](/useradminmodule/fileoperations/logging/iislogscleanup/)                                           |
| FileOperations | [FileWatcher](/useradminmodule/fileoperations/filewatcher/)                                                 |
| FileOperations | [Format-FileSize](/useradminmodule/fileoperations/format-filesize/)                                         |
| FileOperations | [Get-FileAndFolderPermissions](/useradminmodule/fileoperations/get-fileandfolderpermissions/)               |
| FileOperations | [Get-FileExtension](/useradminmodule/fileoperations/get-fileextension/)                                     |
| FileOperations | [Get-FileOwner](/useradminmodule/fileoperations/get-fileowner/)                                             |
| FileOperations | [Get-IniContent](/useradminmodule/fileoperations/get-inicontent/)                                           |
| FileOperations | [Get-LatestFiles](/useradminmodule/fileoperations/get-latestfiles/)                                         |
| FileOperations | [Get-MediaDetails](/useradminmodule/fileoperations/get-mediadetails/)                                       |
| FileOperations | [Get-NeglectedFiles](/useradminmodule/fileoperations/get-neglectedfiles/)                                   |
| FileOperations | [Get-OldFiles](/useradminmodule/fileoperations/get-oldfiles/)                                               |
| FileOperations | [Get-PathPermissions](/useradminmodule/fileoperations/get-pathpermissions/)                                 |
| FileOperations | [IISLogsCleanup](/useradminmodule/fileoperations/logging/iislogscleanup/)                                           |
| FileOperations | [Invoke-RemoteZipExpansion](/useradminmodule/fileoperations/invoke-remotezipexpansion/)                     |
| FileOperations | [Merge-Files](/useradminmodule/fileoperations/merge-files/)                                                 |
| FileOperations | [New-DummyFile](/useradminmodule/fileoperations/new-dummyfile/)                                             |
| FileOperations | [New-DummyFiles](/useradminmodule/fileoperations/new-dummyfiles/)                                           |
| FileOperations | [New-FileArchive](/useradminmodule/fileoperations/new-filearchive/)                                         |
| FileOperations | [New-FileofSize](/useradminmodule/fileoperations/new-fileofsize/)                                           |
| FileOperations | [New-FileReport](/useradminmodule/fileoperations/new-filereport/)                                           |
| FileOperations | [New-FolderCompare](/useradminmodule/fileoperations/new-foldercompare/)                                     |
| FileOperations | [New-PSDriveRootFolder](/useradminmodule/fileoperations/new-psdriverootfolder/)                             |
| FileOperations | [New-Shortcut](/useradminmodule/fileoperations/new-shortcut/)                                               |
| FileOperations | [New-ZipFile](/useradminmodule/fileoperations/new-zipfile/)                                                 |
| FileOperations | [parse_NTFS](/useradminmodule/fileoperations/parse-ntfs/)                                                   |
| FileOperations | [Randomize-FilesIntoSubfolders](/useradminmodule/fileoperations/randomize-filesintosubfolders/)             |
| FileOperations | [Register-FileSystemWatcher](/useradminmodule/fileoperations/register-filesystemwatcher/)                   |
| FileOperations | [Remove-DummyFiles](/useradminmodule/fileoperations/remove-dummyfiles/)                                     |
| FileOperations | [Remove-EmptyFolders](/useradminmodule/fileoperations/remove-emptyfolders/)                                 |
| FileOperations | [Remove-Files](/useradminmodule/fileoperations/remove-files/)                                               |
| FileOperations | [Remove-FoldersWithoutSpecifiedFiles](/useradminmodule/fileoperations/remove-folderswithoutspecifiedfiles/) |
| FileOperations | [Reorganize-FilesByType](/useradminmodule/fileoperations/reorganize-filesbytype/)                           |
| FileOperations | [Save-PasswordFile](/useradminmodule/fileoperations/save-passwordfile/)                                     |
| FileOperations | [Search-ForFiles](/useradminmodule/fileoperations/search-forfiles/)                                         |
| FileOperations | [search-scripts](/useradminmodule/fileoperations/search-scripts/)                                           |
| FileOperations | [Search-Scripts](/useradminmodule/fileoperations/search-scripts/)                                           |
| FileOperations | [Show-PSDrive](/useradminmodule/fileoperations/show-psdrive/)                                               |
| FileOperations | [Start-DownloadFileToTemp](/useradminmodule/fileoperations/start-downloadfiletotemp/)                       |
| FileOperations | [Unblock-AndUnzipFiles](/useradminmodule/fileoperations/unblock-andunzipfiles/)                             |
| FileOperations | [UncompressZip-SameDestination](/useradminmodule/fileoperations/uncompresszip-samedestination/)             |
| FileOperations | [zipArchiveTool_recursive](/useradminmodule/fileoperations/ziparchivetool-recursive/)                       |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## JekyllBlog

The JekyllBlog category provides specialized PowerShell functions for managing Jekyll-based static websites and blogs. These tools help developers and content creators automate blog post creation, manage Jekyll servers, embed GitHub Gists, and handle various blogging workflows. Essential for technical writers and developers who maintain Jekyll-powered documentation sites and blogs.

| Category   | Function                                                                    |
| :--------- | :-------------------------------------------------------------------------- |
| JekyllBlog | [Get-GistIframe](/useradminmodule/jekyllblog/get-gistiframe/)                   |
| JekyllBlog | [New-BlogServer](/useradminmodule/jekyllblog/new-blogserver/)                   |
| JekyllBlog | [New-JekyllBlogPost](/useradminmodule/jekyllblog/new-jekyllblogpost/)           |
| JekyllBlog | [New-JekyllBlogServer](/useradminmodule/jekyllblog/new-jekyllblogserver/)       |
| JekyllBlog | [New-JekyllBlogSession](/useradminmodule/jekyllblog/new-jekyllblogsession/)     |
| JekyllBlog | [Remove-JekyllBlogServer](/useradminmodule/jekyllblog/remove-jekyllblogserver/) |
| JekyllBlog | [Show-JekyllBlogSite](/useradminmodule/jekyllblog/show-jekyllblogsite/)         |
| JekyllBlog | [Start-JekyllBlogging](/useradminmodule/jekyllblog/start-jekyllblogging/)       |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Logging

The Logging category contains PowerShell functions for comprehensive event log management and analysis. These tools enable administrators to query Windows Event Logs, filter events by various criteria, monitor system events, and implement custom logging solutions. Critical for system monitoring, troubleshooting, and maintaining audit trails in enterprise environments.

| Category | Function                                                                    |
| :------- | :-------------------------------------------------------------------------- |
| Logging  | [Get-EventLogs](/useradminmodule/logging/get-eventlogs/)                     |
| Logging  | [Get-EventsFromTimeframe](/useradminmodule/logging/get-eventsfromtimeframe/) |
| Logging  | [Get-FilteredEvents](/useradminmodule/logging/get-filteredevents/)           |
| Logging  | [Get-LogonEvent](/useradminmodule/logging/get-logonevent/)                   |
| Logging  | [Get-SystemEvent](/useradminmodule/logging/get-systemevent/)                 |
| Logging  | [Get-WmiADEvent](/useradminmodule/logging/get-wmiadevent/)                   |
| Logging  | [Initialize-EventLogging](/useradminmodule/logging/initialize-eventlogging/) |
| Logging  | [IISLogsCleanup](/useradminmodule/fileoperations/logging/iislogscleanup/)                   |
| Logging  | [Log-Event](/useradminmodule/logging/log-event/)                             |
| Logging  | [New-LogEvent](/useradminmodule/logging/new-logevent/)                       |
| Logging  | [Script4logging](/useradminmodule/logging/script4logging/)                   |
| Logging  | [Write-Log](/useradminmodule/logging/write-log/)                             |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## MediaManagement

The MediaManagement category provides PowerShell functions for multimedia processing and management. These tools integrate with FFmpeg for video/audio manipulation, VLC for playlist creation, and various media analysis utilities. Perfect for content creators, system administrators managing media servers, and anyone working with multimedia files who needs to automate media processing workflows.

| Category        | Function                                                                                        |
| :-------------- | :---------------------------------------------------------------------------------------------- |
| MediaManagement | [Create-VLCPlaylists](/useradminmodule/mediamanagement/create-vlcplaylists/)                             |
| MediaManagement | [FFMpeg-Install](/useradminmodule/mediamanagement/ffmpeg-install/)                                       |
| MediaManagement | [Get-FFProbeAudioStreams](/useradminmodule/mediamanagement/get-ffprobeaudiostreams/)                     |
| MediaManagement | [Get-FFProbeVideoInfo](/useradminmodule/mediamanagement/get-ffprobevideoinfo/)                           |
| MediaManagement | [Find-Movies](/useradminmodule/mediamanagement/find-movies/)                                             |
| MediaManagement | [New-SpeechOutput](/useradminmodule/mediamanagement/new-speechoutput/)                                   |
| MediaManagement | [Remove-FFMpegVideoFileAudioStream](/useradminmodule/mediamanagement/remove-ffmpegvideofileaudiostream/) |
| MediaManagement | [Set-FFMpegVideoSpeed](/useradminmodule/mediamanagement/set-ffmpegvideospeed/)                           |
| MediaManagement | [Set-TransmissionDefaultSettings](/useradminmodule/mediamanagement/set-transmissiondefaultsettings/)     |
| MediaManagement | [Start-Stream](/useradminmodule/mediamanagement/start-stream/)                                           |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Network

The Network category offers a comprehensive set of PowerShell functions for network administration, diagnostics, and management. These tools cover IP address management, DNS operations, network connectivity testing, firewall configuration, and various network service monitoring capabilities. Essential for network administrators and system engineers who need to automate network-related tasks and troubleshoot connectivity issues.

| Category | Function                                                                |
| :------- | :---------------------------------------------------------------------- |
| Network  | [Connect-Proxy](/useradminmodule/network/connect-proxy/)                 |
| Network  | [Get-CidrIPRange](/useradminmodule/network/get-cidriprange/)             |
| Network  | [Get-ComputerIP](/useradminmodule/network/get-computerip/)               |
| Network  | [Get-HostIOResults](/useradminmodule/network/get-hostioresults/)         |
| Network  | [Get-ipInfo](/useradminmodule/network/get-ipinfo/)                       |
| Network  | [Get-MullvadApiDetails](/useradminmodule/network/get-mullvadapidetails/) |
| Network  | [Get-PortService](/useradminmodule/network/get-portservice/)             |
| Network  | [Get-RemoteIPSettings](/useradminmodule/network/get-remoteipsettings/)   |
| Network  | [Get-RemoteServerPorts](/useradminmodule/network/get-remoteserverports/) |
| Network  | [Get-ServerIPInfo](/useradminmodule/network/get-serveripinfo/)           |
| Network  | [Get-WhoIsInformation](/useradminmodule/network/get-whoisinformation/)   |
| Network  | [Get-WTFismyIP](/useradminmodule/network/get-wtfismyip/)                 |
| Network  | [Send-MagicPacket](/useradminmodule/network/send-magicpacket/)           |
| Network  | [Set-DHCPIPAddress](/useradminmodule/network/set-dhcpipaddress/)         |
| Network  | [Set-GoogleDynamicDNS](/useradminmodule/network/set-googledynamicdns/)   |
| Network  | [Set-StaticIPAddress](/useradminmodule/network/set-staticipaddress/)     |
| Network  | [Set-WMIPermissions](/useradminmodule/network/set-wmipermissions/)       |
| Network  | [Switch-VpnFailover](/useradminmodule/network/switch-vpnfailover/)       |
| Network  | [Switch-VpnFailoverMac](/useradminmodule/network/switch-vpnfailovermac/) |
| Network  | [Update-CloudflareDDNS](/useradminmodule/network/update-cloudflareddns/) |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PKICertificateTools

The PKICertificateTools category provides specialized PowerShell functions for managing Public Key Infrastructure (PKI) and Certificate Authority (CA) operations. These tools enable administrators to backup and restore CA servers, manage certificate templates, handle certificate revocation lists, and perform various PKI-related administrative tasks. Critical for organizations managing their own certificate infrastructure and ensuring secure certificate lifecycle management.

| Category            | Function                                                                                                        |
| :------------------ | :-------------------------------------------------------------------------------------------------------------- |
| PKICertificateTools | [Backup-CAServer](/useradminmodule/pkicertificatetools/backup-caserver/)                                                     |
| PKICertificateTools | [Backup-CertificateServicesDatabase](/useradminmodule/pkicertificatetools/backup-certificateservicesdatabase/)               |
| PKICertificateTools | [Decommission-CA](/useradminmodule/pkicertificatetools/decommission-ca/)                                                     |
| PKICertificateTools | [Export-CRL](/useradminmodule/pkicertificatetools/export-crl/)                                                               |
| PKICertificateTools | [Find-CertificateByTemplate](/useradminmodule/pkicertificatetools/find-certificatebytemplate/)                               |
| PKICertificateTools | [Get-ADCertificates](/useradminmodule/pkicertificatetools/get-adcertificates/)                                               |
| PKICertificateTools | [Get-AdCertificateTemplate](/useradminmodule/pkicertificatetools/get-adcertificatetemplate/)                                 |
| PKICertificateTools | [Get-AllPKICertificates](/useradminmodule/pkicertificatetools/get-allpkicertificates/)                                       |
| PKICertificateTools | [Get-CACertificateInfo](/useradminmodule/pkicertificatetools/get-cacertificateinfo/)                                         |
| PKICertificateTools | [Get-Oid](/useradminmodule/pkicertificatetools/get-oid/)                                                                     |
| PKICertificateTools | [Get-PKICertificate](/useradminmodule/pkicertificatetools/get-pkicertificate/)                                               |
| PKICertificateTools | [Get-PKICertificates](/useradminmodule/pkicertificatetools/get-pkicertificates/)                                             |
| PKICertificateTools | [Get-PublishedTemplate](/useradminmodule/pkicertificatetools/get-publishedtemplate/)                                         |
| PKICertificateTools | [Get-RDGCAIssuedCert](/useradminmodule/pkicertificatetools/get-rdgcaissuedcert/)                                             |
| PKICertificateTools | [Get-RDGCARequestPending](/useradminmodule/pkicertificatetools/get-rdgcarequestpending/)                                     |
| PKICertificateTools | [Get-Sid](/useradminmodule/pkicertificatetools/get-sid/)                                                                     |
| PKICertificateTools | [Move-CertificateServicesDatabase](/useradminmodule/pkicertificatetools/move-certificateservicesdatabase/)                   |
| PKICertificateTools | [Optimize-DomainControllerTlsConfiguration](/useradminmodule/pkicertificatetools/optimize-domaincontrollertlsconfiguration/) |
| PKICertificateTools | [Publish-NewCRL](/useradminmodule/pkicertificatetools/publish-newcrl/)                                                       |
| PKICertificateTools | [Remove-ADCSArtifacts](/useradminmodule/pkicertificatetools/remove-adcsartifacts/)                                           |
| PKICertificateTools | [Remove-CAFromNTAuth](/useradminmodule/pkicertificatetools/remove-cafromntauth/)                                             |
| PKICertificateTools | [Remove-CAKeys](/useradminmodule/pkicertificatetools/remove-cakeys/)                                                         |
| PKICertificateTools | [Remove-CASolution](/useradminmodule/pkicertificatetools/remove-casolution/)                                                 |
| PKICertificateTools | [Remove-CertLogDatabase](/useradminmodule/pkicertificatetools/remove-certlogdatabase/)                                       |
| PKICertificateTools | [Remove-ExpiredCertificate](/useradminmodule/pkicertificatetools/remove-expiredcertificate/)                                 |
| PKICertificateTools | [Revoke-AllValidCerts](/useradminmodule/pkicertificatetools/revoke-allvalidcerts/)                                           |
| PKICertificateTools | [Revoke-CACertificate](/useradminmodule/pkicertificatetools/revoke-cacertificate/)                                           |
| PKICertificateTools | [Show-CertificateTemplateInformation](/useradminmodule/pkicertificatetools/show-certificatetemplateinformation/)             |
| PKICertificateTools | [Write-CAActivityLog](/useradminmodule/pkicertificatetools/write-caactivitylog/)                                             |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## PrintManagement

The PrintManagement category contains PowerShell functions for managing print servers, print spoolers, and printer operations. These tools help administrators monitor print services, troubleshoot printing issues, and manage print server configurations. Essential for IT support teams and system administrators responsible for maintaining printing infrastructure in enterprise environments.

| Category        | Function                                                              |
| :-------------- | :-------------------------------------------------------------------- |
| PrintManagement | [Disable-PrintSpooler](/useradminmodule/printmanagement/disable-printspooler/) |
| PrintManagement | [Enable-PrintSpooler](/useradminmodule/printmanagement/enable-printspooler/)   |
| PrintManagement | [Get-PrintSpooler](/useradminmodule/printmanagement/get-printspooler/)         |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ProcessServiceSchedules

The ProcessServiceSchedules category provides PowerShell functions for managing Windows processes, services, and scheduled tasks. These tools enable administrators to monitor system processes, manage Windows services, and handle scheduled task operations across local and remote systems. Critical for system monitoring, troubleshooting performance issues, and maintaining automated task schedules.

| Category                | Function                                                                            |
| :---------------------- | :---------------------------------------------------------------------------------- |
| ProcessServiceSchedules | [Get-AllScheduledScripts](/useradminmodule/processserviceschedules/get-allscheduledscripts/)         |
| ProcessServiceSchedules | [Get-ProcessandServicePID](/useradminmodule/processserviceschedules/get-processandservicepid/)       |
| ProcessServiceSchedules | [Get-ProcessStatus](/useradminmodule/processserviceschedules/get-processstatus/)                     |
| ProcessServiceSchedules | [Get-RemoteScheduledTasks](/useradminmodule/processserviceschedules/get-remotescheduledtasks/)       |
| ProcessServiceSchedules | [Get-ScheduledScripts](/useradminmodule/processserviceschedules/get-scheduledscripts/)               |
| ProcessServiceSchedules | [Get-ScheduledTasks](/useradminmodule/processserviceschedules/get-scheduledtasks/)                   |
| ProcessServiceSchedules | [Get-ServiceStatus](/useradminmodule/processserviceschedules/get-servicestatus/)                     |
| ProcessServiceSchedules | [New-ScheduledScript](/useradminmodule/processserviceschedules/new-scheduledscript/)                 |
| ProcessServiceSchedules | [New-ScheduledTask](/useradminmodule/processserviceschedules/new-scheduledtask/)                     |
| ProcessServiceSchedules | [Remove-ScheduledScript](/useradminmodule/processserviceschedules/remove-scheduledscript/)           |
| ProcessServiceSchedules | [Restart-NinjaRMMService](/useradminmodule/processserviceschedules/restart-ninjarmmservice/)         |
| ProcessServiceSchedules | [Restart-PrintSpooler](/useradminmodule/processserviceschedules/restart-printspooler/)               |
| ProcessServiceSchedules | [Set-PrintSpoolerConfig](/useradminmodule/processserviceschedules/set-printspoolerconfig/)           |
| ProcessServiceSchedules | [Set-ServiceConfig](/useradminmodule/processserviceschedules/set-serviceconfig/)                     |
| ProcessServiceSchedules | [Start-BullwallServices](/useradminmodule/processserviceschedules/start-bullwallservices/)           |
| ProcessServiceSchedules | [Start-Outlook](/useradminmodule/processserviceschedules/start-outlook/)                             |
| ProcessServiceSchedules | [Start-ProcessOnComputer](/useradminmodule/processserviceschedules/start-processoncomputer/)         |
| ProcessServiceSchedules | [Start-ScheduledScript](/useradminmodule/processserviceschedules/start-scheduledscript/)             |
| ProcessServiceSchedules | [Start-TaskList](/useradminmodule/processserviceschedules/start-tasklist/)                           |
| ProcessServiceSchedules | [Start-ServicesInOrder](/useradminmodule/processserviceschedules/start-servicesinorder/)             |
| ProcessServiceSchedules | [Stop-FailedService](/useradminmodule/processserviceschedules/stop-failedservice/)                   |
| ProcessServiceSchedules | [Stop-NonRespondingProcesses](/useradminmodule/processserviceschedules/stop-nonrespondingprocesses/) |
| ProcessServiceSchedules | [Stop-ProcessOnComputer](/useradminmodule/processserviceschedules/stop-processoncomputer/)           |
| ProcessServiceSchedules | [Stop-ScheduledScript](/useradminmodule/processserviceschedules/stop-scheduledscript/)               |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## RemoteConnections

The RemoteConnections category offers PowerShell functions for establishing and managing remote connections to Windows systems. These tools support various remote access methods including RDP, PSExec, Remote Assistance, and specialized connection viewers. Essential for IT support teams and system administrators who need to remotely access and manage multiple systems efficiently.

| Category          | Function                                                                      |
| :---------------- | :---------------------------------------------------------------------------- |
| RemoteConnections | [Connect-CmRcViewer](/useradminmodule/remoteconnections/connect-cmrcviewer/)             |
| RemoteConnections | [Connect-InternalPRTG](/useradminmodule/remoteconnections/connect-internalprtg/)         |
| RemoteConnections | [Connect-Mstsc](/useradminmodule/remoteconnections/connect-mstsc/)                       |
| RemoteConnections | [Connect-PSExec](/useradminmodule/remoteconnections/connect-psexec/)                     |
| RemoteConnections | [Connect-PSExecPowershell](/useradminmodule/remoteconnections/connect-psexecpowershell/) |
| RemoteConnections | [Connect-RemoteAssistance](/useradminmodule/remoteconnections/connect-remoteassistance/) |
| RemoteConnections | [Connect-RDPSession](/useradminmodule/remoteconnections/connect-rdpsession/)             |
| RemoteConnections | [Disable-RDPRemotely](/useradminmodule/remoteconnections/disable-rdpremotely/)           |
| RemoteConnections | [Disable-RDPRemotelyCIM](/useradminmodule/remoteconnections/disable-rdpremotelycim/)     |
| RemoteConnections | [Disable-RDPRemotelyWMI](/useradminmodule/remoteconnections/disable-rdpremotelywmi/)     |
| RemoteConnections | [Enable-RDPRemotely](/useradminmodule/remoteconnections/enable-rdpremotely/)             |
| RemoteConnections | [Enable-RDPRemotelyCIM](/useradminmodule/remoteconnections/enable-rdpremotelycim/)       |
| RemoteConnections | [Enable-RDPRemotelyWMI](/useradminmodule/remoteconnections/enable-rdpremotelywmi/)       |
| RemoteConnections | [Enable-RemoteDesktop](/useradminmodule/remoteconnections/enable-remotedesktop/)         |
| RemoteConnections | [Get-LoggedOnRDPUser](/useradminmodule/remoteconnections/get-loggedonrdpuser/)           |
| RemoteConnections | [Get-RDPStatus](/useradminmodule/remoteconnections/get-rdpstatus/)                       |
| RemoteConnections | [Get-RDPStatusCIM](/useradminmodule/remoteconnections/get-rdpstatuscim/)                 |
| RemoteConnections | [Get-RDPStatusWMI](/useradminmodule/remoteconnections/get-rdpstatuswmi/)                 |
| RemoteConnections | [Get-RDPUserReport](/useradminmodule/remoteconnections/get-rdpuserreport/)               |
| RemoteConnections | [Logoff-Stale-RDP](/useradminmodule/remoteconnections/logoff-stale-rdp/)                 |
| RemoteConnections | [Remove-RDPUserSession](/useradminmodule/remoteconnections/remove-rdpusersession/)       |
| RemoteConnections | [Set-RDPRemotely](/useradminmodule/remoteconnections/set-rdpremotely/)                   |
| RemoteConnections | [Set-RDPStatus](/useradminmodule/remoteconnections/set-rdpstatus/)                       |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Replication

The Replication category provides PowerShell functions for managing Active Directory replication, synchronization, and directory health monitoring. These tools help administrators monitor domain controller replication status, troubleshoot replication issues, and ensure proper synchronization between AD and Azure AD. Critical for maintaining directory service health and ensuring consistent data across domain environments.

| Category    | Function                                                                                |
| :---------- | :-------------------------------------------------------------------------------------- |
| Replication | [Get-ComputerReplicationStatus](/useradminmodule/replication/get-computerreplicationstatus/) |
| Replication | [Get-DCDIAGResults](/useradminmodule/replication/get-dcdiagresults/)                         |
| Replication | [Get-SysvolReplicationInfo](/useradminmodule/replication/get-sysvolreplicationinfo/)         |
| Replication | [Get-UserReplicationStatus](/useradminmodule/replication/get-userreplicationstatus/)         |
| Replication | [New-SecurePassword](/useradminmodule/replication/new-securepassword/)                       |
| Replication | [Sync-ADwithAAD](/useradminmodule/replication/sync-adwithaad/)                               |
| Replication | [Sync-DomainController](/useradminmodule/replication/sync-domaincontroller/)                 |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Security

The Security category contains PowerShell functions for managing system security, encryption, and compliance. These tools cover BitLocker encryption management, security policy configuration, permission auditing, and various security-related administrative tasks. Essential for security administrators and IT teams responsible for maintaining system security posture and ensuring compliance with security standards.

| Category | Function                                                                                        |
| :------- | :---------------------------------------------------------------------------------------------- |
| Security | [Disable-CiscoSecure](/useradminmodule/security/disable-ciscosecure/)                             |
| Security | [Enable-CiscoSecure](/useradminmodule/security/enable-ciscosecure/)                               |
| Security | [Get-CimNamespacePermissions](/useradminmodule/security/get-cimnamespacepermissions/)             |
| Security | [Get-CimNamespacePermissionsRemote](/useradminmodule/security/get-cimnamespacepermissionsremote/) |
| Security | [Get-CimPermsLocal](/useradminmodule/security/get-cimpermslocal/)                                 |
| Security | [Get-InsecureLDAPBinds](/useradminmodule/security/get-insecureldapbinds/)                         |
| Security | [Get-NameSpacePerms](/useradminmodule/security/get-namespaceperms/)                               |
| Security | [Get-Namespaces](/useradminmodule/security/get-namespaces/)                                       |
| Security | [Get-PasswordAttempts](/useradminmodule/security/get-passwordattempts/)                           |
| Security | [Get-PasswordAttempts2](/useradminmodule/security/get-passwordattempts2/)                         |
| Security | [Get-PSGalleryItemsForAuthor](/useradminmodule/security/get-psgalleryitemsforauthor/)             |
| Security | [Get-VpnFailoverEventLogs](/useradminmodule/security/get-vpnfailovereventlogs/)                   |
| Security | [Invoke-CiscoSecureManagement](/useradminmodule/security/invoke-ciscosecuremanagement/)           |
| Security | [Invoke-PasswordifyPhrase](/useradminmodule/security/invoke-passwordifyphrase/)                   |
| Security | [New-DynamicParameter](/useradminmodule/security/new-dynamicparameter/)                           |
| Security | [New-KrbtgtKeys](/useradminmodule/security/new-krbtgtkeys/)                                       |
| Security | [Set-CIMPermissions](/useradminmodule/security/set-cimpermissions/)                               |
| Security | [Set-LDAPSBinding](/useradminmodule/security/set-ldapsbinding/)                                   |
| Security | [Update-SSLCertificate](/useradminmodule/security/update-sslcertificate/)                         |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Shell

The Shell category provides PowerShell functions for shell productivity, utilities, and general-purpose tools. These functions enhance the PowerShell experience with features like history management, time conversions, console configuration, and various utility operations. Perfect for PowerShell users looking to improve their shell workflow and productivity.

| Category | Function                                                                                              |
| :------- | :---------------------------------------------------------------------------------------------------- |
| Shell    | [Check-BirthdayCountdown](/useradminmodule/shell/check-birthdaycountdown/)                           |
| Shell    | [Convert-TimeUnit](/useradminmodule/shell/convert-timeunit/)                                         |
| Shell    | [Copy-History](/useradminmodule/shell/copy-history/)                                                 |
| Shell    | [Get-BankHolidays](/useradminmodule/shell/get-bankholidays/)                                         |
| Shell    | [Get-ConsoleConfig](/useradminmodule/shell/get-consoleconfig/)                                       |
| Shell    | [Get-DayOfWeek](/useradminmodule/shell/get-dayofweek/)                                               |
| Shell    | [Get-DSTInfo](/useradminmodule/shell/get-dstinfo/)                                                   |
| Shell    | [Get-DuckDuckGoSearch](/useradminmodule/shell/get-duckduckgosearch/)                                 |
| Shell    | [Get-ExportedFunction](/useradminmodule/shell/get-exportedfunction/)                                 |
| Shell    | [Get-FriendlySize](/useradminmodule/shell/get-friendlysize/)                                         |
| Shell    | [Get-GoogleDirections](/useradminmodule/shell/get-googledirections/)                                 |
| Shell    | [Get-GoogleSearch](/useradminmodule/shell/get-googlesearch/)                                         |
| Shell    | [Get-Icon](/useradminmodule/shell/get-icon/)                                                         |
| Shell    | [Get-LastBootTime](/useradminmodule/shell/get-lastboottime/)                                         |
| Shell    | [Get-LastCommands](/useradminmodule/shell/get-lastcommands/)                                         |
| Shell    | [Get-LastRebootEvent](/useradminmodule/shell/get-lastrebootevent/)                                   |
| Shell    | [Get-LastxOfMonth](/useradminmodule/shell/get-lastxofmonth/)                                         |
| Shell    | [Get-LoadedFunctions](/useradminmodule/shell/get-loadedfunctions/)                                   |
| Shell    | [Get-LocationStack](/useradminmodule/shell/get-locationstack/)                                       |
| Shell    | [Get-MonthOfYear](/useradminmodule/shell/get-monthofyear/)                                           |
| Shell    | [Get-MoreCowbell](/useradminmodule/shell/get-morecowbell/)                                           |
| Shell    | [Get-MyHistory](/useradminmodule/shell/get-myhistory/)                                               |
| Shell    | [Get-MyIpWtf](/useradminmodule/shell/get-myipwtf/)                                                   |
| Shell    | [Get-NextPayDay](/useradminmodule/shell/get-nextpayday/)                                             |
| Shell    | [Get-OutlookAppointments](/useradminmodule/shell/get-outlookappointments/)                           |
| Shell    | [Get-PatchTue](/useradminmodule/shell/get-patchtue/)                                                 |
| Shell    | [Get-PayDay](/useradminmodule/shell/get-payday/)                                                     |
| Shell    | [Get-ProfileFunctions](/useradminmodule/shell/get-profilefunctions/)                                 |
| Shell    | [Get-RageQuitEvents](/useradminmodule/shell/get-ragequitevents/)                                     |
| Shell    | [GitHubCopilotAlias](/useradminmodule/shell/githubcopilotalias/)                                     |
| Shell    | [HomePowerShell_profile](/useradminmodule/shell/homepowershell-profile/)                             |
| Shell    | [Initialize-Module](/useradminmodule/shell/initialize-module/)                                       |
| Shell    | [Install-LatestPWSH7](/useradminmodule/shell/install-latestpwsh7/)                                   |
| Shell    | [Install-ModuleIfNotPresent](/useradminmodule/shell/install-moduleifnotpresent/)                     |
| Shell    | [Ifnotpwsh7](/useradminmodule/shell/ifnotpwsh7/)                                                     |
| Shell    | [Install-PSTools](/useradminmodule/shell/install-pstools/)                                           |
| Shell    | [Install-RequiredModules](/useradminmodule/shell/install-requiredmodules/)                           |
| Shell    | [Install-WinGet](/useradminmodule/shell/install-winget/)                                             |
| Shell    | [IsAdmin](/useradminmodule/shell/isadmin/)                                                           |
| Shell    | [Lock-Screen](/useradminmodule/shell/lock-screen/)                                                   |
| Shell    | [Lock-UserInput](/useradminmodule/shell/lock-userinput/)                                             |
| Shell    | [Microsoft.PowerShell_profile](/useradminmodule/shell/microsoft-powershell-profile/)                 |
| Shell    | [Microsoft.PowerShell_profile_example](/useradminmodule/shell/microsoft-powershell-profile-example/) |
| Shell    | [New-AdminTerminal](/useradminmodule/shell/new-adminterminal/)                                       |
| Shell    | [New-AdminShell](/useradminmodule/shell/new-adminshell/)                                             |
| Shell    | [New-CopilotPrompt](/useradminmodule/shell/new-copilotprompt/)                                       |
| Shell    | [New-CountdownDate](/useradminmodule/shell/new-countdowndate/)                                       |
| Shell    | [New-Greeting](/useradminmodule/shell/new-greeting/)                                                 |
| Shell    | [New-Greeting1](/useradminmodule/shell/new-greeting1/)                                               |
| Shell    | [New-Greeting2](/useradminmodule/shell/new-greeting2/)                                               |
| Shell    | [New-GitDrives](/useradminmodule/shell/new-gitdrives/)                                               |
| Shell    | [New-ModulePSM1](/useradminmodule/shell/new-modulepsm1/)                                             |
| Shell    | [New-PSDrives](/useradminmodule/shell/new-psdrives/)                                                 |
| Shell    | [New-PSM1Module](/useradminmodule/shell/new-psm1module/)                                             |
| Shell    | [New-QotD](/useradminmodule/shell/new-qotd/)                                                         |
| Shell    | [New-Shell](/useradminmodule/shell/new-shell/)                                                       |
| Shell    | [New-StreamDeckShell](/useradminmodule/shell/new-streamdeckshell/)                                   |
| Shell    | [PersonalModules](/useradminmodule/shell/personalmodules/)                                           |
| Shell    | [RageQuit](/useradminmodule/shell/ragequit/)                                                         |
| Shell    | [Restart-PowershellProfile](/useradminmodule/shell/restart-powershellprofile/)                       |
| Shell    | [Restart-Profile](/useradminmodule/shell/restart-profile/)                                           |
| Shell    | [Restore-Location](/useradminmodule/shell/restore-location/)                                         |
| Shell    | [Search-Google](/useradminmodule/shell/search-google/)                                               |
| Shell    | [Select-FolderLocation](/useradminmodule/shell/select-folderlocation/)                               |
| Shell    | [Set-ConsoleConfig](/useradminmodule/shell/set-consoleconfig/)                                       |
| Shell    | [Set-DisplayIsAdmin](/useradminmodule/shell/set-displayisadmin/)                                     |
| Shell    | [Set-Home](/useradminmodule/shell/set-home/)                                                         |
| Shell    | [Set-PromptisAdmin](/useradminmodule/shell/set-promptisadmin/)                                       |
| Shell    | [Show-IsAdminOrNot](/useradminmodule/shell/show-isadminornot/)                                       |
| Shell    | [Show-Notification](/useradminmodule/shell/show-notification/)                                       |
| Shell    | [Show-RandomCommand](/useradminmodule/shell/show-randomcommand/)                                     |
| Shell    | [Show-RandomHelpAbout](/useradminmodule/shell/show-randomhelpabout/)                                 |
| Shell    | [Start-PSCountdown](/useradminmodule/shell/start-pscountdown/)                                       |
| Shell    | [Stop-Outlook](/useradminmodule/shell/stop-outlook/)                                                 |
| Shell    | [Update-PowerShell](/useradminmodule/shell/update-powershell/)                                       |
| Shell    | [WorkPowerShell_profile](/useradminmodule/shell/workpowershell-profile/)                             |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## ShutdownCommands

The ShutdownCommands category offers PowerShell functions for managing system shutdowns, restarts, and scheduled power operations. These tools enable administrators to remotely shutdown or restart computers, schedule maintenance windows, and handle power-related operations across multiple systems. Essential for IT teams managing system maintenance and power management in enterprise environments.

| Category         | Function                                                                                              |
| :--------------- | :---------------------------------------------------------------------------------------------------- |
| ShutdownCommands | [Get-RemoteComputerScheduledShutdown](/useradminmodule/shutdowncommands/get-remotecomputerscheduledshutdown/)   |
| ShutdownCommands | [Get-ShutdownExample](/useradminmodule/shutdowncommands/get-shutdownexample/)                                   |
| ShutdownCommands | [Invoke-RemoteComputerShutdown](/useradminmodule/shutdowncommands/invoke-remotecomputershutdown/)               |
| ShutdownCommands | [Restart-ProjectComputer](/useradminmodule/shutdowncommands/restart-projectcomputer/)                           |
| ShutdownCommands | [New-PowerOutage](/useradminmodule/shutdowncommands/new-poweroutage/)                                           |
| ShutdownCommands | [Schedule-Shutdown](/useradminmodule/shutdowncommands/schedule-shutdown/)                                       |
| ShutdownCommands | [Start-RemoteComputerShutdownSchedule](/useradminmodule/shutdowncommands/start-remotecomputershutdownschedule/) |
| ShutdownCommands | [Stop-RemoteComputerShutdown](/useradminmodule/shutdowncommands/stop-remotecomputershutdown/)                   |
| ShutdownCommands | [Wait-RemoteComputerShutdown](/useradminmodule/shutdowncommands/wait-remotecomputershutdown/)                   |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Teams

The Teams category provides PowerShell functions for managing Microsoft Teams installations and optimizing performance. These tools help administrators clear Teams cache, manage Teams folders, handle image conversions for Teams, and monitor Teams installations across systems. Essential for IT support teams managing Teams deployments and troubleshooting performance issues.

| Category | Function                                                                                        |
| :------- | :---------------------------------------------------------------------------------------------- |
| Teams    | [Clear-TeamsCache](/useradminmodule/teams/clear-teamscache/)                                   |
| Teams    | [Convert-ImageForTeams](/useradminmodule/teams/convert-imageforteams/)                         |
| Teams    | [Get-MSTeamsPhone](/useradminmodule/teams/get-msteamsphone/)                                   |
| Teams    | [Get-TeamsFolderStructure](/useradminmodule/teams/get-teamsfolderstructure/)                   |
| Teams    | [Get-TeamsVersion](/useradminmodule/teams/get-teamsversion/)                                   |
| Teams    | [Get-UsersTeamsFolders](/useradminmodule/teams/get-usersteamsfolders/)                         |
| Teams    | [Initialize-TeamsLocalUploadFolder](/useradminmodule/teams/initialize-teamslocaluploadfolder/) |
| Teams    | [New-MSTeamsPhone](/useradminmodule/teams/new-msteamsphone/)                                   |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Testing

The Testing category contains PowerShell functions for system validation, connectivity testing, and diagnostic operations. These tools help administrators verify system configurations, test network connectivity, validate Active Directory replication, and perform various system health checks. Essential for IT teams conducting system audits and troubleshooting connectivity or configuration issues.

| Category | Function                                                                        |
| :------- | :------------------------------------------------------------------------------ |
| Testing  | [Test-ADReplication](/useradminmodule/testing/test-adreplication/)               |
| Testing  | [Test-CiscoSecure](/useradminmodule/testing/test-ciscosecure/)                   |
| Testing  | [Test-Computer](/useradminmodule/testing/test-computer/)                         |
| Testing  | [Test-ContactEmail](/useradminmodule/testing/test-contactemail/)                 |
| Testing  | [Test-DeathstarBackUp](/useradminmodule/testing/test-deathstarbackup/)           |
| Testing  | [Test-DisplayName](/useradminmodule/testing/test-displayname/)                   |
| Testing  | [test-dnsrecord](/useradminmodule/testing/test-dnsrecord/)                       |
| Testing  | [Test-DNSRecord](/useradminmodule/testing/test-dnsrecord/)                       |
| Testing  | [Test-DnsRecordEndpoints](/useradminmodule/testing/test-dnsrecordendpoints/)     |
| Testing  | [Test-DomainMailRecords](/useradminmodule/testing/test-domainmailrecords/)       |
| Testing  | [Test-ExchangeConnection](/useradminmodule/testing/test-exchangeconnection/)     |
| Testing  | [Test-ExchangeDNSRR](/useradminmodule/testing/test-exchangednsrr/)               |
| Testing  | [Test-FileExists](/useradminmodule/testing/test-fileexists/)                     |
| Testing  | [Test-FolderExists](/useradminmodule/testing/test-folderexists/)                 |
| Testing  | [Test-ifContactExists](/useradminmodule/testing/test-ifcontactexists/)           |
| Testing  | [Test-IsAdmin](/useradminmodule/testing/test-isadmin/)                           |
| Testing  | [Test-LDAPconnection](/useradminmodule/testing/test-ldapconnection/)             |
| Testing  | [Test-NetworkPort](/useradminmodule/testing/test-networkport/)                   |
| Testing  | [Test-O365EmailExists](/useradminmodule/testing/test-o365emailexists/)           |
| Testing  | [Test-OpenPorts](/useradminmodule/testing/test-openports/)                       |
| Testing  | [Test-OpenPortsWitch](/useradminmodule/testing/test-openportswitch/)             |
| Testing  | [Test-ProfileExists](/useradminmodule/testing/test-profileexists/)               |
| Testing  | [Test-RemoteTimeSettings](/useradminmodule/testing/test-remotetimesettings/)     |
| Testing  | [Test-SamAccountName](/useradminmodule/testing/test-samaccountname/)             |
| Testing  | [Test-ServerRolePortGroup](/useradminmodule/testing/test-serverroleportgroup/)   |
| Testing  | [Test-SMB1Enabled](/useradminmodule/testing/test-smb1enabled/)                   |
| Testing  | [Test-SSLProtocols](/useradminmodule/testing/test-sslprotocols/)                 |
| Testing  | [Test-Surname](/useradminmodule/testing/test-surname/)                           |
| Testing  | [Test-TLSConnection](/useradminmodule/testing/test-tlsconnection/)               |
| Testing  | [Test-TransmissionSettings](/useradminmodule/testing/test-transmissionsettings/) |
| Testing  | [Test-UserExists](/useradminmodule/testing/test-userexists/)                     |
| Testing  | [Test-WebsiteAvailability](/useradminmodule/testing/test-websiteavailability/)   |


<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Utilities

The Utilities category provides a collection of general-purpose PowerShell helper functions and utilities. These tools assist with common tasks like data conversion, error handling, file cleanup, and various administrative helper operations. Perfect for PowerShell developers and administrators who need reliable utility functions for everyday scripting tasks.

| Category  | Function                                                                              |
| :-------- | :------------------------------------------------------------------------------------ |
| Utilities | [Blank-Page](/useradminmodule/utilities/blank-page/)                                     |
| Utilities | [Cleanup-TestFiles](/useradminmodule/utilities/cleanup-testfiles/)                       |
| Utilities | [ConvertFrom-Text](/useradminmodule/utilities/convertfrom-text/)                         |
| Utilities | [Export-Functions](/useradminmodule/utilities/export-functions/)                         |
| Utilities | [Export-SingleFunction](/useradminmodule/utilities/export-singlefunction/)               |
| Utilities | [Get-AdminURL](/useradminmodule/utilities/get-adminurl/)                                 |
| Utilities | [Get-DotNetVersion](/useradminmodule/utilities/get-dotnetversion/)                       |
| Utilities | [Get-DownloadPercent](/useradminmodule/utilities/get-downloadpercent/)                   |
| Utilities | [Get-InstalledDotNetVersions](/useradminmodule/utilities/get-installeddotnetversions/)   |
| Utilities | [Get-KMSclientActivations](/useradminmodule/utilities/get-kmsclientactivations/)         |
| Utilities | [Get-KMSserverActivations](/useradminmodule/utilities/get-kmsserveractivations/)         |
| Utilities | [Get-LastInstalledApplication](/useradminmodule/utilities/get-lastinstalledapplication/) |
| Utilities | [Get-Lines](/useradminmodule/utilities/get-lines/)                                       |
| Utilities | [Get-PendingUpdate](/useradminmodule/utilities/get-pendingupdate/)                       |
| Utilities | [Get-RestartHistory](/useradminmodule/utilities/get-restarthistory/)                     |
| Utilities | [Get-RunOnceRegKeys](/useradminmodule/utilities/get-runonceregkeys/)                     |
| Utilities | [Get-RunRegKeys](/useradminmodule/utilities/get-runregkeys/)                             |
| Utilities | [Get-ScriptFunctionNames](/useradminmodule/utilities/get-scriptfunctionnames/)           |
| Utilities | [Get-ServerInstalledFeatures](/useradminmodule/utilities/get-serverinstalledfeatures/)   |
| Utilities | [Get-ServerTimeZone](/useradminmodule/utilities/get-servertimezone/)                     |
| Utilities | [Get-SpeedTestServers](/useradminmodule/utilities/get-speedtestservers/)                 |
| Utilities | [Get-TimeSource](/useradminmodule/utilities/get-timesource/)                             |
| Utilities | [TimeZoneFunctions](/useradminmodule/utilities/timezonefunctions/)                       |
| Utilities | [Get-TimeZoneID](/useradminmodule/utilities/get-timezoneid/)                             |
| Utilities | [Get-UserProfiles](/useradminmodule/utilities/get-userprofiles/)                         |
| Utilities | [Get-W32TimeConfiguration](/useradminmodule/utilities/get-w32timeconfiguration/)         |
| Utilities | [Get-W32TimeServiceStatus](/useradminmodule/utilities/get-w32timeservicestatus/)         |
| Utilities | [Get-W32TimeSource](/useradminmodule/utilities/get-w32timesource/)                       |
| Utilities | [Get-W32TimeStripchartResults](/useradminmodule/utilities/get-w32timestripchartresults/) |
| Utilities | [Import-CSVCustom](/useradminmodule/utilities/import-csvcustom/)                         |
| Utilities | [Invoke-BatchArray](/useradminmodule/utilities/invoke-batcharray/)                       |
| Utilities | [Invoke-WithPsGalleryStats](/useradminmodule/utilities/invoke-withpsgallerystats/)       |
| Utilities | [Measure-Lines](/useradminmodule/utilities/measure-lines/)                               |
| Utilities | [Move-FilesByType](/useradminmodule/utilities/move-filesbytype/)                         |
| Utilities | [New-Email](/useradminmodule/utilities/new-email/)                                       |
| Utilities | [New-LocalRunOnceRegKey](/useradminmodule/utilities/new-localrunonceregkey/)             |
| Utilities | [New-NTPRecord](/useradminmodule/utilities/new-ntprecord/)                               |
| Utilities | [New-SpeedTest](/useradminmodule/utilities/new-speedtest/)                               |
| Utilities | [New-SYDIDocument](/useradminmodule/utilities/new-sydidocument/)                         |
| Utilities | [PadOrTruncate](/useradminmodule/utilities/padortruncate/)                               |
| Utilities | [Remove-NTPRecord](/useradminmodule/utilities/remove-ntprecord/)                         |
| Utilities | [Remove-RunOnceRegKey](/useradminmodule/utilities/remove-runonceregkey/)                 |
| Utilities | [Remove-RunRegKey](/useradminmodule/utilities/remove-runregkey/)                         |
| Utilities | [Remove-UserProfiles](/useradminmodule/utilities/remove-userprofiles/)                   |
| Utilities | [Save-LogResults](/useradminmodule/utilities/save-logresults/)                           |
| Utilities | [Set-DNSRecord](/useradminmodule/utilities/set-dnsrecord/)                               |
| Utilities | [Set-NTPRecord](/useradminmodule/utilities/set-ntprecord/)                               |
| Utilities | [Set-RegEntry](/useradminmodule/utilities/set-regentry/)                                 |
| Utilities | [Set-RegistryShouldBe](/useradminmodule/utilities/set-registryshouldbe/)                 |
| Utilities | [Set-RemoteComputerTime](/useradminmodule/utilities/set-remotecomputertime/)             |
| Utilities | [Set-RunOnceRegKeys](/useradminmodule/utilities/set-runonceregkeys/)                     |
| Utilities | [Set-RunRegKey](/useradminmodule/utilities/set-runregkey/)                               |
| Utilities | [Set-ServerTimeZone](/useradminmodule/utilities/set-servertimezone/)                     |
| Utilities | [Set-TimeZoneID](/useradminmodule/utilities/set-timezoneid/)                             |
| Utilities | [Validate-LDAPSBinding](/useradminmodule/utilities/validate-ldapsbinding/)               |
| Utilities | [Write-ProgressHelper](/useradminmodule/utilities/write-progresshelper/)                 |
| Utilities | [Write-ProgressPipeline](/useradminmodule/utilities/write-progresspipeline/)             |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Virtualization

The Virtualization category offers PowerShell functions for managing virtualized environments, containers, and system monitoring. These tools enable administrators to monitor Docker containers, track system uptime, generate disk and drive space reports, and manage virtualized infrastructure. Essential for system administrators working with containerized applications and virtual machine environments.

| Category       | Function                                                                          |
| :------------- | :-------------------------------------------------------------------------------- |
| Virtualization | [Get-DiskReport](/useradminmodule/virtualization/get-diskreport/)                         |
| Virtualization | [Get-DockerStatsSnapshot](/useradminmodule/virtualization/get-dockerstatssnapshot/)       |
| Virtualization | [Get-DriveSpaceReport](/useradminmodule/virtualization/get-drivespacereport/)             |
| Virtualization | [Get-ServerInfo](/useradminmodule/virtualization/get-serverinfo/)                         |
| Virtualization | [Get-UptimeResult](/useradminmodule/virtualization/get-uptimeresult/)                     |
| Virtualization | [Get-UptimeV1](/useradminmodule/virtualization/get-uptimev1/)                             |
| Virtualization | [Get-VMGuestHardwareDetails](/useradminmodule/virtualization/get-vmguesthardwaredetails/) |
| Virtualization | [Get-VMInfoCustom](/useradminmodule/virtualization/get-vminfocustom/)                     |
| Virtualization | [Get-VMInformation](/useradminmodule/virtualization/get-vminformation/)                   |
| Virtualization | [Get-VMInformationPlus](/useradminmodule/virtualization/get-vminformationplus/)           |
| Virtualization | [Get-WMIHardwareOSInfo](/useradminmodule/virtualization/get-wmihardwareosinfo/)           |
| Virtualization | [VMWareHealthcheck](/useradminmodule/virtualization/vmwarehealthcheck/)                   |
| Virtualization | [New-WindowsSandbox](/useradminmodule/virtualization/new-windowssandbox/)                 |
| Virtualization | [VMWareHealthcheck](/useradminmodule/virtualization/vmwarehealthcheck/)                   |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

## Weather

The Weather category provides PowerShell functions for retrieving weather information and forecasts. These tools integrate with weather APIs to provide current conditions and detailed weather data. Perfect for system administrators who want to incorporate weather data into their scripts or need location-based weather information for operational purposes.

| Category | Function                                                        |
| :------- | :-------------------------------------------------------------- |
| Weather  | [Get-Weather](/useradminmodule/weather/get-weather/)             |
| Weather  | [Get-WeatherDetail](/useradminmodule/weather/get-weatherdetail/) |
| Weather  | [Get-TempHumidData](/useradminmodule/weather/get-temphumiddata/) |

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

> **⚠️ Important Disclaimer**  
> These PowerShell scripts are provided as-is for educational and administrative purposes. While I've tested them in various environments, using them in production systems is entirely at your own risk. I cannot be held responsible for any unintended consequences, data loss, or system disruptions that may occur.  
> Remember: PowerShell is like a lightsaber - powerful but potentially dangerous in the wrong hands. Use responsibly, and may the Force be with you! 🛡️

---
