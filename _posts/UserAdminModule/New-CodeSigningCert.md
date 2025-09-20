---
layout: post
title: New-CodeSigningCert.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-CodeSigningCert/
categories:
  - UserAdminModule
  - CertificateUtilities
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

Creates a new code signing certificate.

#### Detailed Description

The New-CodeSigningCert function creates a new code signing certificate using the New-SelfSignedCertificate cmdlet. It allows you to specify the friendly name, name, password, file path, and whether the certificate should be trusted.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Trusted
```

Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is added to the trusted root store.

**Example 2**

```powershell
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Password $securePassword -FilePath "C:\Certificates\MyCert.pfx"
```

Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is exported to the specified file path with the provided password.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Creates a new code signing certificate.

.DESCRIPTION
The New-CodeSigningCert function creates a new code signing certificate using the New-SelfSignedCertificate cmdlet. 
It allows you to specify the friendly name, name, password, file path, and whether the certificate should be trusted.

.PARAMETER FriendlyName
Specifies the friendly name for the certificate.

.PARAMETER Name
Specifies the name for the certificate.

.PARAMETER Password
Specifies the password for the exported certificate. This parameter is mandatory when using the "Export" parameter set.

.PARAMETER FilePath
Specifies the file path where the exported certificate should be saved. This parameter is mandatory when using the "Export" parameter set.

.PARAMETER Trusted
Indicates whether the certificate should be added to the trusted root store. By default, the certificate is not added to the trusted root store.

.EXAMPLE
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Trusted
Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is added to the trusted root store.

.EXAMPLE
New-CodeSigningCert -FriendlyName "MyCert" -Name "MyCertificate" -Password $securePassword -FilePath "C:\Certificates\MyCert.pfx"
Creates a new code signing certificate with the friendly name "MyCert" and name "MyCertificate". The certificate is exported to the specified file path with the provided password.

#>
function New-CodeSigningCert {
	[CmdletBinding(
		DefaultParametersetName = "__AllParameterSets",
		SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory)]
		[String]
		$FriendlyName,

		[Parameter(Mandatory)]
		[String]
		$Name,

		[Parameter(Mandatory, ParameterSetName = "Export")]
		[SecureString]
		$Password,

		[Parameter(Mandatory, ParameterSetName = "Export")]
		[String]
		$FilePath,

		[Switch]
		$Trusted
	)

	# create new cert
	$cert = New-SelfSignedCertificate -KeyUsage DigitalSignature -KeySpec Signature -FriendlyName $FriendlyName -Subject "CN=$Name" -KeyExportPolicy ExportableEncrypted -CertStoreLocation Cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(5) -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3')


	if ($PSCmdlet.ShouldProcess("Create", "New certificate $FriendlyName")) {
		if ($Trusted) {
			$Store = New-Object system.security.cryptography.X509Certificates.x509Store("Root", "CurrentUser")
			$Store.Open("ReadWrite")
			$Store.Add($cert)
			$Store.Close()
		}
	}

	$parameterSet = $PSCmdlet.ParameterSetName.ToLower()

	if ($PSCmdlet.ShouldProcess("Export", "$FilePath")) {
		if ($parameterSet -eq "export") {
			# export to file
			$cert | Export-PfxCertificate -Password $Password -FilePath $FilePath

			$cert | Remove-Item
			explorer.exe /select, $FilePath
		}
		else {
			$cert
		}
	}

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/CertificateUtilities/Public/New-CodeSigningCert.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-CodeSigningCert.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

