# ==============================================================================================
# # Microsoft PowerShell Source File
#
# NAME   : Clear-MSPKIcert.ps1
#
# AUTHOR : Andre Gibel GIBEL .NET / http://www.gibel.net
# DATE   : 03.11.2014
# Version: 1.2 - 04.09.2016
#
# COMMENT: Cleanup expired certificates from a Microsoft Windows PKI Certification Authority
#          You can remove
#             - Revoked
#             - Issued
#             - Failed/Denied
#          DB entries which are expired before a certain date.
#
#          Only PS 2.0 is needed without additional modules / cmdlets, so this function also
#          works on older installations (in my case CA is on Windows 2008 Enterprise Server)
#          PS technique used: "select-string" / RegularExpression filter /
#
# 1.1 / 19.12.2014   added the 2 functions
#                    - Get-PublishedCATemplate => lists all custom Templates (Name-OID) which are published
#                    - GetIssuedCert => lists issued cert of certain template starting a certain date
# 1.2 / 04.09.2016   - the regular expression of the date - parameter extended with "-" (for Danish date format)
#                    replaced [\./] with [\./-] ind the 2 functions Get-IssuedCert and Remove-ExpiredCertFromDB
#                    -in function Remove-ExpiredCertFromDB in Variable CertLogFilePath replace any of these chars "\./-"
#                    with "" because they can't be used in a filename
# ==============================================================================================
#requires -version 2.0
Set-StrictMode -version 2
$ErrorActionPreference = "stop"

function Get-PublishedCATemplate {
    [CmdletBinding()]
    Param (
        [parameter()]
        [string]$filter
    )
    $FilterLen = ("msPKI-Cert-Template-OID =").length + 3
    $AllPublishedTemplates = Invoke-Expression "certutil.exe -CATemplates -v | Select-String msPKI-Cert-Template-OID"
    $AllPublishedTemplates | ForEach-Object {
        $tmp = ($_.line).Substring($FilterLen)
        $splitarr = $tmp.split(" ", 2)
        $obj = New-Object PSObject
        Add-Member -Input $obj -Name "name" -MemberType Noteproperty -Value $Splitarr[1].trim()
        Add-Member -Input $obj -Name "oid" -MemberType Noteproperty -Value $Splitarr[0].trim()
        if ($PSBoundParameters["filter"]) {
            if ($Splitarr[1].trim() -match $filter) {
                Write-Output $obj
            }
        }
        else {
            Write-Output $obj
        }
    }
}

function Get-IssuedCert {
    [CmdletBinding()]
    Param (
        [ValidatePattern('^([0-9\.\s])+$')]
        [string]$CertTemplate,
        [ValidatePattern('^\d\d[\./-]{1}\d\d[\./-]{1}\d\d\d\d$')]
        [string]$Date
    )
    if ($PSBoundParameters["CertTemplate"]) {
        Invoke-Expression "certutil.exe -view -restrict 'certificate template=$CertTemplate,disposition=20,notbefore>=$Date' -out 'Request.RequestID,Request.RequesterName,NotBefore,NotAfter,Request.Disposition'"
    }
    else {
        # displays Certificates issued with any custom template
        Invoke-Expression "certutil.exe -view -restrict 'disposition=20,notbefore>=$Date' -out 'Request.RequestID,Request.RequesterName,NotBefore,NotAfter,Request.Disposition'"
    }
}

function Remove-ExpiredCertFromDB {
    <#
 .SYNOPSIS
    Deletes old (expired) entries from a MS Certification Authority

 .DESCRIPTION
    You must choose one of the following 4 types
    - revoked
    - issued
    - failed
    - denied (also in "Failed Requests" folder)

    and also define a date to cleanup all old entries older than that "date"

 .PARAMETER state
    type of record you want to delete
    issued | revoked | failed | denied

 .PARAMETER certtemplate
    OID of a certain certtemplate / only entries from certs issued with
    this template are deleted

 .PARAMETER date
    old records older than this date will be deleted
    open CA mmc-snapIn and check date of one certificate to get the right format (ignore the hour/minute part)
    mm.dd.yyyy (28.03.2014  - date format of Switzerland)
    or
    dd.mm.yyyy or dd/mm/yyyy or mm/dd/yyyy (date format for other countries)

 .PARAMETER delete
    without this switch parameter nothing is really deleted from the PKI db
    so first always run functions WITHOUT -delete

 .PARAMETER  CleanedFolderLogPath
    the default log folder path is "C:\_scripts\PKICleanupLog"
    for each type to delete, a sub folder (eg. issued / failed....)
    is created where the log-file(s) are stored

 .EXAMPLE
    Remove-ExpiredCertFromDB -state issued -Date  28.03.2014 -Verbose -delete

    immediately deletes issued certificates up to March 28. 2014
    (use correct date format for your country)

 .EXAMPLE
    Remove-ExpiredCertFromDB -state revoked -Date  28.03.2014 -Verbose

    only certificates with "revoked" state would be deleted
    it does NOT delete any cert from the CA - db without the "-delete" switch
    the log-file shows all the entries which would be deleted

 .EXAMPLE
    Remove-ExpiredCertFromDB -state revoked -Date  28.03.2012 -CleanedFolderLogPath "D:\CACleanupLog" -Verbose -delete

    immediately deletes all revoked certificates which are expired before October 03. 2014 and
    writes log file to a subfolder within D:\CACleanupLog

 .EXAMPLE
    Remove-ExpiredCertFromDB -state denied -Date  28.03.2014 -Verbose

    shows count (not delete) of all entries older than march 28. 2014 which would
    be deleted from the "Failed Request" folder (with the denied) state
    in the log-file you will see the entries to delete

 .EXAMPLE
    $mytemplateoid = 1.3.6.1.4.1.311.21.8.16341443.7736493.3493543.6246823.13644525.165.2726364.12781461
    Remove-ExpiredCertFromDB -State issued -CertTemplate $mytempalteoid -Date 28.03.2014 -delete

    first assign oid to var and then deletes all issued (and expired) certificates with expiration date <= 28.03.2014

 .NOTES
    originally created by Andr� Gibel - www.gibel.net -  03 November 2014

 .LINK
 #>


    [CmdletBinding()]
    Param (
        [parameter(
            Mandatory = $true
        )]
        [ValidateSet("issued", "revoked", "failed", "denied")]
        [string]$State,

        [parameter(Mandatory = $false)]
        [ValidatePattern('^([0-9\.\s])+$')]
        [string]$CertTemplate,

        # Swiss date format is of this form "dd.mm.yyyy" (eg. 28.06.2014)
        # if it's dd.mm.yyyy or mm.dd.yyyy is the same for the following pattern!
        [ValidatePattern('^\d\d[\./-]{1}\d\d[\./-]{1}\d\d\d\d$')]
        [String]$Date,

        [parameter()]
        # for security reasons / select -delete to really remove certs from db
        [switch]$delete,

        [parameter()]
        [string]$CleanedFolderLogPath = "C:\_scripts\PKICleanupLog"
    )

    $pathmid = ""
    $disp = ""
    $datefilterfield = ""

    switch ($State) {
        'issued' {
            $pathmid = "Issued"
            $disposition = "20"
            $datefilterfield = "notafter"
        }
        'revoked' {
            $pathmid = "Revoked"
            $disposition = "21"
            $datefilterfield = "notafter"
        }

        'failed' {
            $pathmid = "Failed"
            $disposition = "30"
            $datefilterfield = "Request.SubmittedWhen"
        }

        'denied' {
            $pathmid = "Denied"
            $disposition = "31"
            $datefilterfield = "Request.SubmittedWhen"
        }
    }
    Write-Verbose "`$Pathmid = $pathmid"
    Write-Verbose "`$Date = $Date"
    Write-Verbose "`$disposition = $disposition"

    # Path of temporary file needed for further parsing (regular expression)
    # Folder Structure ist automatically created if it doesn't exist
    if (-not (Test-Path $CleanedFolderLogPath )) { New-Item $CleanedFolderLogPath  -ItemType Directory | Out-Null }
    if (-not (Test-Path "$CleanedFolderLogPath\$pathmid" )) { New-Item "$CleanedFolderLogPath\$pathmid" -ItemType Directory | Out-Null }
    if ($delete) {
        $CertLogFilePath = "$CleanedFolderLogPath\$pathmid\RequestID-$pathmid-" + ($Date -replace '[\./-]', '') + ".txt"
    }
    else {
        Write-Host "!!! 'Remove-ExpiredCertFromDB' in 'VIEW MODUS' --> use -delete to delete !!!" -ForegroundColor red -BackgroundColor yellow
        $CertLogFilePath = "$CleanedFolderLogPath\$pathmid\RequestID-$pathmid-ViewOnly-" + ($Date -replace '[\./-]', '') + ".txt"
    }
    Write-Verbose $CertLogFilePath
    Write-Verbose "executin following command"
    Write-Verbose ""
    if ($PSBoundParameters["CertTemplate"]) {
        # only certificates issued with $CertTemplate - certificate
        Write-Verbose "certutil.exe -view -restrict 'certificate template=$CertTemplate,disposition=$disposition,$datefilterfield<=$Date' -out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' > $CertLogFilePath"
        Invoke-Expression "certutil.exe -view -restrict 'certificate template=$CertTemplate,disposition=$disposition,$datefilterfield<=$Date' -out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' > $CertLogFilePath"
    }
    else {
        # certificates issued with ANY template
        Write-Verbose "certutil.exe -view -restrict 'disposition=$disposition,$datefilterfield<=$Date' -out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' > $CertLogFilePath"
        Invoke-Expression "certutil.exe -view -restrict 'disposition=$disposition,$datefilterfield<=$Date' -out 'Request.RequestID,Request.RequesterName,Request.SubmittedWhen,NotBefore,NotAfter,Request.Disposition' > $CertLogFilePath"
    }
    Write-Verbose ""
    Write-Verbose "processing temporary file ..."
    $MatchingRequestIDCollection = (Select-String -Path $CertLogFilePath -SimpleMatch "Request ID:" | Select-Object line)
    if ($null -eq $MatchingRequestIDCollection) {
        Write-Host "!!! No entries to delete from the PKI DB !!!" -ForegroundColor red -BackgroundColor yellow
        Write-Verbose "------    finished    ------"
        break
    }
    else {
        Write-Host "Number of entries to delete from PKI DB: " -ForegroundColor blue -NoNewline
        Write-Host $MatchingRequestIDCollection.Length -ForegroundColor blue
    }
    $EntryDeletedCount = 0;
    # with regex I filter out the HEX part of "Request ID: 0xb (11)"  => "0xb"
    $MatchingRequestIDCollection | ForEach-Object {
        $ReqIDHex = $_.Line -replace "(\s*Request\sID\:\s)(0x[a-f|0-9]+)(.*)", '$2'
        try {
            $IDDec = [int]$ReqIDHex
            if ($delete) {
                Write-Output "certutil.exe -deleterow $ReqIDHex / Info: $IDDec - Decimal "
                & certutil.exe -deleterow $ReqIDHex
            }
            $EntryDeletedCount ++
        }
        catch {
            Write-Host "error deleting PKI DB record" -ForegroundColor blue
        }
    }
    if ($delete) {
        Write-Host ""
        Write-Host "Number of deleted records: $EntryDeletedCount" -ForegroundColor blue
    }
} #Function Remove-ExpiredCertFromDB

#-----------------------------------------------------------------------------------------------------------
# Tests

# Lists all Custom Cert templates to issue
# Get-PublishedCATemplate

# Lists oid of cert template with name "ABCD - Workstation Authentication Certificate"
#$WSTemplate= (Get-PublishedCATemplate -filter "ABCD - Workstation Authentication Certificate").oid
#$WSTemplate

# Lists all issued certificates after 18.12.2014 with the $WSTemplate (= "ABCD - Workstation Authentication Certificate")
#Get-IssuedCert  -CertTemplate $WSTemplate -Date 18.12.2014

#Remove-ExpiredCertFromDB -State issued -CertTemplate $WSTemplate -Date 11.12.2014 -Verbose

#Remove-ExpiredCertFromDB -State issued -Date 11.12.2014 -Verbose

# use -delete switch to really delete / first always run a command without "-delete"
# Remove-ExpiredCertFromDB -State issued -Date 11.12.2014 -Verbose -delete
