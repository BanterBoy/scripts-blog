<#
The script creates a transcript, checks for a TPM module and if exists attempts to enable bitlocker on the system drive and backs up to AD.
Transcript opens upon completion.

Details to be amended prior to running
Change the PIN to required number
Remove -WhatIf from each line
Restart computer to complete
#>

$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Start-Transcript -Path "$ScriptPath\bitlockertranscript.txt" -Force
$SecureString = ConvertTo-SecureString "123456" -AsPlainText -Force # Enter a Numeric PIN
$SecurePassString = ConvertTo-SecureString "PasswordGoesHere" -AsPlainText -Force # Enter a Password
[string] $OSDrive = $env:SystemDrive

if ( (Get-Tpm).TpmPresent -eq $true ) {
    Write-Host 'Module Exists, enabling BitLocker Encryption'
    Enable-BitLocker -MountPoint $OSDrive -EncryptionMethod Aes256 -Pin $SecureString -UsedSpaceOnly -TPMandPinProtector -WhatIf
    Backup-BitLockerKeyProtector -MountPoint $OSDrive -KeyProtectorId $OSDrive.KeyProtector[1].KeyProtectorId -WhatIf
    Add-BitLockerKeyProtector -MountPoint $OSDrive -PasswordProtector -Password $SecurePassString -WhatIf
}
else {
    Write-Host 'No TPM Module present'
}

Stop-Transcript

Start-Process Notepad -ArgumentList "$ScriptPath\bitlockertranscript.txt"
