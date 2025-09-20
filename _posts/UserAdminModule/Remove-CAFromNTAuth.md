---
layout: post
title: Remove-CAFromNTAuth.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-CAFromNTAuth/
categories:
- UserAdminModule
- PKICertificateTools
tags:
- PowerShell
- User Admin Module
- Certificate Authority From NT Auth
- NT
description: Removes a Certificate Authority (CA) certificate from the NTAuth store.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Removes a Certificate Authority (CA) certificate from the NTAuth store.

#### Detailed Description

The `Remove-CAFromNTAuth` function removes a specified CA certificate from the NTAuth store using its thumbprint. The NTAuth store is used to designate trusted CAs for issuing certificates in an Active Directory environment. The function logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-CAFromNTAuth -Thumbprint "ABC123DEF456..."
```

This example removes the CA certificate with the thumbprint `ABC123DEF456...` from the NTAuth store.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: certutil.exe

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server.

- **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.

- **Valid Thumbprint**: The thumbprint provided must match a certificate currently in the NTAuth store.

BEST PRACTICES

- **Validate Thumbprint**: Ensure the thumbprint provided is accurate to avoid removing the wrong certificate from the NTAuth store.

- **Audit Logs**: Maintain logs of certificate removal operations for auditing purposes and to track any issues during the process.

- **Backup NTAuth Store**: Before removing a certificate, consider backing up the NTAuth store to ensure recovery in case of accidental removal.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Removes a Certificate Authority (CA) certificate from the NTAuth store.

    .DESCRIPTION
    The `Remove-CAFromNTAuth` function removes a specified CA certificate from the NTAuth store using its thumbprint.
    The NTAuth store is used to designate trusted CAs for issuing certificates in an Active Directory environment.
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER Thumbprint
    Specifies the thumbprint of the CA certificate to be removed from the NTAuth store. This parameter is required.

    .EXAMPLE
    Remove-CAFromNTAuth -Thumbprint "ABC123DEF456..."
    This example removes the CA certificate with the thumbprint `ABC123DEF456...` from the NTAuth store.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Valid Thumbprint**: The thumbprint provided must match a certificate currently in the NTAuth store.

    BEST PRACTICES
    - **Validate Thumbprint**: Ensure the thumbprint provided is accurate to avoid removing the wrong certificate from the NTAuth store.
    - **Audit Logs**: Maintain logs of certificate removal operations for auditing purposes and to track any issues during the process.
    - **Backup NTAuth Store**: Before removing a certificate, consider backing up the NTAuth store to ensure recovery in case of accidental removal.

#>

function Remove-CAFromNTAuth {
    [CmdletBinding()]
    param ([string]$Thumbprint)
    try {
        # Validate input
        if (-not $Thumbprint) {
            Write-Warning "Thumbprint must be specified to remove from NTAuth store."
            return
        }

        # Remove the certificate from the NTAuth store
        certutil -delstore "NTAuth" "$Thumbprint"
        Write-CAActivityLog -Message "Removed CA certificate from NTAuth store: $Thumbprint"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove CA certificate from NTAuth store. Error: $_"
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Remove-CAFromNTAuth.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-CAFromNTAuth.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

