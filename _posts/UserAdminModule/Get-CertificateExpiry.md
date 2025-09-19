---
layout: post
title: Get-CertificateExpiry.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-CertificateExpiry/
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

Retrieves information about certificates based on their expiry date.

#### Detailed Description

The Get-CertificateExpiry function retrieves information about certificates based on their expiry date. It can be used to check the expiry date of certificates on remote computers.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-CertificateExpiry -FriendlyName "*.raildeliverygroup.com" -Days 10
```

Retrieves information about certificates with a friendly name matching "*.raildeliverygroup.com" that will expire within the next 10 days.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Retrieves information about certificates based on their expiry date.

.DESCRIPTION
    The Get-CertificateExpiry function retrieves information about certificates based on their expiry date. 
    It can be used to check the expiry date of certificates on remote computers.

.PARAMETER ComputerName
    Specifies the name of the computer(s) to retrieve certificate information from. 
    The default value is the local computer.

.PARAMETER Credential
    Specifies the credentials to use when connecting to remote computers. 
    This parameter is optional.

.PARAMETER FriendlyName
    Specifies the friendly name of the certificate(s) to retrieve. 
    This parameter is optional.

.PARAMETER Days
    Specifies the number of days before the certificate expires. 
    This parameter is optional.

.PARAMETER Expired
    Indicates whether to check if the certificate has expired. 
    This parameter is optional.

.OUTPUTS
    The function outputs a custom object with the following properties:
    - FriendlyName: The friendly name of the certificate.
    - NotBefore: The date and time when the certificate becomes valid.
    - NotAfter: The date and time when the certificate expires.
    - Subject: The subject of the certificate.
    - SubjectName: The subject name of the certificate.
    - ExpireInDays: The number of days until the certificate expires.
    - CertificateStore: The certificate store where the certificate is located.
    - Issuer: The issuer of the certificate.
    - ComputerName: The name of the computer where the certificate is located.
    - Thumbprint: The thumbprint of the certificate.
    - AuthUse: The enhanced key usage of the certificate.
    - HasPrivateKey: Indicates whether the certificate has a private key.
    - PrivateKey: The private key of the certificate.
    - DnsNameList: The list of DNS names associated with the certificate.

.EXAMPLE
    Get-CertificateExpiry -FriendlyName "*.raildeliverygroup.com" -Days 10
    Retrieves information about certificates with a friendly name matching "*.raildeliverygroup.com" 
    that will expire within the next 10 days.

.LINK
    http://scripts.lukeleigh.com/

#>

function Get-CertificateExpiry {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a text string that you want to search for.')]
        [ValidateNotNullOrEmpty()]
        [string]$FriendlyName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter number of days before expiry.')]
        [ValidateNotNullOrEmpty()]
        [int]$Days,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'Check if certificate has expired.')]
        [switch]$Expired
    )

    begin {

        foreach ($Computer in $ComputerName) {

            $session = New-PsSession -ComputerName $Computer -Credential $Credential

            $command = {
                if ($Days) {
                    if ($Expired) {
                        $certchk = Invoke-Command -Session $session {
                            Get-ChildItem -Path Cert:\* -Recurse -ExpiringInDays 0 | Select-Object -Property * | Where-Object -FilterScript { $_.EnhancedKeyUsageList.FriendlyName -like "*Authentication*" -and $_.Issuer -notlike "CN=MS-Organization-P2P-Access*" } |  Where-Object -FilterScript { $_.FriendlyName -like "$FriendlyName" }
                        }
                    }
                    else {
                        $certchk = Invoke-Command -Session $session {
                            Get-ChildItem -Path Cert:\* -Recurse -ExpiringInDays $Days | Select-Object -Property * | Where-Object -FilterScript { $_.EnhancedKeyUsageList.FriendlyName -like "*Authentication*" -and $_.Issuer -notlike "CN=MS-Organization-P2P-Access*" } |  Where-Object -FilterScript { $_.FriendlyName -like "$FriendlyName" }
                        }
                    }
                }
                else {
                    $certchk = Invoke-Command -Session $session -Credential $Credential {
                        Get-ChildItem -Path Cert:\* -Recurse | Select-Object -Property * | Where-Object -FilterScript { $_.EnhancedKeyUsageList.FriendlyName -like "*Authentication*" -and $_.Issuer -notlike "CN=MS-Organization-P2P-Access*" } |  Where-Object -FilterScript { $_.FriendlyName -like "$FriendlyName" }
                    }
                }
            }
            Invoke-Command -Session $session -ScriptBlock $command

        }
        
    }
    process {

        if ($PSCmdlet.ShouldProcess($FriendlyName, "Checking expiry date for certificate friendlyname")) {

            foreach ($cert in $certchk) {
                $ExpiryDays = New-timeSpan -Start ($cert.NotAfter)

                if ($ExpiryDays.Days -le $Days) {

                    try {
                        $properties = [ordered]@{
                            FriendlyName     = $cert.FriendlyName
                            NotBefore        = $cert.NotBefore
                            NotAfter         = $cert.NotAfter
                            Subject          = $cert.Subject
                            SubjectName      = $cert.SubjectName
                            ExpireInDays     = $ExpiryDays.Days
                            CertificateStore = ($cert.PSParentPath -split "::")[1]
                            Issuer           = $cert.Issuer
                            ComputerName     = $Computer
                            Thumbprint       = $cert.Thumbprint
                            AuthUse          = $cert.EnhancedKeyUsageList
                            HasPrivateKey    = $cert.HasPrivateKey
                            PrivateKey       = $cert.PrivateKey
                            DnsNameList      = $cert.DnsNameList
                        }
                    }
                    catch {
                        Write-Error -Message $_
                    }
                    finally {
                        $obj = New-Object -TypeName PSObject -Property $properties
                        Write-Output $obj
                    }
                }

            }

        }

    }

    end {

    }

}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/CertificateUtilities/Public/Get-CertificateExpiry.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-CertificateExpiry.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

