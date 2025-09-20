---
layout: post
title: Revoke-AllValidCerts.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Revoke-AllValidCerts/
categories:
  - UserAdminModule
  - PKICertificateTools
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

Revokes all valid certificates issued by a specified Certificate Authority (CA).

#### Detailed Description

The `Revoke-AllValidCerts` function automates the process of revoking all valid certificates issued by a specified Certificate Authority (CA). It retrieves all certificates with a status of "Issued" and revokes them with the reason "Cessation of Operation." The function logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Revoke-AllValidCerts -CAConfig "MyServer\MyCA"
```

This example revokes all valid certificates issued by the CA `MyServer\MyCA` and logs the operation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: ADCSAdministration Module

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.

- **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.

- **Certificate Authority Access**: The function requires access to the specified Certificate Authority to retrieve and revoke certificates.

BEST PRACTICES

- **Backup Before Revocation**: Ensure that a full backup of the CA database has been performed before revoking certificates.

- **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.

- **Verify Certificates**: Review the list of certificates to be revoked to ensure no unintended certificates are included.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Revokes all valid certificates issued by a specified Certificate Authority (CA).

    .DESCRIPTION
    The `Revoke-AllValidCerts` function automates the process of revoking all valid certificates issued by a specified Certificate Authority (CA).
    It retrieves all certificates with a status of "Issued" and revokes them with the reason "Cessation of Operation."
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`. This parameter is required.

    .EXAMPLE
    Revoke-AllValidCerts -CAConfig "MyServer\MyCA"
    This example revokes all valid certificates issued by the CA `MyServer\MyCA` and logs the operation.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Certificate Authority Access**: The function requires access to the specified Certificate Authority to retrieve and revoke certificates.

    BEST PRACTICES
    - **Backup Before Revocation**: Ensure that a full backup of the CA database has been performed before revoking certificates.
    - **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.
    - **Verify Certificates**: Review the list of certificates to be revoked to ensure no unintended certificates are included.

#>

function Revoke-AllValidCerts {
    [CmdletBinding()]
    param ([string]$CAConfig)
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Retrieve all valid certificates and revoke them
        $certificates = Get-CertificationAuthority -Name $CAConfig | Get-IssuedRequest | Where-Object { $_.RequestDisposition -eq "Issued" }
        foreach ($cert in $certificates) {
            Revoke-Certificate -RequestID $cert.RequestID -Reason "CessationOfOperation" -Force
            Write-CAActivityLog -Message "Revoked certificate with RequestID: $($cert.RequestID) using CAConfig: $CAConfig. Reason: Decommissioning CA" -LogPath "C:\CA-Logs\revoke-certificates.log"
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to revoke certificates. Error: $_"
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Revoke-AllValidCerts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Revoke-AllValidCerts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

