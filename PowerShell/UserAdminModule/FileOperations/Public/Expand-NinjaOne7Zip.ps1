<#
.SYNOPSIS
Extracts files from a NinjaOne Zip file using 7-Zip.

.DESCRIPTION
The Expand-NinjaOne7Zip function extracts files from a NinjaOne Zip file using 7-Zip utility. It provides options to specify the destination folder, password (if required), and specific files to extract.

.PARAMETER ZipFile
Specifies the path to the NinjaOne Zip file that needs to be extracted. This parameter is mandatory.

.PARAMETER Destination
Specifies the path to the destination folder where the extracted files will be placed. This parameter is mandatory.

.PARAMETER Password
Specifies the password for the NinjaOne Zip file, if it is password protected. This parameter is optional.

.PARAMETER FilesToExtract
Specifies an array of specific files to extract from the NinjaOne Zip file. This parameter is optional.

.EXAMPLE
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles"

This example extracts all files from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder.

.EXAMPLE
Expand-NinjaOne7Zip -ZipFile "C:\Path\To\NinjaOne.zip" -Destination "C:\ExtractedFiles" -Password "password" -FilesToExtract "file1.txt", "file2.txt"

This example extracts only "file1.txt" and "file2.txt" from the "NinjaOne.zip" file to the "C:\ExtractedFiles" folder, using the specified password.

#>
function Expand-NinjaOne7Zip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$ZipFile,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Destination,
        [Parameter(Mandatory = $false)]
        [string]$Password,
        [Parameter(Mandatory = $false)]
        [string[]]$FilesToExtract
    )

    try {
        # Unzip the NinjaOne Zip file using 7-Zip
        $arguments = "e `"$ZipFile`" -o`"$Destination`" -y"
        if ($Password) {
            $arguments += " -p`"$Password`""
        }
        if ($FilesToExtract) {
            foreach ($file in $FilesToExtract) {
                $arguments += " `"$file`""
            }
        }
        Start-Process -FilePath "7z" -ArgumentList $arguments -NoNewWindow -Wait -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to unzip file '$ZipFile' to destination '$Destination': $_"
    }
}
