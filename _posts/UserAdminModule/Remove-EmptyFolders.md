---
layout: post
title: Remove-EmptyFolders.ps1
date: 2025-09-19
permalink: /useradminmodule/fileoperations/remove-emptyfolders/
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

Removes empty folders from a specified path recursively.

#### Detailed Description

The Remove-EmptyFolders function traverses a specified directory path recursively and removes any empty folders it finds. It also checks if the root folder itself is empty and removes it if necessary.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-EmptyFolders -Path "C:\Temp"
```

**Example 2**

```powershell
Remove-EmptyFolders "\\deathstar.domain.leigh-services.com\MyMusic\" -Verbose
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-EmptyFolders {
    <#
    .SYNOPSIS
    Removes empty folders from a specified path recursively.

    .DESCRIPTION
    The Remove-EmptyFolders function traverses a specified directory path recursively and removes any empty folders it finds. It also checks if the root folder itself is empty and removes it if necessary.

    .PARAMETER Path
    The path of the directory to check for empty folders.

    .EXAMPLE
    Remove-EmptyFolders -Path "C:\Temp"

    .EXAMPLE
    Remove-EmptyFolders "\\deathstar.domain.leigh-services.com\MyMusic\" -Verbose

    .INPUTS
    System.String. The path to the directory to check for empty folders.

    .OUTPUTS
    System.String. A message indicating which folders were removed.

    .NOTES
    Author: Your Name
    Date: 2024-06-30
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    # Helper function to determine if a folder is empty
    function Is-EmptyFolder {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath
        )
        # Check if the folder contains any files or subfolders
        if ((Get-ChildItem -Path $FolderPath -File).Count -eq 0 -and
            (Get-ChildItem -Path $FolderPath -Directory).Count -eq 0) {
            return $true
        }
        return $false
    }

    # Check if the path exists
    if (-Not (Test-Path -Path $Path)) {
        Write-Error "The specified path '$Path' does not exist."
        return
    }

    # Get all directories recursively
    $directories = Get-ChildItem -Path $Path -Directory -Recurse | Sort-Object -Property FullName -Descending

    foreach ($dir in $directories) {
        if (Is-EmptyFolder -FolderPath $dir.FullName) {
            try {
                Remove-Item -Path $dir.FullName -Force -Recurse
                Write-Verbose "Removed empty folder: $($dir.FullName)"
            }
            catch {
                Write-Warning "Failed to remove folder: $($dir.FullName) - $_"
            }
        }
    }

    # Check if the root folder itself is empty and remove if necessary
    if (Is-EmptyFolder -FolderPath $Path) {
        try {
            Remove-Item -Path $Path -Force -Recurse
            Write-Verbose "Removed empty root folder: $Path"
        }
        catch {
            Write-Warning "Failed to remove root folder: $Path - $_"
        }
    }
}

# Example Usage:
# Remove-EmptyFolders -Path "\\deathstar.domain.leigh-services.com\MyMusic\" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Remove-EmptyFolders.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-EmptyFolders.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

