---
layout: post
title: PasswordFunctions.ps1
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
function Save-Password {
<# Example

.EXAMPLE
New-Item -Path C:\ -Name MyPasswords -ItemType Directory
. .\Functions\Save-Password.ps1
Save-Password -Label UserName
Save-Password -Label Password

#>
    param(
        [Parameter(Mandatory)]
        [string]$Label
    )

    $securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
    $securePassword | Out-File -FilePath "C:\MyPasswords\$Label.txt"
}

function Get-Password {
<#
.EXAMPLE
$user = Get-Password -Label UserName
$pass = Get-Password -Label password

.OUTPUT
$user | Format-List

.OUTPUT
Label           : UserName
EncryptedString : domain\administrator

.OUTPUT
$pass | Format-List
Label           : password
EncryptedString : SomeSecretPassword

.OUTPUT
$user.EncryptedString
domain\administrator

.OUTPUT
$pass.EncryptedString
SomeSecretPassword

#>
    param(
        [Parameter(Mandatory)]
        [string]$Label
    )

    $filePath = "C:\MyPasswords\$Label.txt"
    if (-not (Test-Path -Path $filePath)) {
        throw "The password with Label [$($Label)] was not found!"
    }

    $password = Get-Content -Path $filePath | ConvertTo-SecureString
    $decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    [pscustomobject]@{
        Label = $Label
        EncryptedString = $decPassword
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/PasswordFunctions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=PasswordFunctions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
