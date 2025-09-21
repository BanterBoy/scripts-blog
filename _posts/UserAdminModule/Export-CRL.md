---
layout: post
title: Export-CRL.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/export-crl/
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

Exports the Certificate Revocation List (CRL) from the Certificate Authority (CA) to a specified directory.

#### Detailed Description

The `Export-CRL` function automates the process of exporting the Certificate Revocation List (CRL) from the Certificate Authority (CA). It ensures the specified output directory exists, uses the `certutil` command to generate the CRL, and copies the CRL files to the specified directory. Logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Export-CRL
```

This example exports the CRL to the default path `C:\CA-CRL`.

**Example 2**

```powershell
Export-CRL -OutputPath "D:\CRL-Exports"
```

This example exports the CRL to the specified path `D:\CRL-Exports`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: certutil.exe

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.

- **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to export the CRL.

- **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.

- **Output Directory**: The specified output directory must be accessible to the user and have sufficient disk space to store the exported CRL files.

BEST PRACTICES

- **Secure Export Location**: Store the exported CRL files in a secure location with restricted access to prevent unauthorized modifications.

- **Regular Exports**: Schedule regular CRL exports to ensure that revoked certificates are properly communicated to relying parties.

- **Audit Logs**: Maintain logs of CRL export operations for auditing purposes and to track any issues during the process.

- **Verify CRL Distribution**: After exporting, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
    Exports the Certificate Revocation List (CRL) from the Certificate Authority (CA) to a specified directory.

    .DESCRIPTION
    The `Export-CRL` function automates the process of exporting the Certificate Revocation List (CRL) from the Certificate Authority (CA).
    It ensures the specified output directory exists, uses the `certutil` command to generate the CRL, and copies the CRL files to the specified directory.
    Logs the operation's success or failure to a specified log file.

    .PARAMETER OutputPath
    Specifies the directory where the CRL files will be exported. If the directory does not exist, it will be created.
    The default path is `C:\CA-CRL`.

    .EXAMPLE
    Export-CRL
    This example exports the CRL to the default path `C:\CA-CRL`.

    .EXAMPLE
    Export-CRL -OutputPath "D:\CRL-Exports"
    This example exports the CRL to the specified path `D:\CRL-Exports`.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to export the CRL.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Output Directory**: The specified output directory must be accessible to the user and have sufficient disk space to store the exported CRL files.

    BEST PRACTICES
    - **Secure Export Location**: Store the exported CRL files in a secure location with restricted access to prevent unauthorized modifications.
    - **Regular Exports**: Schedule regular CRL exports to ensure that revoked certificates are properly communicated to relying parties.
    - **Audit Logs**: Maintain logs of CRL export operations for auditing purposes and to track any issues during the process.
    - **Verify CRL Distribution**: After exporting, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.


#>

function Export-CRL {
    [CmdletBinding()]
    param ([string]$OutputPath = "C:\CA-CRL")
    try {
        # Ensure the output directory exists
        if (-not (Test-Path $OutputPath)) {
            New-Item -Path $OutputPath -ItemType Directory -Force
        }

        # Export the CRL
        certutil -crl
        Copy-Item -Path "C:\Windows\System32\CertSrv\CertEnroll\*.crl" -Destination $OutputPath -Force
        $exportedFiles = Get-ChildItem -Path $OutputPath -Filter *.crl | ForEach-Object { $_.Name } -join ', '
        Write-CAActivityLog -Message "CRL exported successfully. Files exported to: $OutputPath. Exported files: $exportedFiles" -LogPath "C:\CA-Logs\export-crl.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to export CRL. Error: $_" -LogPath $LogPath
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Export-CRL.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-CRL.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

