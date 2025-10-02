---
layout: post
title: Create-VLCPlaylists.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/mediamanagement/create-vlcplaylists/
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

Creates VLC-compatible M3U playlists for MP3 files located in a specified directory and its subdirectories.

#### Detailed Description

The Create-VLCPlaylists function scans a given base directory and an optional subfolder for MP3 files. It creates M3U playlists for the MP3 files found directly in the specified directory or within its subdirectories.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Create-VLCPlaylists -baseDir "\\deathstar.domain.leigh-services.com\Public\PodCasts\I'm Sorry I Haven't a Clue" -subFolder "Season81"
```

This command will create M3U playlists for MP3 files located in the "Season81" subfolder of the specified base directory.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: Today's Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
    Creates VLC-compatible M3U playlists for MP3 files located in a specified directory and its subdirectories.

.DESCRIPTION
    The Create-VLCPlaylists function scans a given base directory and an optional subfolder for MP3 files. 
    It creates M3U playlists for the MP3 files found directly in the specified directory or within its subdirectories.

.PARAMETER baseDir
    The base directory containing the folders with MP3 files.

.PARAMETER subFolder
    The subfolder within the base directory that contains the MP3 files or further subdirectories.

.EXAMPLE
    Create-VLCPlaylists -baseDir "\\deathstar.domain.leigh-services.com\Public\PodCasts\I'm Sorry I Haven't a Clue" -subFolder "Season81"
    This command will create M3U playlists for MP3 files located in the "Season81" subfolder of the specified base directory.

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Create-VLCPlaylists {
    param (
        [string]$baseDir,
        [string]$subFolder
    )

    # Combine the base directory and subfolder to get the target directory
    $targetDir = Join-Path -Path $baseDir -ChildPath $subFolder
    Write-Output "Target directory: $targetDir"

    if (-Not (Test-Path -Path $targetDir)) {
        Write-Output "Error: Target directory '$targetDir' does not exist."
        return
    }

    # Check if the target directory contains MP3 files directly
    $mp3FilesInTargetDir = Get-ChildItem -Path $targetDir -Filter *.mp3 -ErrorAction SilentlyContinue
    if ($mp3FilesInTargetDir.Count -gt 0) {
        # Create playlist for MP3 files in the target directory
        $playlistPath = Join-Path -Path $targetDir -ChildPath "$subFolder.m3u"
        Write-Output "Creating playlist: $playlistPath"
        Create-Playlist -mp3Files $mp3FilesInTargetDir -playlistPath $playlistPath
    }
    else {
        # Get all directories within the target directory
        $directories = Get-ChildItem -Path $targetDir -Directory
        if ($directories.Count -eq 0) {
            Write-Output "No directories found in '$targetDir'."
            return
        }

        foreach ($directory in $directories) {
            $season = $directory.Name
            $playlistPath = Join-Path -Path $directory.FullName -ChildPath "$season.m3u"
            Write-Output "Creating playlist: $playlistPath"

            # Get all MP3 files in the current season directory
            $mp3Files = Get-ChildItem -Path $directory.FullName -Filter *.mp3 | Sort-Object Name
            if ($mp3Files.Count -eq 0) {
                Write-Output "No MP3 files found in '$directory.FullName'. Skipping..."
                continue
            }

            # Create the M3U playlist content
            Create-Playlist -mp3Files $mp3Files -playlistPath $playlistPath
        }
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Create-VLCPlaylists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Create-VLCPlaylists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

