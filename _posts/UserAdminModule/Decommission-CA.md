---
layout: post
title: Decommission-CA.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Decommission-CA/
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

Decommissions a Certificate Authority (CA) by performing backup, certificate revocation, CRL publishing, and optional CA removal.

#### Detailed Description

The `Decommission-CA` function automates the process of decommissioning a Certificate Authority (CA). It performs the following tasks:

- Backs up the CA database and private keys.

- Revokes all valid certificates issued by the CA.

- Exports and publishes the Certificate Revocation List (CRL).

- Removes Active Directory Certificate Services (ADCS) artifacts and private keys.

- Optionally removes the CA role from the server.

This function supports a dry-run mode for testing and a backup-only mode for scenarios where only a backup is required.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Decommission-CA -CAName "MyCA" -DomainDN "DC=example,DC=com"
```

This example decommissions the CA named "MyCA" in the specified Active Directory domain.

**Example 2**

```powershell
Decommission-CA -CAName "MyCA" -BackupOnly
```

This example performs only the backup operation for the CA named "MyCA" and exits.

**Example 3**

```powershell
Decommission-CA -CAName "MyCA" -RemoveCA -Force
```

This example decommissions the CA named "MyCA" and removes the CA role from the server, forcing all operations without confirmation.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: April 3, 2025 Requires: certutil.exe

REQUIREMENTS

- **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.

- **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to perform backup, revocation, and removal operations.

- **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.

- **Backup Directory**: The specified backup directory must be accessible to the user and have sufficient disk space to store the CA database and private keys.

BEST PRACTICES

- **Secure Backup Location**: Store the backup in a secure location with restricted access to prevent unauthorized access to the CA database and private keys.

- **Encryption**: Consider encrypting the backup directory or using a secure storage solution to protect sensitive data.

- **Regular Backups**: Perform a final backup before decommissioning the CA to ensure data recovery if needed.

- **Test Restores**: Verify the integrity of the backup by performing a test restore before proceeding with the decommissioning process.

- **Audit Logs**: Maintain logs of the decommissioning process for auditing purposes and to track any issues during the operation.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
    Decommissions a Certificate Authority (CA) by performing backup, certificate revocation, CRL publishing, and optional CA removal.

    .DESCRIPTION
    The `Decommission-CA` function automates the process of decommissioning a Certificate Authority (CA). It performs the following tasks:
    - Backs up the CA database and private keys.
    - Revokes all valid certificates issued by the CA.
    - Exports and publishes the Certificate Revocation List (CRL).
    - Removes Active Directory Certificate Services (ADCS) artifacts and private keys.
    - Optionally removes the CA role from the server.

    This function supports a dry-run mode for testing and a backup-only mode for scenarios where only a backup is required.

    .PARAMETER CAName
    Specifies the name of the Certificate Authority to be decommissioned.

    .PARAMETER DomainDN
    Specifies the distinguished name (DN) of the Active Directory domain where the CA is located.

    .PARAMETER BackupPath
    Specifies the directory where the CA database and private keys will be backed up. The default path is `C:\CA-Backup`.

    .PARAMETER CRLPath
    Specifies the directory where the Certificate Revocation List (CRL) will be exported. The default path is `C:\CA-CRL`.

    .PARAMETER CAConfig
    Specifies the CA configuration string in the format `<ServerName>\<CAName>`. If not provided, it will be determined automatically using the CA name and the current server name.

    .PARAMETER KeyName
    Specifies the name of the private key to be removed during the decommissioning process.

    .PARAMETER LogPath
    Specifies the path to the log file where the decommissioning process will be logged. The default path is `C:\CA-Decom\decommission.log`.

    .PARAMETER UNCPaths
    Specifies an array of UNC paths where the CRL will be published.

    .PARAMETER DryRun
    Performs a dry run of the decommissioning process without making any changes. Outputs the actions that would be performed.

    .PARAMETER RemoveCA
    Indicates that the CA role should be removed from the server after completing the decommissioning process.

    .PARAMETER BackupOnly
    Indicates that only the backup operation should be performed. The function will exit after completing the backup.

    .PARAMETER CATypeToRemove
    Specifies the types of CA roles to be removed. The default is `@('EnterpriseSubordinate', 'StandaloneSubordinate')`.

    .PARAMETER Force
    Forces the removal of the CA role and other operations without prompting for confirmation.

    .EXAMPLE
    Decommission-CA -CAName "MyCA" -DomainDN "DC=example,DC=com"
    This example decommissions the CA named "MyCA" in the specified Active Directory domain.

    .EXAMPLE
    Decommission-CA -CAName "MyCA" -BackupOnly
    This example performs only the backup operation for the CA named "MyCA" and exits.

    .EXAMPLE
    Decommission-CA -CAName "MyCA" -RemoveCA -Force
    This example decommissions the CA named "MyCA" and removes the CA role from the server, forcing all operations without confirmation.

    .NOTES
    Author: Luke Leigh
    Date: April 3, 2025
    Requires: certutil.exe

    REQUIREMENTS
    - **Administrative Privileges**: The user running this function must have administrative privileges on the server hosting the Certificate Authority.
    - **Certificate Services Access**: The function requires access to the Certificate Authority service. Ensure the CA service is running and the user has sufficient permissions to perform backup, revocation, and removal operations.
    - **Certutil.exe**: The `certutil` command-line tool must be available on the system. This tool is included with Windows Server installations that have the Active Directory Certificate Services (AD CS) role installed.
    - **Backup Directory**: The specified backup directory must be accessible to the user and have sufficient disk space to store the CA database and private keys.

    BEST PRACTICES
    - **Secure Backup Location**: Store the backup in a secure location with restricted access to prevent unauthorized access to the CA database and private keys.
    - **Encryption**: Consider encrypting the backup directory or using a secure storage solution to protect sensitive data.
    - **Regular Backups**: Perform a final backup before decommissioning the CA to ensure data recovery if needed.
    - **Test Restores**: Verify the integrity of the backup by performing a test restore before proceeding with the decommissioning process.
    - **Audit Logs**: Maintain logs of the decommissioning process for auditing purposes and to track any issues during the operation.

#>

function Decommission-CA {
    [CmdletBinding()]
    param (
        [string]$CAName,
        [string]$DomainDN,
        [string]$BackupPath = "C:\CA-Backup",
        [string]$CRLPath = 'C:\CA-CRL',
        [string]$CAConfig,
        [string]$KeyName,
        [string]$LogPath = 'C:\CA-Decom\decommission.log',
        [string[]]$UNCPaths,
        [switch]$DryRun,
        [switch]$RemoveCA,
        [switch]$BackupOnly,
        [string[]]$CATypeToRemove = @('EnterpriseSubordinate', 'StandaloneSubordinate'),
        [switch]$Force
    )
    try {
        # Determine CAConfig if not provided
        if (-not $CAConfig -and $CAName) {
            $CAConfig = "$env:COMPUTERNAME\$CAName"
        }

        # Dry run mode
        if ($DryRun) {
            Write-Host "[DRY RUN] Would execute backup, revoke, CRL publish, AD cleanup, key delete, and optional CA removal."
            return
        }

        # Log the start of the decommissioning process
        Write-CAActivityLog -Message "Starting the decommissioning process for CA: $CAName on server: $env:COMPUTERNAME." -LogPath "C:\CA-Logs\decommission.log"

        # Perform backup
        Backup-CAServer -BackupPath $BackupPath
        if ($BackupOnly) {
            Write-CAActivityLog -Message "BackupOnly flag set. Exiting." -LogPath $LogPath
            return
        }

        # Revoke certificates, export CRL, and publish CRL
        Revoke-AllValidCerts -CAConfig $CAConfig
        Export-CRL -OutputPath $CRLPath
        Publish-NewCRL -CAConfig $CAConfig -LogPath $LogPath -UNCPaths $UNCPaths -Force:$Force

        # Remove ADCS artifacts and keys
        Remove-ADCSArtifacts -CAName $CAName -DomainDN $DomainDN
        Remove-CAKeys -KeyName $KeyName

        # Optionally remove the CA role
        if ($RemoveCA) {
            $result = Remove-CASolution -CATypeToRemove $CATypeToRemove -Force:$Force
            Write-CAActivityLog -Message "Remove-CASolution result: $($result.Status)" -LogPath $LogPath
        }

        # Log the completion of the decommissioning process
        Write-CAActivityLog -Message "CA decommissioning process completed successfully for CA: $CAName." -LogPath "C:\CA-Logs\decommission.log"
    }
    catch {
        Write-CAActivityLog -Message "ERROR: CA decommissioning failed for CA: $CAName. Error details: $_" -LogPath "C:\CA-Logs\decommission.log"
        throw
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Decommission-CA.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Decommission-CA.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

