---
layout: post
title: Get-AccessToken.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-AccessToken/
categories:
  - UserAdminModule
  - Azure
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

Retrieves an access token for a specified resource using Azure Active Directory App-Only authentication.

#### Detailed Description

The Get-AccessToken function retrieves an access token for a specified resource using Azure Active Directory App-Only authentication. It requires the TenantId, ClientId, CertificatePath, CertificatePassword, and ResourceUri parameters to be provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-AccessToken -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -CertificatePath "C:\Certificates\MyCertificate.pfx" -CertificatePassword "MyPassword" -ResourceUri "https://api.example.com"
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This function requires the Microsoft.IdentityModel.Clients.ActiveDirectory assembly to be loaded. The certificate used for authentication must be stored in the LocalMachine certificate store.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
  Retrieves an access token for a specified resource using Azure Active Directory App-Only authentication.

.DESCRIPTION
  The Get-AccessToken function retrieves an access token for a specified resource using Azure Active Directory App-Only authentication. 
  It requires the TenantId, ClientId, CertificatePath, CertificatePassword, and ResourceUri parameters to be provided.

.PARAMETER TenantId
  Specifies the Azure Active Directory tenant ID. This parameter is mandatory.

.PARAMETER ClientId
  Specifies the Azure Active Directory application client ID. This parameter is mandatory.

.PARAMETER CertificatePath
  Specifies the path to the certificate file used for authentication. This parameter is mandatory.

.PARAMETER CertificatePassword
  Specifies the password for the certificate file used for authentication. This parameter is mandatory.

.PARAMETER ResourceUri
  Specifies the URI of the resource for which the access token is requested. This parameter is mandatory.

.EXAMPLE
  Get-AccessToken -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -CertificatePath "C:\Certificates\MyCertificate.pfx" -CertificatePassword "MyPassword" -ResourceUri "https://api.example.com"

.NOTES
  This function requires the Microsoft.IdentityModel.Clients.ActiveDirectory assembly to be loaded.
  The certificate used for authentication must be stored in the LocalMachine certificate store.
#>
function Get-AccessToken() {
  Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantId,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientId,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePath,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePassword,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceUri
  )
  
  # Rest of the code...
}
<#
.DESCRIPTION 
.PARAMETER
.EXAMPLE
#>
function Get-AccessToken() {
  Param(
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $TenantId = $global:AzureADApplicationTenantId,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientId = $global:AzureADApplicationClientId,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePath = $global:AzureADApplicationCertificatePath,
    
    [Parameter(Mandatory = $true, ParameterSetName = "UseLocal")]
    [Parameter(Mandatory = $false, ParameterSetName = "UseGlobal")]
    [ValidateNotNullOrEmpty()]
    [String]
    $CertificatePassword = $global:AzureADApplicationCertificatePassword,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceUri
  )
  
  #region Validations
  #-----------------------------------------------------------------------
  # Validating the TenantId
  #-----------------------------------------------------------------------
  if (!(Is-Guid -Value $TenantId)) {
    throw [Exception] "TenantId '$TenantId' is not a valid Guid"
  }
  
  #-----------------------------------------------------------------------
  # Validating the ClientId
  #-----------------------------------------------------------------------
  if (!(Is-Guid -Value $ClientId)) {
    throw [Exception] "ClientId '$ClientId' is not a valid Guid"
  }
  
  #-----------------------------------------------------------------------
  # Validating the Certificate Path
  #-----------------------------------------------------------------------
  if (!(Test-Path -Path $CertificatePath)) {
    throw [Exception] "CertificatePath '$CertificatePath' does not exist"
  }
  #endregion
  
  #region Initialization
  #-----------------------------------------------------------------------
  # Loads the Azure Active Directory Assemblies 
  #-----------------------------------------------------------------------
  Add-Type -Path "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll" | Out-Null
  
  #-----------------------------------------------------------------------
  # Constants 
  #-----------------------------------------------------------------------
  $keyStorageFlags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet
  
  #-----------------------------------------------------------------------
  # Building required values
  #-----------------------------------------------------------------------
  $authorizationUriFormat = "https://login.windows.net/{0}/oauth2/authorize"
  $authorizationUri = [String]::Format($authorizationUriFormat, $TenantId)
  #endregion
  
  #region Process
  #-----------------------------------------------------------------------
  # Building the necessary context to acquire the Access Token
  #-----------------------------------------------------------------------
  $authenticationContext = New-Object -TypeName "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authorizationUri, $false
  $certificate = New-Object -TypeName "System.Security.Cryptography.X509Certificates.X509Certificate2" -ArgumentList $CertificatePath, $CertificatePassword, $keyStorageFlags
  $assertionCertificate = New-Object -TypeName "Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate" -ArgumentList $ClientId, $certificate

  #-----------------------------------------------------------------------
  # Ask for the AccessToken based on the App-Only configuration
  #-----------------------------------------------------------------------
  $authenticationResult = $authenticationContext.AcquireToken($ResourceUri, $assertionCertificate)
  
  #-----------------------------------------------------------------------
  # Returns the an AccessToken valid for an hour
  #-----------------------------------------------------------------------
  return $authenticationResult.AccessToken
  #endregion
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Get-AccessToken.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-AccessToken.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

