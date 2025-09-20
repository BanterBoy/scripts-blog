---
layout: post
title: Convert-ImageForTeams.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Convert-ImageForTeams/
categories:
  - UserAdminModule
  - Teams
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

Converts images in a source folder to PNG format and creates thumbnail images.

#### Detailed Description

This function converts images in a source folder to PNG format and creates thumbnail images. The converted images and thumbnails are saved in a destination folder with GUID-based names.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Convert-ImageForTeams -sourceFolder "C:\Path\To\Source\Images" -destinationFolder "C:\Path\To\Destination"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Convert-ImageForTeams {
    <#
    .SYNOPSIS
    Converts images in a source folder to PNG format and creates thumbnail images.
    
    .DESCRIPTION
    This function converts images in a source folder to PNG format and creates thumbnail images. The converted images and thumbnails are saved in a destination folder with GUID-based names.
    
    .PARAMETER sourceFolder
    The path to the folder containing the source images.
    
    .PARAMETER destinationFolder
    The path to the folder where the converted images and thumbnails will be saved.
    
    .EXAMPLE
    Convert-ImageForTeams -sourceFolder "C:\Path\To\Source\Images" -destinationFolder "C:\Path\To\Destination"
    #>
    param (
        [string]$sourceFolder,
        [string]$destinationFolder
    )

    # Install the necessary .NET namespace
    Add-Type -AssemblyName System.Drawing

    # Dummy function to satisfy the GetThumbnailImage method
    function dummyCallback { return $false }

    # Loop through each image file in the source folder
    Get-ChildItem -Path $sourceFolder -File | ForEach-Object {

        # Generate a GUID for the new image name
        $guid = [guid]::NewGuid().ToString()

        # Create a .NET Bitmap object from the image file
        $originalImage = [System.Drawing.Image]::FromFile($_.FullName)

        # Save the image as a PNG with a GUID-based name
        $originalImage.Save("$destinationFolder\$guid.png", [System.Drawing.Imaging.ImageFormat]::Png)

        # Create a thumbnail image
        $thumbWidth = 278
        $thumbHeight = 159
        $thumbnailImage = $originalImage.GetThumbnailImage($thumbWidth, $thumbHeight, [System.Drawing.Image+GetThumbnailImageAbort]$dummyCallback, [System.IntPtr]::Zero)

        # Save the thumbnail image as a PNG with a GUID-based name and "_thumb" suffix
        $thumbnailImage.Save("$destinationFolder\$guid`_thumb.png", [System.Drawing.Imaging.ImageFormat]::Png)

        # Dispose of the image objects to free resources
        $originalImage.Dispose()
        $thumbnailImage.Dispose()
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Teams/Public/Convert-ImageForTeams.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Convert-ImageForTeams.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

