<#
.SYNOPSIS
Creates random documents in a specified folder.

.DESCRIPTION
The CreateRandomDocument function generates a specified number of random documents in a specified folder. Each document is named "Document_x.docx" where x is a random number between 10000 and 99999. The function returns an array of the paths of the created documents.

.PARAMETER FolderPath
The path to the folder where the files should be created.

.PARAMETER NumberOfFiles
The number of files to create.

.EXAMPLE
CreateRandomDocument -FolderPath "C:\path\to\your\folder" -NumberOfFiles 10
Creates 10 random documents in the specified folder.

#>
function New-RandomDocument {
    param(
        [string]$FolderPath, # The path to the folder where the files should be created
        [int]$NumberOfFiles # The number of files to create
    )
    $createdDocuments = @()
    for ($i = 1; $i -le $NumberOfFiles; $i++) {
        # Name will be Document_x.docx with x being a random number between 10000 and 99999
        $FileName = "Document_$((Get-Random -Minimum 10000 -Maximum 99999)).docx"
        $DocumentPath = [System.IO.Path]::Combine($FolderPath, $FileName)
        # Generate a random file name and write it to the file
        [System.IO.Path]::GetRandomFileName() | Out-File -FilePath $DocumentPath -Encoding utf8 -ErrorAction Stop
        # Check if the file was created successfully
        if (Test-Path $DocumentPath) {
            $createdDocuments += $DocumentPath
        } else {
            Write-Error "Failed to create file at $DocumentPath"
        }
    }
    # Return the paths of the created documents
    $createdDocuments
}


<#
.SYNOPSIS
Creates dummy images on the machine.

.DESCRIPTION
The CreateRandomImage function generates a specified number of dummy images with random colors and saves them to the specified folder path.

.PARAMETER FolderPath
The path to the folder where the images should be created.

.PARAMETER NumberOfImages
The number of images to create.

.EXAMPLE
CreateRandomImage -FolderPath "C:\path\to\your\folder" -NumberOfImages 5
Creates 5 dummy images in the specified folder path.

#>
function New-RandomImage {
    param(
        [string]$FolderPath, # The path to the folder where the images should be created
        [int]$NumberOfImages # The number of images to create
    )
    $createdImages = @()
    for ($i = 1; $i -le $NumberOfImages; $i++) {
        # Name will be Image_x.png with x being a random number between 10000 and 99999
        $FileName = "Image_$((Get-Random -Minimum 10000 -Maximum 99999))_$i.png"
        $ImagePath = [System.IO.Path]::Combine($FolderPath, $FileName)
        $bitmap = New-Object System.Drawing.Bitmap 300,300
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        # The colour of the image created is random
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb((Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255), (Get-Random -Minimum 0 -Maximum 255)))
        $graphics.FillRectangle($brush, 0, 0, 300, 300)
        $bitmap.Save($ImagePath, [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        if (Test-Path $ImagePath) {
            $createdImages += $ImagePath
        }
    }
    $createdImages
}


<#
.SYNOPSIS
This function creates dummy audio and video files on the machine.

.DESCRIPTION
The AudioAndVideo function creates a specified number of dummy audio and video files in a specified folder. Each file is named with a timestamp and a unique identifier.

.PARAMETER FolderPath
The path to the folder where the audio and video files should be created.

.PARAMETER NumberOfFiles
The number of audio and video files to create.

.EXAMPLE
AudioAndVideo -FolderPath "C:\path\to\your\folder" -NumberOfFiles 3
Creates 3 dummy audio and video files in the specified folder.

#>
function New-RandomAudioAndVideo {
    param(
        [string]$FolderPath, # The path to the folder where the audio and video files should be created
        [int]$NumberOfFiles # The number of audio and video files to create
    )
    $createdAudio = @()
    $createdVideo = @()
    for ($i = 1; $i -le $NumberOfFiles; $i++) {
        # Name will be Audio_x.wav with x being a random number between 10000 and 99999
        $audioFileName = "Audio_" + (Get-Date -Format "yyyyMMddHHmmss") + "_$i.wav"
        # Name will be Video_x.mp4 with x being a random number between 10000 and 99999
        $videoFileName = "Video_" + (Get-Date -Format "yyyyMMddHHmmss") + "_$i.mp4"
        $audioFilePath = [System.IO.Path]::Combine($FolderPath, $audioFileName)
        $videoFilePath = [System.IO.Path]::Combine($FolderPath, $videoFileName)
        New-Item -Path $audioFilePath -ItemType File | Out-Null
        New-Item -Path $videoFilePath -ItemType File | Out-Null
        if (Test-Path $audioFilePath) {
            $createdAudio += $audioFilePath
        }
        if (Test-Path $videoFilePath) {
            $createdVideo += $videoFilePath
        }
    }
    $createdAudio, $createdVideo
}


