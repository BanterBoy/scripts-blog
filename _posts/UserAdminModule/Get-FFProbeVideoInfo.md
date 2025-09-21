---
layout: post
title: Get-FFProbeVideoInfo.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/mediamanagement/get-ffprobevideoinfo/
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

Collect ffprobe metadata for video files and optionally return the audio streams as structured objects.

#### Detailed Description

`Get-FFProbeVideoInfo` targets video files in a chosen directory (or a specific file) and executes ffprobe with banner output suppressed. By default it writes the raw ffprobe results to the console, mirroring the traditional command-line experience. Supplying the `-GetAudioStreams` switch changes the behaviour to parse ffprobe's JSON stream data, returning each audio track with index, codec, and language fields—ideal for piping into `Remove-FFMpegVideoFileAudioStream`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-FFProbeVideoInfo -Dir "C:\\Media\\Movies" -VideoFile "Alien (1979).mkv"
```

Prints ffprobe metadata for the specified file while hiding banner information.

**Example 2**

```powershell
Get-FFProbeVideoInfo -Dir "C:\\Media\\Shows\\Season 01"
```

Iterates through every file in the folder, outputting ffprobe details for each item.

**Example 3**

```powershell
Get-FFProbeVideoInfo -Dir "C:\\Media\\Movies" -VideoFile "Alien (1979).mkv" -GetAudioStreams
```

Parses the ffprobe JSON response and returns audio stream objects instead of the raw console output.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- Requires ffprobe from the FFmpeg suite to be accessible in the current environment.
- When `-GetAudioStreams` is used, the function mirrors the output shape of [`Get-FFProbeAudioStreams`](/useradminmodule/mediamanagement/get-ffprobeaudiostreams/), returning an object per audio track.
- Omitting `-VideoFile` causes the function to enumerate every file in the specified directory, matching the behaviour of the original monolithic script.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Calls ffprobe to get a video file's info (without banner). Can optionally return audio stream information as objects.

.DESCRIPTION
Calls ffprobe to get a video file's info (without banner). When GetAudioStreams is specified, returns structured audio stream information instead of raw output.

.PARAMETER Dir
The directory the file is located in. Defaults to current location if not supplied.

.PARAMETER VideoFile
The video file name. Iterates every file in the directory if not supplied.

.PARAMETER GetAudioStreams
Return audio stream information as PowerShell objects instead of raw ffprobe output.

.EXAMPLE
Get-FFProbeVideoInfo -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv"

.EXAMPLE
Get-FFProbeVideoInfo -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv" -GetAudioStreams

#>
function Get-FFProbeVideoInfo {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [string]$Dir,

        [Parameter(HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [string]$VideoFile,

        [Parameter(HelpMessage = "Return audio stream information as PowerShell objects instead of raw ffprobe output.")]
        [switch]$GetAudioStreams
    )

    if ([String]::IsNullOrWhiteSpace($Dir)) {
        $Dir = Get-Location
    }

    if (-Not [String]::IsNullOrWhiteSpace($VideoFile)) {
        $filePath = Join-Path -Path $Dir -ChildPath $VideoFile
        if ($GetAudioStreams) {
            $json = ffprobe -v quiet -print_format json -show_streams $filePath 2>$null
            if ($LASTEXITCODE -eq 0) {
                $data = $json | ConvertFrom-Json
                $audioStreams = $data.streams | Where-Object { $_.codec_type -eq 'audio' } |
                Select-Object index, codec_name,
                @{Name = 'Language'; Expression = { $_.tags.language } },
                @{Name = 'File'; Expression = { $filePath } }
                return $audioStreams
            }
            else {
                Write-Error "ffprobe failed to analyze $filePath"
            }
        }
        else {
            ffprobe $filePath -hide_banner
        }
    }
    else {
        if ($GetAudioStreams) {
            Get-ChildItem -Path $Dir -File | ForEach-Object {
                $json = ffprobe -v quiet -print_format json -show_streams $_.FullName 2>$null
                if ($LASTEXITCODE -eq 0) {
                    $data = $json | ConvertFrom-Json
                    $audioStreams = $data.streams | Where-Object { $_.codec_type -eq 'audio' } |
                    Select-Object index, codec_name,
                    @{Name = 'Language'; Expression = { $_.tags.language } },
                    @{Name = 'File'; Expression = { $_.FullName } }
                    $audioStreams
                }
                else {
                    Write-Error "ffprobe failed to analyze $($_.FullName)"
                }
            }
        }
        else {
            Get-ChildItem -Path $Dir -File | ForEach-Object {
                ffprobe $_.FullName -hide_banner
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Get-FFProbeVideoInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FFProbeVideoInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>
