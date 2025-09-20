---
layout: post
title: Publish-NewCRL.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Publish-NewCRL/
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

Publishes a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA) and optionally copies it to specified UNC paths.

#### Detailed Description

The `Publish-NewCRL` function automates the process of publishing a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA). It uses the `ADCSAdministration` module to publish the CRL and optionally copies the CRL files to specified UNC paths for distribution. The function logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Publish-NewCRL -CAConfig "MyServer\MyCA"
```

This example publishes a new CRL for the CA `MyServer\MyCA` and logs the operation to the default log path.

**Example 2**

```powershell
Publish-NewCRL -CAConfig "MyServer\MyCA" -UNCPaths "\\FileShare1\CRL", "\\FileShare2\CRL"
```

This example publishes a new CRL for the CA `MyServer\MyCA` and copies the CRL files to the specified UNC paths.

**Example 3**

```powershell
Publish-NewCRL -CAConfig "MyServer\MyCA" -Force
```

This example forces the publishing of a new CRL for the CA `MyServer\MyCA` without prompting for confirmation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: ADCSAdministration Module

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.

- **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.

- **Certificate Authority Access**: The function requires access to the specified Certificate Authority to publish the CRL.

- **UNC Path Permissions**: If UNC paths are specified, the user must have write permissions to the target locations.

BEST PRACTICES

- **Secure Distribution**: Ensure that the UNC paths used for CRL distribution are secure and accessible only to authorized users.

- **Regular Publishing**: Schedule regular CRL publishing to ensure that revoked certificates are properly communicated to relying parties.

- **Audit Logs**: Maintain logs of CRL publishing operations for auditing purposes and to track any issues during the process.

- **Verify Distribution**: After publishing, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Publishes a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA) and optionally copies it to specified UNC paths.

    .DESCRIPTION
    The `Publish-NewCRL` function automates the process of publishing a new Certificate Revocation List (CRL) for a specified Certificate Authority (CA).
    It uses the `ADCSAdministration` module to publish the CRL and optionally copies the CRL files to specified UNC paths for distribution.
    The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAConfig
    Specifies the configuration string of the Certificate Authority in the format `<ServerName>\<CAName>`.

    .PARAMETER LogPath
    Specifies the path to the log file where the CRL publishing process will be logged. The default path is `C:\CA-Logs\crl-publish.log`.

    .PARAMETER UNCPaths
    Specifies an array of UNC paths where the CRL files will be copied after publishing.

    .PARAMETER Force
    Forces the CRL publishing operation without prompting for confirmation.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA"
    This example publishes a new CRL for the CA `MyServer\MyCA` and logs the operation to the default log path.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA" -UNCPaths "\\FileShare1\CRL", "\\FileShare2\CRL"
    This example publishes a new CRL for the CA `MyServer\MyCA` and copies the CRL files to the specified UNC paths.

    .EXAMPLE
    Publish-NewCRL -CAConfig "MyServer\MyCA" -Force
    This example forces the publishing of a new CRL for the CA `MyServer\MyCA` without prompting for confirmation.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Certificate Authority Access**: The function requires access to the specified Certificate Authority to publish the CRL.
    - **UNC Path Permissions**: If UNC paths are specified, the user must have write permissions to the target locations.

    BEST PRACTICES
    - **Secure Distribution**: Ensure that the UNC paths used for CRL distribution are secure and accessible only to authorized users.
    - **Regular Publishing**: Schedule regular CRL publishing to ensure that revoked certificates are properly communicated to relying parties.
    - **Audit Logs**: Maintain logs of CRL publishing operations for auditing purposes and to track any issues during the process.
    - **Verify Distribution**: After publishing, verify that the CRL is properly distributed to all required locations, such as LDAP or HTTP distribution points.

#>

function Publish-NewCRL {
    [CmdletBinding()]
    param (
        [string]$CAConfig,
        [string]$LogPath = "C:\CA-Logs\crl-publish.log",
        [string[]]$UNCPaths,
        [switch]$Force
    )
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Publish the CRL using ADCSAdministration cmdlets
        $ca = Get-CertificationAuthority -Name $CAConfig
        Publish-CertificateRevocationList -InputObject $ca -Force:$Force
        Write-CAActivityLog -Message "Published CRL for CA: $CAConfig." -LogPath $LogPath

        # Copy CRL to UNC paths if specified
        if ($UNCPaths) {
            $crlFiles = Get-ChildItem -Path "C:\Windows\System32\CertSrv\CertEnroll\*.crl"
            foreach ($file in $crlFiles) {
                foreach ($unc in $UNCPaths) {
                    $dest = Join-Path -Path $unc -ChildPath $file.Name
                    Copy-Item -Path $file.FullName -Destination $dest -Force
                    Write-CAActivityLog -Message "Copied CRL file to UNC path: $dest" -LogPath $LogPath
                }
            }
        }
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to publish CRL. Error: $_" -LogPath $LogPath
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Publish-NewCRL.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Publish-NewCRL.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

