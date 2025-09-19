<#
.SYNOPSIS
    Invokes Cisco Secure Management on a remote computer.

.DESCRIPTION
    The Invoke-CiscoSecureManagement function is used to enable, disable, copy files, and optionally expand zip files on a remote computer with Cisco Secure Management enabled.

.PARAMETER ComputerName
    The name of the remote computer where Cisco Secure Management is installed.

.PARAMETER FilePath
    The path to the file (zip or single file) that needs to be copied to the remote computer.

.PARAMETER DestinationFolderPath
    The destination folder path on the remote computer where the file should be copied (and expanded if it's a zip file).

.PARAMETER Password
    The password for disabling and enabling Cisco Secure Management on the remote computer.

.PARAMETER Credential
    The credential object used to authenticate with the remote computer.

.PARAMETER IsZipFile
    A switch parameter to indicate if the FilePath is a zip file that needs to be expanded on the remote computer.

.OUTPUTS
    The function returns a PSObject with the following properties:
    - FileCopied: The path of the file that was copied to the remote computer.
    - ExpandedFiles: The list of files that were expanded from the zip file on the remote computer (if applicable).
    - CiscoSecureState: The state of Cisco Secure Management on the remote computer (enabled or disabled).

.EXAMPLE
    $File = "C:\Path\to\File.ps1"
    $Destination = "C:\RemoteFolder"
    $ComputerName = "RemoteComputer"
    $Password = ConvertTo-SecureString -String "PASSWORD" -AsPlainText -Force
    $Credential = Get-Credential
    $result = Invoke-CiscoSecureManagement -ComputerName $ComputerName -FilePath $File -DestinationFolderPath $Destination -Password $Password -Credential $Credential
    $result

    Description
    -----------
    This example invokes Cisco Secure Management on a remote computer, copies the file "File.ps1" to the "C:\RemoteFolder" folder, and returns the result.

.EXAMPLE
    $File = "C:\Path\to\ZipFile.zip"
    $Destination = "C:\RemoteFolder"
    $ComputerName = "RemoteComputer"
    $Password = ConvertTo-SecureString -String "PASSWORD" -AsPlainText -Force
    $Credential = Get-Credential
    $result = Invoke-CiscoSecureManagement -ComputerName $ComputerName -FilePath $File -DestinationFolderPath $Destination -Password $Password -Credential $Credential -IsZipFile
    $result.ExpandedFiles
    $result

    Description
    -----------
    This example invokes Cisco Secure Management on a remote computer, copies the zip file "ZipFile.zip" to the "C:\RemoteFolder" folder, expands the zip file, and returns the list of expanded files.
.NOTES
    Author: Your Name
    Date:   Current Date
#>
function Invoke-CiscoSecureManagement {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]$ComputerName,
        [string]$FilePath,
        [string]$DestinationFolderPath,
        [SecureString]$Password,
        [PSCredential]$Credential,
        [switch]$IsZipFile
    )

    # Define a PSObject to store the results
    $result = New-Object PSObject

    # Check if Cisco Secure is enabled
    $isCiscoSecureEnabled = (Test-CiscoSecure -ComputerName $ComputerName).CiscoSecureServiceStatus

    if ($isCiscoSecureEnabled) {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Disable Cisco Secure")) {
            # Disable Cisco Secure
            Disable-CiscoSecure -ComputerName $ComputerName -Password $Password
        }

        if ($PSCmdlet.ShouldProcess("$ComputerName", "Copy file to remote computer")) {
            # Copy the file
            Copy-FilestoRemote -ComputerName $ComputerName -LocalFile $FilePath -RemotePath $DestinationFolderPath -Credentials $Credential
        }

        if ($IsZipFile.IsPresent -and $PSCmdlet.ShouldProcess("$ComputerName", "Expand zip file on remote computer")) {
            # Uncompress the zip file and get the list of expanded files
            $expandedFiles = Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
                param($FilePath, $DestinationFolderPath)
                $RemoteZipFilePath = Join-Path -Path $DestinationFolderPath -ChildPath (Split-Path -Path $FilePath -Leaf)
                if (Test-Path -Path $RemoteZipFilePath) {
                    Expand-Archive -Path $RemoteZipFilePath -DestinationPath $DestinationFolderPath -Force
                    return Get-ChildItem -Path $DestinationFolderPath -Recurse | Select-Object -ExpandProperty FullName
                } else {
                    Write-Error "The zip file $RemoteZipFilePath does not exist on the remote computer."
                }
            } -ArgumentList $FilePath, $DestinationFolderPath
        }

        if ($PSCmdlet.ShouldProcess("$ComputerName", "Enable Cisco Secure")) {
            # Re-enable Cisco Secure
            Enable-CiscoSecure -ComputerName $ComputerName
        }

        # Test if Cisco Secure is re-enabled
        $isCiscoSecureEnabled = (Test-CiscoSecure -ComputerName $ComputerName).CiscoSecureServiceStatus
    }

    # Add the results to the PSObject
    $result | Add-Member -Type NoteProperty -Name "FileCopied" -Value $FilePath
    $result | Add-Member -Type NoteProperty -Name "ExpandedFiles" -Value $expandedFiles
    $result | Add-Member -Type NoteProperty -Name "CiscoSecureState" -Value $isCiscoSecureEnabled

    # Return the result
    return $result
}
