---
layout: post
title: Expand-NinjaOne7Zip.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/expand-ninjaone7zip/
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

Extracts files from a NinjaOne Zip file using 7-Zip.

#### Detailed Description

The Expand-NinjaOne7Zip function extracts files from a NinjaOne Zip file using 7-Zip utility. It provides options to specify the destination folder, password (if required), and specific files to extract.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles"
```

This example extracts all files from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder.

**Example 2**

```powershell
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles" -Password "password" -FilesToExtract "file1.txt", "file2.txt"
```

This example extracts only "file1.txt" and "file2.txt" from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder, using the specified password.

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
Extracts files from a NinjaOne Zip file using 7-Zip.

.DESCRIPTION
The Expand-NinjaOne7Zip function extracts files from a NinjaOne Zip file using 7-Zip utility. It provides options to specify the destination folder, password (if required), and specific files to extract.

.PARAMETER ZipFile
Specifies the path to the NinjaOne Zip file that needs to be extracted. This parameter is mandatory.

.PARAMETER Destination
Specifies the path to the destination folder where the extracted files will be placed. This parameter is mandatory.

.PARAMETER Password
Specifies the password for the NinjaOne Zip file, if it is password protected. This parameter is optional.

.PARAMETER FilesToExtract
Specifies an array of specific files to extract from the NinjaOne Zip file. This parameter is optional.

.EXAMPLE
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles"

This example extracts all files from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder.

.EXAMPLE
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles" -Password "password" -FilesToExtract "file1.txt", "file2.txt"

This example extracts only "file1.txt" and "file2.txt" from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder, using the specified password.

#>
function Expand-NinjaOne7Zip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$ZipFile,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Destination,
        [Parameter(Mandatory = $false)]
        [string]$Password,
        [Parameter(Mandatory = $false)]
        [string[]]$FilesToExtract
    )

    try {
        # Unzip the NinjaOne Zip file using 7-Zip
        $arguments = "e `"$ZipFile`" -o`"$Destination`" -y"
        if ($Password) {
            $arguments += " -p`"$Password`""
        }
        if ($FilesToExtract) {
            foreach ($file in $FilesToExtract) {
                $arguments += " `"$file`""
            }
        }
        Start-Process -FilePath "7z" -ArgumentList $arguments -NoNewWindow -Wait -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to unzip file '$ZipFile' to destination '$Destination': $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Expand-NinjaOne7Zip.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Expand-NinjaOne7Zip.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

