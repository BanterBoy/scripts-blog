---
layout: post
title: Set-FFMpegVideoSpeed.ps1
date: 2025-09-19
permalink: /useradminmodule/mediamanagement/set-ffmpegvideospeed/
categories:
  - UserAdminModule
  - MediaManagement
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

Speed up a video file by a configurable percentage while keeping audio and video in sync.

#### Detailed Description

`Set-FFMpegVideoSpeed` wraps the ffmpeg `setpts` and `atempo` filters to produce a faster version of a video. Provide the full path to the source file and the desired output location, then specify the percentage increase. The function converts that percentage into a factor that ffmpeg uses to adjust both video frames and audio tempo, giving you a sped-up copy without touching the source file.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Set-FFMpegVideoSpeed -VideoFile "C:\\Media\\Clips\\demo.mp4" -OutputFile "C:\\Media\\Clips\\demo-fast.mp4" -SpeedUpPercentage 150
```

Creates a copy of the clip at 1.5x speed.

**Example 2**

```powershell
Get-ChildItem -Path "C:\\Media\\Highlights" -Filter *.mp4 |
    ForEach-Object {
        $output = Join-Path $_.Directory.FullName ("{0}-fast{1}" -f $_.BaseName, $_.Extension)
        Set-FFMpegVideoSpeed -VideoFile $_.FullName -OutputFile $output -SpeedUpPercentage 200
    }
```

Batch processes highlight reels, doubling their playback speed while writing new files alongside the originals.

**Example 3**

```powershell
Set-FFMpegVideoSpeed -VideoFile "C:\\Media\\Tutorials\\walkthrough.mkv" -OutputFile "C:\\Media\\Tutorials\\walkthrough-condensed.mkv"
```

Uses the default `SpeedUpPercentage` value (100) to keep tempo unchanged, which is handy when you only want to re-encode with the preset filters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- Requires ffmpeg to be installed and present on the system `PATH`.
- Ensure the output file extension matches the input container to avoid format issues.
- For speeds greater than 200% you may need to adjust the `atempo` filter chain manually, as ffmpeg limits each `atempo` stage to a factor between 0.5 and 2.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Speeds up a video file.

.DESCRIPTION
Speeds up a video file by a specified percentage, adjusting both video and audio to maintain synchronization. Useful for creating condensed versions of media or increasing playback speed for review purposes.

.PARAMETER VideoFile
Input video file. Full path.

.PARAMETER OutputFile
Output video file. Full path, and make sure that the file extension is the same as the input. Might not matter but why risk it?

.PARAMETER SpeedUpPercentage
Percentage to speed up the video by. 100% will be twice as fast, etc. Defaults to 100.

.EXAMPLE
Set-FFMpegVideoSpeed -VideoFile "C:\Users\Rob\OneDrive\Desktop\Black.Mirror.S01E01.720p.HDTV.x264-BiA.avi" -OutputFile "C:\Temp\out.avi" -SpeedUpPercentage 400

#>
function Set-FFMpegVideoSpeed {
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipeline = $false, HelpMessage = "Input video file. Full path.")]
        [string]$VideoFile,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "Output video file. Full path, and make sure that the file extension is the same as the input. Might not matter but why risk it?")]
        [string]$OutputFile,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "Percentage to speed up the video by. 100% will be twice as fast, etc. Defaults to 100.")]
        [int]$SpeedUpPercentage = 100
    )

    process {
        [decimal] $factor = ($SpeedUpPercentage / 100)

        ffmpeg -i "$VideoFile" -vf "setpts=(PTS-STARTPTS)/$factor" -crf 18 -af atempo=$factor $OutputFile
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Set-FFMpegVideoSpeed.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-FFMpegVideoSpeed.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>
