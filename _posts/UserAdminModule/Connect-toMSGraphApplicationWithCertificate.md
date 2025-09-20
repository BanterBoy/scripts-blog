---
layout: post
title: Connect-toMSGraphApplicationWithCertificate.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Connect-toMSGraphApplicationWithCertificate/
categories:
- UserAdminModule
- Azure
tags:
- PowerShell
- User Admin Module
- To MS Graph Application With Certificate
- MS
description: Connects to Microsoft Graph API using an application with a certificate.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Connects to Microsoft Graph API using an application with a certificate.

#### Detailed Description

This function connects to Microsoft Graph API using an application with a certificate. It requires the tenant ID, client ID, and certificate name as input parameters. The function retrieves the certificate thumbprint based on the provided certificate name and connects to Microsoft Graph API using the Connect-MgGraph cmdlet.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Connect-toMSGraphApplicationWithCertificate -TenantId "12345678-1234-1234-1234-1234567890ab" -ClientId "12345678-1234-1234-1234-1234567890ab" -CertName "MyCertificate"
```

Connects to Microsoft Graph API using the specified tenant ID, client ID, and certificate name.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Current Date Version: 1.0

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Connects to Microsoft Graph API using an application with a certificate.

.DESCRIPTION
This function connects to Microsoft Graph API using an application with a certificate. It requires the tenant ID, client ID, and certificate name as input parameters. The function retrieves the certificate thumbprint based on the provided certificate name and connects to Microsoft Graph API using the Connect-MgGraph cmdlet.

.PARAMETER TenantId
The tenant ID of the Microsoft Graph API.

.PARAMETER ClientId
The client ID of the Microsoft Graph API application.

.PARAMETER CertName
The name of the certificate to be used for authentication.

.EXAMPLE
Connect-toMSGraphApplicationWithCertificate -TenantId "12345678-1234-1234-1234-1234567890ab" -ClientId "12345678-1234-1234-1234-1234567890ab" -CertName "MyCertificate"

Connects to Microsoft Graph API using the specified tenant ID, client ID, and certificate name.

.INPUTS
None.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0

.LINK
https://docs.microsoft.com/en-us/graph/overview

#>

function Connect-toMSGraphApplicationWithCertificate {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (

        [Parameter(Mandatory = $true, HelpMessage = "Enter the MSGraph tenant ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid TenantId format. It should be a GUID." }
            })]
        [string]
        $TenantId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the MSGraph client ID.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') { $true } else { throw "Invalid ClientId format. It should be a GUID." }
            })]
        [string]
        $ClientId,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the certificate name.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ -match '^[a-zA-Z0-9 *?]+$') { $true } else { throw "Invalid CertName format. It should be an alphanumeric string with optional spaces and wildcard characters." }
            })]
        [string]
        $CertName
    )

    $InformationPreference = "Continue"
    
    if ($PSCmdlet.ShouldProcess("Connecting to MSGraph with Application: $ClientId")) {
        try {
            $CertificateThumbprint = (Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Subject -match $CertName }).Thumbprint
            if (!$CertificateThumbprint) {
                throw "Certificate with name $CertName not found in the CurrentUser\My store."
            }
            Connect-MgGraph -ClientId $ClientID -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
            Write-Verbose "Connected to MSGraph with ClientId: $ClientId and CertificateThumbprint: $CertificateThumbprint at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }
        catch {
            Write-Error "Failed to connect to MSGraph: $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Connect-toMSGraphApplicationWithCertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-toMSGraphApplicationWithCertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

