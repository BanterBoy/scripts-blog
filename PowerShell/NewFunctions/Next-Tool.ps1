. .\GitRepos\RDG\Scripts\Test-O365EmailExists.ps1
Test-O365EmailExists -EmailAddress graham@albanysmith.com
Test-O365EmailExists -EmailAddress amphitheatre@raildeliverygroup.com
Test-O365EmailExists -EmailAddress 9bNRCC@atoc.org
Test-O365EmailExists -EmailAddress AnalysisandResearchteamCalender@raildeliverygroup.com
Test-O365EmailExists -EmailAddress 9bNRCC@atoc.onmicrosoFormat-Table.com
Get-EXORecipient -Anr 9bNRCC@atoc.onmicrosoFormat-Table.com
Get-EXORecipient -Anr 9bNRCC
Get-EXORecipient -RecipientType SharedMailbox
Get-EXORecipient -Anr 9bNRCC@atoc.onmicrosoFormat-Table.com -RecipientType SharedMailbox
Get-Help Get-EXORecipient -Parameter RecipientType
Get-EXORecipient -RecipientType *
Get-EXORecipient -RecipientType MailContact
Get-EXORecipient -RecipientType MailContact | Where-Object -FilterScript { $_.EmailAddresses -eq "9bNRCC@atoc.org" }
Get-EXORecipient -RecipientType MailUniversalDistributionGroup  | Where-Object -FilterScript { $_.EmailAddresses -eq "9bNRCC@atoc.org" }
Get-EXORecipient -RecipientType MailUser  | Where-Object -FilterScript { $_.EmailAddresses -eq "luke.leigh@raildeliverygroup.com" }
Get-EXORecipient -RecipientType UserMailBox | Where-Object -FilterScript { $_.EmailAddresses -eq "luke.leigh@raildeliverygroup.com" }
Get-EXORecipient -RecipientType UserMailBox
(Get-EXORecipient -RecipientType UserMailBox)[1].EmailAddresses
Get-EXORecipient -RecipientType UserMailBox | Where-Object -FilterScript { $_.EmailAddresses -eq "smtp:luke.leigh@raildeliverygroup.com" }
Get-EXORecipient -RecipientType UserMailBox -Properties * | Where-Object -FilterScript { $_.EmailAddresses -eq "smtp:luke.leigh@raildeliverygroup.com
Get-Help Get-EXORecipient
Get-Help Get-EXORecipient -Online
Get-EXORecipient -RecipientType UserMailBox -Properties all | Where-Object -FilterScript { $_.EmailAddresses -eq 'smtp:luke.leigh@raildeliverygroup.com" }
Get-EXORecipient -RecipientType GroupMailbox | Where-Object -FilterScript { $_.EmailAddresses -eq "smtp:9bNRCC@atoc.org" }
Get-Recipient -RecipientType GroupMailbox | Where-Object -FilterScript { $_.EmailAddresses -eq "smtp:9bNRCC@atoc.org" }
Get-Recipient -RecipientType Group | Where-Object -FilterScript { $_.EmailAddresses -eq "smtp:9bNRCC@atoc.org" }
Get-Recipient -anr 9bNRCC@atoc.org
Get-Recipient -anr 9bNRCC@atoc.org -Properties *
Get-Recipient -anr 9bNRCC@atoc.org | Select-Object -Property *
Get-EXORecipient -anr 9bNRCC@atoc.org | Select-Object -Property *
Clear-Host
Get-MyHistory -Quantity 100 | Format-List
Get-MyHistory -Quantity 100 | Select-Object -Property CommandLine
Get-MyHistory -Quantity 100 | Select-Object -Property CommandLine | Clip
Get-EXORecipient -anr "Ruth Anderson"
Get-Recipient -anr "Ruth Anderson"
Get-Recipient -anr "Ruth Anderson" | Get-MailboxFolderPermission | Format-Tablermat-Table -a
Get-Recipient -anr "Ruth Anderson" | Get-MailboxFolderPermission $_.Email:\Calendar | Format-Table -a
Get-Recipient -anr "Ruth Anderson" | Format-List
Get-MailboxFolderPermission ruth.anderson@raildeliverygroup.com:\Calendar | Format-Table -a
Set-MailboxFolderPermission ruth.anderson@raildeliverygroup.com:\Calendar -User "Lyn Penfold" -AccessRights PublishingEditor
Get-MailboxFolderPermission ruth.anderson@raildeliverygroup.com:\Calendar | Format-Table -a
Get-ADGroup -Filter { Name -like "*hr*" }
Get-ADGroup -Filter { Name -like "*hr*" } | Format-Table -a
Get-ADGroup -Filter { Name -like "*hr*" } | Format-Table -Property Name,DisplayName,SamAccountName -a
Get-ADUser -Filter { Name -like "*hr*" } | Format-Table -Property Name,DisplayName,SamAccountName -a




Get-ADUser -Filter {Name -like "*Alan Cain*" }
Get-ADUser -Filter {Name -like "*Alan Cain*" } -Properties Memberof
Get-ADUser -Filter {Name -like "*Alan Cain*" } -Properties Memberof | Select-Object -ExpandProperty Memberof
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" "  | Format-Table
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" "
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " | Get-ADGroupMember -Identity $_.Name
Get-ADGroupMember -Identity "Conditional Access Include Group"
Get-ADGroupMember -Filter "Name -like "*Conditional Access Include Group*" "
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " | Get-ADGroupMember -Recursive
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " -Properties * | Get-ADGroupMember -Recursive
Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " -Properties *
Clear-Host
(Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " -Properties *).Member
((Get-ADGroup -Filter "Name -like "*Conditional Access Include Group*" " -Properties *).Member).Count
((Get-ADGroup -Filter "Name -eq "Domain Admins" " -Properties *).Member).Count
(Get-ADGroup -Filter "Name -eq "Domain Admins" " -Properties *).Member
(Get-ADGroup -Filter "Name -eq "Domain Admins" " -Properties *).Member | Sort-Object
Get-ADGroupMember -Identity "Domain Admins"
Get-ADGroupMember -Identity "Domain Admins" | Format-Table -AutoSize
Get-ADGroupMember -Identity "Domain Admins" | Format-Table -Property DisplayName,Name,SamAccountName -AutoSize
Get-ADGroupMember -Identity "Domain Admins" | Format-Table -Property Name,SamAccountName -AutoSize
Get-ADGroupMember -Identity "Domain Admins" | Format-Table -Property Name,SamAccountName,OrganisationalUnit -AutoSize
Get-ADGroupMember -Identity "Domain Admins" -Recursive
Get-ADGroupMember -Identity "Domain Admins" | Select-Object -Property * | Format-Table -Property Name,SamAccountName,OrganisationalUnit -AutoSize
Get-ADGroupMember -Identity "Domain Admins" | Select-Object -Property * | Get-Member
Get-ADGroupMember -Identity "Domain Admins" | Format-List
Get-ADGroupMember -Identity "Domain Admins" | Format-List -Property *
(Get-ADGroup -Filter "Name -eq "Domain Admins" " -Properties *).Member | ForEach-Object -Process { Get-ADUser -Identity $_.SamAccountName -Properties * }
$Something = Get-ADGroup -Filter "Name -eq "Domain Admins" " -Properties *
$Something.Member
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ -Properties DisplayName,Name,SamAccountName,OrganisationalUnit }
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ -Properties DisplayName,Name,SamAccountName }
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ } | Format-Table -Properties DisplayName,Name,SamAccountName -AutoSize
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ } | Format-Table -Property DisplayName,Name,SamAccountName -AutoSize
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ -Properties * }
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ -Properties * } | Get-Member
Get-ProfileFunctions
. .\GitRepos\RDG\Profile\Functions\Get-ProfileFunctions.ps1
Get-ProfileFunctions
. .\GitRepos\RDG\Profile\Functions\Get-ProfileFunctions.ps1
Get-ProfileFunctions
Get-LastInstalledApplication -ComputerName $env:COMPUTERNAME
Get-LastInstalledApplication
Get-LastInstalledApplication -ComputerName RDGLT1259
test-OpenPorts -ComputerName RDGLT1259 -Ports 3389,5985,5986 | Format-Table -AutoSize
Write-ProgressHelper -StepNumber 1 -Message Something
Write-ProgressHelper -StepNumber 1 -Message "Something"
Get-Help Write-ProgressHelper
Get-Help Write-ProgressHelper -Examples
$Something.Member | ForEach-Object -Process { Get-ADUser -Identity $_ -Properties * }
resolve-DnsName -Name 10.16.8.21
Get-ADUser -Filter {Name -eq "qatest4a" }
Get-ADObject -Filter {Name -eq "qatest4a" }
Get-ADUser -Filter { Name -eq "Richard Senya" }
Get-ADUser -Filter { Name -eq "Richard Senya" } | Select-Object -Property *phone*
Get-ADUser -Filter { Name -eq "Richard Senya" } -Properties * | Select-Object -Property *phone*
ServerManager.exe
Get-ADUser -Filter { Name -eq "Richard Senya" } -Properties * | Select-Object -Property *phone*
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties *
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone*
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Set-ADUser -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" } -WhatIf
Set-ADUser -Identity "luke.leigh" -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" } -WhatIf
Set-ADUser -Identity "luke.leigh" -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" }
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone*
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Richard Senya" } -Properties * | Select-Object -Property *phone*
Set-ADUser -Identity "luke.leigh" -Add @{ "telephoneNumber" = "+442037804095" }
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Filter { Name -eq "Luke Leigh" } -Properties * | Select-Object -Property *phone
Get-ADUser -Identity "michael.opoku"
Set-ADUser -Identity "michael.opoku" -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" } -Add @{ "telephoneNumber" = "+442037804031" }
Set-ADUser -Identity "michael.opoku" -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" }
Set-ADUser -Identity "michael.opoku" -Add @{ "telephoneNumber" = "+442037804031" }
Set-ADUser -Identity "michael.opoku" -Add @{ "telephoneNumber" = "+442037804031" }
Set-ADUser -Identity "michael.opoku" -OfficePhone "+442037804095" -Add @{ "ipphone" = "4095" }
Get-ADUser -Identity "michael.opoku"
Get-ADUser -Identity "michael.opoku" | Select-Object -Property *phone*
Get-ADUser -Identity "michael.opoku" -Properties * | Select-Object -Property *phone*
Get-MyHistory 100 | Select-Object -Property CommandLine




$Teams = Get-Process -Name Teams -ErrorAction SilentlyContinue
if ($Teams) {
else { Write-Output 'Teams not running' }
$Teams = Get-Process -Name Teams -ErrorAction SilentlyContinue
$Teams = Get-Process -Name Teams -ErrorAction SilentlyContinue
$Teams = Get-Process -Name Teams -ErrorAction SilentlyContinue
}

. .\GitRepos\RDG\Scripts\Test-O365EmailExists.ps1
Test-O365EmailExists -EmailAddress david.emerson@silverrailtech.com
get-exORecipient -anr "david.emerson@silverrailtech.com"
get-Recipient -anr "david.emerson@silverrailtech.com"
Get-EXORecipient -anr david.emerson@silverrailtech.com
Get-EXORecipient -anr silverrailtech.com
Get-MailContact -Filter { Name -like '*david emerson*' }
Get-MailContact -Filter { Name -like '*david*' }
Get-MailContact -Filter { Name -like '*davidemerson*' }
Get-MailContact -Filter { Name -like '*emerson*' }

Get-GroupMailbox -Identity "Error Report RSIDs"
Get-DistributionGroup -Identity "Error Report RSIDs"
Get-DistributionGroup -Identity "Error Report RSIDs" | Select-Object -Property Members
Get-DistributionGroup -Identity "Error Report RSIDs" | Get-Member
Get-DistributionGroup -Identity "Error Report RSIDs" | Select-Object -Property AddressListMembership
Get-DistributionGroup -Identity "Error Report RSIDs" | Select-Object -Property AddressListMembership -ExpandProperty AddressListMembership

Get-DistributionGroup -Identity "Error Report RSIDs" | Format-List
Get-DistributionGroupMember -Identity "Error Report RSIDs"
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Group-Object -Property RecipientType
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Get-Member
(Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name)[1] | Format-List
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property Name,RecipientType,ExternalEmailAdd
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
New-Item -Path C:\GitRepos\ -Name Output -ItemType Directory
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Get-Member -Name *mail*
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Get-Member -Name *mail*,*user*
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Get-Member -Name *address*
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,ExternalE
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,PrimarySm
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,PrimarySm
Get-DistributionGroupMember -Identity "Error Report RSIDs" | Sort-Object -Property Name | Select-Object -Property DisplayName,RecipientType,PrimarySm
Get-Mailbox -Identity TDABprojects
Get-Mailbox -Identity TDABprojects | Format-List
(Get-Mailbox -Identity TDABprojects).MessageCopyForSentAsEnabled 
Set-Mailbox -Identity TDABprojects -MessageCopyForSentAsEnabled $true
Get-Mailbox -Identity TDABprojects | Select-Object -Property DisplayName,MessageCopyForSentAsEnabled,MessageCopyForSendOnBehalfEnabled

