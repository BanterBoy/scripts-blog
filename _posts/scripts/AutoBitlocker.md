---
layout: post
title: AutoBitlocker.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
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
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/AutoBitlocker.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=AutoBitlocker.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
