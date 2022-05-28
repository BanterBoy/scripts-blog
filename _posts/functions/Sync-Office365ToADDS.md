---
layout: post
title: Sync-Office365ToADDS.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
	.NOTES
	===========================================================================
	 Created on:   	11/15/2018 11:56 AM
	 Created by:   	Bradley Wyatt
	 Filename:      Sync-Office365ToADDS.ps1
	===========================================================================
	.REQUIREMENTS
		MSONLINE Module (Install-Module MSOnline)
			*Will install it automatically if not present
	.DESCRIPTION
		The PowerShell function will connect to your Office 365 / AzureAD and can re-create your Users, Groups, and Contacts in Active Directory.
		This is extremly helpful if you are looking to change your identity source from Office 365 (AzureAD) to Active Directory and then have Active Directory sync up to Office 365.

		This will also re-create Distribution, Security, and Mail-Enabled Security Groups and also populate the membership and owner (managed by). Distribution and Mail-Enabled security groups will SMTP match when you configure AADConnect.

		Attributes:
		If Azure AD finds an object where the attribute values are the same for an object coming from Connect (Active Directory) and that it is already present in Azure AD, then the object in Azure AD is taken over by Connect.
		The previously cloud-managed object is flagged as on-premises managed. All attributes in Azure AD with a value in on-premises AD are overwritten with the on-premises value. The exception is when an attribute has a NULL value on-premises.
		In this case, the value in Azure AD remains, but you can still only change it on-premises to something else.

		USER ATTRIBUTES IT WILL COPY OVER
		- First Name
		- Last Name
		- Display Name
		- User Principal Name
		- Email Address
		- Proxy Addresses
			- SMTP
			- SPO
			- SIP
			- EUM
		- Office
		- Title
		- Department
		- City
		- Office Phone (telephone number)

		MAIL CONTACT ATTRIBUTES IT WILL COPY OVER
		- Display Name
		- External Email
		- Proxy Addresses
		- First Name
		- Last Name

		DISTRIBUTION GROUP ATTRIBUTES IT WILL COPY OVER
		- Name
		- Display Name
		- Primary SmtpAddress
		- Proxyaddresses
		- Description
		- Members
		- Group Owner (Managed By)

		MAIL-ENABLED SECURITY GROUP ATTRIBUTES IT WILL COPY OVER
		- Name
		- Display Name
		- Primary SmtpAddress
		- Description
		- Members
		- Group Owner (Managed By)

		SECURITY GROUP ATTRIBUTES IT WILL COPY OVER
		- Name
		- Display Name
		- Primary SmtpAddress
		- Description
		- Members
		- Group Owner (Managed By)

	.PARAMETER SyncUsers
		[switch] Syncs Office 365 Users to ADDS

	.PARAMETER UsersOU
		[string] Optional. Can specify which OU to create the users in

	.PARAMETER PasswordForAllUsers
		[string] Required if you use the SyncUsers switch. Specifies the password that will be set for all users that are created. Converts the plain text string to secure.string

	.PARAMETER DomainMoveUsersToOU
		[switch] Optional. Will move users to an OU that matches the domain name in their UPN. If the UPN is thelazyadministrator.com it will find an OU with the name "thelazyadministrator" and move the user there. If the OU is not present it will keep the user in the default Users OU

	.PARAMETER SyncContacts
		[switch] Syncs Office 365 Mail Contacts to ADDS

	.PARAMETER ContactsOU
		[string] Optional. Can specify which OU to create the mail contacts in

	.PARAMETER SyncDistributionGroups
		[switch] Syncs Office 365 Distribution Groups to ADDS

	.PARAMETER DistributionGroupsOU
		[string] Optional. Can specify which OU to create the Distribution Groups in

	.PARAMETER SyncMailEnabledSecurityGroups
		[switch] Syncs Office 365 Mail Enabled Security Groups to ADDS

	.PARAMETER MailEnabledSecurityGroupsOU
		[string] Optional. Can specify which OU to create the Mail-Enabled Security Groups in

	.PARAMETER SyncSecurityGroups
		[switch] Syncs Office 365 Security Groups to ADDS

	.PARAMETER DistributionGroupsOU
		[string] Optional. Can specify which OU to create the Security Groups in

	.EXAMPLE
		Sync-Office365ToADDS -SyncUsers -PaswordForAllUsers "Temp123!"

	.EXAMPLE
		Sync-Office365ToADDS -SyncContacts -SyncDistributionGroups

	.EXAMPLE
		Sync-Office365ToADDS -SyncSecurityGroups -SecurityGroupsOU "OU=Users,OU=bwya77,DC=lazyadmin,DC=com"

	.EXAMPLE
		Sync-Office365ToADDS -SyncUsers -PaswordForAllUsers "Temp123" "OU=Users,OU=Chicago,DC=lazyadmin,DC=com"

#>
function Sync-Office365ToADDS {
	[CmdletBinding()]
	Param (
		[switch]$SyncUsers,
		[string]$UsersOU,
		[switch]$DomainMoveUsersToOU,
		[string]$PasswordForAllUsers,
		[switch]$SyncContacts,
		[string]$ContactsOU,
		[switch]$DomainMoveContactsToOU,
		[switch]$SyncDistributionGroups,
		[string]$DistributionGroupsOU,
		[switch]$DomainMoveDistributionGroupsToOU,
		[switch]$SyncMailEnabledSecurityGroups,
		[string]$MailEnabledSecurityGroupsOU,
		[switch]$DomainMoveMailEnabledSecurityGroupsToOU,
		[switch]$SyncSecurityGroups,
		[string]$SecurityGroupsOU
	)

	function Connect-O365 {
		$UserCredential = Get-Credential
		$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell/" -Credential $UserCredential -Authentication Basic -AllowRedirection
		Import-PSSession $Session
		Connect-MsolService -Credential $UserCredential
	}

	If (($SyncUsers -eq $True) -and (($PasswordForAllUsers).Length -lt 1)) {
		Do {
			$PasswordForAllUsers = Read-Host -Prompt "Please enter a password that will be set for all users synced from Office 365. This password will be converted to secure.string"

		}
		Until (($PasswordForAllUsers).Length -gt 0)
	}

	Write-Host "Checking to see if already connected to AzureAD"
	$AzureConnect = Get-AzureADTenantDetail -ErrorAction SilentlyContinue
	If ($null -eq $AzureConnect) {

		Write-Host "Checking to see if AzureAD Module is present" -ForegroundColor Green
		$AzureADCheck = get-module -ListAvailable | Where-object { $_.name -like "*azuread*" }
		If ($Null -eq $AzureADCheck) {
			Write-Warning "AzureAd module is not present, attempting to install it"
			Install-Module AzureAd -Force

		}
		Write-Host "Importing AzureAd Module"
		Import-Module AzureAd

		Write-Host "Connecting to AzureAd"
		Connect-AzureAD
	}

	$MSOnlineConnect = Get-MsolCompanyInformation -ErrorAction SilentlyContinue
	If ($null -eq $MSOnlineConnect) {
		Write-Host "Checking to see if MSOnline Module is present" -ForegroundColor Green
		$MSOnlineCheck = get-module -ListAvailable | Where-object { $_.name -like "*msonline*" }
		If ($Null -eq $MSOnlineCheck) {
			Write-Warning "MSOnline module is not present, attempting to install it"
			Install-Module Msonline -Force

		}
		Write-Host "Importing MSOnline Module"
		Import-Module MSOnline

		Write-Host "Connecting to MSOnline" -ForegroundColor DarkMagenta
		Connect-O365

	}

	Write-Host "###############################" -ForegroundColor Green
	Write-Host "#         DOMAINS             #" -ForegroundColor Green
	Write-Host "###############################" -ForegroundColor Green

	#Get all domains in Office 365 tenant, do not grab the onmicrosoft domain. Add all the Domains as valid UPN suffixes in AD
	$Domains = Get-MsolDomain | Where-Object { $_.Name -notlike "*.onmicrosoft.com*" } | Select-Object -ExpandProperty Name
	foreach ($Domain in $Domains) {
		Write-Host "Adding $Domain as a valid UPN suffix"
		#If the UPN suffix is already present it will not error or cause issues
		Get-ADForest | Set-ADForest -UPNSuffixes @{ add = "$Domain" }
	}
	If ($SyncUsers -eq $true) {
		Write-Host "###############################" -ForegroundColor Green
		Write-Host "#          USERS              #" -ForegroundColor Green
		Write-Host "###############################" -ForegroundColor Green

		$Password = ConvertTo-SecureString $Passwordforallusers -AsPlainText -Force

		#Get all of the Office 365 Users
		#Conditional to remove the account AADConnect will use. You will see this account synced if Office 365 was previously synced to Office 365. This account will be created automatically when you use express settings in the AADConnect wizard
		$Users = Get-Msoluser -All | Where-Object { $_.DisplayName -notlike "On-Premises Directory Synchronization Service Account" }
		foreach ($User in $Users) {
			Write-Host "Working on the user, '$($User.DisplayName)'" -ForegroundColor Green

			Write-Host "Storing the user in a var"
			$ADUser = Get-ADUser -Filter * | Where-Object { $_.Name -eq $user.DisplayName } -ErrorAction SilentlyContinue
			Write-Host "Checking to see if $($user.displayname) is already present in Active Directory"
			If ($Null -ne $ADUser) {
				write-host "$($user.displayname) is present in Active Directory, Skipping!"
			}
			Else {

				write-host "$($user.displayname) is not present in Active Directory"


				Write-Host "Working on $($User.DisplayName)..." -ForegroundColor Yellow

				#Var for priamry e-mail address
				$PrimEMail = Get-MSOLUser -UserPrincipalName $user.UserPrincipalName | Select-Object -ExpandProperty ProxyAddresses | Where-Object { $_ -cmatch '^SMTP:' }
				#Var for all the alias e-mail addresses
				$AliasEMails = Get-MSOLUser -UserPrincipalName $user.UserPrincipalName | Select-Object -ExpandProperty ProxyAddresses | Where-Object { $_ -cmatch 'smtp:' }
				#Var for all the SPO e-mail addresses
				$SPOs = Get-Mailbox -identity $user.UserPrincipalName | Select-Object -ExpandProperty EmailAddresses | Where-Object { $_ -cmatch '^SPO:' }
				#Var for all the EUM e-mail addresses
				$CEUMs = Get-Mailbox -identity $user.UserPrincipalName | Select-Object -ExpandProperty EmailAddresses | Where-Object { $_ -cmatch '^EUM:' }
				#Var for all the lowercase eum e-mail addresses
				$LEUMs = Get-Mailbox -identity $user.UserPrincipalName | Select-Object -ExpandProperty EmailAddresses | Where-Object { $_ -cmatch 'eum:' }
				#Var for all the SIP e-mail addresses
				$SIPs = Get-Mailbox -identity $user.UserPrincipalName | Select-Object -ExpandProperty EmailAddresses | Where-Object { $_ -cmatch '^SIP:' }

				$SamAccountName = $user.UserPrincipalName.split("@") | Select-Object -First 1

				Write-Host "Creating the user, '$($User.DisplayName)' as an Active Directory user... "
				If ($Null -ne $PrimEMail) {

					New-ADUser -Name $User.DisplayName -GivenName $user.Firstname -Surname $user.LastName -userprincipalName $user.UserPrincipalName -EmailAddress $PrimEMail.replace("SMTP:", "") -Enabled $true -AccountPassword $Password -ChangePasswordAtLogon $true -SamAccountName $SamAccountName -DisplayName $User.DisplayName -Office $User.Office -Title $User.Title -Department $User.Department -City $User.City -OfficePhone $User.PhoneNumber
				}
				Else {
					New-ADUser -Name $User.DisplayName -GivenName $user.Firstname -Surname $user.LastName -userprincipalName $user.UserPrincipalName -Enabled $true -AccountPassword $Password -ChangePasswordAtLogon $true -SamAccountName $SamAccountName -DisplayName $User.DisplayName -Office $User.Office -Title $User.title -Department $User.Department -City $User.City -OfficePhone $User.PhoneNumber

				}
				$ADUser = Get-ADUser -Filter * | Where-Object { $_.Name -eq $user.DisplayName } -ErrorAction SilentlyContinue
				#Add all the proxy e-mail address to the user
				foreach ($AliasEMail in $AliasEMails) {
					Write-Host "Adding the alias $AliasEMail for user, '$($User.DisplayName)'"
					$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$AliasEMail" }
				}
				#Add all the proxy SPO addresses to the user
				foreach ($SPO in $SPOs) {
					Write-Host "Adding the SPO address $SPO for user, '$($User.DisplayName)'"
					$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$SPO" }
				}
				#Add all the proxy EUM addresses to the user
				foreach ($CEUM in $CEUMs) {
					Write-Host "Adding the EUM address, '$CEUM' for user, '$($User.DisplayName)'"
					$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$CEUM" }
				}
				#Add all the proxy EUM addresses to the user
				foreach ($LEUM in $LEUMs) {
					Write-Host "Adding the EUM address, '$LEUM' for user, '$($User.DisplayName)'"
					$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$LEUM" }
				}
				#Add all the proxy SIP addresses to the user
				foreach ($SIP in $SIPs) {
					Write-Host "Adding the SIP address, '$SIP' for user, '$($User.DisplayName)'"
					$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$SIP" }
				}

				#Set the primary e-mail address
				Write-Host "Adding the primary email address $PrimEMail for $($User.DisplayName)"
				$ADUser | Set-ADUser -Add @{ Proxyaddresses = "$PrimEMail" }
			}

			If ($UsersOU -like "*OU*") {
				Write-Host "Moving the user, '$($User.DisplayName)' to the OU at $UsersOU"
				Move-ADObject -Identity $ADUser.ObjectGuid -TargetPath $UsersOU
			}
			If ($DomainMoveUsersToOU -eq $true) {
				#Grab users UPN Domain
				Write-Host "Finding the UPN Domain for the user, '$($User.DisplayName)'"
				$UserUPNDomain = ((($User).UserPrincipalName).Split("@") | Select-Object -Last 1).Split(".") | Select-Object -First 1
				Write-Host "The domain is $UserUPNDomain"
				Write-Host "Finding an OU that contains $UserUPNDomain"
				$DynOU = (Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -like "*$UserUPNDomain*" } -ErrorAction SilentlyContinue).DistinguishedName
				If ($null -eq $DynOU) {
					Write-Host "No OU was found to move $($User.DisplayName) to. User will be at the default user creation OU"
				}
				Else {
					Write-Host "Moving $($User.DisplayName) to $DynOU"
					Move-ADObject -Identity $ADUser.ObjectGuid -TargetPath $DynOU
				}
			}
			$ADUser = $null
		}
	}

	If ($SyncContacts -eq $true) {

		Write-Host "###############################" -ForegroundColor Green
		Write-Host "#        CONTACTS             #" -ForegroundColor Green
		Write-Host "###############################" -ForegroundColor Green

		#Mail Contacts
		$MailContacts = Get-MailContact
		Foreach ($MailContact in $MailContacts) {
			$mailcontactexternalemail = ($mailcontact.ExternalEmailAddress).split("SMTP:") | Select-Object -Last 1
			$Mailcontactfirstname = ($MailContact.displayname).split() | Select-Object -First 1
			$Mailcontactlastname = ($MailContact.displayname).split() | Select-Object -Last 1

			Write-Host "Working on the contact , '$($MailContact.displayname)'" -ForegroundColor Green

			$EContactUser = Get-ADObject -LDAPFilter "objectClass=Contact" | Where-Object { $_.Name -eq $mailcontact.DisplayName } -ErrorAction SilentlyContinue
			If ($Null -ne $EContactUser) {
				write-host "$($MailContact.displayname) is present in Active Directory, Skipping!"
			}
			Else {

				Write-Host "$($MailContact.displayname) not found in Active Directory, creating..."

				Write-Host "Creating mail contact, '$($Mailcontact.DisplayName)'" -ForegroundColor Yellow
				New-ADObject -name $mailcontact.displayname -DisplayName $mailcontact.displayname -type contact -OtherAttributes @{ 'mail' = $mailcontactexternalemail; 'givenName' = $Mailcontactfirstname; 'sn' = $Mailcontactlastname; 'Proxyaddresses' = $mailcontactexternalemail }
			}
			$EContactUser = Get-ADObject -LDAPFilter "objectClass=Contact" | Where-Object { $_.Name -eq $mailcontact.DisplayName } -ErrorAction SilentlyContinue
			If ($ContactsOU -like "*OU*") {
				Write-Host "Moving the contact, '$($MailContact.displayname)' to $ContactsOU"
				Move-ADObject $EContactUser.ObjectGuid -TargetPath $ContactsOU
			}
			If ($DomainMoveContactsToOU -eq $true) {
				#Grab contacts domain based on external email address
				Write-Host "Finding the External Email Address Domain for the contact, '$($Mailcontact.DisplayName)'"
				$ContactsDomain = (($mailcontactexternalemail).Split("@") | Select-Object -Last 1).Split(".") | Select-Object -First 1
				Write-Host "The domain is $ContactsDomain"
				Write-Host "Finding an OU that contains $ContactsDomain"
				$DynOU = (Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -like "*$ContactsDomain*" } -ErrorAction SilentlyContinue).DistinguishedName
				If ($null -eq $DynOU) {
					Write-Host "No OU was found to move $($Mailcontact.DisplayName) to. Contact will be at the default OU or at the forest root level"
				}
				Else {
					Write-Host "Moving $($Mailcontact.DisplayName) to $DynOU"
					Move-ADObject $EContactUser.ObjectGuid -TargetPath $DynOU
				}
			}
			$EContactUser = $null
		}
	}

	If ($SyncDistributionGroups -eq $true) {

		Write-Host "###############################" -ForegroundColor Green
		Write-Host "#     DISTRIBUTION GROUPS     #" -ForegroundColor Green
		Write-Host "###############################" -ForegroundColor Green

		#Distribution Groups
		$Groups = Get-DistributionGroup | Where-Object { $_.GroupType -eq "Universal" }
		foreach ($Group in $Groups) {

			Write-Host "Working on the Distribution Group, '$($Group.DisplayName)'" -ForegroundColor Green
			Write-Host "Checking to see if the Distribution Group, '$($Group.DisplayName) is already present in Active Directory'"
			Try { Get-ADGroup -Identity $Group.DisplayName -ErrorAction SilentlyContinue }
			Catch {
				Write-Host "The Distribution Group, '$($Group.DisplayName) is not present in Active Directory'" -ForegroundColor Yellow
				$GroupSAMAccountName = ($Group.DisplayName).Trim(" ")
				Write-Host "Creating the Distribution group, '$($group.DisplayName)'"
				If ($DistributionGroupsOU -like "*OU*") {
					New-ADGroup -Name $Group.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Distribution" -GroupScope Global -DisplayName $Group.DisplayName -Path $DistributionGroupsOU -OtherAttributes @{ 'mail' = $group.PrimarySmtpAddress } -Description $Group.Description
				}
				Else {
					New-ADGroup -Name $Group.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Distribution" -GroupScope Global -DisplayName $Group.DisplayName -OtherAttributes @{ 'mail' = $group.PrimarySmtpAddress } -Description $Group.Description

				}
			}
			Write-Host "Getting members for Distribution group, '$($Group.DisplayName)'"
			$Members = Get-DistributionGroupMember -Identity $Group.Name
			If ($Null -eq $Members) {
				write-host "$($Group.displayname) Has no members to add, Skipping!"
			}
			Else {
				foreach ($Member in $Members) {
					Write-Host "Adding $($Member.Name) to the group, '$($Group.Name)'"

					$AddMember = Get-ADObject -Filter * | Where-Object { $_.Name -eq $member.DisplayName }
					If ($null -eq $AddMember) {
						Write-Warning "$($Member.Name) was not found in Active Directory and could not be added as a member to $($Group.DisplayName)"
					}
					Else {
						Set-ADGroup -identity $Group.DisplayName -add @{ 'member' = $AddMember.DistinguishedName }
					}
				}
			}

			Write-Host "Getting Owner of the Distribution Group, '$($Group.DisplayName)'"
			$GroupOwner = Get-MsolGroup -ObjectId $Group.ExternalDirectoryObjectId | Select-Object @{ n = "ManagedBy"; e = { (Get-MsolUser -ObjectId (Get-MsolGroup -ObjectId $_.ObjectId).ManagedBy).UserPrincipalName } } | Select-Object -ExpandProperty ManagedBy
			Write-Host "The Owner is $GroupOwner"
			If ($null -eq $GroupOwner) {
				Write-Warning "The Distribution Group, '$($Group.DisplayName)' did not return an Owner"
			}
			Else {
				Write-Host "Finding $GroupOwner in Active Directory"
				$AddOwner = Get-ADUser -Filter * | Where-Object { $_.userprincipalname -eq "$GroupOwner" }
				If ($null -eq $AddOwner) {
					Write-Warning "$GroupOwner was not found in Active Directory and could not be added as an Owner for the group, '$($yGroup.DisplayName)'"
				}
				Else {
					Write-Host "The user, '$GroupOwner' was found in Active Directory. Adding as owner to the Distribution Group, '$($Group.DisplayName)'"
					Set-ADGroup -identity $Group.DisplayName -ManagedBy $AddOwner.DistinguishedName
				}
			}
			$AliasEMailGroups = $Group.EmailAddresses
			foreach ($AliasEMailGroup in $AliasEMailGroups) {
				Write-Host "Adding the alias $AliasEMailGroup for Distribution Group, '$($Group.DisplayName)'"
				Set-ADGroup -identity $Group.DisplayName -Add @{ Proxyaddresses = "$AliasEMailGroup" }
			}

			If ($DomainMoveDistributionGroupsToOU -eq $true) {
				#Grab Distribution Group domain based on external email address
				Write-Host "Finding the External Email Address Domain for the Distribution Group, '$($Group.DisplayName)'"
				$DistroGroupDomain = (($group.PrimarySmtpAddress).Split("@") | Select-Object -Last 1).Split(".") | Select-Object -First 1
				Write-Host "The domain is $DistroGroupDomain"
				Write-Host "Finding an OU that contains $DistroGroupDomain"
				$DynOU = (Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -like "*$DistroGroupDomain*" } -ErrorAction SilentlyContinue).DistinguishedName
				If ($null -eq $DynOU) {
					Write-Host "No OU was found to move $($Group.DisplayName) to. Contact will be at the default Users OU"
				}
				Else {
					Write-Host "Moving $($Group.DisplayName) to $DynOU"
					Get-ADGroup -identity $Group.DisplayName | Move-ADObject -TargetPath $DynOU
				}
			}
			$GroupPresent = $null
		}
	}

	If ($SyncMailEnabledSecurityGroups -eq $true) {

		Write-Host "################################" -ForegroundColor Green
		Write-Host "# MAIL-ENABLED SECURITY GROUPS #" -ForegroundColor Green
		Write-Host "################################" -ForegroundColor Green

		#Mail Enabled Security Groups
		$MailEnabledSecurityGroups = Get-DistributionGroup | Where-Object { $_.GroupType -like "*SecurityEnabled*" }
		foreach ($MailEnabledSecurityGroup in $MailEnabledSecurityGroups) {

			Write-Host "Working on the mail-enabled security group, '$($MailEnabledSecurityGroup.DisplayName)'" -ForegroundColor Green

			Write-Host "Checking to see if the Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName) is already present in Active Directory'"
			Try { Get-ADGroup -Identity $MailEnabledSecurityGroup.DisplayName }
			Catch {
				Write-Host "The Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName) is not present in Active Directory'" -ForegroundColor Yellow

				$GroupSAMAccountName = ($MailEnabledSecurityGroup.DisplayName).Trim(" ")
				Write-Host "Creating the Mail-Enabled Security group, '$($MailEnabledSecurityGroup.DisplayName)'"
				If ($MailEnabledSecurityGroupsOU -like "*OU*") {
					New-ADGroup -Name $MailEnabledSecurityGroup.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Security" -GroupScope Global -DisplayName $MailEnabledSecurityGroup.DisplayName -Path $MailEnabledSecurityGroupsOU -OtherAttributes @{ 'mail' = $MailEnabledSecurityGroup.PrimarySmtpAddress } -Description $MailEnabledSecurityGroup.Description
				}
				Else {
					New-ADGroup -Name $MailEnabledSecurityGroup.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Security" -GroupScope Global -DisplayName $MailEnabledSecurityGroup.DisplayName -OtherAttributes @{ 'mail' = $MailEnabledSecurityGroup.PrimarySmtpAddress } -Description $MailEnabledSecurityGroup.Description
				}
			}
			Write-Host "Getting members for the Mail-Enabled Security group, '$($MailEnabledSecurityGroup.DisplayName)'"
			$Members = Get-DistributionGroupMember -Identity $MailEnabledSecurityGroup.Name
			foreach ($Member in $Members) {
				Write-Host "Adding $($Member.Name) to the group, '$($MailEnabledSecurityGroup.Name)'"

				$AddMember = Get-ADObject -Filter * | Where-Object { $_.Name -eq $member.DisplayName }
				If ($null -eq $AddMember) {
					Write-Warning "$($Member.Name) was not found in Active Directory and could not be added as a member to $($MailEnabledSecurityGroup.DisplayName)"
				}
				Else {
					Set-ADGroup -identity $MailEnabledSecurityGroup.DisplayName -add @{ 'member' = $AddMember.DistinguishedName }
				}
			}

			Write-Host "Getting Owner of Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName)'"
			$MailEnabledSecurityGroupOwner = Get-MsolGroup -ObjectId $MailEnabledSecurityGroup.ExternalDirectoryObjectId | Select-Object @{ n = "ManagedBy"; e = { (Get-MsolUser -ObjectId (Get-MsolGroup -ObjectId $_.ObjectId).ManagedBy).UserPrincipalName } } | Select-Object -ExpandProperty ManagedBy
			Write-Host "The Owner is $MailEnabledSecurityGroupOwner"
			If ($null -eq $MailEnabledSecurityGroupOwner) {
				Write-Warning "The Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName)' did not return an Owner"
			}
			Else {
				Write-Host "Finding $MailEnabledSecurityGroupOwner in Active Directory"
				$AddOwner = Get-ADUser -Filter * | Where-Object { $_.userprincipalname -eq "$MailEnabledSecurityGroupOwner" }
				If ($null -eq $AddOwner) {
					Write-Warning "$MailEnabledSecurityGroupOwner was not found in Active Directory and could not be added as an Owner for the Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName)'"
				}
				Else {
					Write-Host "The user, '$MailEnabledSecurityGroupOwner' was found in Active Directory. Adding as owner to the Mail-Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName)'"
					Set-ADGroup -identity $MailEnabledSecurityGroup.DisplayName -ManagedBy $AddOwner.DistinguishedName
				}
			}

			If ($DomainMoveMailEnabledSecurityGroupsToOU -eq $true) {
				#Grab Mail Enabled Security Group domain based on external email address
				Write-Host "Finding the External Email Address Domain for the Mail Enabled Security Group, '$($MailEnabledSecurityGroup.DisplayName)'"
				$MailEnabledSecurityGroupDomain = (($MailEnabledSecurityGroup.PrimarySmtpAddress).Split("@") | Select-Object -Last 1).Split(".") | Select-Object -First 1
				Write-Host "The domain is $MailEnabledSecurityGroupDomain"
				Write-Host "Finding an OU that contains $MailEnabledSecurityGroupDomain"
				$DynOU = (Get-ADOrganizationalUnit -Filter * | Where-Object { $_.Name -like "*$MailEnabledSecurityGroupDomain*" } -ErrorAction SilentlyContinue).DistinguishedName
				If ($null -eq $DynOU) {
					Write-Host "No OU was found to move $($MailEnabledSecurityGroup.DisplayName) to. Contact will be at the default Users OU"
				}
				Else {
					Write-Host "Moving $($MailEnabledSecurityGroup.DisplayName) to $DynOU"
					Get-ADGroup -identity $MailEnabledSecurityGroup.DisplayName | Move-ADObject -TargetPath $DynOU
				}
			}
			$GroupPresent = $null
		}
	}

	If ($SyncSecurityGroups -eq $true) {

		Write-Host "################################" -ForegroundColor Green
		Write-Host "#       SECURITY GROUPS        #" -ForegroundColor Green
		Write-Host "################################" -ForegroundColor Green

		#Mail Enabled Security Groups
		#I have a lot of conditionals in there. These groups are default AD groups that may have been synced to Office 365 if someone configured it with the express settings. Using these conditionals I am exluding these groups because they already exisit or will exisit when you set up AADConnect
		$SecurityGroups = Get-MsolGroup | Where-Object { ($_.GroupType -eq "Security") -and ($_.DisplayName -notlike "ADSyncOperators") -and ($_.DisplayName -notlike "ADSyncBrowse") -and ($_.DisplayName -notlike "ADSyncOperators") -and ($_.DisplayName -notlike "ADSyncPasswordSet") -and ($_.DisplayName -notlike "ADSyncAdmins") -and ($_.DisplayName -notlike "DnsAdmins") -and ($_.DisplayName -notlike "DnsUpdateProxy") }
		foreach ($SecurityGroup in $SecurityGroups) {

			Write-Host "Working on the Security Group, '$($SecurityGroup.DisplayName)'"

			Write-Host "Checking to see if the Mail-Enabled Security Group, '$($SecurityGroup.DisplayName) is already present in Active Directory'"
			Try { Get-ADGroup -Identity $SecurityGroup.DisplayName }
			Catch {
				Write-Host "The Security Group, '$($SecurityGroup.DisplayName) is not present in Active Directory'" -ForegroundColor Yellow

				$GroupSAMAccountName = ($SecurityGroup.DisplayName).Trim(" ")
				Write-Host "Creating the Security group, '$($SecurityGroup.DisplayName)'"
				If ($UsersOU -like "*OU*") {
					New-ADGroup -Name $SecurityGroup.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Security" -GroupScope Global -DisplayName $SecurityGroup.DisplayName -Path $SecurityGroupsOU -Description $SecurityGroup.Description
				}
				Else {
					New-ADGroup -Name $SecurityGroup.DisplayName -SamAccountName $GroupSAMAccountName -GroupCategory "Security" -GroupScope Global -DisplayName $SecurityGroup.DisplayName -Description $SecurityGroup.Description
				}
			}
			Write-Host "Getting members for the Security group, '$($SecurityGroup.DisplayName)'"
			$Members = Get-MsolGroupMember -GroupObjectId $SecurityGroup.ObjectID
			foreach ($Member in $Members) {
				Write-Host "Adding $($Member.DisplayName) to the group, '$($SecurityGroup.DisplayName)'"

				$AddMember = Get-ADObject -Filter * | Where-Object { $_.Name -eq $member.DisplayName }
				If ($null -eq $AddMember) {
					Write-Warning "$($Member.Name) was not found in Active Directory and could not be added as a member to $($SecurityGroup.DisplayName)"
				}
				Else {
					Set-ADGroup -identity $SecurityGroup.DisplayName -add @{ 'member' = $AddMember.DistinguishedName }
				}
			}
			Write-Host "Getting Owner of Security Group, '$($SecurityGroup.DisplayName)'"
			$SecurityGroupOwner = Get-AzureADGroupOwner -ObjectId $SecurityGroup.ObjectID | Select-Object -ExpandProperty UserPrincipalName
			Write-Host "The Owner is $SecurityGroupOwner"
			If ($null -eq $SecurityGroupOwner) {
				Write-Warning "The Security Group, '$($SecurityGroup.DisplayName)' did not return an Owner"
			}
			Else {
				Write-Host "Finding $SecurityGroupOwner in Active Directory"
				$AddOwner = Get-ADUser -Filter * | Where-Object { $_.userprincipalname -eq "$SecurityGroupOwner" }
				If ($null -eq $AddOwner) {
					Write-Warning "$SecurityGroupOwner was not found in Active Directory and could not be added as an Owner for the Security Group, '$($SecurityGroup.DisplayName)'"
				}
				Else {
					Write-Host "The user, '$SecurityGroupOwner' was found in Active Directory. Adding as owner to the Security Group, '$($SecurityGroup.DisplayName)'"
					Set-ADGroup -identity $SecurityGroup.DisplayName -ManagedBy $AddOwner.DistinguishedName
				}
			}
		}
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Sync-Office365ToADDSps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Sync-Office365ToADDSps1.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
