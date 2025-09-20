---
layout: post
title: Unblock-AndUnzipFiles.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Unblock-AndUnzipFiles/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- Unblock And Unzip Files
description: Unblocks and unzips all zip files in a specified folder or a single zip
  file.
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

Unblocks and unzips all zip files in a specified folder or a single zip file.

#### Detailed Description

This function unblocks all zip files in the specified folder or a single zip file and then unzips each file into a folder with the same name as the zip file. It also provides a list of zip files that have been unzipped upon completion.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Unblock-AndUnzipFiles -FolderPath "C:\Temp\WindowsSecurityBaseline"
```

This example unblocks and unzips all zip files in the C:\Temp\WindowsSecurityBaseline folder.

**Example 2**

```powershell
Unblock-AndUnzipFiles -FilePath "C:\Temp\WindowsSecurityBaseline\example.zip"
```

This example unblocks and unzips the example.zip file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Unblock-AndUnzipFiles {
    <#
    .SYNOPSIS
    Unblocks and unzips all zip files in a specified folder or a single zip file.
    
    .DESCRIPTION
    This function unblocks all zip files in the specified folder or a single zip file and then unzips each file into a folder with the same name as the zip file. It also provides a list of zip files that have been unzipped upon completion.
    
    .PARAMETER FolderPath
    The path to the folder containing the zip files.
    
    .PARAMETER FilePath
    The path to a single zip file.
    
    .EXAMPLE
    Unblock-AndUnzipFiles -FolderPath "C:\Temp\WindowsSecurityBaseline"
    
    This example unblocks and unzips all zip files in the C:\Temp\WindowsSecurityBaseline folder.
    
    .EXAMPLE
    Unblock-AndUnzipFiles -FilePath "C:\Temp\WindowsSecurityBaseline\example.zip"
    
    This example unblocks and unzips the example.zip file.
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Folder')]
        [string]$FolderPath,

        [Parameter(Mandatory = $false, ParameterSetName = 'File')]
        [string]$FilePath
    )

    if ($PSCmdlet.ParameterSetName -eq 'Folder') {
        # Get all zip files in the folder
        $zipFiles = Get-ChildItem -Path $FolderPath -Filter *.zip
    } elseif ($PSCmdlet.ParameterSetName -eq 'File') {
        # Get the single zip file
        if (Test-Path -Path $FilePath) {
            $zipFiles = @(Get-Item -Path $FilePath)
        } else {
            Write-Error "The specified file does not exist."
            return
        }
    } else {
        Write-Error "You must specify either a FolderPath or a FilePath."
        return
    }

    # Total number of files to process
    $totalFiles = $zipFiles.Count
    $currentFile = 0

    # List to store the names of unzipped files
    $unzippedFiles = @()

    # Iterate through each zip file
    foreach ($zipFile in $zipFiles) {
        # Update progress bar
        $currentFile++
        $progressPercent = ($currentFile / $totalFiles) * 100
        Write-Progress -Activity "Unblocking and Unzipping Files" -Status "Processing $($zipFile.Name)" -PercentComplete $progressPercent

        # Unblock the zip file
        Unblock-File -Path $zipFile.FullName

        # Define the output folder path (same name as the zip file without extension)
        $outputFolderPath = Join-Path -Path $zipFile.DirectoryName -ChildPath ($zipFile.BaseName)

        # Create the output folder if it doesn't exist
        if (-not (Test-Path -Path $outputFolderPath)) {
            New-Item -Path $outputFolderPath -ItemType Directory | Out-Null
        }

        # Unzip the file into the output folder
        Expand-Archive -Path $zipFile.FullName -DestinationPath $outputFolderPath -Force

        # Add the zip file name to the list
        $unzippedFiles += $zipFile.Name
    }

    Write-Output "All zip files have been unblocked and unzipped successfully."
    Write-Output "List of unzipped files:"
    $unzippedFiles
}

# Example usage
# Unblock-AndUnzipFiles -FolderPath "C:\Temp\WindowsSecurityBaseline"
# Unblock-AndUnzipFiles -FilePath "C:\Temp\WindowsSecurityBaseline\example.zip"
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Unblock-AndUnzipFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Unblock-AndUnzipFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

