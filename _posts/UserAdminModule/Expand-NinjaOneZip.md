---
layout: post
title: Expand-NinjaOneZip.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Expand-NinjaOneZip/
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

Extracts the contents of a NinjaOne Zip file to a specified destination folder.

#### Detailed Description

The Expand-NinjaOneZip function extracts the contents of a NinjaOne Zip file to a specified destination folder.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Expand-NinjaOneZip -ZipFile "C:\Temp\NinjaOne.zip" -Destination "C:\Temp\Extracted"
```

This example extracts the contents of the "NinjaOne.zip" file located in "C:\Temp" to the "C:\Temp\Extracted" folder.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Expand-NinjaOneZip {
    <#
    .SYNOPSIS
        Extracts the contents of a NinjaOne Zip file to a specified destination folder.
    .DESCRIPTION
        The Expand-NinjaOneZip function extracts the contents of a NinjaOne Zip file to a specified destination folder.
    .PARAMETER ZipFile
        Specifies the path to the NinjaOne Zip file to extract.
    .PARAMETER Destination
        Specifies the path to the destination folder where the contents of the Zip file will be extracted.
    .EXAMPLE
        Expand-NinjaOneZip -ZipFile "C:\Temp\NinjaOne.zip" -Destination "C:\Temp\Extracted"
        This example extracts the contents of the "NinjaOne.zip" file located in "C:\Temp" to the "C:\Temp\Extracted" folder.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$ZipFile,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Destination
    )

    # Import the Microsoft.PowerShell.Archive module
    Import-Module -Name Microsoft.PowerShell.Archive

    try {
        # Unzip the NinjaOne Zip file
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to unzip file: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Expand-NinjaOneZip.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Expand-NinjaOneZip.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

