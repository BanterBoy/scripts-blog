<#
.SYNOPSIS
Expands a ZIP file on a remote computer.

.DESCRIPTION
The Invoke-RemoteZipExpansion function expands a ZIP file on a remote computer. 
It uses the Invoke-Command cmdlet to run the Expand-Archive cmdlet on the remote computer.

.PARAMETER ComputerName
The name of the remote computer where the ZIP file will be expanded.

.PARAMETER SourceZipFilePath
The path of the ZIP file on the remote computer.

.PARAMETER DestinationFolderPath
The path of the folder on the remote computer where the ZIP file will be expanded.

.PARAMETER Credential
The credentials used to connect to the remote computer.

.EXAMPLE
$credential = Get-Credential
$sourceZipFilePath = "C:\Path\To\Your\ZipFile.zip"
$destinationFolderPath = "C:\Path\To\DestinationFolder"
Invoke-RemoteZipExpansion -ComputerName "RemoteServerName" -SourceZipFilePath $sourceZipFilePath -DestinationFolderPath $destinationFolderPath -Credential $credential
#>
function Invoke-RemoteZipExpansion {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$SourceZipFilePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationFolderPath,

        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )

    # Check if the source ZIP file exists
    if (-not (Test-Path $sourceZip)) {
        Write-Error "ZIP file not found at $sourceZip"
        return
    }

    $scriptBlock = {
        param (
            [string]$sourceZip,
            [string]$destinationFolder
        )

        # Check if the destination folder exists and is writable
        if (-not (Test-Path $destinationFolder -PathType Container)) {
            Write-Error "Destination folder not found at $destinationFolder"
            return
        }

        # Expand the ZIP file
        Expand-Archive -Path $sourceZip -DestinationPath $destinationFolder -Force
        Write-Host "Uncompressed $sourceZip to $destinationFolder"
    }

    # Execute the command on the remote computer with credentials
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $SourceZipFilePath, $DestinationFolderPath -Credential $Credential
}