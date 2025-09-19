function Convert-ImageForTeams {
    <#
    .SYNOPSIS
    Converts images in a source folder to PNG format and creates thumbnail images.
    
    .DESCRIPTION
    This function converts images in a source folder to PNG format and creates thumbnail images. The converted images and thumbnails are saved in a destination folder with GUID-based names.
    
    .PARAMETER sourceFolder
    The path to the folder containing the source images.
    
    .PARAMETER destinationFolder
    The path to the folder where the converted images and thumbnails will be saved.
    
    .EXAMPLE
    Convert-ImageForTeams -sourceFolder "C:\Path\To\Source\Images" -destinationFolder "C:\Path\To\Destination"
    #>
    param (
        [string]$sourceFolder,
        [string]$destinationFolder
    )

    # Install the necessary .NET namespace
    Add-Type -AssemblyName System.Drawing

    # Dummy function to satisfy the GetThumbnailImage method
    function dummyCallback { return $false }

    # Loop through each image file in the source folder
    Get-ChildItem -Path $sourceFolder -File | ForEach-Object {

        # Generate a GUID for the new image name
        $guid = [guid]::NewGuid().ToString()

        # Create a .NET Bitmap object from the image file
        $originalImage = [System.Drawing.Image]::FromFile($_.FullName)

        # Save the image as a PNG with a GUID-based name
        $originalImage.Save("$destinationFolder\$guid.png", [System.Drawing.Imaging.ImageFormat]::Png)

        # Create a thumbnail image
        $thumbWidth = 278
        $thumbHeight = 159
        $thumbnailImage = $originalImage.GetThumbnailImage($thumbWidth, $thumbHeight, [System.Drawing.Image+GetThumbnailImageAbort]$dummyCallback, [System.IntPtr]::Zero)

        # Save the thumbnail image as a PNG with a GUID-based name and "_thumb" suffix
        $thumbnailImage.Save("$destinationFolder\$guid`_thumb.png", [System.Drawing.Imaging.ImageFormat]::Png)

        # Dispose of the image objects to free resources
        $originalImage.Dispose()
        $thumbnailImage.Dispose()
    }
}
