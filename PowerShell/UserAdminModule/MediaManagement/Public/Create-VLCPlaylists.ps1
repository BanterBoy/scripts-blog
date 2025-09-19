<#
.SYNOPSIS
    Creates VLC-compatible M3U playlists for MP3 files located in a specified directory and its subdirectories.

.DESCRIPTION
    The Create-VLCPlaylists function scans a given base directory and an optional subfolder for MP3 files. 
    It creates M3U playlists for the MP3 files found directly in the specified directory or within its subdirectories.

.PARAMETER baseDir
    The base directory containing the folders with MP3 files.

.PARAMETER subFolder
    The subfolder within the base directory that contains the MP3 files or further subdirectories.

.EXAMPLE
    Create-VLCPlaylists -baseDir "\\deathstar.domain.leigh-services.com\Public\PodCasts\I'm Sorry I Haven't a Clue" -subFolder "Season81"
    This command will create M3U playlists for MP3 files located in the "Season81" subfolder of the specified base directory.

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Create-VLCPlaylists {
    param (
        [string]$baseDir,
        [string]$subFolder
    )

    # Combine the base directory and subfolder to get the target directory
    $targetDir = Join-Path -Path $baseDir -ChildPath $subFolder
    Write-Output "Target directory: $targetDir"

    if (-Not (Test-Path -Path $targetDir)) {
        Write-Output "Error: Target directory '$targetDir' does not exist."
        return
    }

    # Check if the target directory contains MP3 files directly
    $mp3FilesInTargetDir = Get-ChildItem -Path $targetDir -Filter *.mp3 -ErrorAction SilentlyContinue
    if ($mp3FilesInTargetDir.Count -gt 0) {
        # Create playlist for MP3 files in the target directory
        $playlistPath = Join-Path -Path $targetDir -ChildPath "$subFolder.m3u"
        Write-Output "Creating playlist: $playlistPath"
        Create-Playlist -mp3Files $mp3FilesInTargetDir -playlistPath $playlistPath
    }
    else {
        # Get all directories within the target directory
        $directories = Get-ChildItem -Path $targetDir -Directory
        if ($directories.Count -eq 0) {
            Write-Output "No directories found in '$targetDir'."
            return
        }

        foreach ($directory in $directories) {
            $season = $directory.Name
            $playlistPath = Join-Path -Path $directory.FullName -ChildPath "$season.m3u"
            Write-Output "Creating playlist: $playlistPath"

            # Get all MP3 files in the current season directory
            $mp3Files = Get-ChildItem -Path $directory.FullName -Filter *.mp3 | Sort-Object Name
            if ($mp3Files.Count -eq 0) {
                Write-Output "No MP3 files found in '$directory.FullName'. Skipping..."
                continue
            }

            # Create the M3U playlist content
            Create-Playlist -mp3Files $mp3Files -playlistPath $playlistPath
        }
    }
}

<#
.SYNOPSIS
    Creates M3U playlist content from an array of MP3 files and saves it to a specified path.

.DESCRIPTION
    The Create-Playlist function generates the content for an M3U playlist from an array of MP3 files. 
    It then saves the playlist content to a specified path.

.PARAMETER mp3Files
    An array of MP3 files for which the playlist will be created.

.PARAMETER playlistPath
    The path where the M3U playlist file will be saved.

.EXAMPLE
    Create-Playlist -mp3Files $mp3Files -playlistPath "C:\Music\Season1.m3u"
    This command will create an M3U playlist at the specified path for the provided MP3 files.

.NOTES
    Author: Your Name
    Date: Today's Date
#>
function Create-Playlist {
    param (
        [array]$mp3Files,
        [string]$playlistPath
    )

    # Create the M3U playlist content
    $playlistContent = "#EXTM3U`r`n"
    foreach ($file in $mp3Files) {
        $relativePath = [System.IO.Path]::GetFileName($file.FullName)
        $playlistContent += "#EXTINF:-1," + [System.IO.Path]::GetFileNameWithoutExtension($file.Name) + "`r`n"
        $playlistContent += "$relativePath`r`n"
    }

    # Save the playlist content to a .m3u file
    Set-Content -Path $playlistPath -Value $playlistContent -Encoding UTF8
    Write-Output "Created playlist: $playlistPath"
}

# Specify the base directory containing the seasons folders and the subfolder
# $baseDirectory = "\\deathstar.domain.leigh-services.com\Public\PodCasts\I'm Sorry I Haven't a Clue"
# $subFolder = "Season81"
# Create-VLCPlaylists -baseDir $baseDirectory -subFolder $subFolder
