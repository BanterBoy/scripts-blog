---
layout: post
title: Revoke-CACertificate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/revoke-cacertificate/
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

Revokes a specific Certificate Authority (CA) certificate using its thumbprint.

#### Detailed Description

The `Revoke-CACertificate` function automates the process of revoking a specific CA certificate by its thumbprint. It uses the `ADCSAdministration` module to revoke the certificate and logs the operation's success or failure to a specified log file. The function supports specifying a reason code for the revocation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..." -ReasonCode 5
```

This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` with the reason code `5` (Cessation of Operation).

**Example 2**

```powershell
Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..."
```

This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` using the default reason code `0` (Unspecified).

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: ADCSAdministration Module

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.

- **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.

- **Valid Thumbprint**: The thumbprint provided must match an existing certificate issued by the specified CA.

BEST PRACTICES

- **Verify Thumbprint**: Ensure the thumbprint provided is accurate to avoid revoking the wrong certificate.

- **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.

- **Backup Before Revocation**: Perform a backup of the CA database before revoking certificates to ensure recovery if needed.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

    .SYNOPSIS
    Revokes a specific Certificate Authority (CA) certificate using its thumbprint.

    .DESCRIPTION
    The `Revoke-CACertificate` function automates the process of revoking a specific CA certificate by its thumbprint.
    It uses the `ADCSAdministration` module to revoke the certificate and logs the operation's success or failure to a specified log file.
    The function supports specifying a reason code for the revocation.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`. This parameter is required.

    .PARAMETER Thumbprint
    Specifies the thumbprint of the CA certificate to be revoked. This parameter is required.

    .PARAMETER ReasonCode
    Specifies the reason code for the revocation. Valid values include:
    - `0`: Unspecified
    - `1`: Key Compromise
    - `2`: CA Compromise
    - `3`: Affiliation Changed
    - `4`: Superseded
    - `5`: Cessation of Operation
    - `6`: Certificate Hold

    .EXAMPLE
    Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..." -ReasonCode 5
    This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` with the reason code `5` (Cessation of Operation).

    .EXAMPLE
    Revoke-CACertificate -CAConfig "MyServer\MyCA" -Thumbprint "ABC123DEF456..."
    This example revokes the CA certificate with the thumbprint `ABC123DEF456...` for the CA `MyServer\MyCA` using the default reason code `0` (Unspecified).

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Valid Thumbprint**: The thumbprint provided must match an existing certificate issued by the specified CA.

    BEST PRACTICES
    - **Verify Thumbprint**: Ensure the thumbprint provided is accurate to avoid revoking the wrong certificate.
    - **Audit Logs**: Maintain logs of the revocation process for auditing purposes and to track any issues during the operation.
    - **Backup Before Revocation**: Perform a backup of the CA database before revoking certificates to ensure recovery if needed.

#>

function Revoke-CACertificate {
    [CmdletBinding()]
    param (
        [string]$CAConfig,
        [string]$Thumbprint,
        [ValidateSet(
            0, # Unspecified
            1, # Key Compromise
            2, # CA Compromise
            3, # Affiliation Changed
            4, # Superseded
            5, # Cessation of Operation
            6  # Certificate Hold
        )]
        [int]$ReasonCode = 0
    )
    try {
        # Validate input
        if (-not $Thumbprint) {
            Write-Warning "Thumbprint must be specified to revoke a CA certificate."
            return
        }

        # Revoke the certificate using ADCSAdministration
        Revoke-Certificate -CAConfig $CAConfig -Thumbprint $Thumbprint -Reason $ReasonCode
        Write-CAActivityLog -Message "CA certificate with thumbprint $Thumbprint revoked with reason code $ReasonCode."
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to revoke CA certificate. Error: $_"
        throw
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Revoke-CACertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Revoke-CACertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

