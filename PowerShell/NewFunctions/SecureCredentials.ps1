Register-SecretVault -Name "RDGPasswordDB" -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault

Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None

$Meta = @{
	'URL or Application'    = ""
	'HostName'              = ""
	'SshHostKeyFingerprint' = ""
	'Purpose'               = ""
	'Tag'                   = ""
	'Creation Date'         = "$(Get-Date)"
}
Set-Secret -Vault "RDGPasswordDB" -Name "UserDescriptiveName" -Secret (Get-Credential "UPN@User.com") -Metadata $Meta
Password = "Password_String"


Set-Secret -Vault "RDGPasswordDB" -Name "AutomationUserPlain" -Secret "SrDqwTlg-7589" -Metadata @{description = "AD Admininistration/Automation Account uk.cruk.net for plain text use." }

$NewUserSecret = Get-Secret -Vault "RDGPasswordDB" -Name "AutomationUserPlain" -AsPlainText


$Meta = @{
	'URL or Application'    = "On-Boarding Process scripts."
	'HostName'              = "sftp01.digits.co.uk"
	'SshHostKeyFingerprint' = "ssh-rsa 2048 tp0OQoqK8d3Ay/OD3Annu9dRrn79ucKnqUYPgTjEtXI="
	'Purpose'               = "GloFTP Account for uploading AD User Export."
	'Tag'                   = "AD User, FTP, Automation, Upload, Export"
	'Creation Date'         = "$(Get-Date)"
}
Set-Secret -Vault "RDGPasswordDB" -Name "gloFTP" -Secret (Get-Credential "Glo_SFTP@carpetright.co.uk") -Metadata $Meta
Password = "vXmUolYk^7219"



Set-Secret -Vault "RDGPasswordDB" -Name "lukeleigh.admin" -Secret (Get-Credential)  -Metadata @{description = "AD Admininistration Account" }

Set-Secret -Vault "RDGPasswordDB" -Name "luke.leigh" -Secret (Get-Credential)  -Metadata @{description = "Azure Admininistration Account" }

$Credential = New-Object -TypeName PSCredential -ArgumentList (Get-Secret -Name "lukeleigh.admin")

$Credential = New-Object -TypeName PSCredential -ArgumentList (Get-Secret -Name "luke.leigh")



$VaultName = 'RDG_DB'
$MasterKey = 'The2R0nnie$'
$VaultMasterKey = ConvertTo-SecureString -String $MasterKey -AsPlainText
$KeePassDatabaseFileName = 'RDG_DB.kdbx'
$VaultFilePath = "C:\GitRepos\RDG\Keepass"
$VaultPath = Join-Path -Path $VaultFilePath -ChildPath $KeePassDatabaseFileName
$RegisterSecretVaultPathOnlyParams = @{
	Name              = $VaultName
	Path              = $VaultPath
	MasterPassword    = $VaultMasterKey
	UseMasterPassword = $true
	ShowFullTitle     = $true
}
Register-KeepassSecretVault @RegisterSecretVaultPathOnlyParams
Get-SecretInfo -Vault RDG_DB
Unregister-SecretVault -Name $VaultName


Unregister-SecretVault -Name RDG
Register-KeepassSecretVault -Path .\GitRepos\RDG\Keepass\RDG_DB.kdbx -MasterPassword (ConvertTo-SecureString -String 'The2R0nnie$' -AsPlainText) -UseMasterPassword:$true -ShowFullTitle:$true

Register-KeepassSecretVault -Path .\GitRepos\RDG\Keepass\RDG_DB.kdbx -MasterPassword (ConvertTo-SecureString -String 'The2R0nnie$' -AsPlainText) -UseMasterPassword:$true -ShowFullTitle:$true

