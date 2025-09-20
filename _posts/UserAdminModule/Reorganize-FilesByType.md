---
layout: post
title: Reorganize-FilesByType.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Reorganize-FilesByType/
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

Reorganizes files in a directory into subfolders based on file types.

#### Detailed Description

This function reorganizes all files in the specified base directory (and its subdirectories) into subfolders based on their file extensions. It also cleans up any empty folders after moving the files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Reorganize-FilesByType -baseDirectory "C:\Path\To\Your\Files"
```

This example reorganizes all files in "C:\Path\To\Your\Files" into subfolders based on their file types.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Reorganize-FilesByType {

    <#
    .SYNOPSIS
        Reorganizes files in a directory into subfolders based on file types.

    .DESCRIPTION
        This function reorganizes all files in the specified base directory (and its subdirectories) into subfolders based on their file extensions. 
        It also cleans up any empty folders after moving the files.

    .PARAMETER baseDirectory
        The root directory containing the files to be reorganized.

    .EXAMPLE
        Reorganize-FilesByType -baseDirectory "C:\Path\To\Your\Files"
        This example reorganizes all files in "C:\Path\To\Your\Files" into subfolders based on their file types.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory
    )

    # Check if the directory exists
    if (-Not (Test-Path -Path $baseDirectory)) {
        Write-Error "The directory '$baseDirectory' does not exist."
        return
    }

    Write-Verbose "Scanning for all files in the directory and subdirectories."
    # Get all files in the directory and subdirectories
    $files = Get-ChildItem -Path $baseDirectory -File -Recurse

    Write-Verbose "Found $($files.Count) files. Starting reorganization process."

    # Loop through each file
    foreach ($file in $files) {
        # Extract the file extension and prepare the target subfolder path
        $fileExtension = $file.Extension.TrimStart('.')
        if ($fileExtension -eq '') {
            $fileExtension = 'NoExtension'
        }
        $targetFolder = Join-Path -Path $baseDirectory -ChildPath $fileExtension

        # Create the subfolder if it doesn't exist
        if (-Not (Test-Path -Path $targetFolder)) {
            Write-Verbose "Creating folder: $targetFolder"
            New-Item -Path $targetFolder -ItemType Directory | Out-Null
        }

        # Move the file to the target subfolder if it's not already there
        $targetFilePath = Join-Path -Path $targetFolder -ChildPath $file.Name
        if ($file.FullName -ne $targetFilePath) {
            Write-Verbose "Moving file: $($file.FullName) to $targetFilePath"
            Move-Item -Path $file.FullName -Destination $targetFilePath
        }
    }

    Write-Verbose "Reorganization complete. Starting cleanup of empty folders."

    # Clean up empty folders
    $allFolders = Get-ChildItem -Path $baseDirectory -Directory -Recurse
    foreach ($folder in $allFolders) {
        if ((Get-ChildItem -Path $folder.FullName).Count -eq 0) {
            Write-Verbose "Removing empty folder: $($folder.FullName)"
            Remove-Item -Path $folder.FullName
        }
    }

    Write-Verbose "Cleanup complete."
}

# Example Usage:
# Reorganize-FilesByType -baseDirectory "C:\Path\To\Your\Files" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Reorganize-FilesByType.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Reorganize-FilesByType.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

