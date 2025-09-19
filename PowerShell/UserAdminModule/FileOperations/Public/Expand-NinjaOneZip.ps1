function Expand-NinjaOneZip {
    <#
    .SYNOPSIS
        Extracts the contents of a NinjaOne Zip file to a specified destination folder.
    .DESCRIPTION
        The Expand-NinjaOneZip function extracts the contents of a NinjaOne Zip file to a specified destination folder.
    .PARAMETER ZipFile
        Specifies the path to the NinjaOne Zip file to extract.
    .PARAMETER Destination
        Specifies the path to the destination folder where the contents of the Zip file will be extracted.
    .EXAMPLE
        Expand-NinjaOneZip -ZipFile "C:\Temp\NinjaOne.zip" -Destination "C:\Temp\Extracted"
        This example extracts the contents of the "NinjaOne.zip" file located in "C:\Temp" to the "C:\Temp\Extracted" folder.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$ZipFile,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Destination
    )

    # Import the Microsoft.PowerShell.Archive module
    Import-Module -Name Microsoft.PowerShell.Archive

    try {
        # Unzip the NinjaOne Zip file
        Expand-Archive -Path $ZipFile -DestinationPath $Destination -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to unzip file: $_"
    }
}
