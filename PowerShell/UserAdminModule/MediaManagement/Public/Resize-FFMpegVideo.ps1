<#
.SYNOPSIS
Resizes video files to specified resolutions (480p, 720p, 1080p, etc.) and saves to a custom output dire            $scale = $ResolutionMap[$TargetResolution]

            # Build FFmpeg arguments as an array to avoid quoting issues
            # Use simpler scale filter that ensures even dimensions
            $ffmpegArgs = @(
                '-i', "`"$inputPath`"",
                '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                '-c:a', 'copy',
                '-y',  # Overwrite output files without asking
                "`"$outputPath`""
            )Resized' subdirectory.

.DESCRIPTION
Resizes video files to specified resolutions using FFmpeg's scale filter. Maintains aspect ratio and outputs to a 'Resized' subdirectory in the source directory, or to a custom output directory if specified. Preserves original files.

.PARAMETER Dirs
Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied.

.PARAMETER Dir
The directory the file is located in. Defaults to current location if not supplied.

.PARAMETER VideoFile
The video file name. Iterates every file in the directory if not supplied.

.PARAMETER TargetResolution
Target resolution. Options: 480p, 720p, 1080p, 1440p, 2160p (4K), or custom format like "1280x720".

.PARAMETER OutputDir
The directory where resized files will be saved. If not specified, creates a 'Resized' subdirectory in the source directory.

.PARAMETER ThrottleLimit
Degree of parallelism. Defaults to 20.

.PARAMETER File
Full path to the video file (for pipeline input).

.EXAMPLE
Resize a single file to 720p and save to custom output directory:
Resize-FFMpegVideo -VideoFile "movie.mp4" -TargetResolution 720p -OutputDir "C:\resized"

.EXAMPLE
Resize all files in directory to 480p and save to custom location:
Resize-FFMpegVideo -Dir "C:\videos" -TargetResolution 480p -OutputDir "D:\converted"

.EXAMPLE
Resize multiple directories to 1080p and save to network location:
Resize-FFMpegVideo -Dirs "C:\videos\action", "C:\videos\comedy" -TargetResolution 1080p -OutputDir "\\server\share\resized"

.EXAMPLE
Resize a single file to 720p and save to custom output directory:
Resize-FFMpegVideo -VideoFile "movie.mp4" -TargetResolution 720p -OutputDir "C:\resized"

.EXAMPLE
Resize all files in directory to 480p and save to custom location:
Resize-FFMpegVideo -Dir "C:\videos" -TargetResolution 480p -OutputDir "D:\converted"

.EXAMPLE
Resize multiple directories to 1080p and save to network location:
Resize-FFMpegVideo -Dirs "C:\videos\action", "C:\videos\comedy" -TargetResolution 1080p -OutputDir "\\server\share\resized"

.EXAMPLE
Simple file-to-file conversion (recommended):
Resize-FFMpegVideo -InputFile "C:\videos\input.mp4" -OutputFile "C:\videos\output_480p.mp4" -TargetResolution 480p

#>
function Resize-FFMpegVideo {
    [CmdletBinding(DefaultParameterSetName = 'Directory')]
    param (
        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $true, Position = 0, HelpMessage = "Multiple directories containing files. No recurse, so only one level. Overrides Dir parameter if supplied")]
        [string[]]$Dirs,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "The directory the file is located in. Defaults to current location if not supplied.")]
        [string]$Dir,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "The video file name. Iterates every file in the directory if not supplied.")]
        [string]$VideoFile,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, Mandatory = $true, HelpMessage = "Target resolution. Options: 480p, 720p, 1080p, 1440p, 2160p, or custom like '1280x720'")]
        [ValidateSet("480p", "720p", "1080p", "1440p", "2160p")]
        [string]$TargetResolution,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "Degree of parallelism. Defaults to 20.")]
        [int]$ThrottleLimit = 20,

        [Parameter(ParameterSetName = 'Directory', ValueFromPipeline = $false, HelpMessage = "The directory where resized files will be saved. If not specified, creates a 'Resized' subdirectory in the source directory.")]
        [string]$OutputDir,

        [Parameter(ParameterSetName = 'Simple', ValueFromPipelineByPropertyName = $true, HelpMessage = "Full path to the input video file.")]
        [string]$InputFile,

        [Parameter(ParameterSetName = 'Simple', ValueFromPipelineByPropertyName = $true, HelpMessage = "Full path to the output video file.")]
        [string]$OutputFile,

        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, HelpMessage = "Full path to the video file.")]
        [string]$File,

        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipelineByPropertyName = $true, HelpMessage = "Target resolution for pipeline input.")]
        [ValidateSet("480p", "720p", "1080p", "1440p", "2160p")]
        [string]$Resolution
    )

    begin {
        $Checkpoint = Get-Location

        # Define resolution mappings - ensure even dimensions for FFmpeg compatibility
        $ResolutionMap = @{
            "480p"  = "854x480"
            "720p"  = "1280x720"
            "1080p" = "1920x1080"
            "1440p" = "2560x1440"
            "2160p" = "3840x2160"
        }
    }

    process {
        # Handle Simple parameter set (direct file-to-file conversion)
        if ($PSCmdlet.ParameterSetName -eq 'Simple') {
            if (-not $InputFile -or -not $OutputFile) {
                Write-Error "Both InputFile and OutputFile parameters are required for simple conversion."
                return
            }

            if ($InputFile -eq $OutputFile) {
                Write-Error "Input and output file paths are the same. Please specify a different output filename."
                return
            }

            # Ensure output directory exists
            $outputDir = Split-Path $OutputFile -Parent
            if (-not (Test-Path $outputDir)) {
                New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
            }

            $scale = $ResolutionMap[$TargetResolution]

            # Build FFmpeg arguments as an array to avoid quoting issues
            $ffmpegArgs = @(
                '-i', "`"$InputFile`"",
                '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                '-c:a', 'copy',
                '-y',  # Overwrite output files without asking
                "`"$OutputFile`""
            )

            Write-Host "Converting: $InputFile -> $OutputFile"
            Write-Host "Running: ffmpeg $($ffmpegArgs -join ' ')"

            try {
                $result = Start-Process -FilePath 'ffmpeg' -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru
                if ($result.ExitCode -ne 0) {
                    Write-Error "FFmpeg failed with exit code $($result.ExitCode) for file: $InputFile"
                }
                else {
                    Write-Host "Successfully converted: $(Split-Path $OutputFile -Leaf)"
                }
            }
            catch {
                Write-Error "Failed to execute FFmpeg for file: $InputFile. Error: $_"
            }

            return
        }

        if ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
            # handle pipeline input
            $Dir = Split-Path $File
            $VideoFile = Split-Path $File -Leaf
            $TargetResolution = $Resolution

            # Determine output directory
            if ($OutputDir) {
                $resizedDir = $OutputDir
            }
            else {
                $resizedDir = Join-Path $Dir 'Resized'
            }
            New-Item -ItemType Directory -Path $resizedDir -Force | Out-Null

            $inputPath = Join-Path $Dir $VideoFile
            $outputPath = Join-Path $resizedDir $VideoFile

            # Check if input and output paths are the same
            if ($inputPath -eq $outputPath) {
                Write-Error "Input and output file paths are the same. Please specify a different output directory or filename."
                return
            }

            $scale = $ResolutionMap[$TargetResolution]

            # Build FFmpeg arguments as an array to avoid quoting issues
            $ffmpegArgs = @(
                '-i', "`"$inputPath`"",
                '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                '-c:a', 'copy',
                '-y',  # Overwrite output files without asking
                "`"$outputPath`""
            )

            Write-Host "Running: ffmpeg $($ffmpegArgs -join ' ')"

            try {
                $result = Start-Process -FilePath 'ffmpeg' -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru
                if ($result.ExitCode -ne 0) {
                    Write-Error "FFmpeg failed with exit code $($result.ExitCode) for file: $VideoFile"
                }
                else {
                    Write-Host "Successfully resized: $VideoFile"
                }
            }
            catch {
                Write-Error "Failed to execute FFmpeg for file: $VideoFile. Error: $_"
            }

            return
        }

        if ($null -eq $Dirs) {
            # perform processing on a single directory

            # If VideoFile is a full path and Dir is not specified, extract directory from VideoFile
            if (-Not [String]::IsNullOrWhiteSpace($VideoFile) -and [String]::IsNullOrWhiteSpace($Dir)) {
                if ([System.IO.Path]::IsPathRooted($VideoFile)) {
                    # VideoFile is a full path, extract directory
                    $Dir = [System.IO.Path]::GetDirectoryName($VideoFile)
                    $VideoFile = [System.IO.Path]::GetFileName($VideoFile)
                    Write-Verbose "Extracted directory '$Dir' and filename '$VideoFile' from full path"
                }
                else {
                    # VideoFile is just a filename, use current location
                    $Dir = Get-Location
                    Write-Verbose "Using current location '$Dir' for filename '$VideoFile'"
                }
            }
            elseif ([String]::IsNullOrWhiteSpace($Dir)) {
                $Dir = Get-Location
                Write-Verbose "Using current location '$Dir' (no directory specified)"
            }

            if (-Not [String]::IsNullOrWhiteSpace($Dir)) {
                Set-Location $Dir
                Write-Verbose "Changed to directory: $Dir"
            }

            Write-Host "Processing files in $($Dir)..."

            # Determine output directory
            if ($OutputDir) {
                $resizedDir = $OutputDir
            }
            else {
                $resizedDir = $(Join-Path -Path $Dir -ChildPath 'Resized')
            }

            mkdir $resizedDir -Force

            # perform processing on single video file
            if (-Not [String]::IsNullOrWhiteSpace($VideoFile)) {
                $inputPath = Join-Path $Dir $VideoFile
                $outputPath = Join-Path $resizedDir $VideoFile

                # Check if input and output paths are the same
                if ($inputPath -eq $outputPath) {
                    Write-Error "Input and output file paths are the same. Please specify a different output directory or filename."
                    return
                }

                $scale = $ResolutionMap[$TargetResolution]                # Build FFmpeg arguments as an array to avoid quoting issues
                $ffmpegArgs = @(
                    '-i', "`"$inputPath`"",
                    '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                    '-c:a', 'copy',
                    '-y',  # Overwrite output files without asking
                    "`"$outputPath`""
                )

                Write-Host "Running: ffmpeg $($ffmpegArgs -join ' ')"

                try {
                    $result = Start-Process -FilePath 'ffmpeg' -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru
                    if ($result.ExitCode -ne 0) {
                        Write-Error "FFmpeg failed with exit code $($result.ExitCode) for file: $VideoFile"
                    }
                    else {
                        Write-Host "Successfully resized: $VideoFile"
                    }
                }
                catch {
                    Write-Error "Failed to execute FFmpeg for file: $VideoFile. Error: $_"
                }

                return
            }

            Get-ChildItem -Path $Dir -File | ForEach-Object {
                $inputFile = $_.FullName
                $outputFile = Join-Path -Path $resizedDir -ChildPath $_.Name

                # Check if input and output paths are the same
                if ($inputFile -eq $outputFile) {
                    Write-Warning "Skipping '$($_.Name)' - input and output paths are the same"
                    continue
                }

                $scale = $ResolutionMap[$TargetResolution]

                # Build FFmpeg arguments as an array to avoid quoting issues
                $ffmpegArgs = @(
                    '-i', "`"$inputFile`"",
                    '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                    '-c:a', 'copy',
                    '-y',  # Overwrite output files without asking
                    "`"$outputFile`""
                )

                Write-Host "Processing: $($_.Name)"
                Write-Host "Running: ffmpeg $($ffmpegArgs -join ' ')"

                try {
                    $result = Start-Process -FilePath 'ffmpeg' -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru
                    if ($result.ExitCode -ne 0) {
                        Write-Error "FFmpeg failed with exit code $($result.ExitCode) for file: $($_.Name)"
                    }
                    else {
                        Write-Host "Successfully resized: $($_.Name)"
                    }
                }
                catch {
                    Write-Error "Failed to execute FFmpeg for file: $($_.Name). Error: $_"
                }
            }

            return
        }

        # perform processing on multiple directories
        $Dirs | ForEach-Object {
            Write-Host "Processing files in $($_)..."

            Set-Location $_

            # Determine output directory
            if ($OutputDir) {
                $resizedDir = $OutputDir
            }
            else {
                $resizedDir = $(Join-Path -Path $_ -ChildPath 'Resized')
            }

            mkdir $resizedDir -Force -InformationAction SilentlyContinue

            Get-ChildItem -Path $_ -File |
            ForEach-Object {
                $inputFile = $_.FullName
                $outputFile = Join-Path -Path $resizedDir -ChildPath $_.Name

                # Check if input and output paths are the same
                if ($inputFile -eq $outputFile) {
                    Write-Warning "Skipping '$($_.Name)' - input and output paths are the same"
                    continue
                }

                $scale = $ResolutionMap[$TargetResolution]

                # Build FFmpeg arguments as an array to avoid quoting issues
                $ffmpegArgs = @(
                    '-i', "`"$inputFile`"",
                    '-vf', "scale=trunc($($scale.Split('x')[0])/2)*2:trunc($($scale.Split('x')[1])/2)*2",
                    '-c:a', 'copy',
                    '-y',  # Overwrite output files without asking
                    "`"$outputFile`""
                )

                Write-Host "Processing: $($_.Name)"
                Write-Host "Running: ffmpeg $($ffmpegArgs -join ' ')"

                try {
                    $result = Start-Process -FilePath 'ffmpeg' -ArgumentList $ffmpegArgs -Wait -NoNewWindow -PassThru
                    if ($result.ExitCode -ne 0) {
                        Write-Error "FFmpeg failed with exit code $($result.ExitCode) for file: $($_.Name)"
                    }
                    else {
                        Write-Host "Successfully resized: $($_.Name)"
                    }
                }
                catch {
                    Write-Error "Failed to execute FFmpeg for file: $($_.Name). Error: $_"
                }
            }
        }
    }

    end {
        Set-Location $Checkpoint
    }
}