---
layout: post
title: Get-FFProbeAudioStreams.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-FFProbeAudioStreams/
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

Retrieve structured audio stream metadata for a video file using ffprobe.

#### Detailed Description

`Get-FFProbeAudioStreams` wraps ffprobe to output the audio streams from a media file as easy-to-filter PowerShell objects. It parses ffprobe's JSON response, returning each stream with its index, codec, language tag, and originating file path. The function accepts a literal path or pipeline input, making it simple to chain with file discovery commands or pass the results directly into `Remove-FFMpegVideoFileAudioStream`.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-FFProbeAudioStreams -VideoFile "C:\\Media\\Movies\\Alien (1979).mkv"
```

Returns all audio streams for the specified video file as structured objects.

**Example 2**

```powershell
"C:\\Media\\Movies\\Alien (1979).mkv" | Get-FFProbeAudioStreams
```

Demonstrates pipeline input, outputting the same stream information without explicitly naming the parameter.

**Example 3**

```powershell
Get-FFProbeAudioStreams -VideoFile "C:\\Media\\Movies\\Alien (1979).mkv" | Where-Object { $_.Language -eq 'eng' }
```

Filters the returned streams to locate the English-language track before taking further action.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- Requires the ffprobe executable to be available on the system `PATH`. Install FFmpeg using [`FFMpeg-Install`](/_posts/UserAdminModule/FFMpeg-Install/) if needed.
- Outputs objects with `index`, `codec_name`, `Language`, and `File` properties to simplify filtering or piping into other automation.
- Designed to feed directly into [`Remove-FFMpegVideoFileAudioStream`](/_posts/UserAdminModule/Remove-FFMpegVideoFileAudioStream/) for automated audio stream removal.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Gets audio stream information from a video file using ffprobe.

.DESCRIPTION
Parses ffprobe JSON output to retrieve audio stream details including index, codec, language, and file path.

.PARAMETER VideoFile
The video file to analyze. Accepts pipeline input.

.EXAMPLE
Get-FFProbeAudioStreams -VideoFile "C:\movies\Alien (1979).mkv"

.EXAMPLE
"C:\movies\Alien (1979).mkv" | Get-FFProbeAudioStreams

#>
function Get-FFProbeAudioStreams {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0, HelpMessage = "The video file to analyze.")]
        [string]$VideoFile
    )

    process {
        try {
            $json = ffprobe -v quiet -print_format json -show_streams $VideoFile 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Error "ffprobe failed to analyze $VideoFile"
                return
            }

            $data = $json | ConvertFrom-Json
            $audioStreams = $data.streams | Where-Object { $_.codec_type -eq 'audio' } |
            Select-Object index, codec_name,
            @{Name = 'Language'; Expression = { $_.tags.language } },
            @{Name = 'File'; Expression = { $VideoFile } }

            return $audioStreams
        }
        catch {
            Write-Error "Error processing $VideoFile : $_"
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Get-FFProbeAudioStreams.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FFProbeAudioStreams.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>
