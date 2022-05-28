---
layout: post
title: Get-UserSupportedEncryptionTypes.ps1
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
Import-Module ActiveDirectory

# Windows Server 2008 and above
# This account supports Kerberos AES 128 bit encryption
# This account supports Kerberos AES 256 bit encryption
# msDS-SupportedEncryptionTypes
# CRC (KERB_ENCTYPE_DES_CBC_CRC, 0x00000001): Supports CRC32
# MD5 (KERB_ENCTYPE_DES_CBC_MD5, 0x00000002): Supports RSA-MD5
# RC4 (KERB_ENCTYPE_RC4_HMAC_MD5, 0x00000004): Supports RC4-HMAC-MD5
# A128 (KERB_ENCTYPE_AES128_CTS_HMAC_SHA1_96, 0x00000008): Supports HMAC-SHA1-96-AES128
# A256 (KERB_ENCTYPE_AES256_CTS_HMAC_SHA1_96, 0x00000010): Supports HMAC-SHA1-96-AES256

function resolve-EncryptionTypes {
    param (
        [int]$key
    )
    switch ($key) {
        "1" { $SupportedEncryptionTypes = @("DES_CRC") }
        "2" { $SupportedEncryptionTypes = @("DES_MD5") }
        "3" { $SupportedEncryptionTypes = @("DES_CRC", "DES_MD5") }
        "4" { $SupportedEncryptionTypes = @("RC4") }
        "8" { $SupportedEncryptionTypes = @("AES128") }
        "16" { $SupportedEncryptionTypes = @("AES256") }
        "24" { $SupportedEncryptionTypes = @("AES128", "AES256") }
        "28" { $SupportedEncryptionTypes = @("RC4", "AES128", "AES256") }
        "31" { $SupportedEncryptionTypes = @("DES_CRC", "DES_MD5", "RC4", "AES128", "AES256") }
        default { $SupportedEncryptionTypes = @("Undefined value of $key") }
    }
    $SupportedEncryptionTypes
}
$Users = Get-ADUser -Properties * -LdapFilter "(&(objectclass=user)(objectcategory=user)(msDS-SupportedEncryptionTypes=*)(!msDS-SupportedEncryptionTypes=0))" | Select-Object -Property Name, @{N = "EncryptionTypes"; E = { resolve-EncryptionTypes $($_."msDS-SupportedEncryptionTypes") } }
foreach ($User in $Users) {
    $User.Name
    foreach ($EncryptionType in $User.EncryptionTypes) {
        $EncryptionType
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-UserSupportedEncryptionTypes.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserSupportedEncryptionTypes.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
