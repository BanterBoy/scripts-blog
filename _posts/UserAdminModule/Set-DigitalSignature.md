---
layout: post
title: Set-DigitalSignature.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-DigitalSignature/
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

Set-DigitalSignature can be used to set the digital signature of a file.

#### Detailed Description

Set-DigitalSignature will extract the Digital Code Signing Certificate from your Personal Store and set it as the digital signature of the file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-DigitalSignature -Path C:\Users\Administrator\Desktop\UnsignedScript.ps1
```

Extracts the digital signature from the Personal Store and sets it as the digital signature of the file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Last Edit: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-DigitalSignature {

    <#
    .SYNOPSIS
        Set-DigitalSignature can be used to set the digital signature of a file.
    
    .DESCRIPTION
        Set-DigitalSignature will extract the Digital Code Signing Certificate from your Personal Store and set it as the digital signature of the file.
    
    .PARAMETER Path
        This parameter is the path to the file you want to set the digital signature of.
    
    .EXAMPLE
        Set-DigitalSignature -Path C:\Users\Administrator\Desktop\UnsignedScript.ps1

        Extracts the digital signature from the Personal Store and sets it as the digital signature of the file.    

    .OUTPUTS
        System.String
    
    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30
    
    .LINK
        https://github.com/BanterBoy
    #>
    
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string], ParameterSetName = 'Default')]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the path to the file to be signed.")]
        [string]
        $Path
    )
    
    BEGIN {
        Write-Verbose "Starting the digital signature process..."
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$Path", "Set digital signature")) {
            try {
                Write-Verbose "Retrieving code signing certificate from the Personal store..."
                $codesigningcert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
                
                if ($null -eq $codesigningcert) {
                    Write-Error "No code signing certificate found in the Personal store."
                    return
                }
                
                Write-Verbose "Certificate retrieved: $($codesigningcert.Subject)"
                Write-Verbose "Signing file: $Path"
                
                $signature = Set-AuthenticodeSignature -FilePath $Path -Certificate $codesigningcert
                
                if ($signature.Status -eq 'Valid') {
                    Write-Verbose "File successfully signed."
                    Write-Output "File '$Path' has been successfully signed with the certificate: $($codesigningcert.Subject)"
                }
                else {
                    Write-Error "Failed to sign the file. Signature status: $($signature.Status)"
                }
            }
            catch {
                Write-Error "An error occurred while setting the digital signature: $_"
            }
        }
    }
    END {
        Write-Verbose "Digital signature process completed."
    }
}

# Example usage:
# Set-DigitalSignature -Path "C:\Users\Administrator\Desktop\UnsignedScript.ps1" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/CertificateUtilities/Public/Set-DigitalSignature.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-DigitalSignature.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

