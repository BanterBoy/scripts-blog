---
layout: post
title: Encrypt-Laptop.ps1
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
$TPM = Get-WmiObject win32_tpm -Namespace root\cimv2\security\microsofttpm |
Where-Object { $_.IsEnabled().Isenabled -eq 'True' } -ErrorAction SilentlyContinue

$WindowsVer = Get-WmiObject -Query 'select * from Win32_OperatingSystem where (Version like "6.2%" or Version like "6.3%" or Version like "10.0%") and ProductType = "1"' -ErrorAction SilentlyContinue
$BitLockerReadyDrive = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction SilentlyContinue

#If all of the above prequisites are met, then create the key protectors, then enable BitLocker and backup the Recovery key to AD.
if ($WindowsVer -and $TPM -and $BitLockerReadyDrive) {

    #Creating the recovery key
    Start-Process 'manage-bde.exe' -ArgumentList " -protectors -add $env:SystemDrive -recoverypassword" -Verb runas -Wait

    #Adding TPM key
    Start-Process 'manage-bde.exe' -ArgumentList " -protectors -add $env:SystemDrive  -tpm" -Verb runas -Wait
    Start-Sleep -Seconds 15 #This is to give sufficient time for the protectors to fully take effect.

    #Enabling Encryption
    Start-Process 'manage-bde.exe' -ArgumentList " -on $env:SystemDrive -em aes256" -Verb runas -Wait

    #Getting Recovery Key GUID
    $RecoveryKeyGUID = (Get-BitLockerVolume -MountPoint $env:SystemDrive).keyprotector |
    Where-Object { $_.Keyprotectortype -eq 'RecoveryPassword' } |
    Select-Object -ExpandProperty KeyProtectorID

    #Backing up the Recovery to AD.
    manage-bde.exe  -protectors $env:SystemDrive -adbackup -id $RecoveryKeyGUID

    #Restarting the computer, to begin the encryption process
    Restart-Computer
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/Encrypt-Laptop.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Encrypt-Laptop.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
