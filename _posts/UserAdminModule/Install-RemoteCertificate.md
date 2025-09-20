---
layout: post
title: Install-RemoteCertificate.ps1
date: 2025-09-19
permalink: /useradminmodule/certificateutilities/install-remotecertificate/
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

Installs a certificate on a remote computer.

#### Detailed Description

This function installs a certificate on a remote computer using a PSSession.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Install-RemoteCertificate -ComputerName "RemoteComputer" -Credential $cred -PassString "password" -CertFilePath "C:\certificates\cert.pfx"
```

Installs the certificate located at "C:\certificates\cert.pfx" on the remote computer "RemoteComputer" using the specified credentials and password.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Install-RemoteCertificate {

    <#
    .SYNOPSIS
        Installs a certificate on a remote computer.
    .DESCRIPTION
        This function installs a certificate on a remote computer using a PSSession.
    .PARAMETER ComputerName
        Specifies the name of the remote computer on which to install the certificate.
    .PARAMETER Credential
        Specifies the credentials to use to authenticate the user on the remote computer.
    .PARAMETER PassString
        Specifies the password for the certificate file.
    .PARAMETER CertFilePath
        Specifies the path to the certificate file on the remote computer.
    .EXAMPLE
        Install-RemoteCertificate -ComputerName "RemoteComputer" -Credential $cred -PassString "password" -CertFilePath "C:\certificates\cert.pfx"
        Installs the certificate located at "C:\certificates\cert.pfx" on the remote computer "RemoteComputer" using the specified credentials and password.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default', supportsShouldProcess = $true, HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string]$ComputerName,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [ValidateNotNullOrEmpty()]
        [string]$PassString,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter the certificate Local file path, where it is located on the remote Server')]
        [ValidateNotNullOrEmpty()]
        [string]$CertFilePath
    )
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Install Certificate")) {
            try {
                Write-Verbose "Creating PSSession to $ComputerName"
                $PSSession = New-PSSession -ComputerName $ComputerName -Credential $Credential -Name "Certificate Install Session" -EnableNetworkAccess -ConfigurationName Microsoft.PowerShell -Authentication Kerberos
                Write-Verbose "Checking if certificate file exists at $CertFilePath"
                $fileExists = Invoke-Command -Session $PSSession -ScriptBlock { param($CertFilePath) Test-Path -Path $CertFilePath } -ArgumentList $CertFilePath
                if (-not $fileExists) {
                    Write-Error "Certificate file does not exist at path: $CertFilePath"
                    return
                }
                Write-Verbose "Invoking command to install certificate"
                Invoke-Command -Session  $PSSession -ScriptBlock { param($PassString, $CertFilePath)
                    try {
                        Write-Verbose 'Converting PassString to SecureString'
                        $crtPwd = ConvertTo-SecureString -String $PassString -AsPlainText -Force
                        Write-Verbose 'Importing Pfx Certificate'
                        Import-PfxCertificate -FilePath $CertFilePath -CertStoreLocation Cert:\LocalMachine\My -Password $crtpwd -ErrorAction Stop
                        Write-Output 'Certificate Installed'
                    }
                    catch {
                        Write-Error "Failed to install certificate: $_"
                    }
                } -ArgumentList $PassString, $CertFilePath
            }
            catch {
                Write-Error "Failed to create PSSession or invoke command: $_"
            }
            finally {
                Write-Verbose "Removing PSSession"
                if ($PSSession) {
                    Remove-PSSession -Session $PSSession
                }
            }
        }
    }
    END {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/CertificateUtilities/Public/Install-RemoteCertificate.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Install-RemoteCertificate.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

