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