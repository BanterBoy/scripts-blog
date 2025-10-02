---
layout: post
title: Invoke-RemoteZipExpansion.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/fileoperations/invoke-remotezipexpansion/
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

Expands a ZIP file on a remote computer.

#### Detailed Description

The Invoke-RemoteZipExpansion function expands a ZIP file on a remote computer. It uses the Invoke-Command cmdlet to run the Expand-Archive cmdlet on the remote computer.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$credential = Get-Credential
```

$sourceZipFilePath = "C:\Path\To\Your\ZipFile.zip" $destinationFolderPath = "C:\Path\To\DestinationFolder" Invoke-RemoteZipExpansion -ComputerName "RemoteServerName" -SourceZipFilePath $sourceZipFilePath -DestinationFolderPath $destinationFolderPath -Credential $credential

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Expands a ZIP file on a remote computer.

.DESCRIPTION
The Invoke-RemoteZipExpansion function expands a ZIP file on a remote computer. 
It uses the Invoke-Command cmdlet to run the Expand-Archive cmdlet on the remote computer.

.PARAMETER ComputerName
The name of the remote computer where the ZIP file will be expanded.

.PARAMETER SourceZipFilePath
The path of the ZIP file on the remote computer.

.PARAMETER DestinationFolderPath
The path of the folder on the remote computer where the ZIP file will be expanded.

.PARAMETER Credential
The credentials used to connect to the remote computer.

.EXAMPLE
$credential = Get-Credential
$sourceZipFilePath = "C:\Path\To\Your\ZipFile.zip"
$destinationFolderPath = "C:\Path\To\DestinationFolder"
Invoke-RemoteZipExpansion -ComputerName "RemoteServerName" -SourceZipFilePath $sourceZipFilePath -DestinationFolderPath $destinationFolderPath -Credential $credential
#>
function Invoke-RemoteZipExpansion {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$SourceZipFilePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationFolderPath,

        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )

    # Check if the source ZIP file exists
    if (-not (Test-Path $sourceZip)) {
        Write-Error "ZIP file not found at $sourceZip"
        return
    }

    $scriptBlock = {
        param (
            [string]$sourceZip,
            [string]$destinationFolder
        )

        # Check if the destination folder exists and is writable
        if (-not (Test-Path $destinationFolder -PathType Container)) {
            Write-Error "Destination folder not found at $destinationFolder"
            return
        }

        # Expand the ZIP file
        Expand-Archive -Path $sourceZip -DestinationPath $destinationFolder -Force
        Write-Host "Uncompressed $sourceZip to $destinationFolder"
    }

    # Execute the command on the remote computer with credentials
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $SourceZipFilePath, $DestinationFolderPath -Credential $Credential
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Invoke-RemoteZipExpansion.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-RemoteZipExpansion.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

