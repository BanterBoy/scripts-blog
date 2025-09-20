---
layout: post
title: Invoke-CiscoSecureManagement.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Invoke-CiscoSecureManagement/
categories:
- UserAdminModule
- Security
tags:
- PowerShell
- User Admin Module
- Cisco Secure Management
description: Invokes Cisco Secure Management on a remote computer.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
---
- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Invokes Cisco Secure Management on a remote computer.

#### Detailed Description

The Invoke-CiscoSecureManagement function is used to enable, disable, copy files, and optionally expand zip files on a remote computer with Cisco Secure Management enabled.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$File = "C:\Path\to\File.ps1"
```

$Destination = "C:\RemoteFolder" $ComputerName = "RemoteComputer" $Password = ConvertTo-SecureString -String "PASSWORD" -AsPlainText -Force $Credential = Get-Credential $result = Invoke-CiscoSecureManagement -ComputerName $ComputerName -FilePath $File -DestinationFolderPath $Destination -Password $Password -Credential $Credential $result Description ----------- This example invokes Cisco Secure Management on a remote computer, copies the file "File.ps1" to the "C:\RemoteFolder" folder, and returns the result.

**Example 2**

```powershell
$File = "C:\Path\to\ZipFile.zip"
```

$Destination = "C:\RemoteFolder" $ComputerName = "RemoteComputer" $Password = ConvertTo-SecureString -String "PASSWORD" -AsPlainText -Force $Credential = Get-Credential $result = Invoke-CiscoSecureManagement -ComputerName $ComputerName -FilePath $File -DestinationFolderPath $Destination -Password $Password -Credential $Credential -IsZipFile $result.ExpandedFiles $result Description ----------- This example invokes Cisco Secure Management on a remote computer, copies the zip file "ZipFile.zip" to the "C:\RemoteFolder" folder, expands the zip file, and returns the list of expanded files.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Current Date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Invoke-CiscoSecureManagement.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-CiscoSecureManagement.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

