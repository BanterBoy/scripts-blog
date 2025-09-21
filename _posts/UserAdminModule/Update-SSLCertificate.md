---
layout: post
title: Update-SSLCertificate.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/security/update-sslcertificate/
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

Updates SSL certificates on specified remote servers and IIS bindings.

#### Detailed Description

This function imports a PFX certificate to the local machine's personal certificate store, copies the certificate to specified remote servers, imports it to their personal certificate stores, and updates IIS bindings to use the new certificate.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> Update-SSLCertificate -CertPath "C:\certs\mycert.pfx" -CertPassword "password123" -CertName "www.example.com" -Servers "Server1", "Server2" -Verbose
```

Imports the specified certificate and updates the SSL bindings on the specified servers.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Updates SSL certificates on specified remote servers and IIS bindings.

.DESCRIPTION
    This function imports a PFX certificate to the local machine's personal certificate store, copies the certificate to specified remote servers,
    imports it to their personal certificate stores, and updates IIS bindings to use the new certificate.

.PARAMETER CertPath
    The file path of the PFX certificate.

.PARAMETER CertPassword
    The password for the PFX certificate.

.PARAMETER CertName
    The common name (CN) of the certificate.

.PARAMETER Servers
    A list of remote servers to update with the new certificate.

.EXAMPLE
    PS C:\> Update-SSLCertificate -CertPath "C:\certs\mycert.pfx" -CertPassword "password123" -CertName "www.example.com" -Servers "Server1", "Server2" -Verbose
    Imports the specified certificate and updates the SSL bindings on the specified servers.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function Update-SSLCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CertPath,
        
        [Parameter(Mandatory = $true)]
        [string]$CertPassword,
        
        [Parameter(Mandatory = $true)]
        [string]$CertName,
        
        [Parameter(Mandatory = $true)]
        [string[]]$Servers
    )

    try {
        Write-Verbose "Importing the PFX certificate to the local machine's personal certificate store."
        
        # Import the PFX certificate to the local machine's personal certificate store
        $newCert = Import-PfxCertificate -FilePath $CertPath -CertStoreLocation Cert:\LocalMachine\My -Password $CertPassword
        
        Write-Verbose "Copying the PFX certificate to the specified list of remote servers."
        
        # Copy the PFX certificate to the specified list of remote servers
        $Servers | ForEach-Object {
            Copy-Item -Path $CertPath -Destination "\\$_\c$"
            Write-Verbose "Copied PFX certificate to \\$_\c$."
        }
        
        Write-Verbose "Establishing a connection to all of the specified remote servers."
        
        # Establish a connection to all of the specified remote servers
        $session = New-PSSession -ComputerName $Servers
        
        Write-Verbose "Importing the PFX certificate to the personal certificate store on the remote servers."
        
        # Import the PFX certificate to the personal certificate store on the remote servers
        Invoke-Command -Session $session -ScriptBlock {
            Import-PfxCertificate -FilePath "c:\$using:CertName" -CertStoreLocation Cert:\LocalMachine\My -Password $using:CertPassword
            Remove-Item -Path "c:\$using:CertName"
            Write-Verbose "Imported and cleaned up the PFX certificate on remote server."
        }
        
        Write-Verbose "Updating SSL bindings in IIS to use the new certificate on the local machine and remote servers."
        
        # Update SSL bindings in IIS to use the new certificate on the local machine and remote servers
        Import-Module WebAdministration
        
        $sites = Get-ChildItem -Path IIS:\Sites
        
        foreach ($site in $sites) {
            foreach ($binding in $site.Bindings.Collection) {
                if ($binding.protocol -eq 'https') {
                    $search = "Cert:\LocalMachine\My\$($binding.certificateHash)"
                    $certs = Get-ChildItem -Path $search -Recurse
                    $hostname = hostname
                    
                    if (($certs.count -gt 0) -and ($certs[0].Subject.StartsWith("CN=$using:CertName"))) {
                        Write-Output "Updating $hostname, site: `"$($site.name)`", binding: `"$($binding.bindingInformation)`", current cert: `"$($certs[0].Subject)`", Expiry Date: `"$($certs[0].NotAfter)`""
                        $binding.AddSslCertificate($newCert.Thumbprint, "my")
                    }
                }
            }
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        Write-Verbose "Cleaning up the PFX certificate file on the local machine."
        # Clean up the PFX certificate file on the local machine
        Remove-Item -Path $CertPath -ErrorAction SilentlyContinue
        Write-Verbose "Cleanup completed."
    }
}

# Example call to the function with verbose output
# Update-SSLCertificate -CertPath "C:\certs\mycert.pfx" -CertPassword "password123" -CertName "www.example.com" -Servers "Server1", "Server2" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Update-SSLCertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-SSLCertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

