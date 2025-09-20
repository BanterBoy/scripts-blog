---
layout: post
title: Remove-FoldersWithoutSpecifiedFiles.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Remove-FoldersWithoutSpecifiedFiles/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- Folders Without Specified Files
description: Removes folders that do not contain specified file types.
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

Removes folders that do not contain specified file types.

#### Detailed Description

This function recursively scans directories within the specified path and removes any folder that does not contain files of the specified types. It can also generate a validation report listing the folders that would be deleted, without actually deleting them.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Validation -ReportPath "C:\Temp\NonMP3Folders.csv"
```

This example validates folders in the specified path and generates a report of folders without .mp3 files.

**Example 2**

```powershell
Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3"
```

This example removes folders in the specified path that do not contain .mp3 files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-FoldersWithoutSpecifiedFiles {
    <#
    .SYNOPSIS
        Removes folders that do not contain specified file types.

    .DESCRIPTION
        This function recursively scans directories within the specified path and removes any folder that does not contain files of the specified types. 
        It can also generate a validation report listing the folders that would be deleted, without actually deleting them.

    .PARAMETER Path
        The root path to begin scanning for folders.

    .PARAMETER FileTypes
        An array of file extensions to check for within each folder.

    .PARAMETER Validation
        If specified, the function will generate a validation report without deleting any folders.

    .PARAMETER ReportPath
        The file path to save the validation report to. Defaults to "DeletionReport.csv".

    .EXAMPLE
        Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Validation -ReportPath "C:\Temp\NonMP3Folders.csv"
        This example validates folders in the specified path and generates a report of folders without .mp3 files.

    .EXAMPLE
        Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3"
        This example removes folders in the specified path that do not contain .mp3 files.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$FileTypes,

        [Parameter(Mandatory = $false)]
        [switch]$Validation,

        [Parameter(Mandatory = $false)]
        [string]$ReportPath = "DeletionReport.csv"
    )

    # Helper function to determine if a folder or any of its subfolders contain specified file types
    function Test-SpecifiedFilesExist {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath,
    
            [Parameter(Mandatory = $true)]
            [string[]]$FileTypes
        )
    
        foreach ($fileType in $FileTypes) {
            if ((Get-ChildItem -Path $FolderPath -Filter "*.$fileType" -File -Recurse).Count -gt 0) {
                return $true
            }
        }
        return $false
    }

    # Helper function to get list of files in the folder
    function Get-FilesInFolder {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FolderPath
        )

        return Get-ChildItem -Path $FolderPath -File -Recurse | Select-Object -ExpandProperty FullName
    }

    $deletionReport = @()

    # Get all directories recursively, sorted in descending order
    $directories = Get-ChildItem -Path $Path -Directory -Recurse | Sort-Object -Property FullName -Descending

    foreach ($dir in $directories) {
        Write-Verbose -Message "Checking folder: $($dir.FullName)"
        if (-not (Test-SpecifiedFilesExist -FolderPath $dir.FullName -FileTypes $FileTypes)) {
            $filesInFolder = (Get-FilesInFolder -FolderPath $dir.FullName) -join "; "
            if ($Validation) {
                Write-Verbose -Message "Adding $($dir.FullName) to validation report"
                $deletionReport += [pscustomobject]@{
                    Path          = $dir.FullName
                    Type          = "Folder"
                    ContainsFiles = $filesInFolder
                }
            }
            else {
                Write-Verbose -Message "Attempting to remove folder: $($dir.FullName)"
                try {
                    Remove-Item -Path $dir.FullName -Force -Recurse
                    Write-Output "Removed folder without specified files: $($dir.FullName)"
                }
                catch {
                    Write-Output "Failed to remove folder: $($dir.FullName) - $_"
                }
            }
        }
    }

    # Check if the root folder itself should be removed
    Write-Verbose -Message "Checking root folder: $Path"
    if (-not (Test-SpecifiedFilesExist -FolderPath $Path -FileTypes $FileTypes)) {
        $filesInFolder = (Get-FilesInFolder -FolderPath $Path) -join "; "
        if ($Validation) {
            Write-Verbose -Message "Adding $Path to validation report"
            $deletionReport += [pscustomobject]@{
                Path          = $Path
                Type          = "Folder"
                ContainsFiles = $filesInFolder
            }
        }
        else {
            Write-Verbose -Message "Attempting to remove root folder: $Path"
            try {
                Remove-Item -Path $Path -Force -Recurse
                Write-Output "Removed root folder without specified files: $Path"
            }
            catch {
                Write-Output "Failed to remove root folder: $Path - $_"
            }
        }
    }

    if ($Validation -and $deletionReport.Count -gt 0) {
        Write-Verbose -Message "Saving validation report to $ReportPath"
        $deletionReport | Export-Csv -Path $ReportPath -NoTypeInformation
        Write-Output "Validation report saved to $ReportPath"
    }
    elseif ($Validation) {
        Write-Output "No folders or files to delete."
    }
}

# Example usage with validation:
# Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Validation -ReportPath "C:\Temp\NonMP3Folders.csv" -Verbose

# Example usage without validation:
# Remove-FoldersWithoutSpecifiedFiles -Path "\\server\share" -FileTypes "mp3" -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/Remove-FoldersWithoutSpecifiedFiles.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-FoldersWithoutSpecifiedFiles.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

