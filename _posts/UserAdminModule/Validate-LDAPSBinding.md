---
layout: post
title: Validate-LDAPSBinding.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Validate-LDAPSBinding/
categories:
  - UserAdminModule
  - Utilities
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Validate-LDAPSBinding {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DomainControllerFQDN,
        
        [Parameter(Mandatory=$true)]
        [string]$CertThumbprint,
        
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential
    )

    $scriptBlock = {
        param (
            [string]$DomainControllerFQDN,
            [string]$CertThumbprint
        )

        $result = [PSCustomObject]@{
            DomainControllerFQDN = $DomainControllerFQDN
            CertThumbprint       = $CertThumbprint
            LDAPSEnabled         = $false
            CertificateBound     = $false
            Message              = ""
        }

        Write-Verbose "Validating LDAPS settings on $DomainControllerFQDN"

        # Check registry settings
        $ldapsAuthentication = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPSAuthentication" -ErrorAction SilentlyContinue
        $ldaps = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPS" -ErrorAction SilentlyContinue

        if ($ldapsAuthentication -and $ldaps) {
            if ($ldapsAuthentication.ClientLDAPSAuthentication -eq 1 -and $ldaps.ClientLDAPS -eq 1) {
                $result.LDAPSEnabled = $true
            }
        }

        # Check if the certificate is bound
        $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("NTDS", "LocalMachine")
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
        $cert = $store.Certificates | Where-Object {
            $_.Thumbprint -eq $CertThumbprint
        }
        if ($cert) {
            $result.CertificateBound = $true
            $result.Message = "LDAPS is correctly configured on $DomainControllerFQDN with certificate $CertThumbprint"
        } else {
            $result.Message = "LDAPS is not correctly configured on $DomainControllerFQDN. Certificate $CertThumbprint is not bound."
        }
        $store.Close()

        return $result
    }

    $validationResult = Invoke-Command -ComputerName $DomainControllerFQDN -ScriptBlock $scriptBlock -ArgumentList $DomainControllerFQDN, $CertThumbprint -Credential $Credential -Verbose
    return $validationResult
}

# Example usage of the function:
# $validationResult = Validate-LDAPSBinding -DomainControllerFQDN "RDGDC01.rdg.co.uk" -CertThumbprint "9f580f463113ea7615847821ad3775d690c640d2" -Credential (Get-Credential) -Verbose
# $validationResult | Format-List
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Validate-LDAPSBinding.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Validate-LDAPSBinding.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

