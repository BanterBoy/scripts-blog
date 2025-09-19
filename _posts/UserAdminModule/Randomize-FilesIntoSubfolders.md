---
layout: post
title: Randomize-FilesIntoSubfolders.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Randomize-FilesIntoSubfolders/
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

Distributes files from a base directory into a specified number of randomly named subfolders.

#### Detailed Description

The Randomize-FilesIntoSubfolders function takes all files from a specified base directory and distributes them into a specified number of subfolders with random names. If the base directory does not exist or contains no files, appropriate warnings or errors are displayed.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Randomize-FilesIntoSubfolders -baseDirectory "C:\Path\To\Your\Files" -numFolders 5
```

Distributes all files from "C:\Path\To\Your\Files" into 5 randomly named subfolders within the same directory.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Randomize-FilesIntoSubfolders {
    <#
    .SYNOPSIS
    Distributes files from a base directory into a specified number of randomly named subfolders.

    .DESCRIPTION
    The Randomize-FilesIntoSubfolders function takes all files from a specified base directory and distributes them into a specified number of subfolders with random names. If the base directory does not exist or contains no files, appropriate warnings or errors are displayed.

    .PARAMETER baseDirectory
    The path of the base directory containing the files to be moved.

    .PARAMETER numFolders
    The number of subfolders to create in the base directory.

    .EXAMPLE
    Randomize-FilesIntoSubfolders -baseDirectory "C:\Path\To\Your\Files" -numFolders 5
    Distributes all files from "C:\Path\To\Your\Files" into 5 randomly named subfolders within the same directory.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None. This function does not produce any output.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$baseDirectory,

        [Parameter(Mandatory = $true)]
        [int]$numFolders
    )

    # Check if the directory exists
    if (-Not (Test-Path -Path $baseDirectory)) {
        Write-Error "The directory '$baseDirectory' does not exist."
        return
    }
    else {
        Write-Verbose "The directory '$baseDirectory' exists."
    }

    # Check if the directory is not empty
    $files = Get-ChildItem -Path $baseDirectory -File
    if ($files.Count -eq 0) {
        Write-Warning "There are no files in the base directory '$baseDirectory' to move."
        return
    }
    else {
        Write-Verbose "Found $($files.Count) files in the base directory '$baseDirectory'."
    }

    # Generate random folder names and create them
    $randomFolderNames = 1..$numFolders | ForEach-Object {
        $randomFolderName = [System.IO.Path]::GetRandomFileName().Replace(".", "")
        $folderPath = Join-Path -Path $baseDirectory -ChildPath $randomFolderName
        New-Item -Path $folderPath -ItemType Directory | Out-Null
        Write-Verbose "Created folder '$folderPath'."
        $folderPath
    }

    # Move files to random folders
    foreach ($file in $files) {
        $randomFolderPath = Get-Random -InputObject $randomFolderNames
        $destinationPath = Join-Path -Path $randomFolderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
        Write-Verbose "Moved file '$($file.Name)' to folder '$randomFolderPath'."
    }
}

# Example Usage:
# Randomize-FilesIntoSubfolders -baseDirectory "C:\Path\To\Your\Files" -numFolders 5 -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Randomize-FilesIntoSubfolders.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Randomize-FilesIntoSubfolders.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

