---
layout: post
title: Move-CertificateServicesDatabase.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/move-certificateservicesdatabase/
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

Move the CA server database to another folder or volume.

#### Detailed Description

By default, the certificate services database is installed on the C: drive of the server. Ideally, the certificate services database will be located on a separate volume to allow more room for growth. This command can be used to relocate the certificate services database to another folder or volume if required.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Move-CertificateServicesDatabase -DestinationPath 'D:\CaDatabase\'
```

Running this PowerShell command will move the Certificate Services database from the original location C:\Windows\System32\CertLog\ to the new location D:\CaDatabase\.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:        1.2.2 Creation Date:  January 20, 2020 Last Updated:   August 9, 2024 Author:         Richard Hicks Organization:   Richard M. Hicks Consulting, Inc. Contact:        rich@richardhicks.com Website:        https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Move the CA server database to another folder or volume.

.PARAMETER SourcePath
    The current location of the Certificate Services database. Without this parameter the default location C:\Windows\System32\CertLog\ is used.

.PARAMETER DestinationPath
    The location to move the Sertificate Services database.

.EXAMPLE
    Move-CertificateServicesDatabase -DestinationPath 'D:\CaDatabase\'

    Running this PowerShell command will move the Certificate Services database from the original location C:\Windows\System32\CertLog\ to the new location D:\CaDatabase\.

.DESCRIPTION
    By default, the certificate services database is installed on the C: drive of the server. Ideally, the certificate services database will be located on a separate volume to allow more room for growth. This command can be used to relocate the certificate services database to another folder or volume if required.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Move-CertificateServicesDatabase.ps1

.LINK
    https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/move-certificate-server-database-log-files

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:        1.2.2
    Creation Date:  January 20, 2020
    Last Updated:   August 9, 2024
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

Function Move-CertificateServicesDatabase {

    [CmdletBinding()]

    Param (

        [string]$SourcePath = (Join-Path -Path $env:systemroot -ChildPath 'System32\CertLog'),
        [Parameter(Mandatory, HelpMessage = 'Enter the full path to move the certificate services database.')]
        [string]$DestinationPath

    )

    # Require elevated privileges
    #Requires -RunAsAdministrator

    # Verify source path exists
    If (-Not (Test-Path $SourcePath)) {

        Write-Warning "The source path `"$SourcePath`" does not exist."
        Return

    }

    If (Test-Path $DestinationPath) {

        Write-Warning "The destiation path `"$DestinationPath`" already exists."
        Return

    }

    Write-Verbose "Moving the Certificate Services database files from $SourcePath to $DestinationPath..."

    # Stop certificate services
    Write-Verbose 'Stopping the Certificate Services service...'
    Stop-Service -Name CertSvc

    Try {

        # Copy CA database files to new location
        Write-Verbose "Copying the Certificate Services database files from $SourcePath to $DestinationPath..."
        Copy-Item -Path $SourcePath -Destination $DestinationPath -Recurse -ErrorAction Stop | Out-Null

    }

    Catch {

        # If file copy fails, raise error, restart certificate services, and return
        Write-Warning $_.Exception.Message
        Write-Verbose 'Restarting the Certificate Services service...'
        Start-Service -Name CertSvc
        Return

    }

    # Use transaction for registry updates
    Start-Transaction

    # Update registry settings
    Write-Verbose 'Updating Certificate Services database location in the registry...'

    $Parameters = @{

        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\'
        Name         = 'DBDirectory'
        Value        = $DestinationPath
        PropertyType = 'String'
        Force        = $True

    }

    New-ItemProperty @Parameters | Out-Null

    $Parameters = @{

        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\'
        Name         = 'DBLogDirectory'
        Value        = $DestinationPath
        PropertyType = 'String'
        Force        = $True

    }

    New-ItemProperty @Parameters | Out-Null

    $Parameters = @{

        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\'
        Name         = 'DBSystemDirectory'
        Value        = $DestinationPath
        PropertyType = 'String'
        Force        = $True

    }

    New-ItemProperty @Parameters | Out-Null

    $Parameters = @{

        Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\'
        Name         = 'DBTempDirectory'
        Value        = $DestinationPath
        PropertyType = 'String'
        Force        = $True

    }

    New-ItemProperty @Parameters | Out-Null

    # Commit registry changes
    Complete-Transaction

    # Start the Certificate Services service
    Write-Verbose 'Starting the Certificate Services service...'
    Start-Service -Name CertSvc

    # Create a readme.txt file in the default location if files are being moved
    $Text = @"
The Certificate Services database and log files have been relocated to $DestinationPath.
The move was performed by $env:USERDOMAIN\$env:USERNAME on $((Get-Date).ToShortDateString()) at $((Get-Date).ToShortTimeString()).
"@

    Write-Verbose "Creating readme.txt file in $SourcePath..."
    Set-Content -Path ${SourcePath}\readme.txt -Value $Text

    Write-Output "Certificate Services database move complete. The database and log files from $SourcePath can be safely deleted."

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Move-CertificateServicesDatabase.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Move-CertificateServicesDatabase.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

