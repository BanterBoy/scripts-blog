---
layout: post
title: Remove-ADCSArtifacts.ps1
date: 2025-09-19
permalink: /useradminmodule/pkicertificatetools/remove-adcsartifacts/
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

Removes Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA).

#### Detailed Description

The `Remove-ADCSArtifacts` function automates the removal of Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA). It uses the `ADCSAdministration` module to locate and remove the CA from Active Directory. The function logs the operation's success or failure to a specified log file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-ADCSArtifacts -CAName "MyCA" -DomainDN "DC=example,DC=com"
```

This example removes the ADCS artifacts for the CA named "MyCA" from the specified Active Directory domain.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: ADCSAdministration Module

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server and in the Active Directory domain.

- **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.

- **Active Directory Access**: The function requires access to the Active Directory domain where the CA is located.

BEST PRACTICES

- **Backup Before Removal**: Ensure that a full backup of the CA database and private keys has been performed before removing ADCS artifacts.

- **Audit Logs**: Maintain logs of the removal process for auditing purposes and to track any issues during the operation.

- **Verify Removal**: After running the function, verify that all ADCS-related objects have been successfully removed from Active Directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#

    .SYNOPSIS
    Removes Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA).

    .DESCRIPTION
    The `Remove-ADCSArtifacts` function automates the removal of Active Directory Certificate Services (ADCS) artifacts for a specified Certificate Authority (CA).
    It uses the `ADCSAdministration` module to locate and remove the CA from Active Directory. The function logs the operation's success or failure to a specified log file.

    .PARAMETER CAName
    Specifies the name of the Certificate Authority to be removed from Active Directory.

    .PARAMETER DomainDN
    Specifies the distinguished name (DN) of the Active Directory domain where the CA is located.

    .EXAMPLE
    Remove-ADCSArtifacts -CAName "MyCA" -DomainDN "DC=example,DC=com"
    This example removes the ADCS artifacts for the CA named "MyCA" from the specified Active Directory domain.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: ADCSAdministration Module

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server and in the Active Directory domain.
    - **ADCSAdministration Module**: The `ADCSAdministration` PowerShell module must be available and imported on the system.
    - **Active Directory Access**: The function requires access to the Active Directory domain where the CA is located.

    BEST PRACTICES
    - **Backup Before Removal**: Ensure that a full backup of the CA database and private keys has been performed before removing ADCS artifacts.
    - **Audit Logs**: Maintain logs of the removal process for auditing purposes and to track any issues during the operation.
    - **Verify Removal**: After running the function, verify that all ADCS-related objects have been successfully removed from Active Directory.

#>

function Remove-ADCSArtifacts {
    [CmdletBinding()]
    param (
        [string]$CAName,
        [string]$DomainDN
    )
    try {
        # Ensure the ADCSAdministration module is imported
        if (-not (Get-Module -Name ADCSAdministration)) {
            Import-Module ADCSAdministration -ErrorAction Stop
        }

        # Remove ADCS-related objects using ADCSAdministration cmdlets
        $ca = Get-CertificationAuthority -Name $CAName
        Remove-CertificationAuthority -InputObject $ca -Force
        Write-CAActivityLog -Message "Removed Certification Authority: $CAName from Active Directory." -LogPath "C:\CA-Logs\remove-adcs-artifacts.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: Failed to remove ADCS artifacts. Error: $_"
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Remove-ADCSArtifacts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-ADCSArtifacts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

