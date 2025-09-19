---
layout: post
title: Disable-CiscoSecure.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Disable-CiscoSecure/
categories:
  - UserAdminModule
  - Security
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Disables Cisco Secure on one or more computers.

#### Detailed Description

The Disable-CiscoSecure function disables Cisco Secure on the specified computers. It uses the sfc.exe utility located in the "C:\Program Files\Cisco\AMP\" directory.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$Password = Read-Host "Enter your password" -AsSecureString
```

Disable-CiscoSecure -Password $Password -ComputerName "Server01", "Server02"

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
   Disables Cisco Secure on one or more computers.

.DESCRIPTION
   The Disable-CiscoSecure function disables Cisco Secure on the specified computers. 
   It uses the sfc.exe utility located in the "C:\Program Files\Cisco\AMP\" directory.

.PARAMETER Password
   The password for the Cisco Secure service. This should be a secure string.

.PARAMETER ComputerName
   The names of the computers where Cisco Secure should be disabled. This can be a single computer name or an array of computer names.

.EXAMPLE
   $Password = Read-Host "Enter your password" -AsSecureString
   Disable-CiscoSecure -Password $Password -ComputerName "Server01", "Server02"
#>
function Disable-CiscoSecure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )
    $ScriptBlock = {
        # Find the sfc.exe utility
        $Path = Get-ChildItem -Path "C:\Program Files\Cisco\AMP\" -Filter "sfc.exe" -Recurse -ErrorAction SilentlyContinue
        if ($Path) {
            $Path = $Path.FullName
            # Convert the secure password to plain text
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($using:Password)
            $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            # Run the sfc.exe utility with the password
            Start-Process -FilePath $Path -ArgumentList "-k $UnsecurePassword" -Wait
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath = $Path
                Action = "Disabled"
            }
        }
        else {
            # Output the results as a PSCustomObject
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                SfcExePath = $null
                Action = "sfc.exe not found"
            }
        }
    }
    # Run the script block on each computer
    foreach ($Computer in $ComputerName) {
        Invoke-Command -ComputerName $Computer -ScriptBlock $ScriptBlock -ArgumentList $Password
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Disable-CiscoSecure.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Disable-CiscoSecure.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

