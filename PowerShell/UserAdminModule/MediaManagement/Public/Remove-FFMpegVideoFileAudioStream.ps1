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