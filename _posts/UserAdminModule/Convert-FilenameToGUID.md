---
layout: post
title: Convert-FilenameToGUID.ps1
date: 2025-09-19
permalink: /useradminmodule/fileoperations/convert-filenametoguid/
categories:
  - UserAdminModule
  - FileOperations
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

Converts a filename (without extension) to a GUID using SHA256 hash.

#### Detailed Description

This function takes a filename (without extension) as input and computes its SHA256 hash. The hash is then converted to a hexadecimal string and the first 32 characters are formatted as a GUID.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Convert-FilenameToGUID -filenameWithoutExtension "MyImage"
```

This example converts the filename "MyImage" to a GUID using SHA256 hash.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: GitHub Copilot

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Convert-FilenameToGUID {
    <#
    .SYNOPSIS
    Converts a filename (without extension) to a GUID using SHA256 hash.
    
    .DESCRIPTION
    This function takes a filename (without extension) as input and computes its SHA256 hash. The hash is then converted to a hexadecimal string and the first 32 characters are formatted as a GUID.
    
    .PARAMETER filenameWithoutExtension
    The filename (without extension) to be converted to a GUID.
    
    .EXAMPLE
    Convert-FilenameToGUID -filenameWithoutExtension "MyImage"
    
    This example converts the filename "MyImage" to a GUID using SHA256 hash.
    
    .NOTES
    Author: GitHub Copilot
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$filenameWithoutExtension
    )

    try {
        # Compute the SHA256 hash
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $hashBytes = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($filenameWithoutExtension))

        # Convert the hash to a hexadecimal string
        $hexString = [BitConverter]::ToString($hashBytes) -replace '-'
        
        # Take the first 32 characters and format as a GUID
        $guidString = "{0}-{1}-{2}-{3}-{4}" -f $hexString.Substring(0, 8), $hexString.Substring(8, 4), $hexString.Substring(12, 4), $hexString.Substring(16, 4), $hexString.Substring(20, 12)
        $guid = [System.Guid]::Parse($guidString)

        return $guid
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        if ($null -ne $sha256) {
            $sha256.Dispose()
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Convert-FilenameToGUID.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Convert-FilenameToGUID.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

