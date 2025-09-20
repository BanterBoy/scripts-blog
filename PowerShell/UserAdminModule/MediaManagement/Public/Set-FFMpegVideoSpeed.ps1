<#
.SYNOPSIS
Speeds up a video file.

.DESCRIPTION
Speeds up a video file, likely to make porn really weird.

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