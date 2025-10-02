---
layout: post
title: Get-CACertificateInfo.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-cacertificateinfo/
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

Retrieves certificates from a specified certificate store on the local machine.

#### Detailed Description

The `Get-CACertificateInfo` function retrieves certificates from a specified certificate store on the local machine. It can retrieve all certificates in the store or filter by a specific certificate thumbprint. The function uses the `Get-Certificate` cmdlet to query the certificate store and returns the matching certificates.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-CACertificateInfo
```

This example retrieves all certificates from the default `CA` certificate store.

**Example 2**

```powershell
Get-CACertificateInfo -StoreName "My" -CertThumbprint "ABC123DEF456..."
```

This example retrieves a specific certificate with the thumbprint `ABC123DEF456...` from the `My` certificate store.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: PowerShell Certificate Cmdlets

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges to access the certificate store.

- **Certificate Store Access**: The function requires access to the specified certificate store on the local machine.

- **PowerShell Certificate Cmdlets**: The `Get-Certificate` cmdlet must be available on the system. This is included in modern versions of PowerShell.

BEST PRACTICES

- **Secure Access**: Ensure that only authorized users have access to the certificate store to prevent unauthorized modifications or access to sensitive certificates.

- **Validate Thumbprints**: When filtering by thumbprint, ensure the thumbprint is accurate to avoid retrieving incorrect certificates.

- **Audit Logs**: Maintain logs of certificate retrieval operations for auditing purposes and to track any issues during the process.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
    .SYNOPSIS
    Retrieves certificates from a specified certificate store on the local machine.

    .DESCRIPTION
    The `Get-CACertificateInfo` function retrieves certificates from a specified certificate store on the local machine.
    It can retrieve all certificates in the store or filter by a specific certificate thumbprint. The function uses the
    `Get-Certificate` cmdlet to query the certificate store and returns the matching certificates.

    .PARAMETER StoreName
    Specifies the name of the certificate store to query. The default store is `CA`.

    .PARAMETER CertThumbprint
    Specifies the thumbprint of the certificate to retrieve. If not provided, all certificates in the specified store will be returned.

    .EXAMPLE
    Get-CACertificateInfo
    This example retrieves all certificates from the default `CA` certificate store.

    .EXAMPLE
    Get-CACertificateInfo -StoreName "My" -CertThumbprint "ABC123DEF456..."
    This example retrieves a specific certificate with the thumbprint `ABC123DEF456...` from the `My` certificate store.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: PowerShell Certificate Cmdlets

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges to access the certificate store.
    - **Certificate Store Access**: The function requires access to the specified certificate store on the local machine.
    - **PowerShell Certificate Cmdlets**: The `Get-Certificate` cmdlet must be available on the system. This is included in modern versions of PowerShell.

    BEST PRACTICES
    - **Secure Access**: Ensure that only authorized users have access to the certificate store to prevent unauthorized modifications or access to sensitive certificates.
    - **Validate Thumbprints**: When filtering by thumbprint, ensure the thumbprint is accurate to avoid retrieving incorrect certificates.
    - **Audit Logs**: Maintain logs of certificate retrieval operations for auditing purposes and to track any issues during the process.


#>

function Get-CACertificateInfo {
    [CmdletBinding()]
    param (
        [string]$StoreName = "CA",
        [string]$CertThumbprint
    )
    try {
        # Retrieve certificates using ADCSAdministration
        if (-not $CertThumbprint) {
            $certs = Get-Certificate -CertStoreLocation "Cert:\LocalMachine\$StoreName"
        }
        else {
            $certs = Get-Certificate -CertStoreLocation "Cert:\LocalMachine\$StoreName" | Where-Object { $_.Thumbprint -eq $CertThumbprint }
        }

        # Return the certificates
        return $certs
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to retrieve certificates from store '$StoreName'. Error: $_"
        throw
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-CACertificateInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-CACertificateInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

