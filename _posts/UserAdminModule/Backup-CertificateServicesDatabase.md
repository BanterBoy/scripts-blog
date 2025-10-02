---
layout: post
title: Backup-CertificateServicesDatabase.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/backup-certificateservicesdatabase/
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

Back up the CA server database and additional configuration information.

#### Detailed Description

Use this PowerShell script to perform regular certificate services database and configuration backup. Can be scheduled with a scheduled PowerShell job or scheduled task and performed on a regular schedule.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Backup-CertificateServicesDatabase
```

Running this PowerShell command will back up the local certificate services database and configuration files to the default location C:\CaBackup.

**Example 2**

```powershell
Backup-CertificateServicesDatabase -IncludePrivateKey
```

Running this PowerShell command will back up the local certificate services database and configuration files to the default location C:\CaBackup and include private keys in the backup.

**Example 3**

```powershell
Backup-CertificateServicesDatabase -LocalPath 'C:\Temp\CaBackup' -RemotePath '\\fs1.corp.example.net\pki\backup\'
```

Running this PowerShell command will back up the local certificate services database and configuration files to C:\Temp\CaBackup and copy a compressed archive (.zip file) to a remote file server.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.4 Creation Date:  January 20, 2020 Last Updated:   March 14, 2025 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Back up the CA server database and additional configuration information.

.PARAMETER LocalPath
    The local file path to store backup files.

.PARAMETER RemotePath
    The remote file path to store the backup file archive.

.PARAMETER IncludePrivateKey
    Indicates that private keys should be included in the backup.

.EXAMPLE
    Backup-CertificateServicesDatabase

    Running this PowerShell command will back up the local certificate services database and configuration files to the default location C:\CaBackup.

.EXAMPLE
    Backup-CertificateServicesDatabase -IncludePrivateKey

    Running this PowerShell command will back up the local certificate services database and configuration files to the default location C:\CaBackup and include private keys in the backup.

.EXAMPLE
    Backup-CertificateServicesDatabase -LocalPath 'C:\Temp\CaBackup' -RemotePath '\\fs1.corp.example.net\pki\backup\'

    Running this PowerShell command will back up the local certificate services database and configuration files to C:\Temp\CaBackup and copy a compressed archive (.zip file) to a remote file server.

.DESCRIPTION
    Use this PowerShell script to perform regular certificate services database and configuration backup. Can be scheduled with a scheduled PowerShell job or scheduled task and performed on a regular schedule.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Backup-CertificateServicesDatabase.ps1

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.4
    Creation Date:  January 20, 2020
    Last Updated:   March 14, 2025
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Backup-CertificateServicesDatabase {

    [CmdletBinding()]

    Param (

        [string]$LocalPath = (Join-Path -Path $env:systemdrive -ChildPath 'CaBackup'),
        [string]$RemotePath,
        [switch]$IncludePrivateKey

    )

    # Require elevated privileges
    #Requires -RunAsAdministrator

    # Variables
    $Hostname = $env:computername
    $BackupDBPath = Join-Path -Path $LocalPath -ChildPath 'Database'

    # Backup CA database
    If (Test-Path $BackupDBPath) {

        Write-Verbose 'Deleting previous backup...'
        Remove-Item $BackupDBPath -Recurse

    }

    # Backup the CA database
    Write-Verbose "Backing up the CA database on $Hostname..."
    Backup-CARoleService -Path $LocalPath -DatabaseOnly

    # Backup CA certificate(s) and private key(s)
    If ($IncludePrivateKey) {

        # Prompt user for password and validate
        Do {

            # Prompt user for password
            $Password = Read-Host 'Enter a password to protect the exported private key(s)' -AsSecureString
            $Password2 = Read-Host 'Confirm password' -AsSecureString

            # Convert both secure strings to plain text for comparison
            $PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            $PlainPassword2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password2))

            # Check if passwords match
            If ($PlainPassword -ne $PlainPassword2) {

                Write-Warning 'Passwords do not match. Please try again.'

            }

        }

        # Repeat until passwords match
        While ($PlainPassword -ne $PlainPassword2)

        Try {

            Backup-CaRoleService -Path $LocalPath -Password $Password -KeyOnly

        }

        Catch {

            Write-Warning $_.Exception.Message
            Return

        }

    }

    # Export CA configuration registry entries
    Write-Verbose 'Exporting CA registry entries...'
    [void](Invoke-Command -ScriptBlock { reg.exe export HKLM\System\CurrentControlSet\Services\CertSvc\Configuration $LocalPath\$Hostname.reg /y })

    # Copy CAPolicy.inf
    If (Test-Path "$env:systemroot\CAPolicy.inf") {

        Write-Verbose 'Backup up CApolicy.inf...'
        Copy-Item "$env:systemroot\CAPolicy.inf" $LocalPath

    }

    # Record existing CSP algorithm and key length
    Write-Verbose 'Recording existing CSP algorithm and key length...'
    Invoke-Command -ScriptBlock { certutil.exe -getreg CA\CSP\* | Out-File $LocalPath\csp.txt }

    # Record published templates
    Write-Verbose 'Recording published templates...'
    Invoke-Command -ScriptBlock { certutil.exe -catemplates | Out-File $LocalPath\templates.txt }

    # Record machine SID if domain-joined (useful for server migrations)
    If ((Get-CimInstance -ClassName Win32_ComputerSystem).PartOfDomain) {

        Write-Verbose 'Recording machine SID...'
        Get-Sid -SidType Machine | Out-File $LocalPath\sid.txt

    }

    # Record current CA signing certificate thumbprint (useful for server migrations)
    $CaInfo = Invoke-Command -ScriptBlock { certutil.exe -dump } | Out-String
    $Subject = ($CaInfo -split "`n" | Select-String -Pattern "\(Local\)" | ForEach-Object { $CaInfo -split "`n" | Select-Object -Skip (([array]::IndexOf($CaInfo -split "`n", $_.Line)) + 1) | Select-Object -First 1 } | Select-String -Pattern 'Name:\s*"(.+?)"' ).Matches.Groups[1].Value

    # Search local computer certificate store for newest CA signing certificate
    $CaCert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -match $Subject } | Sort-Object -Property NotAfter -Descending | Select-Object -First 1

    # Record CA certificate thumbprint
    $CaCert.Thumbprint | Out-File $LocalPath\cacert.txt

    # Create archive file in remote location
    If ($RemotePath) {

        # Check for existing archive folder. Create if not found.
        Write-Verbose "Checking for existing archive folder `"$RemotePath`"."
        If (-Not (Test-Path $RemotePath)) {

            Try {

                Write-Verbose 'Archive path not found. Creating folder...'
                New-Item -Path $RemotePath -ItemType Directory -ErrorAction Stop | Out-Null

            }

            Catch {

                Write-Warning $_.Exception.Message
                Return

            }

        }

        # Create archive file and copy to server
        $ArchivePath = Join-Path -Path $RemotePath -ChildPath cabackup_${hostname}.zip

        Write-Verbose "Creating archive file $ArchivePath..."

        Try {

            Compress-Archive -Path $LocalPath -DestinationPath $ArchivePath -CompressionLevel Optimal -Force

        }

        Catch {

            Write-Warning $_.Exception.Message
            Return

        }

    }

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Backup-CertificateServicesDatabase.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Backup-CertificateServicesDatabase.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

