---
layout: post
title: Set-LDAPSBinding.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/security/set-ldapsbinding/
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

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Set-LDAPSBinding {
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

        Write-Verbose "Searching for certificate with thumbprint $CertThumbprint on $DomainControllerFQDN"
        
        $cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {
            $_.Thumbprint -eq $CertThumbprint
        }

        if ($null -ne $cert) {
            Write-Verbose "Certificate found. Binding certificate with thumbprint $CertThumbprint to LDAP service on $DomainControllerFQDN"

            # Bind the certificate to the NTDS service
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPSAuthentication" -Value 1 -PropertyType DWORD -Force | Out-Null
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "ClientLDAPS" -Value 1 -PropertyType DWORD -Force | Out-Null

            # Bind the certificate to the LDAP service
            $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("NTDS", "LocalMachine")
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            $store.Add($cert)
            $store.Close()

            Write-Verbose "Certificate with thumbprint $CertThumbprint successfully bound to LDAP service on $DomainControllerFQDN"
        } else {
            Write-Warning "No valid certificate found with thumbprint $CertThumbprint for LDAPS on $DomainControllerFQDN"
        }
    }

    Invoke-Command -ComputerName $DomainControllerFQDN -ScriptBlock $scriptBlock -ArgumentList $DomainControllerFQDN, $CertThumbprint -Credential $Credential -Verbose
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Set-LDAPSBinding.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-LDAPSBinding.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

