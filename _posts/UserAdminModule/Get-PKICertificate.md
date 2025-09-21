---
layout: post
title: Get-PKICertificate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-pkicertificate/
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

Retrieves PKI certificates from one or more specified computers.

#### Detailed Description

This function retrieves PKI certificates from the local machine's certificate store on one or more specified computers. Optionally, it can filter the certificates by issuer or by certificate status/type (Active, Issued, Dependencies, or Expired). In addition, the function outputs extended certificate details for enhanced PKI analysis.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Retrieve all active certificates from the local computer with extended details
```

Get-PKICertificate -CertificateType Active | Format-Table

**Example 2**

```powershell
# Retrieve all issued certificates from a remote computer
```

Get-PKICertificate -ComputerName "RemoteMachine01" -CertificateType Issued | Format-Table

**Example 3**

```powershell
# Retrieve certificates filtered by issuer from multiple computers
```

$Certs = Get-PKICertificate -ComputerName "RemoteMachine01", "RemoteMachine02" -IssuerFilter "CN=ExampleIssuer" $Certs | Format-Table

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves PKI certificates from one or more specified computers.

.DESCRIPTION
    This function retrieves PKI certificates from the local machine's certificate store on one or more specified computers.
    Optionally, it can filter the certificates by issuer or by certificate status/type (Active, Issued, Dependencies, or Expired).
    In addition, the function outputs extended certificate details for enhanced PKI analysis.

.PARAMETER ComputerName
    The names of the computers from which to retrieve certificates.
    Defaults to the local computer if not specified.

.PARAMETER IssuerFilter
    An optional filter for the issuer name.
    If not specified, all certificates are retrieved regardless of issuer.

.PARAMETER CertificateType
    The type of certificates to retrieve. Valid values are 'Active', 'Issued', 'Dependencies', and 'Expired'.
    Defaults to 'Active'. 'Active' certificates have NotAfter greater than the current date.
    'Expired' certificates have NotAfter less than or equal to the current date.
    'Issued' certificates include additional validity information.
    'Dependencies' can be used to drive additional logic if needed.

.PARAMETER Credential
    The PSCredential to use for remote connections.
    If not specified, the current user's credentials are used.

.EXAMPLE
    # Retrieve all active certificates from the local computer with extended details
    Get-PKICertificate -CertificateType Active | Format-Table

.EXAMPLE
    # Retrieve all issued certificates from a remote computer
    Get-PKICertificate -ComputerName "RemoteMachine01" -CertificateType Issued | Format-Table

.EXAMPLE
    # Retrieve certificates filtered by issuer from multiple computers
    $Certs = Get-PKICertificate -ComputerName "RemoteMachine01", "RemoteMachine02" -IssuerFilter "CN=ExampleIssuer"
    $Certs | Format-Table

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Get-PKICertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "The names of the computers from which to retrieve certificates. Defaults to the local computer.")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, HelpMessage = "The issuer name to filter the certificates. If not specified, all certificates are retrieved.")]
        [string]$IssuerFilter,

        [Parameter(Mandatory = $false, HelpMessage = "The type of certificates to retrieve. Valid values are 'Active', 'Issued', 'Dependencies', and 'Expired'. Defaults to 'Active'.")]
        [ValidateSet("Active", "Issued", "Dependencies", "Expired")]
        [string]$CertificateType = "Active",

        [Parameter(Mandatory = $false, HelpMessage = "The PSCredential to use for remote connections.")]
        [System.Management.Automation.PSCredential]$Credential
    )

    # Define the script block to run on target computer(s).
    $ScriptBlock = {
        param($IssuerFilter, $CertificateType)
        try {
            $CertStore = Get-ChildItem -Path Cert:\LocalMachine\My -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to access the certificate store on $env:COMPUTERNAME: $_"
            return @()
        }
        
        $Certificates = @()
        $CurrentDate = Get-Date

        foreach ($Cert in $CertStore) {
            # Apply issuer filter if specified.
            if ($IssuerFilter -and ($Cert.Issuer -notlike "*$IssuerFilter*")) {
                continue
            }

            # Determine whether to include this certificate based on CertificateType.
            $IncludeCert = $true
            
            switch ($CertificateType) {
                "Expired" {
                    if ($Cert.NotAfter -gt $CurrentDate) { $IncludeCert = $false }
                }
                "Active" {
                    if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                }
                "Issued" {
                    # For "Issued", include certificates that are active (and add extra validity details later).
                    if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                }
                "Dependencies" {
                    # Placeholder logic for dependency-related filtering.
                    $IncludeCert = $true
                }
            }

            if (-not $IncludeCert) { continue }

            # Build the certificate object with extended details.
            $CertObject = [PSCustomObject]@{
                ComputerName       = $env:COMPUTERNAME
                Subject            = $Cert.Subject
                Issuer             = $Cert.Issuer
                Thumbprint         = $Cert.Thumbprint
                NotBefore          = $Cert.NotBefore
                NotAfter           = $Cert.NotAfter
                SerialNumber       = $Cert.SerialNumber
                Version            = $Cert.Version
                FriendlyName       = $Cert.FriendlyName
                HasPrivateKey      = $Cert.HasPrivateKey
                SignatureAlgorithm = $Cert.SignatureAlgorithm.FriendlyName
                PublicKeyAlgorithm = $Cert.PublicKey.Oid.FriendlyName
            }

            # For "Issued" type, add extra validity properties.
            if ($CertificateType -eq "Issued") {
                $CertObject | Add-Member -MemberType NoteProperty -Name "ValidFrom" -Value $Cert.NotBefore -Force
                $CertObject | Add-Member -MemberType NoteProperty -Name "ValidTo" -Value $Cert.NotAfter -Force
            }
            $Certificates += $CertObject
        }
        return $Certificates
    }

    $AllResults = @()
    foreach ($Target in $ComputerName) {
        try {
            if ($Target -eq $env:COMPUTERNAME) {
                $Results = & $ScriptBlock -IssuerFilter $IssuerFilter -CertificateType $CertificateType
            }
            else {
                $Results = Invoke-Command -ComputerName $Target -ScriptBlock $ScriptBlock -ArgumentList $IssuerFilter, $CertificateType -Credential $Credential -ErrorAction Stop
            }
            $AllResults += $Results
        }
        catch {
            Write-Warning "Error connecting to $($Target): $_"
        }
    }
    return $AllResults
}

# Example usage:
# $Cred = Get-Credential
# $Certs = Get-PKICertificate -ComputerName "RemoteMachine01", "RemoteMachine02" -IssuerFilter "CN=ExampleIssuer" -CertificateType Issued -Credential $Cred
# $Certs | Format-Table
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-PKICertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PKICertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>


