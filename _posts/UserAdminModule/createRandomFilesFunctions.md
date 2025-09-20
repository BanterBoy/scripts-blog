---
layout: post
title: createRandomFilesFunctions.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/createRandomFilesFunctions/
categories:
- UserAdminModule
- FileOperations
tags:
- PowerShell
- User Admin Module
- Random Files Functions
description: Creates random documents in a specified folder.
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

Creates random documents in a specified folder.

#### Detailed Description

The CreateRandomDocument function generates a specified number of random documents in a specified folder. Each document is named "Document_x.docx" where x is a random number between 10000 and 99999. The function returns an array of the paths of the created documents.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
CreateRandomDocument -FolderPath "C:\path\to\your\folder" -NumberOfFiles 10
```

Creates 10 random documents in the specified folder.

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
Creates random documents in a specified folder.

.DESCRIPTION
The CreateRandomDocument function generates a specified number of random documents in a specified folder. Each document is named "Document_x.docx" where x is a random number between 10000 and 99999. The function returns an array of the paths of the created documents.

.PARAMETER FolderPath
The path to the folder where the files should be created.

.PARAMETER NumberOfFiles
The number of files to create.

.EXAMPLE
CreateRandomDocument -FolderPath "C:\path\to\your\folder" -NumberOfFiles 10
Creates 10 random documents in the specified folder.

#>
function New-RandomDocument {
    param(
        [string]$FolderPath, # The path to the folder where the files should be created
        [int]$NumberOfFiles # The number of files to create
    )
    $createdDocuments = @()
    for ($i = 1; $i -le $NumberOfFiles; $i++) {
        # Name will be Document_x.docx with x being a random number between 10000 and 99999
        $FileName = "Document_$((Get-Random -Minimum 10000 -Maximum 99999)).docx"
        $DocumentPath = [System.IO.Path]::Combine($FolderPath, $FileName)
        # Generate a random file name and write it to the file
        [System.IO.Path]::GetRandomFileName() | Out-File -FilePath $DocumentPath -Encoding utf8 -ErrorAction Stop
        # Check if the file was created successfully
        if (Test-Path $DocumentPath) {
            $createdDocuments += $DocumentPath
        } else {
            Write-Error "Failed to create file at $DocumentPath"
        }
    }
    # Return the paths of the created documents
    $createdDocuments
}


<#
.SYNOPSIS
Creates dummy images on the machine.

.DESCRIPTION
The CreateRandomImage function generates a specified number of dummy images with random colors and saves them to the specified folder path.

.PARAMETER FolderPath
The path to the folder where the images should be created.

.PARAMETER NumberOfImages
The number of images to create.

.EXAMPLE
CreateRandomImage -FolderPath "C:\path\to\your\folder" -NumberOfImages 5
Creates 5 dummy images in the specified folder path.

#>
function New-RandomImage {
    param(
        [string]$FolderPath, # The path to the folder where the images should be created
        [int]$NumberOfImages # The number of images to create
    )
    $createdImages = @()
    for ($i = 1; $i -le $NumberOfImages; $i++) {
        # Name will be Image_x.png with x being a random number between 10000 and 99999
        $FileName = "Image_$((Get-Random -Minimum 10000 -Maximum 99999))_$i.png"
        $ImagePath = [System.IO.Path]::Combine($FolderPath, $FileName)
        $bitmap = New-Object System.Drawing.Bitmap 300,300
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        # The colour of the image created is random
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb((Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255)))
        $graphics.FillRectangle($brush, 0, 0, 300, 300)
        $bitmap.Save($ImagePath, [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        if (Test-Path $ImagePath) {
            $createdImages += $ImagePath
        }
    }
    $createdImages
}


<#
.SYNOPSIS
This function creates dummy audio and video files on the machine.

.DESCRIPTION
The AudioAndVideo function creates a specified number of dummy audio and video files in a specified folder. Each file is named with a timestamp and a unique identifier.

.PARAMETER FolderPath
The path to the folder where the audio and video files should be created.

.PARAMETER NumberOfFiles
The number of audio and video files to create.

.EXAMPLE
AudioAndVideo -FolderPath "C:\path\to\your\folder" -NumberOfFiles 3
Creates 3 dummy audio and video files in the specified folder.

#>
function New-RandomAudioAndVideo {
    param(
        [string]$FolderPath, # The path to the folder where the audio and video files should be created
        [int]$NumberOfFiles # The number of audio and video files to create
    )
    $createdAudio = @()
    $createdVideo = @()
    for ($i = 1; $i -le $NumberOfFiles; $i++) {
        # Name will be Audio_x.wav with x being a random number between 10000 and 99999
        $audioFileName = "Audio_" + (Get-Date -Format "yyyyMMddHHmmss") + "_$i.wav"
        # Name will be Video_x.mp4 with x being a random number between 10000 and 99999
        $videoFileName = "Video_" + (Get-Date -Format "yyyyMMddHHmmss") + "_$i.mp4"
        $audioFilePath = [System.IO.Path]::Combine($FolderPath, $audioFileName)
        $videoFilePath = [System.IO.Path]::Combine($FolderPath, $videoFileName)
        New-Item -Path $audioFilePath -ItemType File | Out-Null
        New-Item -Path $videoFilePath -ItemType File | Out-Null
        if (Test-Path $audioFilePath) {
            $createdAudio += $audioFilePath
        }
        if (Test-Path $videoFilePath) {
            $createdVideo += $videoFilePath
        }
    }
    $createdAudio, $createdVideo
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/FileOperations/Public/createRandomFilesFunctions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=createRandomFilesFunctions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

