---
layout: post
title: Get-PKICertificates.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/pkicertificatetools/get-pkicertificates/
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

Retrieves PKI certificates (computer and/or user) with extended details from specified computers.

#### Detailed Description

This function retrieves PKI certificates from certificate stores on one or more specified computers. You can choose to retrieve certificates from the LocalMachine certificate store, the CurrentUser certificate store, or both. Optionally, it can filter the certificates by issuer or certificate status/type (Active, Issued, Dependencies, or Expired). The output now includes extended details such as the certificate template name (if available), along with other attributes for enhanced PKI analysis.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
# Retrieve all active computer certificates from the local computer
```

Get-PKICertificates -CertificateType Active -StoreLocation LocalMachine | Format-Table

**Example 2**

```powershell
# Retrieve all issued certificates (both computer and user) from a remote computer
```

Get-PKICertificates -ComputerName "RemoteMachine01" -StoreLocation Both -CertificateType Issued | Format-Table

**Example 3**

```powershell
# Retrieve certificates filtered by issuer from multiple computers, but only from the current user's store
```

$Certs = Get-PKICertificates -ComputerName "RemoteMachine01", "RemoteMachine02" -StoreLocation CurrentUser -IssuerFilter "CN=ExampleIssuer" $Certs | Format-Table

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
    Retrieves PKI certificates (computer and/or user) with extended details from specified computers.

.DESCRIPTION
    This function retrieves PKI certificates from certificate stores on one or more specified computers.
    You can choose to retrieve certificates from the LocalMachine certificate store, the CurrentUser certificate store, or both.
    Optionally, it can filter the certificates by issuer or certificate status/type (Active, Issued, Dependencies, or Expired).
    The output now includes extended details such as the certificate template name (if available),
    along with other attributes for enhanced PKI analysis.

.PARAMETER ComputerName
    The names of the computers from which to retrieve certificates.
    Defaults to the local computer if not specified.

.PARAMETER StoreLocation
    The certificate store location to search.
    Valid values are 'LocalMachine', 'CurrentUser', or 'Both'. Defaults to 'LocalMachine'.

.PARAMETER IssuerFilter
    An optional filter for the issuer name.
    If not specified, all certificates are retrieved regardless of issuer.

.PARAMETER CertificateType
    The type of certificates to retrieve. Valid values are 'Active', 'Issued', 'Dependencies', and 'Expired'.
    Defaults to 'Active'. 'Active' certificates have NotAfter greater than the current date,
    'Expired' certificates have NotAfter less than or equal to the current date,
    'Issued' certificates include additional validity information,
    while 'Dependencies' is reserved for future custom logic.

.PARAMETER Credential
    The PSCredential to use for remote connections.
    If not specified, the current user's credentials are used.

.EXAMPLE
    # Retrieve all active computer certificates from the local computer
    Get-PKICertificates -CertificateType Active -StoreLocation LocalMachine | Format-Table

.EXAMPLE
    # Retrieve all issued certificates (both computer and user) from a remote computer
    Get-PKICertificates -ComputerName "RemoteMachine01" -StoreLocation Both -CertificateType Issued | Format-Table

.EXAMPLE
    # Retrieve certificates filtered by issuer from multiple computers, but only from the current user's store
    $Certs = Get-PKICertificates -ComputerName "RemoteMachine01", "RemoteMachine02" -StoreLocation CurrentUser -IssuerFilter "CN=ExampleIssuer"
    $Certs | Format-Table

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Get-PKICertificates {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "The names of the computers from which to retrieve certificates. Defaults to the local computer.")]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, HelpMessage = "The certificate store location to search. Valid values: 'LocalMachine', 'CurrentUser', 'Both'. Defaults to 'LocalMachine'.")]
        [ValidateSet("LocalMachine", "CurrentUser", "Both")]
        [string]$StoreLocation = "LocalMachine",

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
        param($IssuerFilter, $CertificateType, $StoreLocation)

        # Set the certificate store paths based on the requested StoreLocation.
        switch ($StoreLocation) {
            "LocalMachine" { $StorePaths = "Cert:\LocalMachine\My" }
            "CurrentUser" { $StorePaths = "Cert:\CurrentUser\My" }
            "Both" { $StorePaths = @("Cert:\LocalMachine\My", "Cert:\CurrentUser\My") }
        }

        try {
            $Certificates = @()
            $CurrentDate = Get-Date

            foreach ($Store in $StorePaths) {
                try {
                    $CertStore = Get-ChildItem -Path $Store -ErrorAction Stop
                }
                catch {
                    Write-Warning "Failed to access store $Store on $env:COMPUTERNAME: $_"
                    continue
                }

                foreach ($Cert in $CertStore) {
                    # Apply issuer filter if specified.
                    if ($IssuerFilter -and ($Cert.Issuer -notlike "*$IssuerFilter*")) {
                        continue
                    }

                    # Determine whether to include the certificate based on CertificateType.
                    $IncludeCert = $true
                    switch ($CertificateType) {
                        "Expired" {
                            if ($Cert.NotAfter -gt $CurrentDate) { $IncludeCert = $false }
                        }
                        "Active" {
                            if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                        }
                        "Issued" {
                            if ($Cert.NotAfter -le $CurrentDate) { $IncludeCert = $false }
                        }
                        "Dependencies" {
                            # Placeholder logic for dependency-related filtering.
                            $IncludeCert = $true
                        }
                    }
                    if (-not $IncludeCert) { continue }

                    # Attempt to get the certificate template name as seen in certlm.msc.
                    # First, try the 'Certificate Template Name' extension (OID 1.3.6.1.4.1.311.21.8),
                    # which often directly contains the template name.
                    $templateName = $null
                    $templateNameExt = $Cert.Extensions | Where-Object { $_.Oid.Value -eq '1.3.6.1.4.1.311.21.8' }
                    if ($templateNameExt) {
                        # Format(false) usually returns a plain string.
                        $templateName = $templateNameExt.Format($false)
                    }
                    else {
                        # Fallback: use the 'Certificate Template Information' extension (OID 1.3.6.1.4.1.311.21.7)
                        # and try to parse out the template name.
                        $templateExt = $Cert.Extensions | Where-Object { $_.Oid.Value -eq '1.3.6.1.4.1.311.21.7' }
                        if ($templateExt) {
                            $templateFormatted = $templateExt.Format($true)
                            # Attempt to extract the name using a regex pattern.
                            if ($templateFormatted -match "Template\s*:\s*(.+)") {
                                $templateName = $Matches[1].Trim()
                            }
                            else {
                                $templateName = $templateFormatted
                            }
                        }
                    }

                    # Build the certificate object with extended details.
                    $CertObject = [PSCustomObject]@{
                        ComputerName       = $env:COMPUTERNAME
                        StoreLocation      = $Store
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
                        TemplateName       = $templateName
                    }

                    if ($CertificateType -eq "Issued") {
                        # Add extra validity properties for "Issued" certificates.
                        $CertObject | Add-Member -MemberType NoteProperty -Name "ValidFrom" -Value $Cert.NotBefore -Force
                        $CertObject | Add-Member -MemberType NoteProperty -Name "ValidTo" -Value $Cert.NotAfter -Force
                    }
                    $Certificates += $CertObject
                }
            }
            return $Certificates
        }
        catch {
            Write-Error "Failed to retrieve certificates on $env:COMPUTERNAME: $_"
            return @()
        }
    }

    $AllResults = @()
    foreach ($Target in $ComputerName) {
        try {
            if ($Target -eq $env:COMPUTERNAME) {
                $Results = & $ScriptBlock -IssuerFilter $IssuerFilter -CertificateType $CertificateType -StoreLocation $StoreLocation
            }
            else {
                $Results = Invoke-Command -ComputerName $Target -ScriptBlock $ScriptBlock -ArgumentList $IssuerFilter, $CertificateType, $StoreLocation -Credential $Credential -ErrorAction Stop
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
# $Certs = Get-PKICertificates -ComputerName "RemoteMachine01", "RemoteMachine02" -StoreLocation Both -IssuerFilter "CN=ExampleIssuer" -CertificateType Issued -Credential $Cred
# $Certs | Format-Table
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-PKICertificates.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-PKICertificates.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

