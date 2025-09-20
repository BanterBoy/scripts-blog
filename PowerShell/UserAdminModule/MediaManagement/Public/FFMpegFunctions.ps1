<#
.SYNOPSIS
Calls ffprobe to get a video file's info (without banner).

.DESCRIPTION
Calls ffprobe to get a video file's info (without banner).

.PARAMETER Dir
The directory the file is located in. Defaults to current location if not supplied.

.PARAMETER VideoFile
The video file name. Iterates every file in the directory if not supplied.

.EXAMPLE
Get-FFProbeVideoInfo -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv"
#>
function FFProbe-GetVideoInfo {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [string]$Dir,

        [Parameter(HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [string]$VideoFile
    )

    if ([String]::IsNullOrWhiteSpace($Dir)) {
        $Dir = Get-Location
    }

    if (-Not [String]::IsNullOrWhiteSpace($VideoFile)) {
        ffprobe $(Join-Path -Path $Dir -ChildPath $VideoFile) -hide_banner
    } else {
        # get all video file types from windows


        Get-ChildItem -Path $Dir -File | ForEach-Object {
            ffprobe $_.FullName -hide_banner
        }
    }
}

<#
.SYNOPSIS
Removes an audio stream from a video file by index. Outputs a copy of the input file with 'asr-' prefix on the filename.

.DESCRIPTION
Removes an audio stream from a video file by index. Outputs a copy of the input file with 'asr-' prefix on the filename.

.PARAMETER Dir
The directory the file is located in. Defaults to current location if not supplied.

.PARAMETER VideoFile
The video file name. Iterates every file in the directory if not supplied.

.PARAMETER VideoStreamIx
Index of the video stream. Defaults to 0.

.PARAMETER AudioStreamIx
Index of the audio stream to remove.

.EXAMPLE
Where non-english is the first audio stream:
FFMpeg-RemoveVideoFileAudioStream -Dir "C:\movies\Alien (1979)" -VideoFile "Alien (1979).mkv" -AudioStreamIx 0

.EXAMPLE
Where non-english is the first audio stream and all season folders in show:
Get-ChildItem -Path "Y:\complete\The Americans" -Directory | 
    ForEach-Object { $_.FullName } | 
        FFMpeg-RemoveVideoFileAudioStream -AudioStreamIx 0

#>
function FFMpeg-RemoveVideoFileAudioStream {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0, HelpMessage = "Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied")]
        [string[]]$Dirs,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [string]$Dir,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [string]$VideoFile,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "Index of the video stream. Defaults to 0.")]
        [int]$VideoStreamIx = 0,

        [Parameter(ValueFromPipeline = $false, Mandatory = $true, HelpMessage = "Index of the audio stream to remove.")]
        [int]$AudioStreamIx,

        [Parameter(ValueFromPipeline = $false, HelpMessage = "Degree of parallelism. Defaults to 20.")]
        [int]$ThrottleLimit = 20
    )

    begin {
        $Checkpoint = Get-Location
    }
    
    process {
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
            } else {
                Set-Location $Dir
            }

            Write-Host "Processing files in $($Dir)..."

            $asrDir = $(Join-Path -Path $Dir -ChildPath 'ASR')
    
            mkdir $asrDir -Force

            # perform processing on single video file
            if (-Not [String]::IsNullOrWhiteSpace($VideoFile)) {
                ffmpeg -i $(Join-Path -Path $Dir -ChildPath $VideoFile) -map $VideoStreamIx -map -$VideoStreamIx:a:$AudioStreamIx -c copy $(Join-Path -Path $asrDir -ChildPath $VideoFile)

                return
            }
            
            # perform processing on all files in directory
            #Get-ChildItem -Path $Dir -File | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
            Get-ChildItem -Path $Dir -File | ForEach-Object {
                $cleanFullName = EscapeSingleQuotes -String $_.FullName

                $asrFile = $($cleanFullName).Replace($($_.Name), $(Join-Path -Path 'ASR' -ChildPath $($_.Name)))

                $command = "ffmpeg -i `"$($cleanFullName)`" -map $VideoStreamIx -map -$($VideoStreamIx):a:$($AudioStreamIx) -c copy `"$asrFile`""

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

                    $command = "ffmpeg -i $($($_.FullName)) -map $VideoStreamIx -map -$($VideoStreamIx):a:$($AudioStreamIx) -c copy ($asrFile)"

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
FFMpeg-SpeedThatShitUp -VideoFile "C:\Users\Rob\OneDrive\Desktop\Black.Mirror.S01E01.720p.HDTV.x264-BiA.avi" -OutputFile "C:\Temp\out.avi" -SpeedUpPercentage 400

#>
function FFMpeg-SpeedThatShitUp {
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