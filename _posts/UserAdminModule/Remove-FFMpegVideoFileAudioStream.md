---
layout: post
title: Remove-FFMpegVideoFileAudioStream.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/mediamanagement/remove-ffmpegvideofileaudiostream/
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

Remove an unwanted audio stream from one or many video files while preserving the originals.

#### Detailed Description

`Remove-FFMpegVideoFileAudioStream` creates audio-sanitised copies of media files by removing the specified audio stream index. It can target a single directory, process a specific file, or accept pipeline input from `Get-FFProbeAudioStreams`. Output is written to an `ASR` subdirectory, leaving original files untouched. The function wraps ffmpeg commands and supports optional throttling when iterating large directories.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-FFMpegVideoFileAudioStream -Dir "C:\\Media\\Movies" -VideoFile "Alien (1979).mkv" -AudioStreamIx 0
```

Creates an `ASR` folder in the movie directory and outputs a copy of the file with the first audio stream removed.

**Example 2**

```powershell
Get-ChildItem -Path "C:\\Media\\Shows\\Season 01" -Directory |
    ForEach-Object { $_.FullName } |
        Remove-FFMpegVideoFileAudioStream -AudioStreamIx 0
```

Processes every season folder, stripping the indexed audio track from each video in parallel.

**Example 3**

```powershell
Get-FFProbeAudioStreams -VideoFile "C:\\Media\\Movies\\Alien (1979).mkv" |
    Where-Object { $_.index -eq 1 } |
        Remove-FFMpegVideoFileAudioStream
```

Uses pipeline input from `Get-FFProbeAudioStreams` to remove the matching stream without manually specifying file paths.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

- Requires ffmpeg to be installed and available on the system `PATH`.
- Writes processed files to an `ASR` subfolder so the originals remain unchanged.
- Accepts pipeline input from `Get-FFProbeAudioStreams`, which automatically maps the audio stream index and file path.
- Supports both single-directory and multi-directory processing, reverting to the original working directory once complete.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Removes an audio stream from a video file by index, or removes all audio. Outputs a copy of the input file with 'asr-' prefix on the filename. Supports pipeline input from Get-FFProbeAudioStreams.

.DESCRIPTION
Removes an audio stream from a video file by index, or removes all audio streams. Outputs a copy of the input file with 'asr-' prefix on the filename. Can accept pipeline input from Get-FFProbeAudioStreams for automated processing.

.PARAMETER Dirs
Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied.

.PARAMETER Dir
The directory the file is located in. Defaults to current location if not supplied.

.PARAMETER VideoFile
The video file name. Iterates every file in the directory if not supplied.

.PARAMETER VideoStreamIx
Index of the video stream. Defaults to 0.

.PARAMETER RemoveAllAudio
Remove all audio streams from the video file.

.PARAMETER ThrottleLimit
Degree of parallelism. Defaults to 20.

.PARAMETER File
Full path to the video file (for pipeline input).

.PARAMETER Index
Index of the audio stream to remove (for pipeline input).

.PARAMETER VideoStreamIxPipeline
Index of the video stream for pipeline input. Defaults to 0.

.EXAMPLE
Remove a specific audio stream:
Remove-FFMpegVideoFileAudioStream -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv" -AudioStreamIx 0

.EXAMPLE
Remove all audio from a video file:
Remove-FFMpegVideoFileAudioStream -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv" -RemoveAllAudio

.EXAMPLE
Using pipeline from Get-FFProbeAudioStreams to remove the first audio stream:
Get-FFProbeAudioStreams -VideoFile "C:\movies\Alien (1979).mkv" | Where-Object { $_.index -eq 1 } | Remove-FFMpegVideoFileAudioStream

#>
function Remove-FFMpegVideoFileAudioStream {
    [CmdletBinding(DefaultParameterSetName = 'Directory')]
    param (
        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $true, Position = 0, HelpMessage = "Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied")]
        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $true, Position = 0, HelpMessage = "Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied")]
        [string[]]$Dirs,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $false, HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [string]$Dir,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $false, HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [string]$VideoFile,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "Index of the video stream. Defaults to 0.")]
        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $false, HelpMessage = "Index of the video stream. Defaults to 0.")]
        [int]$VideoStreamIx = 0,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, Mandatory = $true, HelpMessage = "Index of the audio stream to remove.")]
        [int]$AudioStreamIx,

        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $false, HelpMessage = "Remove all audio streams from the video file.")]
        [switch]$RemoveAllAudio,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "Degree of parallelism. Defaults to 20.")]
        [Parameter(ParameterSetName = 'DirectoryRemoveAll', ValueFromPipeline = $false, HelpMessage = "Degree of parallelism. Defaults to 20.")]
        [int]$ThrottleLimit = 20,

        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, HelpMessage = "Full path to the video file.")]
        [string]$File,

        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, HelpMessage = "Index of the audio stream to remove.")]
        [int]$Index,

        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipeline = $false, HelpMessage = "Index of the video stream. Defaults to 0.")]
        [int]$VideoStreamIxPipeline = 0
    )

    begin {
        $Checkpoint = Get-Location
    }
    
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
            # handle pipeline input
            $Dir = Split-Path $File
            $VideoFile = Split-Path $File -Leaf
            $AudioStreamIx = $Index
            $VideoStreamIx = $VideoStreamIxPipeline

            $asrDir = Join-Path $Dir 'ASR'
            New-Item -ItemType Directory -Path $asrDir -Force | Out-Null

            $inputPath = Join-Path $Dir $VideoFile
            $outputPath = Join-Path $asrDir $VideoFile

            $command = "& ffmpeg -i '$inputPath' -map $VideoStreamIx -map -$VideoStreamIx`:a:$AudioStreamIx -c copy '$outputPath'"
            Write-Host $command
            Start-Process -FilePath 'powershell' -ArgumentList "-command $command" -Wait -NoNewWindow -PassThru
            return
        }

        Function EscapeSingleQuotes {
            [CmdletBinding()]
            param (
                [Parameter(ValueFromPipeline = $true, Position = 0, HelpMessage = "String to escape single quotes in.")]
                [string]$String
            )

            Process {
                return $String.Replace("'", "``'")
            }
        }

        if ($null -eq $Dirs) {
            # perform processing on a single directory

            if ([String]::IsNullOrWhiteSpace($Dir)) {
                $Dir = Get-Location
            }
            else {
                Set-Location $Dir
            }

            Write-Host "Processing files in $($Dir)..."

            $asrDir = $(Join-Path -Path $Dir -ChildPath 'ASR')
    
            mkdir $asrDir -Force

            # perform processing on single video file
            if (-Not [String]::IsNullOrWhiteSpace($VideoFile)) {
                $inputFile = Join-Path -Path $Dir -ChildPath $VideoFile
                $outputFile = Join-Path -Path $asrDir -ChildPath $VideoFile
                
                if ($RemoveAllAudio) {
                    ffmpeg -i "$inputFile" -an -c copy "$outputFile"
                }
                else {
                    ffmpeg -i "$inputFile" -map $VideoStreamIx -map -$VideoStreamIx:a:$AudioStreamIx -c copy "$outputFile"
                }

                return
            }
            
            # perform processing on all files in directory
            #Get-ChildItem -Path $Dir -File | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
            Get-ChildItem -Path $Dir -File | ForEach-Object {
                $cleanFullName = EscapeSingleQuotes -String $_.FullName

                $asrFile = $($cleanFullName).Replace($($_.Name), $(Join-Path -Path 'ASR' -ChildPath $($_.Name)))

                if ($RemoveAllAudio) {
                    $command = "& ffmpeg -i '$($cleanFullName)' -an -c copy '$asrFile'"
                }
                else {
                    $command = "& ffmpeg -i '$($cleanFullName)' -map $VideoStreamIx -map -$($VideoStreamIx):a:$($AudioStreamIx) -c copy '$asrFile'"
                }

                Write-Host $command
                
                Start-Process -FilePath 'powershell' -ArgumentList "-command $command" -Wait -NoNewWindow -PassThru
            }

            return
        }

        # perform processing on multiple directories
        $Dirs | ForEach-Object {
            Write-Host "Processing files in $($_)..."

            Set-Location $_

            $asrDir = $(Join-Path -Path $_ -ChildPath 'ASR')
    
            mkdir $asrDir -Force -InformationAction SilentlyContinue

            Get-ChildItem -Path $Dir -File | 
            ForEach-Object {
                $asrFile = $($_.FullName).Replace($($_.Name), $(Join-Path -Path 'ASR' -ChildPath $($_.Name)))

                if ($RemoveAllAudio) {
                    $command = "& ffmpeg -i '$($_.FullName)' -an -c copy '$asrFile'"
                }
                else {
                    $command = "& ffmpeg -i '$($_.FullName)' -map $VideoStreamIx -map -$($VideoStreamIx):a:$($AudioStreamIx) -c copy '$asrFile'"
                }

                Start-Process -FilePath 'powershell' -ArgumentList "-command $command" -Wait -NoNewWindow -PassThru

                #ffmpeg -i $($_.FullName) -map $VideoStreamIx -map -$($VideoStreamIx):a:$($AudioStreamIx) -c copy ($asrFile)
            }

            # ffmpeg doesn't like working in parallel threads, investigate at a time you can be arsed to work out why
            
            # Get-ChildItem -Path $_ -File | 
            #     ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
            #         $asrFile = $($PSItem.FullName).Replace($($PSItem.Name), $(Join-Path -Path 'ASR' -ChildPath $($PSItem.Name)))

            #         ffmpeg -i $($PSItem.FullName) -map $VideoStreamIx -map -$VideoStreamIx:a:$AudioStreamIx -c copy $asrFile
            #     }
        }
    }
    
    end { 
        Set-Location $Checkpoint
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/MediaManagement/Public/Remove-FFMpegVideoFileAudioStream.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-FFMpegVideoFileAudioStream.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>
