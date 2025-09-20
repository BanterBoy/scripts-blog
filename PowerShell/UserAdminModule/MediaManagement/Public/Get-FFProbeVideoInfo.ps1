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