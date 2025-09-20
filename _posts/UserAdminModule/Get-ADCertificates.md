---
layout: post
title: Get-ADCertificates.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-ADCertificates/
categories:
- UserAdminModule
- PKICertificateTools
tags:
- PowerShell
- User Admin Module
- Active Directory Certificates
- Active Directory
description: No synopsis provided.
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
```powershell
function Get-ADCertificates {
    [CmdletBinding()]
    Param(
        # Optional PSCredential for remote access. If not specified, uses the current user context.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]$Credential,
        
        # ComputerName(s) to query. Defaults to the local computer.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        # Optional filter: certificates issued on or after this date.
        [Parameter()]
        [AllowNull()]
        [DateTime]$ValidAfter = $null,
        
        # Optional filter: certificates that expire on or before this date.
        [Parameter()]
        [AllowNull()]
        [DateTime]$ValidBefore = $null
    )

    # Define the certificate store locations to scan.
    $storePaths = @("Cert:\LocalMachine\My", "Cert:\CurrentUser\My")

    # Prepare a script block that will run on a target machine.
    $scriptBlock = {
        param(
            [string[]]$storePaths,
            [AllowNull()]
            [DateTime]$ValidAfter,
            [AllowNull()]
            [DateTime]$ValidBefore
        )

        $results = @()
        foreach ($store in $storePaths) {
            try {
                Get-ChildItem -Path $store -ErrorAction Stop | ForEach-Object {
                    $cert = $_

                    # Apply date filters if provided. Use 'continue' to skip current iteration.
                    if ($ValidAfter -and $cert.NotBefore -lt $ValidAfter) {
                        continue
                    }
                    if ($ValidBefore -and $cert.NotAfter -gt $ValidBefore) {
                        continue
                    }

                    # Create a custom PSObject with expanded certificate details.
                    $results += [PSCustomObject]@{
                        ComputerName       = $env:COMPUTERNAME
                        StoreLocation      = $store
                        Subject            = $cert.Subject
                        Issuer             = $cert.Issuer
                        NotBefore          = $cert.NotBefore
                        NotAfter           = $cert.NotAfter
                        Thumbprint         = $cert.Thumbprint
                        FriendlyName       = $cert.FriendlyName
                        SerialNumber       = $cert.SerialNumber
                        Version            = $cert.Version
                        HasPrivateKey      = $cert.HasPrivateKey
                        SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
                    }
                }
            }
            catch {
                Write-Warning "Could not access store $store on $env:COMPUTERNAME: $_"
            }
        }
        return $results
    }

    $allResults = @()
    foreach ($computer in $ComputerName) {
        if ($computer -eq $env:COMPUTERNAME) {
            # Local query.
            $results = & $scriptBlock -storePaths $storePaths -ValidAfter $ValidAfter -ValidBefore $ValidBefore
            $allResults += $results
        }
        else {
            # Remote query using Invoke-Command.
            try {
                $sessionParams = @{
                    ComputerName = $computer
                    ScriptBlock  = $scriptBlock
                    ArgumentList = @($storePaths, $ValidAfter, $ValidBefore)
                }
                if ($Credential) {
                    $sessionParams.Credential = $Credential
                }
                $results = Invoke-Command @sessionParams -ErrorAction Stop
                $allResults += $results
            }
            catch {
                # Use $($computer) to clearly expand the variable if desired.
                Write-Warning "Error connecting to $($computer): $_"
            }
        }
    }

    # Output all the collected certificate details.
    return $allResults
}

<# 
    Example usage:

    # Retrieve all certificate details on the local computer:
    Get-ADCertificates

    # Retrieve certificate details from remote computers using credentials:
    $cred = Get-Credential
    Get-ADCertificates -Credential $cred -ComputerName "Server01", "Server02"

    # Retrieve certificate details with validity dates filtered:
    Get-ADCertificates -ValidAfter (Get-Date "2023-01-01") -ValidBefore (Get-Date "2025-12-31")

    # Filter the output for certificates issued by a particular CA:
    Get-ADCertificates | Where-Object { $_.Issuer -like "*YourCAName*" }
#>
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/PKICertificateTools/Public/Get-ADCertificates.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADCertificates.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

