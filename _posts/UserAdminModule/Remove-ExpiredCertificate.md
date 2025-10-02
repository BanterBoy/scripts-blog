---
layout: post
title: Remove-ExpiredCertificate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/remove-expiredcertificate/
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

Delete expired certificates from the CA server database.

#### Detailed Description

Use this command to remove expired certificates from a CA server, and optionally compress the CA database after performing maintenance.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-ExpiredCertificate -State Denied
```

Displays all expired Denied certificates. Does not delete any records.

**Example 2**

```powershell
Remove-ExpiredCertificate -State Failed -Delete
```

Deletes all expired Failed certificates.

**Example 3**

```powershell
Remove-ExpiredCertificate -State Issued -Template '1.3.6.1.4.1.311.21.8.8823763.7881424.11597667.39223303.50834909.808.1387547.7582140'
```

Displays all expired Issued certificates based on the specified certificate template OID. Does not delete any records.

**Example 4**

```powershell
Remove-ExpiredCertificate -State Revoked -Date 12/31/2022 -Delete -CompressDatabase
```

Deletes all expired Revoked certificates prior to December 31, 2022 and compresses the CA database.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Version:            1.3.1 Creation Date:      January 18, 2020 Last Updated:       March 10, 2025 Special Note:       This script adapted from original published guidance by Andre Gibel Original Author:    Andre Gibel Original Script:    https://vanbrenk.blogspot.com/2020/12/how-to-cleanup-expired-certificates.html Author:             Richard Hicks Organization:       Richard M. Hicks Consulting, Inc. Contact:            rich@richardhicks.com Website:            https://www.richardhicks.com/

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#

.SYNOPSIS
    Delete expired certificates from the CA server database.

.PARAMETER State
    This parameter defines what type of certificate record to delete - Denied, Failed, Issued, or Revoked.

.PARAMETER Template
    The Object Identifier (OID) of a specific certificate template to delete database records for. Use Get-CaTemplate to retrieve the OID of a published certificate template.

.PARAMETER Date
    Database records older than this date will be deleted.

.PARAMETER Delete
    Use this switch to delete records from the CA database. If this switch is not present, the script only displays records that will be deleted, if any.

.PARAMETER LogFilePath
    Specifies the location to store CA maintenance log files. The default location is C:\Users\<username>\AppData\Local\Temp\.

.PARAMETER CompressDatabase
    Use this switch to compress the CA database after performing maintenance (recommended).

.EXAMPLE
    Remove-ExpiredCertificate -State Denied

    Displays all expired Denied certificates. Does not delete any records.

.EXAMPLE
    Remove-ExpiredCertificate -State Failed -Delete

    Deletes all expired Failed certificates.

.EXAMPLE
    Remove-ExpiredCertificate -State Issued -Template '1.3.6.1.4.1.311.21.8.8823763.7881424.11597667.39223303.50834909.808.1387547.7582140'

    Displays all expired Issued certificates based on the specified certificate template OID. Does not delete any records.

.EXAMPLE
    Remove-ExpiredCertificate -State Revoked -Date 12/31/2022 -Delete -CompressDatabase

    Deletes all expired Revoked certificates prior to December 31, 2022 and compresses the CA database.

.DESCRIPTION
    Use this command to remove expired certificates from a CA server, and optionally compress the CA database after performing maintenance.

.LINK
    https://github.com/richardhicks/adcstools/blob/main/Functions/Remove-ExpiredCertificate.ps1

.LINK
    https://vanbrenk.blogspot.com/2020/12/how-to-cleanup-expired-certificates.html

.LINK
    https://www.richardhicks.com/

.NOTES
    Version:            1.3.1
    Creation Date:      January 18, 2020
    Last Updated:       March 10, 2025
    Special Note:       This script adapted from original published guidance by Andre Gibel
    Original Author:    Andre Gibel
    Original Script:    https://vanbrenk.blogspot.com/2020/12/how-to-cleanup-expired-certificates.html
    Author:             Richard Hicks
    Organization:       Richard M. Hicks Consulting, Inc.
    Contact:            rich@richardhicks.com
    Website:            https://www.richardhicks.com/

#>

Function Remove-ExpiredCertificate {

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory)]
        [ValidateSet('Denied', 'Failed', 'Issued', 'Revoked')]
        [String]$State,
        [ValidatePattern('^([0-9\.\s])+$')]
        [String]$Template,
        [ValidatePattern('^(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/([0-9]{4})$')]
        [String]$Date = (Get-Date -Format M/d/yyyy),
        [Switch]$Delete,
        [String]$LogFilePath = $env:temp,
        [Alias('Compress')]
        [Switch]$CompressDatabase

    )

    # Ensure date input is no later than today when viewing or deleting Issued certificates
    If ($State -eq 'Issued' -And (Get-Date $Date) -gt (Get-Date)) {

        Write-Warning 'The date specified is in the future. Please specify a date no later than today when viewing or deleting Issued certificates.'
        Return

    }

    $Pathmid = ''
    $DateFilterField = ''

    Switch ($State) {

        'Issued' {

            $Pathmid = 'Issued'
            $Disposition = '20'
            $DateFilterField = 'NotAfter'

        }

        'Revoked' {

            $Pathmid = 'Revoked'
            $Disposition = '21'
            $DateFilterField = 'NotAfter'

        }

        'Failed' {

            $Pathmid = 'Failed'
            $Disposition = '30'
            $DateFilterField = 'Request.SubmittedWhen'

        }

        'Denied' {

            $Pathmid = 'Denied'
            $Disposition = '31'
            $DateFilterField = 'Request.SubmittedWhen'

        }

    }

    Write-Verbose "`$Pathmid = $Pathmid"
    Write-Verbose "`$Date = $Date"
    Write-Verbose "`$Disposition = $Disposition"

    # Path of temporary file needed for further parsing (regular expression)
    # Folder structure is automatically created if it doesn't exist
    If (-Not (Test-Path $LogFilePath )) {

        New-Item -Path $LogFilePath -ItemType Directory | Out-Null

    }

    If (-Not (Test-Path "$LogFilePath\$Pathmid" )) {

        New-Item -Path $LogFilePath\$Pathmid -ItemType Directory | Out-Null

    }

    If ($Delete) {

        $CertLogFilePath = Join-Path -Path $LogFilePath -ChildPath "$Pathmid\RequestID-$Pathmid-$($Date -Replace '[\./-]', '').txt"

    }

    Else {

        Write-Warning "'Remove-ExpiredCertificates' is in view only mode. Use the -Delete parameter to delete CA database entries."
        $CertLogFilePath = Join-Path -Path $LogFilePath -ChildPath "$Pathmid\RequestID-$Pathmid-ViewOnly-$($Date -Replace '[\./-]', '').txt"

    }

    Write-Output "Log file path is $CertLogFilePath."
    Write-Verbose 'Executing the following command...'

    If ($PSBoundParameters['Template']) {

        # Select certificates matching a specific template
        Write-Verbose "Query: certutil.exe -view -restrict 'Certificate Template=$Template,Disposition=$Disposition,$DateFilterField<=$Date' -Out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition'"
        Invoke-Command -ScriptBlock { certutil.exe -view -restrict "Certificate Template=$Template,Disposition=$Disposition,$DateFilterField<=$Date" -Out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' | Out-File $CertLogFilePath }

    }

    Else {

        # Select certificates matching any template
        Write-Verbose "Query: certutil.exe -view -restrict 'Disposition=$Disposition,$DateFilterField<=$Date' -Out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition'"
        Invoke-Command -ScriptBlock { certutil.exe -view -restrict "Disposition=$Disposition,$DateFilterField<=$Date" -Out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' | Out-File $CertLogFilePath }

    }

    Write-Verbose 'Processing temporary file...'
    $MatchingRequestIDCollection = (Select-String -Path $CertLogFilePath -SimpleMatch "Request ID:" | Select-Object line)

    If ($Null -eq $MatchingRequestIDCollection) {

        Write-Warning 'No entries to delete from the CA database.'
        Break

    }

    Else {

        Write-Output "Number of entries to delete from CA database: $($MatchingRequestIDCollection.Count)."

    }

    # Delete expired certificates
    $EntryDeletedCount = 0

    # Filter out the HEX part of "Request ID: 0xb (11)"  => "0xb"
    $MatchingRequestIDCollection | ForEach-Object {

        $ReqIDHex = $_.Line -Replace "(\s*Request\sID\:\s)(0x[a-f|0-9]+)(.*)", '$2'

        Try {

            $IDDec = [int]$ReqIDHex
            If ($Delete) {

                Write-Output "Executing command: `"certutil.exe -deleterow $ReqIDHex`" (Request ID $IDDec)"
                & certutil.exe -deleterow $ReqIDHex

            }

            $EntryDeletedCount ++

        }

        Catch {

            Write-Output 'Error deleting CA database record.'

        }

    }

    If ($Delete) {

        Write-Output "Number of deleted records: $EntryDeletedCount."

    }

    If ($CompressDatabase) {

        # Identify CA database location
        Write-Verbose 'Identifying certificate services database location...'
        $DbFolder = Get-ItemProperty HKLM:SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\ -Name DBDirectory | Select-Object -ExpandProperty DBDirectory
        $DbName = Get-ItemProperty HKLM:SYSTEM\CurrentControlSet\Services\CertSvc\Configuration\ -Name Active | Select-Object -ExpandProperty Active
        $DbPath = Join-Path -Path $DbFolder -ChildPath "$DbName.edb"

        Write-Verbose "The Certificate Services database location is `"$DbPath`"."

        # Stop certificate services service
        Write-Verbose 'Stopping the Certificate Services service...'
        Stop-Service -Name CertSvc -PassThru

        # Compress certificate services database
        Write-Verbose 'Compressing the Certificate Services database...'
        Invoke-Command -ScriptBlock { esentutl.exe /d $DbPath }

        # Start certificate services service
        Write-Verbose 'Starting the Certificate Services service...'
        Start-Service -Name CertSvc -PassThru

    }

}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Remove-ExpiredCertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-ExpiredCertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

